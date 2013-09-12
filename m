From: akpm@linux-foundation.org
Subject: [merged] ipcshm-shorten-critical-region-for-shmat.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:50:53 -0700
Message-ID: <52321b1d.V7Ca9MgRsjcbQAZx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3ILTvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, sasha.levin@oracle.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: [merged] ipcshm-shorten-critical-region-for-shmat.patch removed from -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sasha.levin@oracle.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:50:53 -0700


The patch titled
     Subject: ipc,shm: shorten critical region for shmat
has been removed from the -mm tree.  Its filename was
     ipcshm-shorten-critical-region-for-shmat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,shm: shorten critical region for shmat

Similar to other system calls, acquire the kern_ipc_perm lock after doing
the initial permission and security checks.

[sasha.levin@oracle.com: dont leave do_shmat with rcu lock held]
Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

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
@@ -1086,10 +1089,11 @@ long do_shmat(int shmid, char __user *sh
 	 * additional creator id...
 	 */
 	ns = current->nsproxy->ipc_ns;
-	shp = shm_lock_check(ns, shmid);
+	rcu_read_lock();
+	shp = shm_obtain_object_check(ns, shmid);
 	if (IS_ERR(shp)) {
 		err = PTR_ERR(shp);
-		goto out;
+		goto out_unlock;
 	}
 
 	err = -EACCES;
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

origin.patch

