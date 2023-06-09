Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F89C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjFIXSO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjFIXSN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:18:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966AC2D74
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18D84618CA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7E2C433D2;
        Fri,  9 Jun 2023 23:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352691;
        bh=M23WrWIT4vLtxwoHz9Pgg8M/VA8qlmcRZcW3Pexev0M=;
        h=Date:To:From:Subject:From;
        b=fefScrOlIz05FsPaxXkHRTMj0IoFMXnwDyTzAluDrFEWvTxgpV/0VyoDpLkK/ow7D
         Nd+JjKdOQE072f5tsqIDeoZUp97oAyO9PtxnYEAGb96DI3VHK7SCh0W1lC62I4tQMM
         D4ORIIE3R0G0emi1usRqCIBiS2U61pq06kp+AWM8=
Date:   Fri, 09 Jun 2023 16:18:10 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-compaction-simplify-should_compact_retry-fix.patch removed from -mm tree
Message-Id: <20230609231811.6A7E2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-compaction-simplify-should_compact_retry-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-simplify-should_compact_retry-fix.patch

This patch was dropped because it was folded into mm-compaction-simplify-should_compact_retry.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-compaction-simplify-should_compact_retry-fix
Date: Fri, 2 Jun 2023 10:47:05 -0400

Vlastimil points out an unintended change. Previously when hitting
max_retries we'd bump the priority level and restart the loop. Now we
bail out and fail instead. Restore the original behavior.

Link: https://lkml.kernel.org/r/20230602144705.GB161817@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-compaction-simplify-should_compact_retry-fix
+++ a/mm/page_alloc.c
@@ -3506,6 +3506,15 @@ should_compact_retry(struct alloc_contex
 		return false;
 
 	/*
+	 * Compaction was skipped due to a lack of free order-0
+	 * migration targets. Continue if reclaim can help.
+	 */
+	if (compact_result == COMPACT_SKIPPED) {
+		ret = compaction_zonelist_suitable(ac, order, alloc_flags);
+		goto out;
+	}
+
+	/*
 	 * Compaction managed to coalesce some page blocks, but the
 	 * allocation failed presumably due to a race. Retry some.
 	 */
@@ -3522,17 +3531,10 @@ should_compact_retry(struct alloc_contex
 		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			max_retries /= 4;
 
-		ret = ++(*compaction_retries) <= max_retries;
-		goto out;
-	}
-
-	/*
-	 * Compaction was skipped due to a lack of free order-0
-	 * migration targets. Continue if reclaim can help.
-	 */
-	if (compact_result == COMPACT_SKIPPED) {
-		ret = compaction_zonelist_suitable(ac, order, alloc_flags);
-		goto out;
+		if (++(*compaction_retries) <= max_retries) {
+			ret = true;
+			goto out;
+		}
 	}
 
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compaction-remove-compaction-result-helpers.patch
mm-compaction-simplify-should_compact_retry.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-refactor-__compaction_suitable-fix.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch
mm-compaction-have-compaction_suitable-return-bool.patch
mm-compaction-avoid-gfp_nofs-abba-deadlock.patch
mm-page_isolation-write-proper-kerneldoc.patch

