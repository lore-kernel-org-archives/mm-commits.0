Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACD7C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244349AbiATV2q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38614 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbiATV2p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58C3061715
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3140C340E0;
        Thu, 20 Jan 2022 21:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714124;
        bh=0qXPidcIy4qPUJNF0Feqe2Ox1yZCDAf3i8LxACnaBVs=;
        h=Date:From:To:Subject:From;
        b=JmAyBFFT51sl+gO5/LHrA+Eo+hQ0rAw/EnZBEpWbrojtY8g4s5Eb7HXMs2amoZdEl
         pn1glIxP983Cy0XrB31vIllp2jCkx+41pX/YDZMde27hG77E5Jebg29VYbosAlYMxL
         raUScF2MT8y7RhbmUpDGY7DygVdE7jwDs+caGEwc=
Date:   Thu, 20 Jan 2022 13:28:44 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch
 removed from -mm tree
Message-ID: <20220120212844.4oNEAwOxk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove a mistakenly added comment for a future feature
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are


