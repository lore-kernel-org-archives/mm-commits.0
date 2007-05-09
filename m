From: akpm@linux-foundation.org
Subject: - cpu-time-limit-patch--setrlimitrlimit_cpu-0-cheat-fix.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:47 -0700
Message-ID: <200705090250.l492olla009389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032136AbXEICu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alsbergt@cs.huji.ac.il, mm-commits@vger.kernel.org


The patch titled
     CPU time limit patch / setrlimit(RLIMIT_CPU, 0) cheat fix
has been removed from the -mm tree.  Its filename was
     cpu-time-limit-patch--setrlimitrlimit_cpu-0-cheat-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CPU time limit patch / setrlimit(RLIMIT_CPU, 0) cheat fix
From: Tom Alsberg <alsbergt@cs.huji.ac.il>

As discovered here today, the change in Kernel 2.6.17 intended to inhibit
users from setting RLIMIT_CPU to 0 (as that is equivalent to unlimited) by
"cheating" and setting it to 1 in such a case, does not make a difference,
as the check is done in the wrong place (too late), and only applies to the
profiling code.

On all systems I checked running kernels above 2.6.17, no matter what the
hard and soft CPU time limits were before, a user could escape them by
issuing in the shell (sh/bash/zsh) "ulimit -t 0", and then the user's
process was not ever killed.

Attached is a trivial patch to fix that.  Simply moving the check to a
slightly earlier location (specifically, before the line that actually
assigns the limit - *old_rlim = new_rlim), does the trick.

Do note that at least the zsh (but not ash, dash, or bash) shell has the
problem of "caching" the limits set by the ulimit command, so when running
zsh the fix will not immediately be evident - after entering "ulimit -t 0",
"ulimit -a" will show "-t: cpu time (seconds) 0", even though the actual
limit as returned by getrlimit(...) will be 1.  It can be verified by
opening a subshell (which will not have the values of the parent shell in
cache) and checking in it, or just by running a CPU intensive command like
"echo '65536^1048576' | bc" and verifying that it dumps core after one
second.

Regardless of whether that is a misfeature in the shell, perhaps it would
be better to return -EINVAL from setrlimit in such a case instead of
cheating and setting to 1, as that does not really reflect the actual state
of the process anymore.  I do not however know what the ground for that
decision was in the original 2.6.17 change, and whether there would be any
"backward" compatibility issues, so I preferred not to touch that right
now.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN kernel/sys.c~cpu-time-limit-patch--setrlimitrlimit_cpu-0-cheat-fix kernel/sys.c
--- a/kernel/sys.c~cpu-time-limit-patch--setrlimitrlimit_cpu-0-cheat-fix
+++ a/kernel/sys.c
@@ -1923,6 +1923,16 @@ asmlinkage long sys_setrlimit(unsigned i
 	if (retval)
 		return retval;
 
+	if (resource == RLIMIT_CPU && new_rlim.rlim_cur == 0) {
+		/*
+		 * The caller is asking for an immediate RLIMIT_CPU
+		 * expiry.  But we use the zero value to mean "it was
+		 * never set".  So let's cheat and make it one second
+		 * instead
+		 */
+		new_rlim.rlim_cur = 1;
+	}
+
 	task_lock(current->group_leader);
 	*old_rlim = new_rlim;
 	task_unlock(current->group_leader);
@@ -1944,15 +1954,6 @@ asmlinkage long sys_setrlimit(unsigned i
 		unsigned long rlim_cur = new_rlim.rlim_cur;
 		cputime_t cputime;
 
-		if (rlim_cur == 0) {
-			/*
-			 * The caller is asking for an immediate RLIMIT_CPU
-			 * expiry.  But we use the zero value to mean "it was
-			 * never set".  So let's cheat and make it one second
-			 * instead
-			 */
-			rlim_cur = 1;
-		}
 		cputime = secs_to_cputime(rlim_cur);
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&current->sighand->siglock);
_

Patches currently in -mm which might be from alsbergt@cs.huji.ac.il are

origin.patch
