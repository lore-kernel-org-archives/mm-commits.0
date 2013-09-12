From: akpm@linux-foundation.org
Subject: [merged] ipcshm-introduce-shmctl_nolock.patch removed from -mm
 tree
Date: Thu, 12 Sep 2013 12:50:45 -0700
Message-ID: <52321b15.mbTWGH+PuPj9j6im%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3ILTvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: [merged] ipcshm-introduce-shmctl_nolock.patch removed from -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:50:45 -0700


The patch titled
     Subject: ipc,shm: introduce shmctl_nolock
has been removed from the -mm tree.  Its filename was
     ipcshm-introduce-shmctl_nolock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,shm: introduce shmctl_nolock

Similar to semctl and msgctl, when calling msgctl, the *_INFO and *_STAT
commands can be performed without acquiring the ipc object.

Add a shmctl_nolock() function and move the logic of *_INFO and *_STAT out
of msgctl().  Since we are just moving functionality, this change still
takes the lock and it will be properly lockless in the next patch.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   57 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff -puN ipc/shm.c~ipcshm-introduce-shmctl_nolock ipc/shm.c
--- a/ipc/shm.c~ipcshm-introduce-shmctl_nolock
+++ a/ipc/shm.c
@@ -820,29 +820,24 @@ out_up:
 	return err;
 }
 
-SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
+static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
+			 int cmd, int version, void __user *buf)
 {
+	int err;
 	struct shmid_kernel *shp;
-	int err, version;
-	struct ipc_namespace *ns;
 
-	if (cmd < 0 || shmid < 0) {
-		err = -EINVAL;
-		goto out;
+	/* preliminary security checks for *_INFO */
+	if (cmd == IPC_INFO || cmd == SHM_INFO) {
+		err = security_shm_shmctl(NULL, cmd);
+		if (err)
+			return err;
 	}
 
-	version = ipc_parse_version(&cmd);
-	ns = current->nsproxy->ipc_ns;
-
-	switch (cmd) { /* replace with proc interface ? */
+	switch (cmd) {
 	case IPC_INFO:
 	{
 		struct shminfo64 shminfo;
 
-		err = security_shm_shmctl(NULL, cmd);
-		if (err)
-			return err;
-
 		memset(&shminfo, 0, sizeof(shminfo));
 		shminfo.shmmni = shminfo.shmseg = ns->shm_ctlmni;
 		shminfo.shmmax = ns->shm_ctlmax;
@@ -864,10 +859,6 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 	{
 		struct shm_info shm_info;
 
-		err = security_shm_shmctl(NULL, cmd);
-		if (err)
-			return err;
-
 		memset(&shm_info, 0, sizeof(shm_info));
 		down_read(&shm_ids(ns).rw_mutex);
 		shm_info.used_ids = shm_ids(ns).in_use;
@@ -928,6 +919,36 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 			err = result;
 		goto out;
 	}
+	default:
+		return -EINVAL;
+	}
+
+out_unlock:
+	shm_unlock(shp);
+out:
+	return err;
+}
+
+SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
+{
+	struct shmid_kernel *shp;
+	int err, version;
+	struct ipc_namespace *ns;
+
+	if (cmd < 0 || shmid < 0) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	version = ipc_parse_version(&cmd);
+	ns = current->nsproxy->ipc_ns;
+
+	switch (cmd) {
+	case IPC_INFO:
+	case SHM_INFO:
+	case SHM_STAT:
+	case IPC_STAT:
+		return shmctl_nolock(ns, shmid, cmd, version, buf);
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

