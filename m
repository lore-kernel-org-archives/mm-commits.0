Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEB6C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 19:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiFFTSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiFFTSB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 15:18:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A858A320
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 12:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EF796145D
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 19:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A28C34115;
        Mon,  6 Jun 2022 19:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654543077;
        bh=2IzEFJLMqEOWprin58yvcr4dQ9VAAJ5nSLQy2r+EgC0=;
        h=Date:To:From:Subject:From;
        b=GpYk8dsHOV9F3kyNwnb7zbAgXNLIR4QOKQ1M2jIwIwnxs1uTuxajU+T4ZBRpIbmFk
         2qMxQaAg9NML12AWE1zlekYUns4wALjUbE0mf2YHIs53I9gi41+meNFN0XH/Brk0Iv
         db0EuCoiI2LWAIYaxRXv4/vPmhHDBXpEMiHEYSS4=
Date:   Mon, 06 Jun 2022 12:17:56 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-make-enabled-checking-timer-simpler.patch added to mm-unstable branch
Message-Id: <20220606191757.81A28C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: make 'enabled' checking timer simpler
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-make-enabled-checking-timer-simpler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-make-enabled-checking-timer-simpler.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: make 'enabled' checking timer simpler
Date: Mon, 6 Jun 2022 18:23:09 +0000

DAMON_RECLAIM's 'enabled' parameter store callback ('enabled_store()')
schedules the parameter check timer ('damon_reclaim_timer') if the
parameter is set as 'Y'.  Then, the timer schedules itself to check if
user has set the parameter as 'N'.  It's unnecessarily complex.

This commit makes it simpler by making the parameter store callback to
schedule the timer regardless of the parameter value and disabling the
timer's self scheduling.

Link: https://lkml.kernel.org/r/20220606182310.48781-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-make-enabled-checking-timer-simpler
+++ a/mm/damon/reclaim.c
@@ -353,7 +353,6 @@ static int damon_reclaim_turn(bool on)
 	return 0;
 }
 
-#define ENABLE_CHECK_INTERVAL_MS	1000
 static struct delayed_work damon_reclaim_timer;
 static void damon_reclaim_timer_fn(struct work_struct *work)
 {
@@ -367,10 +366,6 @@ static void damon_reclaim_timer_fn(struc
 		else
 			enabled = last_enabled;
 	}
-
-	if (enabled)
-		schedule_delayed_work(&damon_reclaim_timer,
-			msecs_to_jiffies(ENABLE_CHECK_INTERVAL_MS));
 }
 static DECLARE_DELAYED_WORK(damon_reclaim_timer, damon_reclaim_timer_fn);
 
@@ -382,9 +377,7 @@ static int enabled_store(const char *val
 	if (rc < 0)
 		return rc;
 
-	if (enabled)
-		schedule_delayed_work(&damon_reclaim_timer, 0);
-
+	schedule_delayed_work(&damon_reclaim_timer, 0);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch

