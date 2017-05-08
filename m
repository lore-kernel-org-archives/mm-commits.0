From: akpm@linux-foundation.org
Subject: [folded-merged]
 taskstats-add-e-u-stime-for-tgid-command-fix.patch removed from -mm tree
Date: Mon, 08 May 2017 15:39:18 -0700
Message-ID: <5910f396.FvKHwGju3hvXbN+M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdEHWjY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:39:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsingharora@gmail.com, oleg@redhat.com, xiao.zhang@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats-add-e-u-stime-for-tgid-command-fix
has been removed from the -mm tree.  Its filename was
     taskstats-add-e-u-stime-for-tgid-command-fix.patch

This patch was dropped because it was folded into taskstats-add-e-u-stime-for-tgid-command.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: taskstats-add-e-u-stime-for-tgid-command-fix

run ktime_get_ns() a single time

Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Zhang Xiao <xiao.zhang@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command-fix kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command-fix
+++ a/kernel/taskstats.c
@@ -211,6 +211,7 @@ static int fill_stats_for_tgid(pid_t tgi
 	unsigned long flags;
 	int rc = -ESRCH;
 	u64 delta, utime, stime;
+	u64 start_time;
 
 	/*
 	 * Add additional stats from live tasks except zombie thread group
@@ -228,6 +229,7 @@ static int fill_stats_for_tgid(pid_t tgi
 		memset(stats, 0, sizeof(*stats));
 
 	tsk = first;
+	start_time = ktime_get_ns();
 	do {
 		if (tsk->exit_state)
 			continue;
@@ -240,7 +242,7 @@ static int fill_stats_for_tgid(pid_t tgi
 		delayacct_add_tsk(stats, tsk);
 
 		/* calculate task elapsed time in nsec */
-		delta = ktime_get_ns() - tsk->start_time;
+		delta = start_time - tsk->start_time;
 		/* Convert to micro seconds */
 		do_div(delta, NSEC_PER_USEC);
 		stats->ac_etime += delta;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

taskstats-add-e-u-stime-for-tgid-command.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
dax-add-tracepoint-to-dax_writeback_one-fix.patch
drivers-staging-ccree-ssi_hashc-fix-build-with-gcc-444.patch

