From: akpm@linux-foundation.org
Subject: [folded] mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:17:06 -0800
Message-ID: <201003052117.o25LH6In028094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235Ab0CEVRz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:17:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, rientjes@goog


The patch titled
     mm-restore-zone-all_unreclaimable-to-independence-word-fix
has been removed from the -mm tree.  Its filename was
     mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch

This patch was dropped because it was folded into mm-restore-zone-all_unreclaimable-to-independence-word.patch

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
@@ -1926,7 +1926,7 @@ static int sleeping_prematurely(pg_data_
 		if (!populated_zone(zone))
 			continue;
 
-		if (zone_is_all_unreclaimable(zone))
+		if (zone->all_unreclaimable)
 			continue;
 
 		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
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

