Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB06C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 03:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355268AbhLBDog (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355230AbhLBDn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 22:43:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F06C061574
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 19:40:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 286A8CE2160
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 03:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A65C00446;
        Thu,  2 Dec 2021 03:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638416423;
        bh=fYDf5uak2ZPZfK1g5SQC1PajmmR50PVDrKt8WYlqQQM=;
        h=Date:From:To:Subject:From;
        b=yvFkrsXgW0dQkx/9OUakpNM6uw0pcKW4yS7ZS/A4y1zlhX5co6cDPFMkwcR7yQvtj
         mjI+681Eui2WS9t18veHXfQ0vXwwIlpw5UXqbYheVJ8OotrJ/y8PCeeV2IvZ61zFLd
         fJyHUKhZmmTEaUZHalsN1nOnxVHBLv2I7Y7b23dk=
Date:   Wed, 01 Dec 2021 19:40:22 -0800
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sj@kernel.org
Subject:  +
 mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch added
 to -mm tree
Message-ID: <20211202034022.1_N7p1Uux%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: use better timer mechanisms selection threshold
has been added to the -mm tree.  Its filename is
     mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch

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
Subject: mm/damon/core: use better timer mechanisms selection threshold

Patch series "mm/damon: Trivial fixups and improvements".

This patchset contains trivial fixups and improvements for DAMON and its
kunit/kselftest tests.


This patch (of 11):

DAMON is using hrtimer if requested sleep time is <=100ms, while the
suggested threshold[1] is <=20ms.  This commit applies the threshold.

[1] Documentation/timers/timers-howto.rst

Link: https://lkml.kernel.org/r/20211201150440.1088-2-sj@kernel.org
Fixes: ee801b7dd7822 ("mm/damon/schemes: activate schemes based on a watermarks mechanism")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-use-better-timer-mechanisms-selection-threshold
+++ a/mm/damon/core.c
@@ -980,7 +980,8 @@ static unsigned long damos_wmark_wait_us
 
 static void kdamond_usleep(unsigned long usecs)
 {
-	if (usecs > 100 * 1000)
+	/* See Documentation/timers/timers-howto.rst for the thresholds */
+	if (usecs > 20 * USEC_PER_MSEC)
 		schedule_timeout_idle(usecs_to_jiffies(usecs));
 	else
 		usleep_idle_range(usecs, usecs + 1);
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

