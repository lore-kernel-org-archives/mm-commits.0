Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33007C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381251AbiEMTUy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383456AbiEMTUw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:20:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B090E71
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:20:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2959FB83128
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6FDC34113;
        Fri, 13 May 2022 19:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469646;
        bh=rl6DhJkOjUxCR+LRDhvTlwC5QIpO6RBJaL+TE/RoIu0=;
        h=Date:To:From:Subject:From;
        b=DZAgPoxHLL9XYojB3ViwCEixIQegbveJAxQ9vAIMZoHHiGIEFfPvz/1aNCzU0F8ZU
         pVC8pH4IDrGSccU4QrGInROJrvgxtvBPh1xXenLKCL+odCw7BbtfTAISne6ediWTsm
         gAC3ZaVrUAFftXm/J8PhA/nv3i3rnFxWekznRBEM=
Date:   Fri, 13 May 2022 12:20:46 -0700
To:     mm-commits@vger.kernel.org, ohkwon1043@gmail.com, mgorman@suse.de,
        lakroforce@gmail.com, jsyoo5b@gmail.com, hannes@cmpxchg.org,
        dthex5d@gmail.com, vvghjk1234@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-cache-the-result-of-node_dirty_ok.patch removed from -mm tree
Message-Id: <20220513192046.BD6FDC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: cache the result of node_dirty_ok()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-cache-the-result-of-node_dirty_ok.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wonhyuk Yang <vvghjk1234@gmail.com>
Subject: mm/page_alloc: cache the result of node_dirty_ok()

To spread dirty pages, nodes are checked whether they have reached the
dirty limit using the expensive node_dirty_ok().  To reduce the frequency
of calling node_dirty_ok(), the last node that hit the dirty limit can be
cached.

Instead of caching the node, caching both the node and its node_dirty_ok()
status can reduce the number of calle to node_dirty_ok().

[akpm@linux-foundation.org: rename last_pgdat_dirty_limit to last_pgdat_dirty_ok]
Link: https://lkml.kernel.org/r/20220430011032.64071-1-vvghjk1234@gmail.com
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Donghyeok Kim <dthex5d@gmail.com>
Cc: JaeSang Yoo <jsyoo5b@gmail.com>
Cc: Jiyoup Kim <lakroforce@gmail.com>
Cc: Ohhoon Kwon <ohkwon1043@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-cache-the-result-of-node_dirty_ok
+++ a/mm/page_alloc.c
@@ -4021,7 +4021,8 @@ get_page_from_freelist(gfp_t gfp_mask, u
 {
 	struct zoneref *z;
 	struct zone *zone;
-	struct pglist_data *last_pgdat_dirty_limit = NULL;
+	struct pglist_data *last_pgdat = NULL;
+	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 
 retry:
@@ -4060,13 +4061,13 @@ retry:
 		 * dirty-throttling and the flusher threads.
 		 */
 		if (ac->spread_dirty_pages) {
-			if (last_pgdat_dirty_limit == zone->zone_pgdat)
-				continue;
+			if (last_pgdat != zone->zone_pgdat) {
+				last_pgdat = zone->zone_pgdat;
+				last_pgdat_dirty_ok = node_dirty_ok(zone->zone_pgdat);
+			}
 
-			if (!node_dirty_ok(zone->zone_pgdat)) {
-				last_pgdat_dirty_limit = zone->zone_pgdat;
+			if (!last_pgdat_dirty_ok)
 				continue;
-			}
 		}
 
 		if (no_fallback && nr_online_nodes > 1 &&
_

Patches currently in -mm which might be from vvghjk1234@gmail.com are

mm-page_alloc-fix-tracepoint-mm_page_alloc_zone_locked.patch

