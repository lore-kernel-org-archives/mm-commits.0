From: akpm@linux-foundation.org
Subject: - vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:34:16 -0700
Message-ID: <200810182334.m9INYGMA031765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYJRXeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:34:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan-fix-pagecache-reclaim-referenced-bit-check-fix
has been removed from the -mm tree.  Its filename was
     vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch

This patch was dropped because it was folded into vmscan-fix-pagecache-reclaim-referenced-bit-check.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-fix-pagecache-reclaim-referenced-bit-check-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check-fix
+++ a/mm/vmscan.c
@@ -1095,14 +1095,13 @@ static void shrink_active_list(unsigned 
 		cond_resched();
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
+
+		/* page_referenced clears PageReferenced */
+		if (page_mapping_inuse(page) &&
+		    page_referenced(page, 0, sc->mem_cgroup))
+			pgmoved++;
+
 		list_add(&page->lru, &l_inactive);
-		if (!page_mapping_inuse(page)) {
-			/*
-			 * Bypass use-once, make the next access count. See
-			 * mark_page_accessed and shrink_page_list.
-			 */
-			SetPageReferenced(page);
-		}
 	}
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

