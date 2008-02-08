From: akpm@linux-foundation.org
Subject: - move-daemonized-kernel-threads-into-the-swappers-session.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:57 -0800
Message-ID: <200802082013.m18KDcM4010307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbYBHUzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:55:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     move daemonized kernel threads into the swapper's session
has been removed from the -mm tree.  Its filename was
     move-daemonized-kernel-threads-into-the-swappers-session.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: move daemonized kernel threads into the swapper's session
From: Oleg Nesterov <oleg@tv-sign.ru>

Daemonized kernel threads run in the init's session. This doesn't match the
behaviour of kthread_create()'ed threads, and this is one of the 2 reasons
why we need a special hack in sys_setsid().

Now that set_special_pids() was changed to use struct pid, not pid_t, we can
use init_struct_pid and set 0,0 special pids.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~move-daemonized-kernel-threads-into-the-swappers-session kernel/exit.c
--- a/kernel/exit.c~move-daemonized-kernel-threads-into-the-swappers-session
+++ a/kernel/exit.c
@@ -388,7 +388,7 @@ void daemonize(const char *name, ...)
 		get_nsproxy(&init_nsproxy);
 		switch_task_namespaces(current, &init_nsproxy);
 	}
-	set_special_pids(find_pid(1));
+	set_special_pids(&init_struct_pid);
 	proc_clear_tty(current);
 
 	/* Block and flush all signals */
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
