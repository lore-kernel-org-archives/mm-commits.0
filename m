From: akpm@linux-foundation.org
Subject: + ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:28:18 -0800
Message-ID: <200802122128.m1CLSISp023083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbYBLV3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:29:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com


The patch titled
     IPC/semaphores: remove one unused parameter from semctl_down()
has been added to the -mm tree.  Its filename is
     ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch

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
Subject: IPC/semaphores: remove one unused parameter from semctl_down()
From: Pierre Peiffer <pierre.peiffer@bull.net>

semctl_down() takes one unused parameter: semnum.  This patch proposes to get
rid of it.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN ipc/sem.c~ipc-semaphores-remove-one-unused-parameter-from-semctl_down ipc/sem.c
--- a/ipc/sem.c~ipc-semaphores-remove-one-unused-parameter-from-semctl_down
+++ a/ipc/sem.c
@@ -880,8 +880,8 @@ static inline unsigned long copy_semid_f
  * to be held in write mode.
  * NOTE: no locks must be held, the rw_mutex is taken inside this function.
  */
-static int semctl_down(struct ipc_namespace *ns, int semid, int semnum,
-		int cmd, int version, union semun arg)
+static int semctl_down(struct ipc_namespace *ns, int semid,
+		       int cmd, int version, union semun arg)
 {
 	struct sem_array *sma;
 	int err;
@@ -972,7 +972,7 @@ asmlinkage long sys_semctl (int semid, i
 		return err;
 	case IPC_RMID:
 	case IPC_SET:
-		err = semctl_down(ns,semid,semnum,cmd,version,arg);
+		err = semctl_down(ns, semid, cmd, version, arg);
 		return err;
 	default:
 		return -EINVAL;
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
