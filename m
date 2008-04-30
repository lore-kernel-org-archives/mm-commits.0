From: akpm@linux-foundation.org
Subject: - ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:15 -0700
Message-ID: <200804300544.m3U5iF05029390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759793AbYD3GMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IPC/semaphores: remove one unused parameter from semctl_down()
has been removed from the -mm tree.  Its filename was
     ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

