From: akpm@linux-foundation.org
Subject: + cifs-use-mutexdiff.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:55:13 -0700
Message-ID: <200704020555.l325tDrm025479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36788 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511AbXDBF62 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:58:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@digitalvampire.org, jengelh@gmx.de, sfrench@us.ibm.com


The patch titled
     cifs: use mutex
has been added to the -mm tree.  Its filename is
     cifs-use-mutexdiff.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cifs: use mutex
From: Roland Dreier <roland@digitalvampire.org>

Originally at http://lkml.org/lkml/2006/9/2/86

The recent change to "allow Windows blocking locks to be cancelled via a
CANCEL_LOCK call" introduced a new semaphore in struct cifsFileInfo,
lock_sem.  However, semaphores used as mutexes are deprecated these days,
and there's no reason to add a new one to the kernel.  Therefore, convert
lock_sem to a struct mutex (and also fix one indentation glitch on one of
the lines changed anyway).

Compile tested only, since I don't use CIFS.

Signed-off-by: Roland Dreier <roland@digitalvampire.org>
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/dir.c      |    2 +-
 fs/cifs/file.c     |   14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/cifs/cifsglob.h~cifs-use-mutexdiff fs/cifs/cifsglob.h
--- a/fs/cifs/cifsglob.h~cifs-use-mutexdiff
+++ a/fs/cifs/cifsglob.h
@@ -311,7 +311,7 @@ struct cifsFileInfo {
 	/* lock scope id (0 if none) */
 	struct file * pfile; /* needed for writepage */
 	struct inode * pInode; /* needed for oplock break */
-	struct semaphore lock_sem;
+	struct mutex lock_mutex;
 	struct list_head llist; /* list of byte range locks we have. */
 	unsigned closePend:1;	/* file is marked to close */
 	unsigned invalidHandle:1;  /* file closed via session abend */
diff -puN fs/cifs/dir.c~cifs-use-mutexdiff fs/cifs/dir.c
--- a/fs/cifs/dir.c~cifs-use-mutexdiff
+++ a/fs/cifs/dir.c
@@ -274,7 +274,7 @@ cifs_create(struct inode *inode, struct 
 			pCifsFile->invalidHandle = FALSE;
 			pCifsFile->closePend     = FALSE;
 			init_MUTEX(&pCifsFile->fh_sem);
-			init_MUTEX(&pCifsFile->lock_sem);
+			mutex_init(&pCifsFile->lock_mutex);
 			INIT_LIST_HEAD(&pCifsFile->llist);
 			atomic_set(&pCifsFile->wrtPending,0);
 
diff -puN fs/cifs/file.c~cifs-use-mutexdiff fs/cifs/file.c
--- a/fs/cifs/file.c~cifs-use-mutexdiff
+++ a/fs/cifs/file.c
@@ -47,7 +47,7 @@ static inline struct cifsFileInfo *cifs_
 	private_data->netfid = netfid;
 	private_data->pid = current->tgid;	
 	init_MUTEX(&private_data->fh_sem);
-	init_MUTEX(&private_data->lock_sem);
+	mutex_init(&private_data->lock_mutex);
 	INIT_LIST_HEAD(&private_data->llist);
 	private_data->pfile = file; /* needed for writepage */
 	private_data->pInode = inode;
@@ -499,12 +499,12 @@ int cifs_close(struct inode *inode, stru
 
 		/* Delete any outstanding lock records.
 		   We'll lose them when the file is closed anyway. */
-		down(&pSMBFile->lock_sem);
+		mutex_lock(&pSMBFile->lock_mutex);
 		list_for_each_entry_safe(li, tmp, &pSMBFile->llist, llist) {
 			list_del(&li->llist);
 			kfree(li);
 		}
-		up(&pSMBFile->lock_sem);
+		mutex_unlock(&pSMBFile->lock_mutex);
 
 		write_lock(&GlobalSMBSeslock);
 		list_del(&pSMBFile->flist);
@@ -589,9 +589,9 @@ static int store_file_lock(struct cifsFi
 	li->offset = offset;
 	li->length = len;
 	li->type = lockType;
-	down(&fid->lock_sem);
+	mutex_lock(&fid->lock_mutex);
 	list_add(&li->llist, &fid->llist);
-	up(&fid->lock_sem);
+	mutex_unlock(&fid->lock_mutex);
 	return 0;
 }
 
@@ -748,7 +748,7 @@ int cifs_lock(struct file *file, int cmd
 			struct cifsLockInfo *li, *tmp;
 
 			rc = 0;
-			down(&fid->lock_sem);
+			mutex_lock(&fid->lock_mutex);
 			list_for_each_entry_safe(li, tmp, &fid->llist, llist) {
 				if (pfLock->fl_start <= li->offset &&
 						length >= li->length) {
@@ -762,7 +762,7 @@ int cifs_lock(struct file *file, int cmd
 					kfree(li);
 				}
 			}
-			up(&fid->lock_sem);
+			mutex_unlock(&fid->lock_mutex);
 		}
 	}
 
_

Patches currently in -mm which might be from roland@digitalvampire.org are

cifs-use-mutexdiff.patch
