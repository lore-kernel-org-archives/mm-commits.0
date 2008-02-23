From: akpm@linux-foundation.org
Subject: - mips-use-find_task_by_vpid-in-system-calls.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:04 -0800
Message-ID: <200802232022.m1NKM4at013395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761627AbYBWU2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: use find_task_by_vpid in system calls
has been removed from the -mm tree.  Its filename was
     mips-use-find_task_by_vpid-in-system-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: use find_task_by_vpid in system calls
From: Pavel Emelyanov <xemul@openvz.org>

There are some places left in mips, that lookup task in initial namespace,
while the code doing so gets the pid from the user space and thus must treat
it as virtual.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/mips-mt-fpaff.c |    2 +-
 arch/mips/kernel/sysirix.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/kernel/mips-mt-fpaff.c~mips-use-find_task_by_vpid-in-system-calls arch/mips/kernel/mips-mt-fpaff.c
--- a/arch/mips/kernel/mips-mt-fpaff.c~mips-use-find_task_by_vpid-in-system-calls
+++ a/arch/mips/kernel/mips-mt-fpaff.c
@@ -36,7 +36,7 @@ unsigned long mt_fpemul_threshold = 0;
  */
 static inline struct task_struct *find_process_by_pid(pid_t pid)
 {
-	return pid ? find_task_by_pid(pid) : current;
+	return pid ? find_task_by_vpid(pid) : current;
 }
 
 
diff -puN arch/mips/kernel/sysirix.c~mips-use-find_task_by_vpid-in-system-calls arch/mips/kernel/sysirix.c
--- a/arch/mips/kernel/sysirix.c~mips-use-find_task_by_vpid-in-system-calls
+++ a/arch/mips/kernel/sysirix.c
@@ -111,7 +111,7 @@ asmlinkage int irix_prctl(unsigned optio
 		printk("irix_prctl[%s:%d]: Wants PR_ISBLOCKED\n",
 		       current->comm, current->pid);
 		read_lock(&tasklist_lock);
-		task = find_task_by_pid(va_arg(args, pid_t));
+		task = find_task_by_vpid(va_arg(args, pid_t));
 		error = -ESRCH;
 		if (error)
 			error = (task->run_list.next != NULL);
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
git-net.patch
udf-fix-anchor-point-detection.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
