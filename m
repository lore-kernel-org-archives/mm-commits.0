From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes.patch removed
 from -mm tree
Date: Thu, 05 Mar 2020 18:50:07 -0800
Message-ID: <20200306025007.iRsJi-XLa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgCFCuI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 21:50:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-vmscan-remove-unnecessary-lruvec-adding.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes

WARNING: line over 80 characters
#66: FILE: mm/vmscan.c:1855:
+		 *				         !PageLRU //skip lru_lock

total: 0 errors, 1 warnings, 56 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-vmscan-remove-unnecessary-lruvec-adding.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes
+++ a/mm/vmscan.c
@@ -1849,11 +1849,11 @@ static unsigned noinline_for_stack move_
 		/*
 		 * The SetPageLRU needs to be kept here for list intergrity.
 		 * Otherwise:
-		 *   #0 mave_pages_to_lru              #1 release_pages
-		 *				       if (put_page_testzero())
+		 *   #0 mave_pages_to_lru           #1 release_pages
+		 *				    if (put_page_testzero())
 		 *   if !put_page_testzero
-		 *				         !PageLRU //skip lru_lock
-		 *                                         list_add(&page->lru,)
+		 *				      !PageLRU //skip lru_lock
+		 *                                      list_add(&page->lru,)
 		 *     list_add(&page->lru,) //corrupt
 		 */
 		SetPageLRU(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
mm.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
