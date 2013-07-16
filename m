From: akpm@linux-foundation.org
Subject: + ipcshm-make-shmctl_nolock-lockless.patch added to -mm tree
Date: Tue, 16 Jul 2013 15:51:48 -0700
Message-ID: <51e5ce84.cNXnCXgn6Al6y7Os%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246Ab3GPWvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 18:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipcshm-make-shmctl_nolock-lockless.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 15:51:48 -0700


The patch titled
     Subject: ipc,shm: make shmctl_nolock lockless
has been added to the -mm tree.  Its filename is
     ipcshm-make-shmctl_nolock-lockless.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-make-shmctl_nolock-lockless.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-make-shmctl_nolock-lockless.patch

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
Subject: ipc,shm: make shmctl_nolock lockless

While the INFO cmd doesn't take the ipc lock, the STAT commands do acquire
it unnecessarily.  We can do the permissions and security checks only
holding the rcu lock.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN ipc/shm.c~ipcshm-make-shmctl_nolock-lockless ipc/shm.c
--- a/ipc/shm.c~ipcshm-make-shmctl_nolock-lockless
+++ a/ipc/shm.c
@@ -882,27 +882,31 @@ static int shmctl_nolock(struct ipc_name
 		struct shmid64_ds tbuf;
 		int result;
 
+		rcu_read_lock();
 		if (cmd == SHM_STAT) {
-			shp = shm_lock(ns, shmid);
+			shp = shm_obtain_object(ns, shmid);
 			if (IS_ERR(shp)) {
 				err = PTR_ERR(shp);
-				goto out;
+				goto out_unlock;
 			}
 			result = shp->shm_perm.id;
 		} else {
-			shp = shm_lock_check(ns, shmid);
+			shp = shm_obtain_object_check(ns, shmid);
 			if (IS_ERR(shp)) {
 				err = PTR_ERR(shp);
-				goto out;
+				goto out_unlock;
 			}
 			result = 0;
 		}
+
 		err = -EACCES;
 		if (ipcperms(ns, &shp->shm_perm, S_IRUGO))
 			goto out_unlock;
+
 		err = security_shm_shmctl(shp, cmd);
 		if (err)
 			goto out_unlock;
+
 		memset(&tbuf, 0, sizeof(tbuf));
 		kernel_to_ipc64_perm(&shp->shm_perm, &tbuf.shm_perm);
 		tbuf.shm_segsz	= shp->shm_segsz;
@@ -912,8 +916,9 @@ static int shmctl_nolock(struct ipc_name
 		tbuf.shm_cpid	= shp->shm_cprid;
 		tbuf.shm_lpid	= shp->shm_lprid;
 		tbuf.shm_nattch	= shp->shm_nattch;
-		shm_unlock(shp);
-		if(copy_shmid_to_user (buf, &tbuf, version))
+		rcu_read_unlock();
+
+		if (copy_shmid_to_user (buf, &tbuf, version))
 			err = -EFAULT;
 		else
 			err = result;
@@ -924,7 +929,7 @@ static int shmctl_nolock(struct ipc_name
 	}
 
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

