Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCCBC77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjESVkB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjESVj6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:39:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519BB101
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1999643FF
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496C7C433EF;
        Fri, 19 May 2023 21:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532396;
        bh=mlYSjc558Oi7oxtJVfgLBTxmj5IfSGMUu3L9pgPD2MQ=;
        h=Date:To:From:Subject:From;
        b=ZC32QrULk9H3Hlsz6X2/ssKS1aF989bhz4bJEOX3ylgAuAqqQN8G/ZQhsUJH73ock
         /or2mIdiMAwQviCVcdcBWJlSKebAnLdVRsUEadaqEzhNms878JbOwqGY8/rAfNZPJo
         w1njqgAVV1uMWw5Z9rnrs4omjS5pbeCvIpnMVjXc=
Date:   Fri, 19 May 2023 14:39:55 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-simplify-should_compact_retry.patch added to mm-unstable branch
Message-Id: <20230519213956.496C7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: simplify should_compact_retry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-simplify-should_compact_retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-simplify-should_compact_retry.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: simplify should_compact_retry()
Date: Fri, 19 May 2023 14:39:56 +0200

The different branches for retry are unnecessarily complicated.  There are
really only three outcomes: progress (retry n times), skipped (retry if
reclaim can help), failed (retry with higher priority).

Rearrange the branches and the retry counter to make it simpler.

Link: https://lkml.kernel.org/r/20230519123959.77335-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   53 +++++++++++++---------------------------------
 1 file changed, 16 insertions(+), 37 deletions(-)

--- a/mm/page_alloc.c~mm-compaction-simplify-should_compact_retry
+++ a/mm/page_alloc.c
@@ -3510,16 +3510,22 @@ should_compact_retry(struct alloc_contex
 	 * Compaction managed to coalesce some page blocks, but the
 	 * allocation failed presumably due to a race. Retry some.
 	 */
-	if (compact_result == COMPACT_SUCCESS)
-		(*compaction_retries)++;
+	if (compact_result == COMPACT_SUCCESS) {
+		/*
+		 * !costly requests are much more important than
+		 * __GFP_RETRY_MAYFAIL costly ones because they are de
+		 * facto nofail and invoke OOM killer to move on while
+		 * costly can fail and users are ready to cope with
+		 * that. 1/4 retries is rather arbitrary but we would
+		 * need much more detailed feedback from compaction to
+		 * make a better decision.
+		 */
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
+			max_retries /= 4;
 
-	/*
-	 * All zones were scanned completely and still no result. It
-	 * doesn't really make much sense to retry except when the
-	 * failure could be caused by insufficient priority
-	 */
-	if (compact_result == COMPACT_COMPLETE)
-		goto check_priority;
+		ret = ++(*compaction_retries) <= max_retries;
+		goto out;
+	}
 
 	/*
 	 * Compaction was skipped due to a lack of free order-0
@@ -3531,35 +3537,8 @@ should_compact_retry(struct alloc_contex
 	}
 
 	/*
-	 * If compaction backed due to being deferred, due to
-	 * contended locks in async mode, or due to scanners meeting
-	 * after a partial scan, retry with increased priority.
-	 */
-	if (compact_result == COMPACT_DEFERRED ||
-	    compact_result == COMPACT_CONTENDED ||
-	    compact_result == COMPACT_PARTIAL_SKIPPED)
-		goto check_priority;
-
-	/*
-	 * !costly requests are much more important than __GFP_RETRY_MAYFAIL
-	 * costly ones because they are de facto nofail and invoke OOM
-	 * killer to move on while costly can fail and users are ready
-	 * to cope with that. 1/4 retries is rather arbitrary but we
-	 * would need much more detailed feedback from compaction to
-	 * make a better decision.
-	 */
-	if (order > PAGE_ALLOC_COSTLY_ORDER)
-		max_retries /= 4;
-	if (*compaction_retries <= max_retries) {
-		ret = true;
-		goto out;
-	}
-
-	/*
-	 * Make sure there are attempts at the highest priority if we exhausted
-	 * all retries or failed at the lower priorities.
+	 * Compaction failed. Retry with increasing priority.
 	 */
-check_priority:
 	min_priority = (order > PAGE_ALLOC_COSTLY_ORDER) ?
 			MIN_COMPACT_COSTLY_PRIORITY : MIN_COMPACT_PRIORITY;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compaction-remove-compaction-result-helpers.patch
mm-compaction-simplify-should_compact_retry.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch

