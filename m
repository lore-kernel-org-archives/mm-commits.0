From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes.patch added to
 -mm tree
Date: Mon, 02 Mar 2020 14:14:35 -0800
Message-ID: <20200302221435.S8odfjmjy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbgCBWOg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:14:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-vmscan-remove-unnecessary-lruvec-adding-checkpatch-fixes.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
