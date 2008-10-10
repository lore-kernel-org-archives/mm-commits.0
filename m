From: akpm@linux-foundation.org
Subject: + vmscan-split-lru-lists-into-anon-file-sets-fix-style-issue-of-get_scan_ratio.patch added to -mm tree
Date: Fri, 10 Oct 2008 13:02:07 -0700
Message-ID: <200810102002.m9AK27gE029052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761470AbYJJUCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 16:02:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     fix style issue of get_scan_ratio()
has been added to the -mm tree.  Its filename is
     vmscan-split-lru-lists-into-anon-file-sets-fix-style-issue-of-get_scan_ratio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix style issue of get_scan_ratio()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

vmscan-split-lru-lists-into-anon-file-sets.patch introduce two style issue.
this patch fix it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~vmscan-split-lru-lists-into-anon-file-sets-fix-style-issue-of-get_scan_ratio mm/vmscan.c
--- a/mm/vmscan.c~vmscan-split-lru-lists-into-anon-file-sets-fix-style-issue-of-get_scan_ratio
+++ a/mm/vmscan.c
@@ -1193,7 +1193,7 @@ static unsigned long shrink_list(enum lr
  * percent[0] specifies how much pressure to put on ram/swap backed
  * memory, while percent[1] determines pressure on the file LRUs.
  */
-static void get_scan_ratio(struct zone *zone, struct scan_control * sc,
+static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 					unsigned long *percent)
 {
 	unsigned long anon, file, free;
@@ -1221,16 +1221,16 @@ static void get_scan_ratio(struct zone *
 	}
 
 	/*
-         * OK, so we have swap space and a fair amount of page cache
-         * pages.  We use the recently rotated / recently scanned
-         * ratios to determine how valuable each cache is.
-         *
-         * Because workloads change over time (and to avoid overflow)
-         * we keep these statistics as a floating average, which ends
-         * up weighing recent references more than old ones.
-         *
-         * anon in [0], file in [1]
-         */
+	 * OK, so we have swap space and a fair amount of page cache
+	 * pages.  We use the recently rotated / recently scanned
+	 * ratios to determine how valuable each cache is.
+	 *
+	 * Because workloads change over time (and to avoid overflow)
+	 * we keep these statistics as a floating average, which ends
+	 * up weighing recent references more than old ones.
+	 *
+	 * anon in [0], file in [1]
+	 */
 	if (unlikely(zone->recent_scanned[0] > anon / 4)) {
 		spin_lock_irq(&zone->lru_lock);
 		zone->recent_scanned[0] /= 2;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

git-tip.patch
mm-do_generic_file_read-never-gets-a-null-filp-argument.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-split-lru-lists-into-anon-file-sets-adjust-quicklists-field-of-proc-meminfo.patch
vmscan-split-lru-lists-into-anon-file-sets-adjust-hugepage-related-field-of-proc-meminfo.patch
vmscan-split-lru-lists-into-anon-file-sets-fix-style-issue-of-get_scan_ratio.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-unlockless-reclaim.patch
coredump_filter-add-hugepage-dumping-v4.patch
hugepage-support-zero_page.patch
add-config_core_dump_default_elf_headers.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

