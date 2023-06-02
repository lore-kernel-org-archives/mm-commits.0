Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4031C77B7A
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 18:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbjFBSfZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jun 2023 14:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236967AbjFBSfY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2023 14:35:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12417194
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 11:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ABDC6526D
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 18:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB153C433EF;
        Fri,  2 Jun 2023 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685730922;
        bh=MKe9/V9t8PQaNtVGwK6DmPIZYvprszhelGGtULVUKmA=;
        h=Date:To:From:Subject:From;
        b=F0nrapUDjke5CYEcPfeExGw0XXJDkEhKnlxfg25zqll5P6OpZspRbJKhcZur9m1ot
         QNp1tmRz/yorLBuUik0ytv6SxfCP6hHDWNIIEBNeWYCKFXNwayJahS0MW4DdAXybtj
         1p5uCO0NuQN5rTIkbcAXLaFFZxWpXuiCdOQl8/dg=
Date:   Fri, 02 Jun 2023 11:35:21 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-simplify-should_compact_retry-fix.patch added to mm-unstable branch
Message-Id: <20230602183521.DB153C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-simplify-should_compact_retry-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-simplify-should_compact_retry-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-simplify-should_compact_retry-fix.patch

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
mm-compaction-simplify-should_compact_retry-fix.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-refactor-__compaction_suitable-fix.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch
mm-compaction-have-compaction_suitable-return-bool.patch
mm-page_isolation-write-proper-kerneldoc.patch
mm-compaction-avoid-gfp_nofs-abba-deadlock.patch

