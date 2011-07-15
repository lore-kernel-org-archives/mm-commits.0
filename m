From: akpm@linux-foundation.org
Subject: + mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch added to -mm tree
Date: Fri, 15 Jul 2011 12:57:24 -0700
Message-ID: <201107151957.p6FJvO14030553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab1GOT6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Jul 2011 15:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     mm: page allocator: reconsider zones for allocation after direct reclaim
has been added to the -mm tree.  Its filename is
     mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch

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
Subject: mm: page allocator: reconsider zones for allocation after direct reclaim
From: Mel Gorman <mgorman@suse.de>

With zone_reclaim_mode enabled, it's possible for zones to be considered
full in the zonelist_cache so they are skipped in the future.  If the
process enters direct reclaim, the ZLC may still consider zones to be full
even after reclaiming pages.  Reconsider all zones for allocation if
direct reclaim returns successfully.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN mm/page_alloc.c~mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim
+++ a/mm/page_alloc.c
@@ -1616,6 +1616,21 @@ static void zlc_mark_zone_full(struct zo
 	set_bit(i, zlc->fullzones);
 }
 
+/*
+ * clear all zones full, called after direct reclaim makes progress so that
+ * a zone that was recently full is not skipped over for up to a second
+ */
+static void zlc_clear_zones_full(struct zonelist *zonelist)
+{
+	struct zonelist_cache *zlc;	/* cached zonelist speedup info */
+
+	zlc = zonelist->zlcache_ptr;
+	if (!zlc)
+		return;
+
+	bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
+}
+
 #else	/* CONFIG_NUMA */
 
 static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
@@ -1963,6 +1978,10 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	if (unlikely(!(*did_some_progress)))
 		return NULL;
 
+	/* After successful reclaim, reconsider all zones for allocation */
+	if (NUMA_BUILD)
+		zlc_clear_zones_full(zonelist);
+
 retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page-allocator-initialise-zlc-for-first-zone-eligible-for-zone_reclaim.patch
mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch

