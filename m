From: akpm@linux-foundation.org
Subject: + mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch added to -mm tree
Date: Thu, 14 Jan 2010 16:19:21 -0800
Message-ID: <201001150044.o0F0iM56009603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367Ab0AOApL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 19:45:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, rientjes@google.com, shijie8@gmail.com


The patch titled
     mm-restore-zone-all_unreclaimable-to-independence-word-fix
has been added to the -mm tree.  Its filename is
     mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch

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
Subject: mm-restore-zone-all_unreclaimable-to-independence-word-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm-restore-zone-all_unreclaimable-to-independence-word.patch broke
vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch

Cc: David Rientjes <rientjes@google.com>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-restore-zone-all_unreclaimable-to-independence-word-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-restore-zone-all_unreclaimable-to-independence-word-fix
+++ a/mm/vmscan.c
@@ -1948,7 +1948,7 @@ static int sleeping_prematurely(pg_data_
 		if (!populated_zone(zone))
 			continue;
 
-		if (zone_is_all_unreclaimable(zone))
+		if (zone->all_unreclaimable)
 			continue;
 
 		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ttyh-make-function-static-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
drivers-usb-core-sysfsc-set_reset_quirk-remove-unused-local.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
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

