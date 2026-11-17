Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794887779;
	b=vU8cGJYucJIHoaPmGFGokWwu3o/xACTNahmizqru+dr9YQIyVQcT3erOga0WkvlB0+FX
	 JjaE12bvS85OQjHOxPp5/m0JZPyoUsRmrkfsUkDq3fuyDnqYvSXvAaH3R0ckTFgfTjP1h
	 Vv2u2uKC5CY3+s+FF1m8l4jwjNZKzws5km0fkS6/PIr76HxDuz6XLCMCEhYuQP74rrkle
	 04+LsYJkNNIkuQsZiBKSZyTg4JKHnLgxiQesAyqXaujgJ2mOMnd2pSAROVdhsnTEfoCNr
	 zORsDgL4mYYVjsERRwTo0lrw2CUSI2ikE9ry8tsx4lOZAhZAW4BSomghmpkKZmmEt+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794887779;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jOTeIk7xZv1V7N3RiQgmE3U5Nf10Yq78XERtZUYHF/w=;
	b=PZ2IhJvXtkO56YRt8u1pkpT17lK6oc0D7iUj+3+hqK32zeKn2UUl2ilytiK4nWbUPlWu
	 SQytzqkdv6fdMnaj89sTW9xIHA2goEEQruOUrfeQDTXYnb/80A0QNRrfjLpPir1QCNJ/D
	 6FegSjwbU+2PtK2ONeK7UULCcpK3DUH2qSbPKNDESlFGpjyqfICWIjfuhe3wAr58pm4Lb
	 1YLLsASyzFZgNhZx1DTMzJ8DJmZJccpEDDIwgPD6iAWL2bxB3EdeKsZzSmcFWeHJ3VJsE
	 69524+tKIehVQeNAVh5EQhaVhkHwzeBbqKqBOW5wQ1QnRUlrWsCuSVw9POaMXaSyhbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=R1zzK1iz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5282A606A31C;
	Tue, 17 Nov 2026 03:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=R1zzK1iz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61DD1F000C4;
	Tue, 17 Nov 2026 03:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794887779;
	bh=jOTeIk7xZv1V7N3RiQgmE3U5Nf10Yq78XERtZUYHF/w=;
	h=Date:To:From:Subject;
	b=R1zzK1izg+7yEX141OAZhxAazUOE21UDXIEgWAj8CWTx3W8bOcdEBkavzd/6rKgOC
	 Bq7/exNDunJOQ0ZC/w+i0xiFHCQuA4PKuiBGlbVEH2feiR+l/XkO3QcyQlpidH8zLV
	 2XjA1QkjfiViFsYBIw+kx1tx+hfjL6bhlH/yVR4g=
Date: Mon, 16 Nov 2026 19:56:18 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,
	osalvador@suse.de,osalvador@kernel.org,nao.horiguchi@gmail.com,
	ljs@kernel.org,linmiaohe@huawei.com,joao.m.martins@oracle.com,
	jiaqiyan@google.com,david@kernel.org,azpijr@gmail.com,
	songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch added to mm-new branch
Message-Id: <20261117035618.D61DD1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb_vmemmap: fix HWPoison state races during optimization
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb_vmemmap: fix HWPoison state races during optimization
Date: Sat, 14 Nov 2026 19:25:21 +0800

Patch series "mm/hugetlb_vmemmap: Fix HVO races and deadlock", v3.

This series fixes three HVO issues reported by Sashiko.

The first patch serializes HWPoison updates and removal against HVO
remapping so raw_hwp_page state cannot be lost or freed while a
replacement vmemmap head page is being installed.  The second patch uses
an HVO-private rwsem to prevent deferred PMD splits from racing with PTE
remapping before the TLB flush.  The last patch switches the vmemmap walk
to the lockless walker so a PMD split allocation cannot recurse into
init_mm.mmap_lock through reclaim.


This patch (of 3):

HVO copies the vmemmap head page before remapping it to a newly allocated
backing page. Memory failure can update the old head page after the copy
but before the remap's TLB invalidation completes:

CPU 0                            CPU 1
init_new_hugetlb_folio()
__hugetlb_vmemmap_optimize_folio()
  vmemmap_optimize_pte()
    copy_page(old_head, new_head)
                                 try_memory_failure_hugetlb()
                                   get_huge_page_for_hwpoison()
                                     hugetlb_update_hwpoison(old_head)
  set_pte_at(..., new_head)
  flush_tlb_all()
free_vmemmap_page_list(old_head)

The raw_hwp_page linked to the old head is then leaked and the folio's
HWPoison state is lost when the obsolete backing page is freed, allowing
the poisoned huge page to be allocated later.

Unpoisoning has a similar race: unpoison_memory() can free the
raw_hwp_page and clear PG_hwpoison from the old head after it is copied,
leaving the new head with stale HWPoison state and a freed pointer.

Serialize HVO remapping against HWPoison updates and removal. This
ensures that an update is either copied to the new vmemmap head page or
applied after HVO installs the new mapping and completes the TLB flush,
and prevents unpoisoning from modifying the old head while HVO installs
its replacement.

Link: https://lore.kernel.org/20261114112523.75208-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20261114112523.75208-2-songmuchun@bytedance.com
Fixes: 11aad2631bf7 ("mm/hugetlb_vmemmap: remap head page to newly allocated page")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-18e93f17-529b-4d84-ba44-a41829f4be64
Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: <stable@vger.kernel.org>

 mm/hugetlb_vmemmap.c |   10 ++++++++++
 mm/hugetlb_vmemmap.h |   24 ++++++++++++++++++++++++
 mm/memory-failure.c  |    3 +++
 3 files changed, 37 insertions(+)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization
+++ a/mm/hugetlb_vmemmap.c
@@ -15,6 +15,7 @@
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
+#include <linux/rwsem.h>
 #include <linux/vmemmap-optimization.h>
 
 #include <asm/tlbflush.h>
@@ -41,6 +42,8 @@ struct vmemmap_remap_walk {
 	unsigned long		flags;
 };
 
+DECLARE_RWSEM(vmemmap_remap_rwsem);
+
 static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 			     struct vmemmap_remap_walk *walk)
 {
@@ -333,6 +336,9 @@ static int vmemmap_pteify_folio(const st
  * responsible for freeing the pages left on the @vmemmap_pages list, even on
  * failure.
  *
+ * Note: The caller must hold vmemmap_remap_rwsem. If TLB flushing is deferred,
+ * the lock must remain held until the final TLB flush.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_optimize_folio(const struct folio *folio,
@@ -348,6 +354,8 @@ static int vmemmap_optimize_folio(const
 		.flags		= flags,
 	};
 
+	rwsem_assert_held(&vmemmap_remap_rwsem);
+
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
 
 	if (!vmemmap_optimizable_order(folio_order(folio)))
@@ -536,6 +544,7 @@ void hugetlb_vmemmap_optimize_folio(cons
 {
 	LIST_HEAD(vmemmap_pages);
 
+	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
@@ -588,6 +597,7 @@ void hugetlb_vmemmap_optimize_folios(str
 
 	flush_tlb_all();
 
+	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization
+++ a/mm/hugetlb_vmemmap.h
@@ -9,9 +9,12 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
+#include <linux/rwsem.h>
 #include <linux/vmemmap-optimization.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+extern struct rw_semaphore vmemmap_remap_rwsem;
+
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
@@ -20,6 +23,16 @@ void hugetlb_vmemmap_optimize_folio(cons
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
+static inline void hugetlb_vmemmap_write_lock(void)
+{
+	down_write(&vmemmap_remap_rwsem);
+}
+
+static inline void hugetlb_vmemmap_write_unlock(void)
+{
+	up_write(&vmemmap_remap_rwsem);
+}
+
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
 	return pages_per_huge_page(h) * sizeof(struct page);
@@ -59,6 +72,14 @@ static inline void hugetlb_vmemmap_optim
 {
 }
 
+static inline void hugetlb_vmemmap_write_lock(void)
+{
+}
+
+static inline void hugetlb_vmemmap_write_unlock(void)
+{
+}
+
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
@@ -69,6 +90,9 @@ static inline void hugetlb_vmemmap_optim
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 
+DEFINE_LOCK_GUARD_0(vmemmap_remap,
+		    hugetlb_vmemmap_write_lock(), hugetlb_vmemmap_write_unlock())
+
 static inline bool hugetlb_vmemmap_optimizable(const struct hstate *h)
 {
 	return hugetlb_vmemmap_optimizable_size(h) != 0;
--- a/mm/memory-failure.c~mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization
+++ a/mm/memory-failure.c
@@ -69,6 +69,7 @@
 #include "page_alloc.h"
 #include "internal.h"
 #include "memory-failure.h"
+#include "hugetlb_vmemmap.h"
 
 static int sysctl_memory_failure_early_kill __read_mostly;
 
@@ -2038,6 +2039,7 @@ static int get_huge_page_for_hwpoison(un
 	bool count_increased = false;
 	int ret, rc;
 
+	guard(vmemmap_remap)();
 	spin_lock_irq(&hugetlb_lock);
 	folio = page_folio(page);
 	if (!folio_test_hugetlb(folio)) {
@@ -2812,6 +2814,7 @@ int unpoison_memory(unsigned long pfn)
 
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
+		guard(vmemmap_remap)();
 		if (folio_test_hugetlb(folio)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch

