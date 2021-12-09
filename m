Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162BEC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhLIUgJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:36:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34546 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhLIUgI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:36:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42D03B82410
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA311C341CA;
        Thu,  9 Dec 2021 20:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639081953;
        bh=VEz1UwWufGe65aRDDVRrUu9mlons55BdOZu0JtzUwTw=;
        h=Date:From:To:Subject:From;
        b=k8/3bYCWXHc5SbrpOfBAFLegh00Ul10bjKVh/WQKorwgmpu30Kfl/D1B5T7y0ekFc
         AT/goVOMQ+dIO0h/s9K5qz6JP5TaIuw5TyWO50ITNJSW4hMk6opfKh0SPos6mH/IJa
         pVNC4RAVISz3lEDozvJiSND2WptKCqharc5OJIZs=
Date:   Thu, 09 Dec 2021 12:32:32 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch added
 to -mm tree
Message-ID: <20211209203232.4Nkg8cO0c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove a mistakenly added comment for a future feature
has been added to the -mm tree.  Its filename is
     mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch
mm-damon-dbgfs-remove-an-unnecessary-error-message.patch
mm-damon-core-remove-unnecessary-error-messages.patch
mm-damon-vaddr-remove-an-unnecessary-warning-message.patch
mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch
mm-damon-vaddr-test-remove-unnecessary-variables.patch
selftests-damon-skip-test-if-damon-is-running.patch
selftests-damon-test-damon-enabling-with-empty-target_ids-case.patch
selftests-damon-test-wrong-damos-condition-ranges-input.patch
selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch
selftests-damon-split-test-cases.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch

