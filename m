From: akpm@linux-foundation.org
Subject: + ipcshm-shorten-critical-region-for-shmat.patch added to -mm
 tree
Date: Tue, 16 Jul 2013 15:51:51 -0700
Message-ID: <51e5ce87.citaFUebzYXiMZP+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657Ab3GPWwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 18:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipcshm-shorten-critical-region-for-shmat.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 15:51:51 -0700


The patch titled
     Subject: ipc,shm: shorten critical region for shmat
has been added to the -mm tree.  Its filename is
     ipcshm-shorten-critical-region-for-shmat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-shorten-critical-region-for-shmat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-shorten-critical-region-for-shmat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,shm: shorten critical region for shmat

Similar to other system calls, acquire the kern_ipc_perm lock after doing
the initial permission and security checks.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN ipc/shm.c~ipcshm-shorten-critical-region-for-shmat ipc/shm.c
--- a/ipc/shm.c~ipcshm-shorten-critical-region-for-shmat
+++ a/ipc/shm.c
@@ -19,6 +19,9 @@
  * namespaces support
  * OpenVZ, SWsoft Inc.
  * Pavel Emelianov <xemul@openvz.org>
+ *
+ * Better ipc lock (kern_ipc_perm.lock) handling
+ * Davidlohr Bueso <davidlohr.bueso@hp.com>, June 2013.
  */
 
 #include <linux/slab.h>
@@ -1086,7 +1089,8 @@ long do_shmat(int shmid, char __user *sh
 	 * additional creator id...
 	 */
 	ns = current->nsproxy->ipc_ns;
-	shp = shm_lock_check(ns, shmid);
+	rcu_read_lock();
+	shp = shm_obtain_object_check(ns, shmid);
 	if (IS_ERR(shp)) {
 		err = PTR_ERR(shp);
 		goto out;
@@ -1100,11 +1104,13 @@ long do_shmat(int shmid, char __user *sh
 	if (err)
 		goto out_unlock;
 
+	ipc_lock_object(&shp->shm_perm);
 	path = shp->shm_file->f_path;
 	path_get(&path);
 	shp->shm_nattch++;
 	size = i_size_read(path.dentry->d_inode);
-	shm_unlock(shp);
+	ipc_unlock_object(&shp->shm_perm);
+	rcu_read_unlock();
 
 	err = -ENOMEM;
 	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
@@ -1175,7 +1181,7 @@ out_nattch:
 	return err;
 
 out_unlock:
-	shm_unlock(shp);
+	rcu_read_unlock();
 out:
 	return err;
 }
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcshm-shorten-critical-region-in-shmctl_down.patch
ipc-drop-ipcctl_pre_down.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-introduce-shmctl_nolock.patch
ipcshm-make-shmctl_nolock-lockless.patch
ipcshm-shorten-critical-region-for-shmctl.patch
ipcshm-cleanup-do_shmat-pasta.patch
ipcshm-shorten-critical-region-for-shmat.patch
ipc-rename-ids-rw_mutex.patch
ipcmsg-drop-msg_unlock.patch
ipc-document-general-ipc-locking-scheme.patch

