From: akpm@linux-foundation.org
Subject: - deprecate-find_task_by_pid-kgdb.patch removed from -mm tree
Date: Wed, 13 Feb 2008 13:03:44 -0800
Message-ID: <200802132103.m1DL3iLL013253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbYBMVEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 16:04:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Deprecate find_task_by_pid(): kgdb
has been removed from the -mm tree.  Its filename was
     deprecate-find_task_by_pid-kgdb.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Deprecate find_task_by_pid(): kgdb
From: Pavel Emelyanov <xemul@openvz.org>

There are some places that are known to operate on tasks'
global pids only:

* the rest_init() call (called on boot)
* the kgdb's getthread
* the create_kthread() (since the kthread is run in init ns)

So use the find_task_by_pid_ns(..., &init_pid_ns) there
and schedule the find_task_by_pid for removal.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kgdb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kgdb.c~deprecate-find_task_by_pid-kgdb kernel/kgdb.c
--- a/kernel/kgdb.c~deprecate-find_task_by_pid-kgdb
+++ a/kernel/kgdb.c
@@ -720,11 +720,11 @@ static struct task_struct *getthread(str
 		return NULL;
 
 	/*
-	 * find_task_by_pid() does not take the tasklist lock anymore
+	 * find_task_by_pid_ns() does not take the tasklist lock anymore
 	 * but is nicely RCU locked - hence is a pretty resilient
 	 * thing to use:
 	 */
-	return find_task_by_pid(tid);
+	return find_task_by_pid_ns(tid, &init_pid_ns);
 }
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 static int kgdb_softlock_reset[NR_CPUS];
_

Patches currently in -mm which might be from xemul@openvz.org are

use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
git-net.patch
usbatm-switch-to-kthread-api-stop-using-kill_proc.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
deprecate-find_task_by_pid-kgdb.patch
