Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391C323C6EA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837010; cv=none; b=C7BfxFAidzl+hnc7vgrp8bMyD2fqPLpe2cezft/+a6AKgnbNcnO1WE+tD0uBsoFo6xu6LYOlmcVHBtOATyJHhU+zUgF8CvraFN0N3dqL38u7iU7q9JcwhS+qbHIObQxHFs0LOUnRRDehwepuaHtyuuLobzihs5J8LfbPn/QVULQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837010; c=relaxed/simple;
	bh=35AdLaZ2gnIDth3Q4crFw++sCjL+qtN9Nt12DV2/J78=;
	h=Date:To:From:Subject:Message-Id; b=PHvA+6GcsyuItbjdq39uJyOJNoq9jop64n85syU1BGxrmsiYza9c67V6JqZvLvIGKffw0ZPI3hgPRkt8thXffm1X5/QLVJ8ZzGuIZ8+gjNXfMSuxkPJptdxMl8rclFPFQ9/egox1al+0oHd5L0RB8c/gBr51PWCq+YeCuQqQtZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YJjJ3L6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YJjJ3L6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F11C4CEDD;
	Tue, 14 Jan 2025 06:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837010;
	bh=35AdLaZ2gnIDth3Q4crFw++sCjL+qtN9Nt12DV2/J78=;
	h=Date:To:From:Subject:From;
	b=YJjJ3L6RTbB5SOUo7ag2UIG3me+7AwUMpWJofkZUqDvTzZKZ/sttSjibGbP7P7bEh
	 xXo7vZxDzZSPOYbksyGqA2qDiWZqw91x3ipU6M05pp83yxXc7F2cDaWxZb7bAMhTaC
	 QMxiPRRXkLuTHgjkkO0WQ+ijd2WsRr99hcof+tcQ=
Date: Mon, 13 Jan 2025 22:43:29 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch removed from -mm tree
Message-Id: <20250114064330.02F11C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: mm: free page table pages by RCU instead of semi RCU
has been removed from the -mm tree.  Its filename was
     x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: x86: mm: free page table pages by RCU instead of semi RCU
Date: Wed, 4 Dec 2024 19:09:50 +0800

Now, if CONFIG_MMU_GATHER_RCU_TABLE_FREE is selected, the page table pages
will be freed by semi RCU, that is:

 - batch table freeing: asynchronous free by RCU
 - single table freeing: IPI + synchronous free

In this way, the page table can be lockless traversed by disabling IRQ in
paths such as fast GUP.  But this is not enough to free the empty PTE page
table pages in paths other that munmap and exit_mmap path, because IPI
cannot be synchronized with rcu_read_lock() in pte_offset_map{_lock}().

In preparation for supporting empty PTE page table pages reclaimation, let
single table also be freed by RCU like batch table freeing.  Then we can
also use pte_offset_map() etc to prevent PTE page from being freed.

Like pte_free_defer(), we can also safely use ptdesc->pt_rcu_head to free
the page table pages:

 - The pt_rcu_head is unioned with pt_list and pmd_huge_pte.

 - For pt_list, it is used to manage the PGD page in x86. Fortunately
   tlb_remove_table() will not be used for free PGD pages, so it is safe
   to use pt_rcu_head.

 - For pmd_huge_pte, it is used for THPs, so it is safe.

After applying this patch, if CONFIG_PT_RECLAIM is enabled, the function
call of free_pte() is as follows:

free_pte
  pte_free_tlb
    __pte_free_tlb
      ___pte_free_tlb
        paravirt_tlb_remove_table
          tlb_remove_table [!CONFIG_PARAVIRT, Xen PV, Hyper-V, KVM]
            [no-free-memory slowpath:]
              tlb_table_invalidate
              tlb_remove_table_one
                __tlb_remove_table_one [frees via RCU]
            [fastpath:]
              tlb_table_flush
                tlb_remove_table_free [frees via RCU]
          native_tlb_remove_table [CONFIG_PARAVIRT on native]
            tlb_remove_table [see above]

Link: https://lkml.kernel.org/r/0287d442a973150b0e1019cc406e6322d148277a.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlb.h |   20 ++++++++++++++++++++
 arch/x86/kernel/paravirt.c |    7 +++++++
 arch/x86/mm/pgtable.c      |   10 +++++++++-
 include/linux/mm_types.h   |    4 +++-
 mm/mmu_gather.c            |    9 ++++++++-
 5 files changed, 47 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/tlb.h~x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu
+++ a/arch/x86/include/asm/tlb.h
@@ -34,8 +34,28 @@ static inline void __tlb_remove_table(vo
 	free_page_and_swap_cache(table);
 }
 
+#ifdef CONFIG_PT_RECLAIM
+static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
+{
+	struct page *page;
+
+	page = container_of(head, struct page, rcu_head);
+	put_page(page);
+}
+
+static inline void __tlb_remove_table_one(void *table)
+{
+	struct page *page;
+
+	page = table;
+	call_rcu(&page->rcu_head, __tlb_remove_table_one_rcu);
+}
+#define __tlb_remove_table_one __tlb_remove_table_one
+#endif /* CONFIG_PT_RECLAIM */
+
 static inline void invlpg(unsigned long addr)
 {
 	asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
 }
+
 #endif /* _ASM_X86_TLB_H */
--- a/arch/x86/kernel/paravirt.c~x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu
+++ a/arch/x86/kernel/paravirt.c
@@ -59,10 +59,17 @@ void __init native_pv_lock_init(void)
 		static_branch_enable(&virt_spin_lock_key);
 }
 
+#ifndef CONFIG_PT_RECLAIM
 static void native_tlb_remove_table(struct mmu_gather *tlb, void *table)
 {
 	tlb_remove_page(tlb, table);
 }
+#else
+static void native_tlb_remove_table(struct mmu_gather *tlb, void *table)
+{
+	tlb_remove_table(tlb, table);
+}
+#endif
 
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
--- a/arch/x86/mm/pgtable.c~x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu
+++ a/arch/x86/mm/pgtable.c
@@ -19,12 +19,20 @@ EXPORT_SYMBOL(physical_mask);
 #endif
 
 #ifndef CONFIG_PARAVIRT
+#ifndef CONFIG_PT_RECLAIM
 static inline
 void paravirt_tlb_remove_table(struct mmu_gather *tlb, void *table)
 {
 	tlb_remove_page(tlb, table);
 }
-#endif
+#else
+static inline
+void paravirt_tlb_remove_table(struct mmu_gather *tlb, void *table)
+{
+	tlb_remove_table(tlb, table);
+}
+#endif /* !CONFIG_PT_RECLAIM */
+#endif /* !CONFIG_PARAVIRT */
 
 gfp_t __userpte_alloc_gfp = GFP_PGTABLE_USER | PGTABLE_HIGHMEM;
 
--- a/include/linux/mm_types.h~x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu
+++ a/include/linux/mm_types.h
@@ -438,7 +438,9 @@ FOLIO_MATCH(compound_head, _head_2a);
  * struct ptdesc -    Memory descriptor for page tables.
  * @__page_flags:     Same as page flags. Powerpc only.
  * @pt_rcu_head:      For freeing page table pages.
- * @pt_list:          List of used page tables. Used for s390 and x86.
+ * @pt_list:          List of used page tables. Used for s390 gmap shadow pages
+ *                    (which are not linked into the user page tables) and x86
+ *                    pgds.
  * @_pt_pad_1:        Padding that aliases with page's compound head.
  * @pmd_huge_pte:     Protected by ptdesc->ptl, used for THPs.
  * @__page_mapping:   Aliases with page->mapping. Unused for page tables.
--- a/mm/mmu_gather.c~x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu
+++ a/mm/mmu_gather.c
@@ -311,11 +311,18 @@ static inline void tlb_table_invalidate(
 	}
 }
 
-static void tlb_remove_table_one(void *table)
+#ifndef __tlb_remove_table_one
+static inline void __tlb_remove_table_one(void *table)
 {
 	tlb_remove_table_sync_one();
 	__tlb_remove_table(table);
 }
+#endif
+
+static void tlb_remove_table_one(void *table)
+{
+	__tlb_remove_table_one(table);
+}
 
 static void tlb_table_flush(struct mmu_gather *tlb)
 {
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


