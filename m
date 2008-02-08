From: akpm@linux-foundation.org
Subject: - pid-fix-solaris_procids.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:21 -0800
Message-ID: <200802082014.m18KE2w9010350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939AbYBHVCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, davem@davemloft.net, oleg@tv-sign.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid: fix solaris_procids
has been removed from the -mm tree.  Its filename was
     pid-fix-solaris_procids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid: fix solaris_procids
From: Eric W. Biederman <ebiederm@xmission.com>

Use task_pgrp_vnr not task_pgrp_nr so we return the process id the processes
pid namespace and not in the initial pid namespace.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/solaris/misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc64/solaris/misc.c~pid-fix-solaris_procids arch/sparc64/solaris/misc.c
--- a/arch/sparc64/solaris/misc.c~pid-fix-solaris_procids
+++ a/arch/sparc64/solaris/misc.c
@@ -415,7 +415,7 @@ asmlinkage int solaris_procids(int cmd, 
 	
 	switch (cmd) {
 	case 0: /* getpgrp */
-		return task_pgrp_nr(current);
+		return task_pgrp_vnr(current);
 	case 1: /* setpgrp */
 		{
 			int (*sys_setpgid)(pid_t,pid_t) =
@@ -426,7 +426,7 @@ asmlinkage int solaris_procids(int cmd, 
 			ret = sys_setpgid(0, 0);
 			if (ret) return ret;
 			proc_clear_tty(current);
-			return task_pgrp_nr(current);
+			return task_pgrp_vnr(current);
 		}
 	case 2: /* getsid */
 		{
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-x86.patch
deprecate-find_task_by_pid-kgdb.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
