Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E43C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiANWKS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:18 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38458 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiANWKS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B3E13CE2497
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1162C36AE9;
        Fri, 14 Jan 2022 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198215;
        bh=0wpDmZGhi9LlL0lT+cuhNOqCuaItfO0G1UgkHf7/l5U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Bl8MD/34u6Vs4uMu7KpuR8P03BGSPRVxWmlLgQwH2fBGNlbW6A3Zf+10iU3yGKJ2N
         hpo3IAcNeRISuBTCc5/jZklv4jTlt8+QpWgZ6wJwnrvNDL1T7ubFfLDlpWgsBglZ28
         4Vhgy5ATdLpJp2hpglxBVMNm/pB/lyhHIPl/KfGg=
Date:   Fri, 14 Jan 2022 14:10:14 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 134/146] mm/damon: remove a mistakenly added
 comment for a future feature
Message-ID: <20220114221014.MeoVZWm-2%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: remove a mistakenly added comment for a future feature

Due to a mistake in patches reordering, a comment for a future feature
called 'arbitrary monitoring target support'[1], which is still under
development, has added.  Because it only introduces confusion and we don't
have a plan to post the patches soon, this commit removes the mistakenly
added part.

[1] https://lore.kernel.org/linux-mm/20201215115448.25633-3-sjpark@amazon.com/

Link: https://lkml.kernel.org/r/20211209131806.19317-7-sj@kernel.org
Fixes: 1f366e421c8f ("mm/damon/core: implement DAMON-based Operation Schemes (DAMOS)")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature
+++ a/include/linux/damon.h
@@ -281,7 +281,7 @@ struct damon_ctx;
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
  * DAMON-based operation scheme is found.  It should apply the scheme's action
- * to the region.  This is not used for &DAMON_ARBITRARY_TARGET case.
+ * to the region.
  * @target_valid should check whether the target is still valid for the
  * monitoring.
  * @cleanup is called from @kdamond just before its termination.
_
