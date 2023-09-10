Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17F8C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 19:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjIJTXb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 15:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjIJTXa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 15:23:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBCD188
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 12:23:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5439FC433C7;
        Sun, 10 Sep 2023 19:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694373806;
        bh=3Qt0ZuuzwEsb6LDcKQoGWnOFjWyRuQyf6aLDhHg64so=;
        h=Date:To:From:Subject:From;
        b=RVluy0IKsuIcF6Lgh+y8jndWTn9fR90v+PbDLYVSOceCZKdWys7cewB6vp1kCKJMk
         +g4Ra2b2mx9VypPcOz59Sh7nzVuIfOSCMn9M3ERsdvuHK8apCHfZ93PqJ1X12z3aDw
         QbTQWRC9GHOLv1aQZUIJf6bjsO/0fhVscH+Gsy7U=
Date:   Sun, 10 Sep 2023 12:23:25 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-complete_signal-use-__for_each_thread.patch added to mm-nonmm-unstable branch
Message-Id: <20230910192326.5439FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: signal: complete_signal: use __for_each_thread()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-complete_signal-use-__for_each_thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-complete_signal-use-__for_each_thread.patch

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
Subject: signal: complete_signal: use __for_each_thread()
Date: Sat, 9 Sep 2023 18:45:37 +0200

do/while_each_thread should be avoided when possible.

Link: https://lkml.kernel.org/r/20230909164537.GA11633@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/signal.c~signal-complete_signal-use-__for_each_thread
+++ a/kernel/signal.c
@@ -1058,12 +1058,11 @@ static void complete_signal(int sig, str
 			signal->flags = SIGNAL_GROUP_EXIT;
 			signal->group_exit_code = sig;
 			signal->group_stop_count = 0;
-			t = p;
-			do {
+			__for_each_thread(signal, t) {
 				task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
-			} while_each_thread(p, t);
+			}
 			return;
 		}
 	}
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

