Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0832FE936E2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243987AbjJDUZO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244907AbjJDUYg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:24:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD3F10E4
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403D3C433C8;
        Wed,  4 Oct 2023 20:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451037;
        bh=LkS/mCrALlzTqMQi76mIWkEo9QVyQXKyO6sRugcsyJU=;
        h=Date:To:From:Subject:From;
        b=hzbQIe8lfBGrurM8pcNSJ9XUMkTFEQwdcTzZ/n/ZZHu/i6r2IXuvFLGZAdZp2E43G
         Q2xcXDiClVw/2xqYY0VYBjG47ZOkiC8bG9Uqbl6lfhWly4xsE1kOIuPJITmpcFtgKi
         JZZzwvyox3HIpiYH/JGu39gQ5QJF+I7hwEPit11A=
Date:   Wed, 04 Oct 2023 13:23:55 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taskstats-fill_stats_for_tgid-use-for_each_thread.patch removed from -mm tree
Message-Id: <20231004202357.403D3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: taskstats: fill_stats_for_tgid: use for_each_thread()
has been removed from the -mm tree.  Its filename was
     taskstats-fill_stats_for_tgid-use-for_each_thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: taskstats: fill_stats_for_tgid: use for_each_thread()
Date: Sat, 9 Sep 2023 23:49:51 +0200

do/while_each_thread should be avoided when possible.

Plus I _think_ this change allows to avoid lock_task_sighand() but I am
not sure, I forgot everything about taskstats.  In any case, this code
does not look right in that the same thread can be accounted twice:
taskstats_exit() can account the exiting thread in signal->stats and drop
->siglock but this thread is still on the thread-group list, so
lock_task_sighand() can't help.

Link: https://lkml.kernel.org/r/20230909214951.GA24274@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/taskstats.c~taskstats-fill_stats_for_tgid-use-for_each_thread
+++ a/kernel/taskstats.c
@@ -233,9 +233,8 @@ static int fill_stats_for_tgid(pid_t tgi
 	else
 		memset(stats, 0, sizeof(*stats));
 
-	tsk = first;
 	start_time = ktime_get_ns();
-	do {
+	for_each_thread(first, tsk) {
 		if (tsk->exit_state)
 			continue;
 		/*
@@ -258,7 +257,7 @@ static int fill_stats_for_tgid(pid_t tgi
 
 		stats->nvcsw += tsk->nvcsw;
 		stats->nivcsw += tsk->nivcsw;
-	} while_each_thread(first, tsk);
+	}
 
 	unlock_task_sighand(first, &flags);
 	rc = 0;
_

Patches currently in -mm which might be from oleg@redhat.com are


