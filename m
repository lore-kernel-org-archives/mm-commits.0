From: akpm@linux-foundation.org
Subject: + ipcshm-cleanup-do_shmat-pasta.patch added to -mm tree
Date: Tue, 16 Jul 2013 15:51:50 -0700
Message-ID: <51e5ce86.StDdGqI/2XGc53xU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657Ab3GPWvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 18:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipcshm-cleanup-do_shmat-pasta.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 15:51:50 -0700


The patch titled
     Subject: ipc,shm: cleanup do_shmat pasta
has been added to the -mm tree.  Its filename is
     ipcshm-cleanup-do_shmat-pasta.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-cleanup-do_shmat-pasta.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-cleanup-do_shmat-pasta.patch

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
Subject: ipc,shm: cleanup do_shmat pasta

Clean up some of the messy do_shmat() spaghetti code, getting rid of
out_free and out_put_dentry labels.  This makes shortening the critical
region of this function in the next patch a little easier to do and read.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN ipc/shm.c~ipcshm-cleanup-do_shmat-pasta ipc/shm.c
--- a/ipc/shm.c~ipcshm-cleanup-do_shmat-pasta
+++ a/ipc/shm.c
@@ -1108,16 +1108,21 @@ long do_shmat(int shmid, char __user *sh
 
 	err = -ENOMEM;
 	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
-	if (!sfd)
-		goto out_put_dentry;
+	if (!sfd) {
+		path_put(&path);
+		goto out_nattch;
+	}
 
 	file = alloc_file(&path, f_mode,
 			  is_file_hugepages(shp->shm_file) ?
 				&shm_file_operations_huge :
 				&shm_file_operations);
 	err = PTR_ERR(file);
-	if (IS_ERR(file))
-		goto out_free;
+	if (IS_ERR(file)) {
+		kfree(sfd);
+		path_put(&path);
+		goto out_nattch;
+	}
 
 	file->private_data = sfd;
 	file->f_mapping = shp->shm_file->f_mapping;
@@ -1143,7 +1148,7 @@ long do_shmat(int shmid, char __user *sh
 		    addr > current->mm->start_stack - size - PAGE_SIZE * 5)
 			goto invalid;
 	}
-		
+
 	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
 	*raddr = addr;
 	err = 0;
@@ -1167,19 +1172,12 @@ out_nattch:
 	else
 		shm_unlock(shp);
 	up_write(&shm_ids(ns).rw_mutex);
-
-out:
 	return err;
 
 out_unlock:
 	shm_unlock(shp);
-	goto out;
-
-out_free:
-	kfree(sfd);
-out_put_dentry:
-	path_put(&path);
-	goto out_nattch;
+out:
+	return err;
 }
 
 SYSCALL_DEFINE3(shmat, int, shmid, char __user *, shmaddr, int, shmflg)
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

