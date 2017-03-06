From: akpm@linux-foundation.org
Subject: + taskstats-add-e-u-stime-for-tgid-command-fix.patch added to -mm tree
Date: Mon, 06 Mar 2017 14:40:38 -0800
Message-ID: <58bde566.hQGPqBLRMKs+hZol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54740 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753274AbdCGAhM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 19:37:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsingharora@gmail.com, oleg@redhat.com, xiao.zhang@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats-add-e-u-stime-for-tgid-command-fix
has been added to the -mm tree.  Its filename is
     taskstats-add-e-u-stime-for-tgid-command-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/taskstats-add-e-u-stime-for-tgid-command-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/taskstats-add-e-u-stime-for-tgid-command-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
linux-next-rejects.patch
treewide-move-set_memory_-functions-away-from-cacheflushh-fix.patch
arm64-use-set_memoryh-header-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

