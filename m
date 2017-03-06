From: akpm@linux-foundation.org
Subject: + taskstats-add-e-u-stime-for-tgid-command.patch added to -mm
 tree
Date: Mon, 06 Mar 2017 14:40:36 -0800
Message-ID: <58bde564.G6Bu4X7Aezhm0KAY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54694 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdCGAhM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 19:37:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiao.zhang@windriver.com, bsingharora@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats: add e/u/stime for TGID command
has been added to the -mm tree.  Its filename is
     taskstats-add-e-u-stime-for-tgid-command.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/taskstats-add-e-u-stime-for-tgid-command.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/taskstats-add-e-u-stime-for-tgid-command.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Xiao <xiao.zhang@windriver.com>
Subject: taskstats: add e/u/stime for TGID command

The elapsed time, user CPU time and system CPU time for the thread group
status request are presently left at zero.  Fill these in.

Link: http://lkml.kernel.org/r/1488508424-12322-1-git-send-email-xiao.zhang@windriver.com
Signed-off-by: Zhang Xiao <xiao.zhang@windriver.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command
+++ a/kernel/taskstats.c
@@ -210,6 +210,7 @@ static int fill_stats_for_tgid(pid_t tgi
 	struct task_struct *tsk, *first;
 	unsigned long flags;
 	int rc = -ESRCH;
+	u64 delta, utime, stime;
 
 	/*
 	 * Add additional stats from live tasks except zombie thread group
@@ -238,6 +239,16 @@ static int fill_stats_for_tgid(pid_t tgi
 		 */
 		delayacct_add_tsk(stats, tsk);
 
+		/* calculate task elapsed time in nsec */
+		delta = ktime_get_ns() - tsk->start_time;
+		/* Convert to micro seconds */
+		do_div(delta, NSEC_PER_USEC);
+		stats->ac_etime += delta;
+
+		task_cputime(tsk, &utime, &stime);
+		stats->ac_utime += div_u64(utime, NSEC_PER_USEC);
+		stats->ac_stime += div_u64(stime, NSEC_PER_USEC);
+
 		stats->nvcsw += tsk->nvcsw;
 		stats->nivcsw += tsk->nivcsw;
 	} while_each_thread(first, tsk);
_

Patches currently in -mm which might be from xiao.zhang@windriver.com are

taskstats-add-e-u-stime-for-tgid-command.patch

