From: akpm@linux-foundation.org
Subject: - use-find_task_by_vpid-in-posix-timers.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:25 -0800
Message-ID: <200802082020.m18KK6HP011137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbYBHUnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:43:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Use find_task_by_vpid in posix timers
has been removed from the -mm tree.  Its filename was
     use-find_task_by_vpid-in-posix-timers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use find_task_by_vpid in posix timers
From: Pavel Emelyanov <xemul@openvz.org>

All the functions that need to lookup a task by pid in posix timers obtain
this pid from a user space, and thus this value refers to a task in the same
namespace, as the current task lives in.

So the proper behavior is to call find_task_by_vpid() here.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |    8 ++++----
 kernel/posix-timers.c     |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/posix-cpu-timers.c~use-find_task_by_vpid-in-posix-timers kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~use-find_task_by_vpid-in-posix-timers
+++ a/kernel/posix-cpu-timers.c
@@ -20,7 +20,7 @@ static int check_clock(const clockid_t w
 		return 0;
 
 	read_lock(&tasklist_lock);
-	p = find_task_by_pid(pid);
+	p = find_task_by_vpid(pid);
 	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
 		   same_thread_group(p, current) : thread_group_leader(p))) {
 		error = -EINVAL;
@@ -305,7 +305,7 @@ int posix_cpu_clock_get(const clockid_t 
 		 */
 		struct task_struct *p;
 		rcu_read_lock();
-		p = find_task_by_pid(pid);
+		p = find_task_by_vpid(pid);
 		if (p) {
 			if (CPUCLOCK_PERTHREAD(which_clock)) {
 				if (same_thread_group(p, current)) {
@@ -354,7 +354,7 @@ int posix_cpu_timer_create(struct k_itim
 		if (pid == 0) {
 			p = current;
 		} else {
-			p = find_task_by_pid(pid);
+			p = find_task_by_vpid(pid);
 			if (p && !same_thread_group(p, current))
 				p = NULL;
 		}
@@ -362,7 +362,7 @@ int posix_cpu_timer_create(struct k_itim
 		if (pid == 0) {
 			p = current->group_leader;
 		} else {
-			p = find_task_by_pid(pid);
+			p = find_task_by_vpid(pid);
 			if (p && !thread_group_leader(p))
 				p = NULL;
 		}
diff -puN kernel/posix-timers.c~use-find_task_by_vpid-in-posix-timers kernel/posix-timers.c
--- a/kernel/posix-timers.c~use-find_task_by_vpid-in-posix-timers
+++ a/kernel/posix-timers.c
@@ -404,7 +404,7 @@ static struct task_struct * good_sigeven
 	struct task_struct *rtn = current->group_leader;
 
 	if ((event->sigev_notify & SIGEV_THREAD_ID ) &&
-		(!(rtn = find_task_by_pid(event->sigev_notify_thread_id)) ||
+		(!(rtn = find_task_by_vpid(event->sigev_notify_thread_id)) ||
 		 !same_thread_group(rtn, current) ||
 		 (event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_SIGNAL))
 		return NULL;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
