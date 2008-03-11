From: akpm@linux-foundation.org
Subject: + smack-use-cap_task_prctl.patch added to -mm tree
Date: Mon, 10 Mar 2008 22:28:41 -0700
Message-ID: <200803110528.m2B5SffR024286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbYCKF2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 01:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, casey@schaufler-ca.com


The patch titled
     smack: use cap_task_prctl
has been added to the -mm tree.  Its filename is
     smack-use-cap_task_prctl.patch

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
Subject: smack: use cap_task_prctl
From: "Serge E. Hallyn" <serue@us.ibm.com>

With the introduction of per-process securebits, the capabilities-related
prctl callbacks were moved into cap_task_prctl().  Have smack use
cap_task_prctl() so that PR_SET_KEEPCAPS is defined.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN security/smack/smack_lsm.c~smack-use-cap_task_prctl security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-use-cap_task_prctl
+++ a/security/smack/smack_lsm.c
@@ -2497,6 +2497,7 @@ struct security_operations smack_ops = {
 	.task_wait = 			smack_task_wait,
 	.task_reparent_to_init =	cap_task_reparent_to_init,
 	.task_to_inode = 		smack_task_to_inode,
+	.task_prctl =			cap_task_prctl,
 
 	.ipc_permission = 		smack_ipc_permission,
 
_

Patches currently in -mm which might be from serue@us.ibm.com are

git-unionfs.patch
capabilities-implement-per-process-securebits.patch
capabilities-implement-per-process-securebits-warning-fix.patch
capabilities-implement-per-process-securebits-fix.patch
smack-use-cap_task_prctl.patch
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

