Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AAAC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344759AbhLJWuH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43444 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344718AbhLJWuG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EA1BB827BD
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00E7C341CA;
        Fri, 10 Dec 2021 22:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176389;
        bh=5pepvlccPgW9ZYLhkz882Z6CHZls7H4EBcsRgCcv8ZM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JZFC16uP2UkYsBf1cZsqF+9ZpBB1dZKbG6wFI6eAlwNTozXoIE53LimBKhgMrXLhy
         U5ijcHI1giQ2q3ZGztqBlHUtCDRSH7ooAOtT2o/dkMB4PLcn5U2F52O7ExCaCpINzA
         UwkZ0qAtvVhQaCO2v4iNGPWmhDq53yarPM5dekbA=
Date:   Fri, 10 Dec 2021 14:46:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 07/21] mm/damon/core: use better timer mechanisms
 selection threshold
Message-ID: <20211210224628.Kbw1PsKxu%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
