From: akpm@linux-foundation.org
Subject: - smack-do-not-dereference-null-ipc-object.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:27 -0700
Message-ID: <200803212029.m2LKTRKQ008872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737AbYCUU3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, casey@schaufler-ca.com, mm-commits@vger.kernel.org


The patch titled
     smack: do not dereference NULL ipc object
has been removed from the -mm tree.  Its filename was
     smack-do-not-dereference-null-ipc-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smack: do not dereference NULL ipc object
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

In the SYSV ipc msgctl(),semctl(),shmctl() family, if the user passed *_INFO
as the desired operation, no specific object is meant to be controlled and
only system-wide information is returned.  This leads to a NULL IPC object in
the LSM hooks if the _INFO flag is given.

Avoid dereferencing this NULL pointer in Smack ipc *ctl() methods.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN security/smack/smack_lsm.c~smack-do-not-dereference-null-ipc-object security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-do-not-dereference-null-ipc-object
+++ a/security/smack/smack_lsm.c
@@ -1508,7 +1508,7 @@ static int smack_shm_associate(struct sh
  */
 static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 {
-	char *ssp = smack_of_shm(shp);
+	char *ssp;
 	int may;
 
 	switch (cmd) {
@@ -1532,6 +1532,7 @@ static int smack_shm_shmctl(struct shmid
 		return -EINVAL;
 	}
 
+	ssp = smack_of_shm(shp);
 	return smk_curacc(ssp, may);
 }
 
@@ -1616,7 +1617,7 @@ static int smack_sem_associate(struct se
  */
 static int smack_sem_semctl(struct sem_array *sma, int cmd)
 {
-	char *ssp = smack_of_sem(sma);
+	char *ssp;
 	int may;
 
 	switch (cmd) {
@@ -1645,6 +1646,7 @@ static int smack_sem_semctl(struct sem_a
 		return -EINVAL;
 	}
 
+	ssp = smack_of_sem(sma);
 	return smk_curacc(ssp, may);
 }
 
@@ -1730,7 +1732,7 @@ static int smack_msg_queue_associate(str
  */
 static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 {
-	char *msp = smack_of_msq(msq);
+	char *msp;
 	int may;
 
 	switch (cmd) {
@@ -1752,6 +1754,7 @@ static int smack_msg_queue_msgctl(struct
 		return -EINVAL;
 	}
 
+	msp = smack_of_msq(msq);
 	return smk_curacc(msp, may);
 }
 
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-kvm.patch
git-security-testing.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch

