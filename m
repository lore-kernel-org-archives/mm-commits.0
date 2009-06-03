From: akpm@linux-foundation.org
Subject: + ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch added to -mm tree
Date: Wed, 03 Jun 2009 14:31:22 -0700
Message-ID: <200906032131.n53LVMWq006083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833AbZFCVbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 17:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, nickpiggin@yahoo.com.au


The patch titled
     ksm: fix losing visibility of part of rmap_item->next list
has been added to the -mm tree.  Its filename is
     ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix losing visibility of part of rmap_item->next list
From: Andrea Arcangeli <aarcange@redhat.com>


The tree_item->rmap_item is the head of the list and as such it must
not be overwritten except in the case that the element we removed
(rmap_item) was the previous head of the list, in which case it would
also have rmap_item->prev set to null.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/ksm.c~ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list mm/ksm.c
--- a/mm/ksm.c~ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list
+++ a/mm/ksm.c
@@ -397,10 +397,10 @@ static void remove_rmap_item_from_tree(s
 				free_tree_item(tree_item);
 				nnodes_stable_tree--;
 			} else if (!rmap_item->prev) {
+				BUG_ON(tree_item->rmap_item != rmap_item);
 				tree_item->rmap_item = rmap_item->next;
-			} else {
-				tree_item->rmap_item = rmap_item->prev;
-			}
+			} else
+				BUG_ON(tree_item->rmap_item == rmap_item);
 		} else {
 			/*
 			 * We dont rb_erase(&tree_item->node) here, beacuse
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch
ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch
ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch

