From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:41:12 -0700
Message-ID: <200906162241.n5GMfCi4003192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757021AbZFPWxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: fix unsafe pte fetching
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix unsafe pte fetching
From: Izik Eidus <ieidus@redhat.com>

is_present_pte() was called inside ksm without anything protecting that
pmd, pud, and pte would go away under our feets.

This patch fix this problem by making sure that down_read(mmap_sem) will
be used beacuse calling to is_present_pte()

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching mm/ksm.c
--- a/mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching
+++ a/mm/ksm.c
@@ -783,8 +783,8 @@ static int is_zapped_item(struct rmap_it
 	struct vm_area_struct *vma;
 
 	cond_resched();
+	down_read(&rmap_item->mm->mmap_sem);
 	if (is_present_pte(rmap_item->mm, rmap_item->address)) {
-		down_read(&rmap_item->mm->mmap_sem);
 		vma = find_vma(rmap_item->mm, rmap_item->address);
 		if (vma && !vma->vm_file) {
 			BUG_ON(vma->vm_flags & VM_SHARED);
@@ -792,8 +792,8 @@ static int is_zapped_item(struct rmap_it
 					     rmap_item->address,
 					     1, 0, 0, page, NULL);
 		}
-		up_read(&rmap_item->mm->mmap_sem);
 	}
+	up_read(&rmap_item->mm->mmap_sem);
 
 	if (ret != 1)
 		return 1;
@@ -979,13 +979,15 @@ static struct tree_item *unstable_tree_s
 		rmap_item = tree_item->rmap_item;
 		BUG_ON(!rmap_item);
 
+		down_read(&rmap_item->mm->mmap_sem);
 		/*
 		 * We dont want to swap in pages
 		 */
-		if (!is_present_pte(rmap_item->mm, rmap_item->address))
+		if (!is_present_pte(rmap_item->mm, rmap_item->address)) {
+			up_read(&rmap_item->mm->mmap_sem);
 			return NULL;
+		}
 
-		down_read(&rmap_item->mm->mmap_sem);
 		ret = get_user_pages(current, rmap_item->mm, rmap_item->address,
 				     1, 0, 0, page2, NULL);
 		up_read(&rmap_item->mm->mmap_sem);
@@ -1344,9 +1346,9 @@ static int ksm_scan_start(struct ksm_sca
 		 * If the page is swapped out or in swap cache, we don't want to
 		 * scan it (it is just for performance).
 		 */
+		down_read(&slot->mm->mmap_sem);
 		if (is_present_pte(slot->mm, slot->addr +
 				   ksm_scan->page_index * PAGE_SIZE)) {
-			down_read(&slot->mm->mmap_sem);
 			val = get_user_pages(current, slot->mm, slot->addr +
 					     ksm_scan->page_index * PAGE_SIZE ,
 					      1, 0, 0, page, NULL);
@@ -1356,6 +1358,8 @@ static int ksm_scan_start(struct ksm_sca
 					cmp_and_merge_page(ksm_scan, page[0]);
 				put_page(page[0]);
 			}
+		} else {
+			up_read(&slot->mm->mmap_sem);
 		}
 		scan_npages--;
 	}
_

Patches currently in -mm which might be from ieidus@redhat.com are

linux-next.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch
ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch
ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch

