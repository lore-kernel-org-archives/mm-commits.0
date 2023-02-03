Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A99C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 22:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjBCWYx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 17:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbjBCWYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 17:24:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B11A69503
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 14:24:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A5416202B
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 22:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AFEC433D2;
        Fri,  3 Feb 2023 22:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675463085;
        bh=MQ05PtIRg5cE4ERZXXjDcpwXneIWNBdGoVz6+69oe9o=;
        h=Date:To:From:Subject:From;
        b=U8LbUQxopZQoyZN68diZn+IbZYzHBfMQkHNa+TF8R2yLcl6tKqmas/bQP0DD29GEU
         KzCe3jQ4hs/7Hofglq9c43WPzBBAt5a2QauLkoNbUHWxpWam0N32+lCOBnj+L8Bi0b
         iQ2C1swb/r+9J49x1yXjLSCXu+B71riIO2kJuGBU=
Date:   Fri, 03 Feb 2023 14:24:44 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz,
        rppt@linux.ibm.com, rppt@kernel.org, osalvador@suse.de,
        mgorman@techsingularity.net, david@redhat.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-reduce-fallbacks-to-migrate_pcptypes-1.patch added to mm-unstable branch
Message-Id: <20230203222444.E0AFEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: reduce fallbacks to (MIGRATE_PCPTYPES - 1)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-reduce-fallbacks-to-migrate_pcptypes-1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-reduce-fallbacks-to-migrate_pcptypes-1.patch

This patch will later appear in the mm-unstable branch at
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
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

mm-page_alloc-reduce-fallbacks-to-migrate_pcptypes-1.patch

