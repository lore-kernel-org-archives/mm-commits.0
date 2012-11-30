From: akpm@linux-foundation.org
Subject: + thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch added to -mm tree
Date: Fri, 30 Nov 2012 14:09:55 -0800
Message-ID: <20121130220955.A8AEC82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:54787 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2K3WJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 17:09:56 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so109458ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 14:09:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, jslaby@suse.cz, lliubbo@gmail.com, rientjes@google.com


The patch titled
     Subject: thp: avoid race on multiple parallel page faults to the same page
has been added to the -mm tree.  Its filename is
     thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: avoid race on multiple parallel page faults to the same page

pmd value is stable only with mm->page_table_lock taken. After taking
the lock we need to check that nobody modified the pmd before changing it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page
+++ a/mm/huge_memory.c
@@ -770,17 +770,20 @@ static inline struct page *alloc_hugepag
 }
 #endif
 
-static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		unsigned long zero_pfn)
 {
 	pmd_t entry;
+	if (!pmd_none(*pmd))
+		return false;
 	entry = pfn_pmd(zero_pfn, vma->vm_page_prot);
 	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	set_pmd_at(mm, haddr, pmd, entry);
 	pgtable_trans_huge_deposit(mm, pgtable);
 	mm->nr_ptes++;
+	return true;
 }
 
 int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -800,6 +803,7 @@ int do_huge_pmd_anonymous_page(struct mm
 				transparent_hugepage_use_zero_page()) {
 			pgtable_t pgtable;
 			unsigned long zero_pfn;
+			bool set;
 			pgtable = pte_alloc_one(mm, haddr);
 			if (unlikely(!pgtable))
 				return VM_FAULT_OOM;
@@ -810,9 +814,13 @@ int do_huge_pmd_anonymous_page(struct mm
 				goto out;
 			}
 			spin_lock(&mm->page_table_lock);
-			set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
+			set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
 					zero_pfn);
 			spin_unlock(&mm->page_table_lock);
+			if (!set) {
+				pte_free(mm, pgtable);
+				put_huge_zero_page();
+			}
 			return 0;
 		}
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
@@ -1046,14 +1054,16 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 */
 	if (is_huge_zero_pmd(pmd)) {
 		unsigned long zero_pfn;
+		bool set;
 		/*
 		 * get_huge_zero_page() will never allocate a new page here,
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
 		zero_pfn = get_huge_zero_page();
-		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
+		set = set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
 				zero_pfn);
+		BUG_ON(!set); /* unexpected !pmd_none(dst_pmd) */
 		ret = 0;
 		goto out_unlock;
 	}
@@ -1110,7 +1120,7 @@ unlock:
 
 static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long address,
-		pmd_t *pmd, unsigned long haddr)
+		pmd_t *pmd, pmd_t orig_pmd, unsigned long haddr)
 {
 	pgtable_t pgtable;
 	pmd_t _pmd;
@@ -1139,6 +1149,9 @@ static int do_huge_pmd_wp_zero_page_fall
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
 	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, orig_pmd)))
+		goto out_free_page;
+
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
@@ -1170,6 +1183,12 @@ static int do_huge_pmd_wp_zero_page_fall
 	ret |= VM_FAULT_WRITE;
 out:
 	return ret;
+out_free_page:
+	spin_unlock(&mm->page_table_lock);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	mem_cgroup_uncharge_page(page);
+	put_page(page);
+	goto out;
 }
 
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
@@ -1317,7 +1336,7 @@ alloc:
 		count_vm_event(THP_FAULT_FALLBACK);
 		if (is_huge_zero_pmd(orig_pmd)) {
 			ret = do_huge_pmd_wp_zero_page_fallback(mm, vma,
-					address, pmd, haddr);
+					address, pmd, orig_pmd, haddr);
 		} else {
 			ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 					pmd, orig_pmd, page, haddr);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
thp-fix-update_mmu_cache_pmd-calls.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build-fix.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-thp-fix-anononymous-page-accounting-in-fallback-path-for-cow-of-hzp.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-fix.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch

