From: akpm@linux-foundation.org
Subject: [merged] mm-oom-introduce-independent-oom-killer-ratelimit-state.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:29 -0700
Message-ID: <20120322201729.67DEAA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:46778 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2CVURb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:31 -0400
Received: by vcbfk26 with SMTP id fk26so402092vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: introduce independent oom killer ratelimit state
has been removed from the -mm tree.  Its filename was
     mm-oom-introduce-independent-oom-killer-ratelimit-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: introduce independent oom killer ratelimit state

printk_ratelimit() uses the global ratelimit state for all printks.  The
oom killer should not be subjected to this state just because another
subsystem or driver may be flooding the kernel log.

This patch introduces printk ratelimiting specifically for the oom killer.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom-introduce-independent-oom-killer-ratelimit-state mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-independent-oom-killer-ratelimit-state
+++ a/mm/oom_kill.c
@@ -34,6 +34,7 @@
 #include <linux/ptrace.h>
 #include <linux/freezer.h>
 #include <linux/ftrace.h>
+#include <linux/ratelimit.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/oom.h>
@@ -444,6 +445,8 @@ static void oom_kill_process(struct task
 	struct task_struct *t = p;
 	struct mm_struct *mm;
 	unsigned int victim_points = 0;
+	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
+					      DEFAULT_RATELIMIT_BURST);
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -454,7 +457,7 @@ static void oom_kill_process(struct task
 		return;
 	}
 
-	if (printk_ratelimit())
+	if (__ratelimit(&oom_rs))
 		dump_header(p, gfp_mask, order, memcg, nodemask);
 
 	task_lock(p);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch

