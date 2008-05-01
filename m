From: akpm@linux-foundation.org
Subject: - pids-__set_special_pids-use-change_pid-helper.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:25 -0700
Message-ID: <200805010931.m419VPm7030872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbYEAJbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pids: __set_special_pids: use change_pid() helper
has been removed from the -mm tree.  Its filename was
     pids-__set_special_pids-use-change_pid-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: __set_special_pids: use change_pid() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Use change_pid() instead of detach_pid() + attach_pid() in
__set_special_pids().

This way task_session() is not NULL in between.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc:  "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~pids-__set_special_pids-use-change_pid-helper kernel/exit.c
--- a/kernel/exit.c~pids-__set_special_pids-use-change_pid-helper
+++ a/kernel/exit.c
@@ -334,13 +334,11 @@ void __set_special_pids(struct pid *pid)
 	pid_t nr = pid_nr(pid);
 
 	if (task_session(curr) != pid) {
-		detach_pid(curr, PIDTYPE_SID);
-		attach_pid(curr, PIDTYPE_SID, pid);
+		change_pid(curr, PIDTYPE_SID, pid);
 		set_task_session(curr, nr);
 	}
 	if (task_pgrp(curr) != pid) {
-		detach_pid(curr, PIDTYPE_PGID);
-		attach_pid(curr, PIDTYPE_PGID, pid);
+		change_pid(curr, PIDTYPE_PGID, pid);
 		set_task_pgrp(curr, nr);
 	}
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

