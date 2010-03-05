From: akpm@linux-foundation.org
Subject: [folded] vmscan-check-high-watermark-after-shrink-zone-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:15:53 -0800
Message-ID: <201003052115.o25LFrxo027987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab0CEVRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:17:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan-check-high-watermark-after-shrink-zone-fix
has been removed from the -mm tree.  Its filename was
     vmscan-check-high-watermark-after-shrink-zone-fix.patch

This patch was dropped because it was folded into vmscan-check-high-watermark-after-shrink-zone.patch

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
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch

