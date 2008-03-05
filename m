From: akpm@linux-foundation.org
Subject: + capabilities-implement-per-process-securebits-fix.patch added to -mm tree
Date: Wed, 05 Mar 2008 10:04:30 -0800
Message-ID: <200803051804.m25I4U0M013440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbYCESFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 13:05:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, jirislaby@gmail.com


The patch titled
     capabilities: use cap_task_prctl when !CONFIG_SECURITY
has been added to the -mm tree.  Its filename is
     capabilities-implement-per-process-securebits-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: capabilities: use cap_task_prctl when !CONFIG_SECURITY
From: Serge E. Hallyn <serue@us.ibm.com>

capabilities-implement-per-process-securebits.patch introduced
cap_task_prctl() and moved the handling of capability-related prctl into it. 
So when !CONFIG_SECURITY, the default security_task_prctl() needs to call
cap_task_prctl() the way other default hooks call capability helpers when they
exist.

This fixes a slew of userspace breakages when CONFIG_SECURITY=n.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/security.h~capabilities-implement-per-process-securebits-fix include/linux/security.h
--- a/include/linux/security.h~capabilities-implement-per-process-securebits-fix
+++ a/include/linux/security.h
@@ -2153,7 +2153,7 @@ static inline int security_task_prctl (i
 				       unsigned long arg4,
 				       unsigned long arg5, long *rc_p)
 {
-	return 0;
+	return cap_task_prctl(option, arg2, arg3, arg3, arg5, rc_p);
 }
 
 static inline void security_task_reparent_to_init (struct task_struct *p)
_

Patches currently in -mm which might be from serue@us.ibm.com are

git-unionfs.patch
capabilities-implement-per-process-securebits.patch
capabilities-implement-per-process-securebits-warning-fix.patch
capabilities-implement-per-process-securebits-fix.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
signals-cleanup-security_task_kill-usage-implementation.patch
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
reiser4-replace-uid==0-check-with-capability.patch

