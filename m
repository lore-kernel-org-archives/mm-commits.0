Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF56C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjFIXTO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjFIXTN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:19:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8A82D74
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B14961870
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02A5C433D2;
        Fri,  9 Jun 2023 23:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352752;
        bh=ruGjLLYfN2SqdxK3qg0KNAP+CeOuUzLfzBVWwV/V648=;
        h=Date:To:From:Subject:From;
        b=y8y8ZW7z5aY8nh55GLQ43wLFpsjl4etMouqnuAv/Uh3Djluo7gyjJiDjOdLcGwtRV
         bAGS3wcPbfqh4HQKxZGGo2KOJ0jIveGlsXUJh9etZrRfBwuR1p/3RIDEf5emBDyFQQ
         Ol5Fnq2PP73Hbm2KdRQlnhAuDItUskri5LfwzZUc=
Date:   Fri, 09 Jun 2023 16:19:11 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-compaction-refactor-__compaction_suitable-fix.patch removed from -mm tree
Message-Id: <20230609231911.E02A5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-compaction-refactor-__compaction_suitable-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-refactor-__compaction_suitable-fix.patch

This patch was dropped because it was folded into mm-compaction-refactor-__compaction_suitable.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-compaction-refactor-__compaction_suitable-fix
Date: Fri, 2 Jun 2023 10:49:42 -0400

Vlastimil points out the function comment is stale now. Update it.

Link: https://lkml.kernel.org/r/20230602144942.GC161817@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-refactor-__compaction_suitable-fix
+++ a/mm/compaction.c
@@ -2226,7 +2226,6 @@ static enum compact_result __compaction_
  * compaction_suitable: Is this suitable to run compaction on this zone now?
  * Returns
  *   COMPACT_SKIPPED  - If there are too few free pages for compaction
- *   COMPACT_SUCCESS  - If the allocation would succeed without compaction
  *   COMPACT_CONTINUE - If compaction should run now
  */
 enum compact_result compaction_suitable(struct zone *zone, int order,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compaction-remove-compaction-result-helpers.patch
mm-compaction-simplify-should_compact_retry.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch
mm-compaction-have-compaction_suitable-return-bool.patch
mm-compaction-avoid-gfp_nofs-abba-deadlock.patch
mm-page_isolation-write-proper-kerneldoc.patch

