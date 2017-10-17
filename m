From: akpm@linux-foundation.org
Subject: +
 mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2.patch added to -mm tree
Date: Tue, 17 Oct 2017 15:44:25 -0700
Message-ID: <59e687c9.0t0CrwUQDJe11pEA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751935AbdJQWo1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, aarcange@redhat.com, alistair@popple.id.au, andrew.donnellan@au1.ibm.com, benh@kernel.crashing.org, dwmw2@infradead.org, jroedel@suse.de, mpe@ellerman.id.au, nadav.amit@gmail.com, sfr@canb.auug.org.au, suravee.suthikulpanit@amd.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2.patch

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
Subject: mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2

Changed since v1:
  - typos (thanks to Andrea)
  - Avoid unnecessary precaution in try_to_unmap() (Andrea)
  - Be more conservative in try_to_unmap_one()

Link: http://lkml.kernel.org/r/20171017031003.7481-2-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alistair Popple <alistair@popple.id.au>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/mmu_notifier.txt |    4 +-
 mm/huge_memory.c                  |    2 -
 mm/hugetlb.c                      |    4 +-
 mm/ksm.c                          |    6 +--
 mm/rmap.c                         |   44 +++++++++++++++++-----------
 5 files changed, 36 insertions(+), 24 deletions(-)

diff -puN Documentation/vm/mmu_notifier.txt~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2 Documentation/vm/mmu_notifier.txt
--- a/Documentation/vm/mmu_notifier.txt~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2
+++ a/Documentation/vm/mmu_notifier.txt
@@ -14,7 +14,7 @@ those secondary TLB while holding page t
      on zero page, __replace_page(), ...)
 
 Case A is obvious you do not want to take the risk for the device to write to
-a page that might now be use by some completely different task.
+a page that might now be used by some completely different task.
 
 Case B is more subtle. For correctness it requires the following sequence to
 happen:
@@ -89,5 +89,5 @@ for the device.
 When changing a pte to write protect or to point to a new write protected page
 with same content (KSM) it is fine to delay the mmu_notifier_invalidate_range
 call to mmu_notifier_invalidate_range_end() outside the page table lock. This
-is true ven if the thread doing the page table update is preempted right after
+is true even if the thread doing the page table update is preempted right after
 releasing page table lock but before call mmu_notifier_invalidate_range_end().
diff -puN mm/huge_memory.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2
+++ a/mm/huge_memory.c
@@ -1189,7 +1189,7 @@ static int do_huge_pmd_wp_page_fallback(
 	/*
 	 * Leave pmd empty until pte is filled note we must notify here as
 	 * concurrent CPU thread might write to new page before the call to
-	 * mmu_notifier_invalidate_range_end() happen which can lead to a
+	 * mmu_notifier_invalidate_range_end() happens which can lead to a
 	 * device seeing memory write in different order than CPU.
 	 *
 	 * See Documentation/vm/mmu_notifier.txt
diff -puN mm/hugetlb.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2
+++ a/mm/hugetlb.c
@@ -3257,10 +3257,10 @@ int copy_hugetlb_page_range(struct mm_st
 		} else {
 			if (cow) {
 				/*
-				 * No need to notify as we downgrading page
+				 * No need to notify as we are downgrading page
 				 * table protection not changing it to point
 				 * to a new page.
-	 			 *
+				 *
 				 * See Documentation/vm/mmu_notifier.txt
 				 */
 				huge_ptep_set_wrprotect(src, addr, src_pte);
diff -puN mm/ksm.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2 mm/ksm.c
--- a/mm/ksm.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2
+++ a/mm/ksm.c
@@ -1053,8 +1053,8 @@ static int write_protect_page(struct vm_
 		 * this assure us that no O_DIRECT can happen after the check
 		 * or in the middle of the check.
 		 *
-		 * No need to notify as we downgrading page table to read only
-		 * not changing it to point to a new page.
+		 * No need to notify as we are downgrading page table to read
+		 * only not changing it to point to a new page.
 		 *
 		 * See Documentation/vm/mmu_notifier.txt
 		 */
@@ -1142,7 +1142,7 @@ static int replace_page(struct vm_area_s
 
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	/*
-	 * No need to notify as we replacing a read only page with another
+	 * No need to notify as we are replacing a read only page with another
 	 * read only page with the same content.
 	 *
 	 * See Documentation/vm/mmu_notifier.txt
diff -puN mm/rmap.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2 mm/rmap.c
--- a/mm/rmap.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2
+++ a/mm/rmap.c
@@ -1431,6 +1431,10 @@ static bool try_to_unmap_one(struct page
 			if (pte_soft_dirty(pteval))
 				swp_pte = pte_swp_mksoft_dirty(swp_pte);
 			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
+			/*
+			 * No need to invalidate here it will synchronize on
+			 * against the special swap migration pte.
+			 */
 			goto discard;
 		}
 
@@ -1488,6 +1492,9 @@ static bool try_to_unmap_one(struct page
 			 * will take care of the rest.
 			 */
 			dec_mm_counter(mm, mm_counter(page));
+			/* We have to invalidate as we cleared the pte */
+			mmu_notifier_invalidate_range(mm, address,
+						      address + PAGE_SIZE);
 		} else if (IS_ENABLED(CONFIG_MIGRATION) &&
 				(flags & (TTU_MIGRATION|TTU_SPLIT_FREEZE))) {
 			swp_entry_t entry;
@@ -1503,6 +1510,10 @@ static bool try_to_unmap_one(struct page
 			if (pte_soft_dirty(pteval))
 				swp_pte = pte_swp_mksoft_dirty(swp_pte);
 			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			/*
+			 * No need to invalidate here it will synchronize on
+			 * against the special swap migration pte.
+			 */
 		} else if (PageAnon(page)) {
 			swp_entry_t entry = { .val = page_private(subpage) };
 			pte_t swp_pte;
@@ -1514,6 +1525,8 @@ static bool try_to_unmap_one(struct page
 				WARN_ON_ONCE(1);
 				ret = false;
 				/* We have to invalidate as we cleared the pte */
+				mmu_notifier_invalidate_range(mm, address,
+							address + PAGE_SIZE);
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
@@ -1521,6 +1534,9 @@ static bool try_to_unmap_one(struct page
 			/* MADV_FREE page check */
 			if (!PageSwapBacked(page)) {
 				if (!PageDirty(page)) {
+					/* Invalidate as we cleared the pte */
+					mmu_notifier_invalidate_range(mm,
+						address, address + PAGE_SIZE);
 					dec_mm_counter(mm, MM_ANONPAGES);
 					goto discard;
 				}
@@ -1554,6 +1570,9 @@ static bool try_to_unmap_one(struct page
 			if (pte_soft_dirty(pteval))
 				swp_pte = pte_swp_mksoft_dirty(swp_pte);
 			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			/* Invalidate as we cleared the pte */
+			mmu_notifier_invalidate_range(mm, address,
+						      address + PAGE_SIZE);
 		} else {
 			/*
 			 * We should not need to notify here as we reach this
@@ -1563,29 +1582,22 @@ static bool try_to_unmap_one(struct page
 			 *   - page is not anonymous
 			 *   - page is locked
 			 *
-			 * So as it is a shared page and it is locked, it can
-			 * not be remove from the page cache and replace by
-			 * a new page before mmu_notifier_invalidate_range_end
-			 * so no concurrent thread might update its page table
-			 * to point at new page while a device still is using
-			 * this page.
-			 *
-			 * But we can not assume that new user of try_to_unmap
-			 * will have that in mind so just to be safe here call
-			 * mmu_notifier_invalidate_range()
+			 * So as it is a locked file back page thus it can not
+			 * be remove from the page cache and replace by a new
+			 * page before mmu_notifier_invalidate_range_end so no
+			 * concurrent thread might update its page table to
+			 * point at new page while a device still is using this
+			 * page.
 			 *
 			 * See Documentation/vm/mmu_notifier.txt
 			 */
 			dec_mm_counter(mm, mm_counter_file(page));
-			mmu_notifier_invalidate_range(mm, address,
-						      address + PAGE_SIZE);
 		}
 discard:
 		/*
-		 * No need to call mmu_notifier_invalidate_range() as we are
-		 * either replacing a present pte with non present one (either
-		 * a swap or special one). We handling the clearing pte case
-		 * above.
+		 * No need to call mmu_notifier_invalidate_range() it has be
+		 * done above for all cases requiring it to happen under page
+		 * table lock before mmu_notifier_invalidate_range_end()
 		 *
 		 * See Documentation/vm/mmu_notifier.txt
 		 */
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-mmu_notifier-avoid-double-notification-when-it-is-useless.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-v2.patch
mm-mmu_notifier-avoid-call-to-invalidate_range-in-range_end.patch

