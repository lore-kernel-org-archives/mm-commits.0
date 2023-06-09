Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE1AC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjFIXbX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjFIX3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35154228
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFAFE61AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FD3C433EF;
        Fri,  9 Jun 2023 23:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353330;
        bh=y9QkWNph8bYidFY0gOyTFfFEc3pPdbWs4kNHYGWP83s=;
        h=Date:To:From:Subject:From;
        b=D6tZQFXMvbu70jUQ/Jscr3SVWSyNpANmKWkEJZlFUwSzWyFinPAZL5XL+efn3uA38
         DzA+XZ0JDaq/6oVbECYyKCgf+BpAw9XKZZWAfIhC7rN8MWOzQZr3VBjG6OSfn9735i
         3x5hgPB9wUlnbSoorUbzE3NWbiZVXj6jpXuKeuLA=
Date:   Fri, 09 Jun 2023 16:28:49 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-simplify-should_compact_retry.patch removed from -mm tree
Message-Id: <20230609232850.21FD3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: simplify should_compact_retry()
has been removed from the -mm tree.  Its filename was
     mm-compaction-simplify-should_compact_retry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: simplify should_compact_retry()
Date: Fri, 19 May 2023 14:39:56 +0200

The different branches for retry are unnecessarily complicated.  There are
really only three outcomes: progress (retry n times), skipped (retry if
reclaim can help), failed (retry with higher priority).

Rearrange the branches and the retry counter to make it simpler.

[hannes@cmpxchg.org: restore behavior when hitting max_retries]
  Link: https://lkml.kernel.org/r/20230602144705.GB161817@cmpxchg.org
Link: https://lkml.kernel.org/r/20230519123959.77335-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   59 +++++++++++++++-------------------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

--- a/mm/page_alloc.c~mm-compaction-simplify-should_compact_retry
+++ a/mm/page_alloc.c
@@ -3470,21 +3470,6 @@ should_compact_retry(struct alloc_contex
 		return false;
 
 	/*
-	 * Compaction managed to coalesce some page blocks, but the
-	 * allocation failed presumably due to a race. Retry some.
-	 */
-	if (compact_result == COMPACT_SUCCESS)
-		(*compaction_retries)++;
-
-	/*
-	 * All zones were scanned completely and still no result. It
-	 * doesn't really make much sense to retry except when the
-	 * failure could be caused by insufficient priority
-	 */
-	if (compact_result == COMPACT_COMPLETE)
-		goto check_priority;
-
-	/*
 	 * Compaction was skipped due to a lack of free order-0
 	 * migration targets. Continue if reclaim can help.
 	 */
@@ -3494,35 +3479,31 @@ should_compact_retry(struct alloc_contex
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
+	 * Compaction managed to coalesce some page blocks, but the
+	 * allocation failed presumably due to a race. Retry some.
 	 */
-	if (order > PAGE_ALLOC_COSTLY_ORDER)
-		max_retries /= 4;
-	if (*compaction_retries <= max_retries) {
-		ret = true;
-		goto out;
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
+
+		if (++(*compaction_retries) <= max_retries) {
+			ret = true;
+			goto out;
+		}
 	}
 
 	/*
-	 * Make sure there are attempts at the highest priority if we exhausted
-	 * all retries or failed at the lower priorities.
+	 * Compaction failed. Retry with increasing priority.
 	 */
-check_priority:
 	min_priority = (order > PAGE_ALLOC_COSTLY_ORDER) ?
 			MIN_COMPACT_COSTLY_PRIORITY : MIN_COMPACT_PRIORITY;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_isolation-write-proper-kerneldoc.patch

