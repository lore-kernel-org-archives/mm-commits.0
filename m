Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D765438D3ED;
	Wed, 29 Jul 2026 04:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298459; cv=none; b=ERg2QZOeX1oXo/y58bnP5Z+6KaZgLB8uDjg7NVQ9pz7vheO05JdNy4vLWZJbOfL445Wf1v+j9yzPqngTUpyJELKygbjkMRLtnL9UMiPR9iWHDwK9Ul9kx448H7491nqc1gcI+ckWk3FEFz2PQZoYe5zTBcn3lylrynijLigc91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298459; c=relaxed/simple;
	bh=rKKu3/nk1ap6kDBhmLGm7x1zXyLR5QhG+16VWbljE+A=;
	h=Date:To:From:Subject:Message-Id; b=Y5Lau8NpkZwdQ6+04DXAj+6GheMtm+5qNaqfWGv7P+WJ6JSeY8ec0qwX1UeIcaad87IWLQ97TCuypq7BN9LnayfjQd7WX1LQiRbEsNwpUAQ4RoY1/N40WCRKXVuU5vGS3K/nd0DPsT7RvGekz+bquTfFIl0pp5mtX6b2uaVlH4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w2n/r958; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w2n/r958"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C931F00A3A;
	Wed, 29 Jul 2026 04:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298457;
	bh=vTTfsxevEgtOCXMrjdTUYIYRR0TrlPGelSTbF81X2BI=;
	h=Date:To:From:Subject;
	b=w2n/r9580qOfO9GSC/nrw3McF6frn29kcwwMg3TcumNaccBBRwfgN5kQ1xXmae/uG
	 fc1ncUdKnOmmPmxVxHwSoRik0f+rKV3ezDnHxqR+finKb2uMnFUwtsJPNQKfMnyEvT
	 Rjpu85Z/CkUPSMdRz65bIZxKHudHSVJQutC4Zb0M=
Date: Tue, 28 Jul 2026 21:14:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,stable@vger.kernel.org,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch removed from -mm tree
Message-Id: <20260729041417.B2C931F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier
Date: Fri, 12 Jun 2026 11:58:48 +0800

Gigantic bootmem HugeTLB pages are currently initialized from
hugetlb_init(), but page_alloc_init_late() runs earlier and walks
pageblocks to determine zone contiguity.

If a bootmem HugeTLB region is marked noinit, set_zone_contiguous() can
observe still-uninitialized struct pages through
__pageblock_pfn_to_page().  This may not trigger an immediate failure, but
it can make set_zone_contiguous() compute the wrong zone contiguity state.
If extra poisoned-page checks are added in this path, such as
PF_POISONED_CHECK() in page_zone_id(), it can also trigger an early boot
panic.

Initialize gigantic bootmem HugeTLB struct pages from
page_alloc_init_late(), before zone contiguity is evaluated, so later page
allocator setup only sees valid struct page state.  This also makes the
initialization order more natural, as struct pages should be initialized
before later code inspects them.

Link: https://lore.kernel.org/20260612035903.2468601-5-songmuchun@bytedance.com
Fixes: fde1c4ecf916 ("mm: hugetlb: skip initialization of gigantic tail struct pages if freed by HVO")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |    5 ++---
 mm/mm_init.c            |    1 +
 mm/sparse-vmemmap.c     |    4 ++--
 4 files changed, 10 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier
+++ a/include/linux/hugetlb.h
@@ -172,6 +172,7 @@ extern int movable_gigantic_pages __read
 extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
+void hugetlb_bootmem_struct_page_init(void);
 void hugetlb_bootmem_alloc(void);
 extern nodemask_t hugetlb_bootmem_nodes;
 void hugetlb_bootmem_set_nodes(void);
@@ -1294,6 +1295,10 @@ static inline bool hugetlbfs_pagecache_p
 static inline void hugetlb_bootmem_alloc(void)
 {
 }
+
+static inline void hugetlb_bootmem_struct_page_init(void)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/hugetlb.c~mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier
+++ a/mm/hugetlb.c
@@ -3353,7 +3353,7 @@ static void __init gather_bootmem_preall
 		gather_bootmem_prealloc_node(nid);
 }
 
-static void __init gather_bootmem_prealloc(void)
+void __init hugetlb_bootmem_struct_page_init(void)
 {
 	struct padata_mt_job job = {
 		.thread_fn	= gather_bootmem_prealloc_parallel,
@@ -3582,7 +3582,7 @@ static unsigned long __init hugetlb_page
  * - For gigantic pages, this is called early in the boot process and
  *   pages are allocated from memblock allocated or something similar.
  *   Gigantic pages are actually added to pools later with the routine
- *   gather_bootmem_prealloc.
+ *   hugetlb_bootmem_struct_page_init.
  * - For non-gigantic pages, this is called later in the boot process after
  *   all of mm is up and functional.  Pages are allocated from buddy and
  *   then added to hugetlb pools.
@@ -4152,7 +4152,6 @@ static int __init hugetlb_init(void)
 	}
 
 	hugetlb_init_hstates();
-	gather_bootmem_prealloc();
 	report_hugepages();
 
 	hugetlb_sysfs_init();
--- a/mm/mm_init.c~mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier
+++ a/mm/mm_init.c
@@ -2330,6 +2330,7 @@ void __init page_alloc_init_late(void)
 	/* Reinit limits that are based on free pages after the kernel is up */
 	files_maxfiles_init();
 #endif
+	hugetlb_bootmem_struct_page_init();
 
 	/* Accounting of total+free memory is stable at this point. */
 	mem_init_print_info();
--- a/mm/sparse-vmemmap.c~mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier
+++ a/mm/sparse-vmemmap.c
@@ -342,8 +342,8 @@ static __meminit struct page *vmemmap_ge
 	 *
 	 * Any initialization done here will be overwritten by memmap_init().
 	 *
-	 * gather_bootmem_prealloc() will take care of initialization after
-	 * memmap_init().
+	 * hugetlb_bootmem_struct_page_init() will take care of initialization
+	 * after memmap_init().
 	 */
 
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

