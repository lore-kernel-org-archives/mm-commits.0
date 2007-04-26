From: akpm@linux-foundation.org
Subject: + return-eperm-not-echild-on-security_task_wait-failure-fix.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:57:14 -0700
Message-ID: <200704260057.l3Q0vEUh017466@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbXDZA6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmorris@namei.org, chrisw@sous-sol.org, roland@redhat.com, sds@tycho.nsa.gov


The patch titled
     return-eperm-not-echild-on-security_task_wait-failure fix
has been added to the -mm tree.  Its filename is
     return-eperm-not-echild-on-security_task_wait-failure-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group.patch
git-net.patch
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
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch
