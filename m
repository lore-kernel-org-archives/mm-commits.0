From: akpm@linux-foundation.org
Subject: - pids-sys_setpgid-use-change_pid-helper.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:23 -0700
Message-ID: <200805010931.m419VNGm030866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804AbYEAJbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pids: sys_setpgid: use change_pid() helper
has been removed from the -mm tree.  Its filename was
     pids-sys_setpgid-use-change_pid-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: sys_setpgid: use change_pid() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Use change_pid() instead of detach_pid() + attach_pid() in sys_setpgid().

This way task_pgrp() is not NULL in between.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc:  "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/sys.c~pids-sys_setpgid-use-change_pid-helper kernel/sys.c
--- a/kernel/sys.c~pids-sys_setpgid-use-change_pid-helper
+++ a/kernel/sys.c
@@ -978,8 +978,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 		goto out;
 
 	if (task_pgrp(p) != pgrp) {
-		detach_pid(p, PIDTYPE_PGID);
-		attach_pid(p, PIDTYPE_PGID, pgrp);
+		change_pid(p, PIDTYPE_PGID, pgrp);
 		set_task_pgrp(p, pid_nr(pgrp));
 	}
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

