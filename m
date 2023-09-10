Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA66C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 19:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjIJTX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 15:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjIJTX1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 15:23:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EA0188
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 12:23:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8F0C433C8;
        Sun, 10 Sep 2023 19:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694373803;
        bh=kKhBdZocki8RFcl2pZIgFy+puWjs3+YvRdkMz3cWBrw=;
        h=Date:To:From:Subject:From;
        b=gxMghs5CJN7FC7y7xQLWBt5Sbj3ToBZGvp2C91AA6Eui+ei+oU07u2nH9jSqblVec
         o4DKqA08lLcK16IZ31XvSqYIoq9j+CQThs/EDkQU+yYpxeiSzqUw2om4iNmkf6xppY
         OfSS+hy5qI+nkrOZmrAtYLWwXjeWSNxXGfxmP2GQ=
Date:   Sun, 10 Sep 2023 12:23:22 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-do_task_stat-use-__for_each_thread.patch added to mm-nonmm-unstable branch
Message-Id: <20230910192323.4E8F0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: do_task_stat: use __for_each_thread()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-proc-do_task_stat-use-__for_each_thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-do_task_stat-use-__for_each_thread.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc: do_task_stat: use __for_each_thread()
Date: Sat, 9 Sep 2023 18:45:01 +0200

do/while_each_thread should be avoided when possible.

Link: https://lkml.kernel.org/r/20230909164501.GA11581@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/array.c~fs-proc-do_task_stat-use-__for_each_thread
+++ a/fs/proc/array.c
@@ -536,12 +536,13 @@ static int do_task_stat(struct seq_file
 
 		/* add up live thread stats at the group level */
 		if (whole) {
-			struct task_struct *t = task;
-			do {
+			struct task_struct *t;
+
+			__for_each_thread(sig, t) {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime += task_gtime(t);
-			} while_each_thread(task, t);
+			}
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
_

Patches currently in -mm which might be from oleg@redhat.com are

introduce-__next_thread-fix-next_tid-vs-exec-race.patch
change-next_thread-to-use-__next_thread-group_leader.patch
change-thread_group_empty-to-use-task_struct-thread_node.patch
kill-task_struct-thread_group.patch
__kill_pgrp_info-simplify-the-calculation-of-return-value.patch
fs-proc-do_task_stat-use-__for_each_thread.patch
signal-complete_signal-use-__for_each_thread.patch
getrusage-add-the-signal_struct-sig-local-variable.patch
getrusage-use-__for_each_thread.patch
taskstats-fill_stats_for_tgid-use-for_each_thread.patch

