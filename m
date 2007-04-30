From: akpm@linux-foundation.org
Subject: - return-eperm-not-echild-on-security_task_wait-failure-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:07:18 -0700
Message-ID: <200704301907.l3UJ7ITJ012296@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946657AbXD3TIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmorris@namei.org, chrisw@sous-sol.org, roland@redhat.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     return-eperm-not-echild-on-security_task_wait-failure fix
has been removed from the -mm tree.  Its filename was
     return-eperm-not-echild-on-security_task_wait-failure-fix.patch

This patch was dropped because it was folded into return-eperm-not-echild-on-security_task_wait-failure.patch

------------------------------------------------------
Subject: return-eperm-not-echild-on-security_task_wait-failure fix
From: James Morris <jmorris@namei.org>

Signed-off-by: James Morris <jmorris@namei.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~return-eperm-not-echild-on-security_task_wait-failure-fix kernel/exit.c
--- a/kernel/exit.c~return-eperm-not-echild-on-security_task_wait-failure-fix
+++ a/kernel/exit.c
@@ -1033,6 +1033,8 @@ asmlinkage void sys_exit_group(int error
 
 static int eligible_child(pid_t pid, int options, struct task_struct *p)
 {
+	int err;
+
 	if (pid > 0) {
 		if (p->pid != pid)
 			return 0;
@@ -1066,8 +1068,9 @@ static int eligible_child(pid_t pid, int
 	if (delay_group_leader(p))
 		return 2;
 
-	if (security_task_wait(p))
-		return -1;
+	err = security_task_wait(p);
+	if (err)
+		return err;
 
 	return 1;
 }
@@ -1475,7 +1478,7 @@ repeat:
 				continue;
 
 			if (unlikely(ret < 0)) {
-				denied = 1;
+				denied = ret;
 				continue;
 			}
 			allowed = 1;
@@ -1579,7 +1582,7 @@ check_continued:
 	}
 	retval = -ECHILD;
 	if (unlikely(denied) && !allowed)
-		retval = -EPERM;
+		retval = denied;
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
_

Patches currently in -mm which might be from jmorris@namei.org are

origin.patch
git-selinux.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
return-eperm-not-echild-on-security_task_wait-failure.patch
return-eperm-not-echild-on-security_task_wait-failure-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
remove-redundant-check-from-proc_setattr.patch
remove-redundant-check-from-proc_sys_setattr.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch
