From: akpm@linux-foundation.org
Subject: + vmscan-check-high-watermark-after-shrink-zone-fix.patch added to -mm tree
Date: Tue, 12 Jan 2010 15:03:06 -0800
Message-ID: <201001122303.o0CN36sm000660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab0ALXDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 18:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan-check-high-watermark-after-shrink-zone-fix
has been added to the -mm tree.  Its filename is
     vmscan-check-high-watermark-after-shrink-zone-fix.patch

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
Subject: vmscan-check-high-watermark-after-shrink-zone-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment, layout.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-check-high-watermark-after-shrink-zone-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-check-high-watermark-after-shrink-zone-fix
+++ a/mm/vmscan.c
@@ -2103,11 +2103,12 @@ loop_again:
 					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok = 0;
 				/*
-				 * We are still under min water mark. it mean we have
-				 * GFP_ATOMIC allocation failure risk. Hurry up!
+				 * We are still under min water mark.  This
+				 * means that we have a GFP_ATOMIC allocation
+				 * failure risk. Hurry up!
 				 */
-				if (!zone_watermark_ok(zone, order, min_wmark_pages(zone),
-						      end_zone, 0))
+				if (!zone_watermark_ok(zone, order,
+					    min_wmark_pages(zone), end_zone, 0))
 					has_under_min_watermark_zone = 1;
 			}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sort-introduce-generic-list_sort-function-v3-checkpatch-fixes.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

