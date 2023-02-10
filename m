Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC955C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjBJA4f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjBJAzM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B725B7430B
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6446CB82398
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CF7C4339B;
        Fri, 10 Feb 2023 00:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990450;
        bh=e4jn/c1pFLX3oWr+DPVgzJGfqTYL7JNWNzDdmfVAJe0=;
        h=Date:To:From:Subject:From;
        b=JFW3vLjQPP2qtocIqQdgNU3pa+YSB4OCzs0xIbF7BkD88rcj1/MVqkWLOLCUd9B0f
         cAQGmk6DpZUfecyEovDn5joR3C80c8az8z6t7ApqynaEoVzRpdkeO8w/qp2SHVJNRA
         KwpwTKn3oCXk7SrQ2FfoAEu/3L9gRSMlzBKe1Y5Y=
Date:   Thu, 09 Feb 2023 16:54:09 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz,
        rppt@linux.ibm.com, rppt@kernel.org, osalvador@suse.de,
        mgorman@techsingularity.net, david@redhat.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-reduce-fallbacks-to-migrate_pcptypes-1.patch removed from -mm tree
Message-Id: <20230210005409.F3CF7C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: reduce fallbacks to (MIGRATE_PCPTYPES - 1)
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reduce-fallbacks-to-migrate_pcptypes-1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/page_alloc: reduce fallbacks to (MIGRATE_PCPTYPES - 1)
Date: Fri, 3 Feb 2023 18:01:32 +0800

The commit 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackable
pageblocks with others") has removed MIGRATE_CMA and MIGRATE_ISOLATE from
fallbacks list. so there is no need to add an element at the end of every
type.

Reduce fallbacks to (MIGRATE_PCPTYPES - 1).

Link: https://lkml.kernel.org/r/20230203100132.1627787-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-reduce-fallbacks-to-migrate_pcptypes-1
+++ a/mm/page_alloc.c
@@ -2603,10 +2603,10 @@ struct page *__rmqueue_smallest(struct z
  *
  * The other migratetypes do not have fallbacks.
  */
-static int fallbacks[MIGRATE_TYPES][3] = {
-	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_TYPES },
-	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_TYPES },
-	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_TYPES },
+static int fallbacks[MIGRATE_TYPES][MIGRATE_PCPTYPES - 1] = {
+	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE   },
+	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE },
+	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE   },
 };
 
 #ifdef CONFIG_CMA
@@ -2865,11 +2865,8 @@ int find_suitable_fallback(struct free_a
 		return -1;
 
 	*can_steal = false;
-	for (i = 0;; i++) {
+	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
 		fallback_mt = fallbacks[migratetype][i];
-		if (fallback_mt == MIGRATE_TYPES)
-			break;
-
 		if (free_area_empty(area, fallback_mt))
 			continue;
 
_

Patches currently in -mm which might be from yajun.deng@linux.dev are


