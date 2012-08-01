From: akpm@linux-foundation.org
Subject: [merged] mm-bug-fix-free-page-check-in-zone_watermark_ok.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:26 -0700
Message-ID: <20120801201526.C5C2E1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:28 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aaditya.kumar@ap.sony.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix free page check in zone_watermark_ok()
has been removed from the -mm tree.  Its filename was
     mm-bug-fix-free-page-check-in-zone_watermark_ok.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix free page check in zone_watermark_ok()

__zone_watermark_ok currently compares free_pages which is a signed type
with z->lowmem_reserve[classzone_idx] which is unsigned which might lead
to sign overflow if free_pages doesn't satisfy the given order (or it came
as negative already) and then we rely on the following order loop to fix
it (which doesn't work for order-0).  Let's fix the type conversion and do
not rely on the given value of free_pages or follow up fixups.

This patch fixes it because "memory-hotplug: fix kswapd looping forever
problem" depends on this.

As benefit of this patch, it doesn't rely on the loop to exit
__zone_watermark_ok in case of high order check and make the first test
effective.(ie, if (free_pages <= min + lowmem_reserve))

Aaditya reported this problem when he test my hotplug patch.

Reported-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Tested-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-bug-fix-free-page-check-in-zone_watermark_ok mm/page_alloc.c
--- a/mm/page_alloc.c~mm-bug-fix-free-page-check-in-zone_watermark_ok
+++ a/mm/page_alloc.c
@@ -1595,6 +1595,7 @@ static bool __zone_watermark_ok(struct z
 {
 	/* free_pages my go negative - that's OK */
 	long min = mark;
+	long lowmem_reserve = z->lowmem_reserve[classzone_idx];
 	int o;
 
 	free_pages -= (1 << order) - 1;
@@ -1603,7 +1604,7 @@ static bool __zone_watermark_ok(struct z
 	if (alloc_flags & ALLOC_HARDER)
 		min -= min / 4;
 
-	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
+	if (free_pages <= min + lowmem_reserve)
 		return false;
 	for (o = 0; o < order; o++) {
 		/* At the next order, this order's pages become unavailable */
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes-fix.patch

