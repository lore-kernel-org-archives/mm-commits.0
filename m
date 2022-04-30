Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003B7C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 30 Apr 2022 18:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244111AbiD3Smt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 30 Apr 2022 14:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244117AbiD3Smr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 30 Apr 2022 14:42:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0183B28B
        for <mm-commits@vger.kernel.org>; Sat, 30 Apr 2022 11:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B413CE0025
        for <mm-commits@vger.kernel.org>; Sat, 30 Apr 2022 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DCEC385AA;
        Sat, 30 Apr 2022 18:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651343961;
        bh=9pvRy/ddilD3yDLbxH0Q0RpW0c1RHUS8eOfsAnO1HS4=;
        h=Date:To:From:Subject:From;
        b=iG3ASenquJ3IFOdKu5u5LI/6J2GHQe8h/xDfkWwE1pe52oSmKzzEBFqIxgLHOA6tp
         BDWwvJGhQ4fNittExqxWyR7IPa5IMWUmzlkTdIFO85afGinjKmJcGn3MUm1+UGlDC3
         GJ9EIJpssvTIPqEvwzDXZBkLaUQjL6M76gUIvDgg=
Date:   Sat, 30 Apr 2022 11:39:20 -0700
To:     mm-commits@vger.kernel.org, ohkwon1043@gmail.com,
        mgorman@techsingularity.net, lakroforce@gmail.com,
        jsyoo5b@gmail.com, hannes@cmpxchg.org, dthex5d@gmail.com,
        vvghjk1234@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-cache-the-result-of-node_dirty_ok.patch added to mm-unstable branch
Message-Id: <20220430183921.16DCEC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: cache the result of node_dirty_ok()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-cache-the-result-of-node_dirty_ok.patch

This patch should soon appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wonhyuk Yang <vvghjk1234@gmail.com>
Subject: mm/page_alloc: cache the result of node_dirty_ok()

To spread dirty pages, nodes are checked whether they have reached the
dirty limit using the expensive node_dirty_ok().  To reduce the frequency
of calling node_dirty_ok(), the last node that hit the dirty limit can be
cached.

Instead of caching the node, caching both the node and its node_dirty_ok()
status can reduce the number of calle to node_dirty_ok().

Link: https://lkml.kernel.org/r/20220430011032.64071-1-vvghjk1234@gmail.com
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
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
+	bool last_pgdat_dirty_limit = false;
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
+				last_pgdat_dirty_limit = node_dirty_ok(zone->zone_pgdat);
+			}
 
-			if (!node_dirty_ok(zone->zone_pgdat)) {
-				last_pgdat_dirty_limit = zone->zone_pgdat;
+			if (!last_pgdat_dirty_limit)
 				continue;
-			}
 		}
 
 		if (no_fallback && nr_online_nodes > 1 &&
_

Patches currently in -mm which might be from vvghjk1234@gmail.com are

mm-page_alloc-cache-the-result-of-node_dirty_ok.patch

