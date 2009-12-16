From: akpm@linux-foundation.org
Subject: [merged] ipc-remove-unreachable-code-in-semc.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:54 -0800
Message-ID: <200912162038.nBGKcsHa013482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964977AbZLPUjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ipc: remove unreachable code in sem.c
has been removed from the -mm tree.  Its filename was
     ipc-remove-unreachable-code-in-semc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: remove unreachable code in sem.c
From: Amerigo Wang <amwang@redhat.com>

This line is unreachable, remove it.

[akpm@linux-foundation.org: remove unneeded initialisation of `err']
Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-remove-unreachable-code-in-semc ipc/sem.c
--- a/ipc/sem.c~ipc-remove-unreachable-code-in-semc
+++ a/ipc/sem.c
@@ -624,7 +624,7 @@ static unsigned long copy_semid_to_user(
 static int semctl_nolock(struct ipc_namespace *ns, int semid,
 			 int cmd, int version, union semun arg)
 {
-	int err = -EINVAL;
+	int err;
 	struct sem_array *sma;
 
 	switch(cmd) {
@@ -701,7 +701,6 @@ static int semctl_nolock(struct ipc_name
 	default:
 		return -EINVAL;
 	}
-	return err;
 out_unlock:
 	sem_unlock(sma);
 	return err;
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch
xtensa-use-generic-sys_pipe.patch

