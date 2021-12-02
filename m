Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D80C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 03:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355243AbhLBDol (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355231AbhLBDn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 22:43:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACE1C061748
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 19:40:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52EE5B82148
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 03:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9A5C00446;
        Thu,  2 Dec 2021 03:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638416426;
        bh=Apvwact+BMkQctxL1ojJgl7/AwFkiK3rWvTDxLgjnaM=;
        h=Date:From:To:Subject:From;
        b=fdvt8/L4as9B2Z3wEVUcZYkMW2Yr5DCiXGW2TaXy+C3l8OGdaqMtTfPH1/++nTOgK
         R4lPPpBsqZdpKB/Jwvhy4j8oWxw0T+0UPBYGZsFDfRy1KCQl889UVdk8+sX1mK/tua
         dl62OLIfE7CpeDCggw0PqB+SUzV9Ge3Gcb03Zis0=
Date:   Wed, 01 Dec 2021 19:40:25 -0800
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sj@kernel.org
Subject:  +
 mm-damon-dbgfs-remove-an-unnecessary-error-message.patch added to -mm tree
Message-ID: <20211202034025.mMbSYQxOu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: remove an unnecessary error message
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-remove-an-unnecessary-error-message.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-remove-an-unnecessary-error-message.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-remove-an-unnecessary-error-message.patch

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
Subject: mm/damon/dbgfs: remove an unnecessary error message

When wrong scheme action is requested via the debugfs interface, DAMON
prints an error message.  Because the function returns error code, this is
not really needed.  Because the code path is triggered by the user
specified input, this can result in kernel log mistakenly being messy.  To
avoid the case, this commit removes the message.

Link: https://lkml.kernel.org/r/20211201150440.1088-3-sj@kernel.org
Fixes: af122dd8f3c0 ("mm/damon/dbgfs: support DAMON-based Operation Schemes")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-remove-an-unnecessary-error-message
+++ a/mm/damon/dbgfs.c
@@ -210,10 +210,8 @@ static struct damos **str_to_schemes(con
 				&wmarks.low, &parsed);
 		if (ret != 18)
 			break;
-		if (!damos_action_valid(action)) {
-			pr_err("wrong action %d\n", action);
+		if (!damos_action_valid(action))
 			goto fail;
-		}
 
 		pos += parsed;
 		scheme = damon_new_scheme(min_sz, max_sz, min_nr_a, max_nr_a,
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

