From: akpm@linux-foundation.org
Subject: +
 mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end.patch added to
 -mm tree
Date: Tue, 17 Oct 2017 15:44:29 -0700
Message-ID: <59e687cd.FoA9WfBLANGEzHy4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751935AbdJQWob (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:44:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, aarcange@redhat.com, alistair@popple.id.au, andrew.donnellan@au1.ibm.com, benh@kernel.crashing.org, dwmw2@infradead.org, jroedel@suse.de, mpe@ellerman.id.au, nadav.amit@gmail.com, sfr@canb.auug.org.au, suravee.suthikulpanit@amd.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: avoid call to invalidate_range() in range_end()
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/mmu_notifier: avoid call to invalidate_range() in range_end()

This is an optimization patch that only affect mmu_notifier users which
rely on the invalidate_range() callback.  This patch avoids calling that
callback twice in a row from inside __mmu_notifier_invalidate_range_end

Existing pattern (before this patch):
    mmu_notifier_invalidate_range_start()
        pte/pmd/pud_clear_flush_notify()
            mmu_notifier_invalidate_range()
    mmu_notifier_invalidate_range_end()
        mmu_notifier_invalidate_range()

New pattern (after this patch):
    mmu_notifier_invalidate_range_start()
        pte/pmd/pud_clear_flush_notify()
            mmu_notifier_invalidate_range()
    mmu_notifier_invalidate_range_only_end()

We call the invalidate_range callback after clearing the page table under
the page table lock and we skip the call to invalidate_range inside the
__mmu_notifier_invalidate_range_end() function.

Idea from Andrea Arcangeli

Link: http://lkml.kernel.org/r/20171017031003.7481-3-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alistair Popple <alistair@popple.id.au>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   17 ++++++++++--
 mm/huge_memory.c             |   46 ++++++++++++++++++++++++++++++---
 mm/memory.c                  |    6 +++-
 mm/migrate.c                 |   15 ++++++++--
 mm/mmu_notifier.c            |   11 ++++++-
 5 files changed, 83 insertions(+), 12 deletions(-)

diff -puN include/linux/mmu_notifier.h~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end
+++ a/include/linux/mmu_notifier.h
@@ -213,7 +213,8 @@ extern void __mmu_notifier_change_pte(st
 extern void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
 				  unsigned long start, unsigned long end);
 extern void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
-				  unsigned long start, unsigned long end);
+				  unsigned long start, unsigned long end,
+				  bool only_end);
 extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
 				  unsigned long start, unsigned long end);
 
@@ -267,7 +268,14 @@ static inline void mmu_notifier_invalida
 				  unsigned long start, unsigned long end)
 {
 	if (mm_has_notifiers(mm))
-		__mmu_notifier_invalidate_range_end(mm, start, end);
+		__mmu_notifier_invalidate_range_end(mm, start, end, false);
+}
+
+static inline void mmu_notifier_invalidate_range_only_end(struct mm_struct *mm,
+				  unsigned long start, unsigned long end)
+{
+	if (mm_has_notifiers(mm))
+		__mmu_notifier_invalidate_range_end(mm, start, end, true);
 }
 
 static inline void mmu_notifier_invalidate_range(struct mm_struct *mm,
@@ -437,6 +445,11 @@ static inline void mmu_notifier_invalida
 				  unsigned long start, unsigned long end)
 {
 }
+
+static inline void mmu_notifier_invalidate_range_only_end(struct mm_struct *mm,
+				  unsigned long start, unsigned long end)
+{
+}
 
 static inline void mmu_notifier_invalidate_range(struct mm_struct *mm,
 				  unsigned long start, unsigned long end)
diff -puN mm/huge_memory.c~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end mm/huge_memory.c
--- a/mm/huge_memory.c~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end
+++ a/mm/huge_memory.c
@@ -1220,7 +1220,12 @@ static int do_huge_pmd_wp_page_fallback(
 	page_remove_rmap(page, true);
 	spin_unlock(vmf->ptl);
 
-	mmu_notifier_invalidate_range_end(vma->vm_mm, mmun_start, mmun_end);
+	/*
+	 * No need to double call mmu_notifier->invalidate_range() callback as
+	 * the above pmdp_huge_clear_flush_notify() did already call it.
+	 */
+	mmu_notifier_invalidate_range_only_end(vma->vm_mm, mmun_start,
+						mmun_end);
 
 	ret |= VM_FAULT_WRITE;
 	put_page(page);
@@ -1369,7 +1374,12 @@ alloc:
 	}
 	spin_unlock(vmf->ptl);
 out_mn:
-	mmu_notifier_invalidate_range_end(vma->vm_mm, mmun_start, mmun_end);
+	/*
+	 * No need to double call mmu_notifier->invalidate_range() callback as
+	 * the above pmdp_huge_clear_flush_notify() did already call it.
+	 */
+	mmu_notifier_invalidate_range_only_end(vma->vm_mm, mmun_start,
+					       mmun_end);
 out:
 	return ret;
 out_unlock:
@@ -2021,7 +2031,12 @@ void __split_huge_pud(struct vm_area_str
 
 out:
 	spin_unlock(ptl);
-	mmu_notifier_invalidate_range_end(mm, haddr, haddr + HPAGE_PUD_SIZE);
+	/*
+	 * No need to double call mmu_notifier->invalidate_range() callback as
+	 * the above pudp_huge_clear_flush_notify() did already call it.
+	 */
+	mmu_notifier_invalidate_range_only_end(mm, haddr, haddr +
+					       HPAGE_PUD_SIZE);
 }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
@@ -2096,6 +2111,15 @@ static void __split_huge_pmd_locked(stru
 		add_mm_counter(mm, MM_FILEPAGES, -HPAGE_PMD_NR);
 		return;
 	} else if (is_huge_zero_pmd(*pmd)) {
+		/*
+		 * FIXME: Do we want to invalidate secondary mmu by calling
+		 * mmu_notifier_invalidate_range() see comments below inside
+		 * __split_huge_pmd() ?
+		 *
+		 * We are going from a zero huge page write protected to zero
+		 * small page also write protected so it does not seems useful
+		 * to invalidate secondary mmu at this time.
+		 */
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
@@ -2231,7 +2255,21 @@ void __split_huge_pmd(struct vm_area_str
 	__split_huge_pmd_locked(vma, pmd, haddr, freeze);
 out:
 	spin_unlock(ptl);
-	mmu_notifier_invalidate_range_end(mm, haddr, haddr + HPAGE_PMD_SIZE);
+	/*
+	 * No need to double call mmu_notifier->invalidate_range() callback.
+	 * They are 3 cases to consider inside __split_huge_pmd_locked():
+	 *  1) pmdp_huge_clear_flush_notify() call invalidate_range() obvious
+	 *  2) __split_huge_zero_page_pmd() read only zero page and any write
+	 *    fault will trigger a flush_notify before pointing to a new page
+	 *    (it is fine if the secondary mmu keeps pointing to the old zero
+	 *    page in the meantime)
+	 *  3) Split a huge pmd into pte pointing to the same page. No need
+	 *     to invalidate secondary tlb entry they are all still valid.
+	 *     any further changes to individual pte will notify. So no need
+	 *     to call mmu_notifier->invalidate_range()
+	 */
+	mmu_notifier_invalidate_range_only_end(mm, haddr, haddr +
+					       HPAGE_PMD_SIZE);
 }
 
 void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
diff -puN mm/memory.c~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end mm/memory.c
--- a/mm/memory.c~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end
+++ a/mm/memory.c
@@ -2555,7 +2555,11 @@ static int wp_page_copy(struct vm_fault
 		put_page(new_page);
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	/*
+	 * No need to double call mmu_notifier->invalidate_range() callback as
+	 * the above ptep_clear_flush_notify() did already call it.
+	 */
+	mmu_notifier_invalidate_range_only_end(mm, mmun_start, mmun_end);
 	if (old_page) {
 		/*
 		 * Don't let another task, with possibly unlocked vma,
diff -puN mm/migrate.c~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end mm/migrate.c
--- a/mm/migrate.c~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end
+++ a/mm/migrate.c
@@ -2088,7 +2088,11 @@ int migrate_misplaced_transhuge_page(str
 	set_page_owner_migrate_reason(new_page, MR_NUMA_MISPLACED);
 
 	spin_unlock(ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	/*
+	 * No need to double call mmu_notifier->invalidate_range() callback as
+	 * the above pmdp_huge_clear_flush_notify() did already call it.
+	 */
+	mmu_notifier_invalidate_range_only_end(mm, mmun_start, mmun_end);
 
 	/* Take an "isolate" reference and put new page on the LRU. */
 	get_page(new_page);
@@ -2804,9 +2808,14 @@ static void migrate_vma_pages(struct mig
 			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
 	}
 
+	/*
+	 * No need to double call mmu_notifier->invalidate_range() callback as
+	 * the above ptep_clear_flush_notify() inside migrate_vma_insert_page()
+	 * did already call it.
+	 */
 	if (notified)
-		mmu_notifier_invalidate_range_end(mm, mmu_start,
-						  migrate->end);
+		mmu_notifier_invalidate_range_only_end(mm, mmu_start,
+						       migrate->end);
 }
 
 /*
diff -puN mm/mmu_notifier.c~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end
+++ a/mm/mmu_notifier.c
@@ -190,7 +190,9 @@ void __mmu_notifier_invalidate_range_sta
 EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_start);
 
 void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
-				  unsigned long start, unsigned long end)
+					 unsigned long start,
+					 unsigned long end,
+					 bool only_end)
 {
 	struct mmu_notifier *mn;
 	int id;
@@ -204,8 +206,13 @@ void __mmu_notifier_invalidate_range_end
 		 * subsystem registers either invalidate_range_start()/end() or
 		 * invalidate_range(), so this will be no additional overhead
 		 * (besides the pointer check).
+		 *
+		 * We skip call to invalidate_range() if we know it is safe ie
+		 * call site use mmu_notifier_invalidate_range_only_end() which
+		 * is safe to do when we know that a call to invalidate_range()
+		 * already happen under page table lock.
 		 */
-		if (mn->ops->invalidate_range)
+		if (!only_end && mn->ops->invalidate_range)
 			mn->ops->invalidate_range(mn, mm, start, end);
 		if (mn->ops->invalidate_range_end)
 			mn->ops->invalidate_range_end(mn, mm, start, end);
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-mmu_notifier-avoid-double-notification-when-it-is-useless.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2.patch
mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end.patch

