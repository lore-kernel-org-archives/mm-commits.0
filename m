Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B263C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 22:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiFFWOm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 18:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiFFWOl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 18:14:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0826D1AD
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 15:14:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED8460A57
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 22:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E189EC34119;
        Mon,  6 Jun 2022 22:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654553679;
        bh=BlDlPUrvcz/JGAvXQW0r8zcmmsDCVAS42fwboK1ZsBA=;
        h=Date:To:From:Subject:From;
        b=ygEAxwBiFjp25kQ5+Q7x1qfYMZYUCws2H1ucmcWDNqYjY0D3ZmsRWQJXdbPTkt4cu
         RR//shSzDQsy+61/950kWR8KZ7dzBQQgh6NNb1PfboGx2t1LKewD/w0pfJbGGJogDj
         IwOabJpGSQ2ygExW1h4wxIDFGX/mO0zjGdAxJb0A=
Date:   Mon, 06 Jun 2022 15:14:38 -0700
To:     mm-commits@vger.kernel.org, tuhailong@gmail.com,
        gwhite@kupulau.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch added to mm-hotfixes-unstable branch
Message-Id: <20220606221438.E189EC34119@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: schedule 'damon_reclaim_timer' only after 'system_wq' is initialized
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/reclaim: schedule 'damon_reclaim_timer' only after 'system_wq' is initialized
Date: Sat, 4 Jun 2022 19:50:51 +0000

Commit 059342d1dd4e ("mm/damon/reclaim: fix the timer always stays
active") made DAMON_RECLAIM's 'enabled' parameter store callback,
'enabled_store()', to schedule 'damon_reclaim_timer'.  The scheduling uses
'system_wq', which is initialized in 'workqueue_init_early()'.  As kernel
parameters parsing function ('parse_args()') is called before
'workqueue_init_early()', 'enabled_store()' can be executed before
'workqueue_init_early()' and end up accessing the uninitialized
'system_wq'.  As a result, the booting hang[1].  This commit fixes the
issue by checking if the initialization is done before scheduling the
timer.

[1] https://lkml.kernel.org/20220604192222.1488-1-sj@kernel.org/

Link: https://lkml.kernel.org/r/20220604195051.1589-1-sj@kernel.org
Fixes: 059342d1dd4e ("mm/damon/reclaim: fix the timer always stays active")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Greg White <gwhite@kupulau.com>
Cc: Hailong Tu <tuhailong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized
+++ a/mm/damon/reclaim.c
@@ -374,6 +374,8 @@ static void damon_reclaim_timer_fn(struc
 }
 static DECLARE_DELAYED_WORK(damon_reclaim_timer, damon_reclaim_timer_fn);
 
+static bool damon_reclaim_initialized;
+
 static int enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
@@ -382,6 +384,10 @@ static int enabled_store(const char *val
 	if (rc < 0)
 		return rc;
 
+	/* system_wq might not initialized yet */
+	if (!damon_reclaim_initialized)
+		return rc;
+
 	if (enabled)
 		schedule_delayed_work(&damon_reclaim_timer, 0);
 
@@ -449,6 +455,8 @@ static int __init damon_reclaim_init(voi
 	damon_add_target(ctx, target);
 
 	schedule_delayed_work(&damon_reclaim_timer, 0);
+
+	damon_reclaim_initialized = true;
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch
docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch

