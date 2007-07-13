From: akpm@linux-foundation.org
Subject: + coda-cleanup-dev-cfs-open-and-close-handling.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:35 -0700
Message-ID: <200707130529.l6D5TZlO030802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731AbXGMFaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: cleanup /dev/cfs open and close handling
has been added to the -mm tree.  Its filename is
     coda-cleanup-dev-cfs-open-and-close-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: cleanup /dev/cfs open and close handling
From: Jan Harkes <jaharkes@cs.cmu.edu>

- Make sure device index is not a negative number.
- Unlink queued requests when the device is closed to avoid passing them
  to the next opener.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/psdev.c  |   61 ++++++++++++++++++++++-----------------------
 fs/coda/upcall.c |    9 +-----
 2 files changed, 32 insertions(+), 38 deletions(-)

diff -puN fs/coda/psdev.c~coda-cleanup-dev-cfs-open-and-close-handling fs/coda/psdev.c
--- a/fs/coda/psdev.c~coda-cleanup-dev-cfs-open-and-close-handling
+++ a/fs/coda/psdev.c
@@ -272,56 +272,51 @@ out:
 
 static int coda_psdev_open(struct inode * inode, struct file * file)
 {
-        struct venus_comm *vcp;
-	int idx;
+	struct venus_comm *vcp;
+	int idx, err;
 
-	lock_kernel();
 	idx = iminor(inode);
-	if(idx >= MAX_CODADEVS) {
-		unlock_kernel();
+	if (idx < 0 || idx >= MAX_CODADEVS)
 		return -ENODEV;
-	}
 
+	lock_kernel();
+
+	err = -EBUSY;
 	vcp = &coda_comms[idx];
-	if(vcp->vc_inuse) {
-		unlock_kernel();
-		return -EBUSY;
-	}
-	
-	if (!vcp->vc_inuse++) {
+	if (!vcp->vc_inuse) {
+		vcp->vc_inuse++;
+
 		INIT_LIST_HEAD(&vcp->vc_pending);
 		INIT_LIST_HEAD(&vcp->vc_processing);
 		init_waitqueue_head(&vcp->vc_waitq);
 		vcp->vc_sb = NULL;
 		vcp->vc_seq = 0;
+
+		file->private_data = vcp;
+		err = 0;
 	}
-	
-	file->private_data = vcp;
 
 	unlock_kernel();
-        return 0;
+	return err;
 }
 
 
 static int coda_psdev_release(struct inode * inode, struct file * file)
 {
-        struct venus_comm *vcp = (struct venus_comm *) file->private_data;
-        struct upc_req *req, *tmp;
+	struct venus_comm *vcp = (struct venus_comm *) file->private_data;
+	struct upc_req *req, *tmp;
 
-	lock_kernel();
-	if ( !vcp->vc_inuse ) {
-		unlock_kernel();
+	if (!vcp || !vcp->vc_inuse ) {
 		printk("psdev_release: Not open.\n");
 		return -1;
 	}
 
-	if (--vcp->vc_inuse) {
-		unlock_kernel();
-		return 0;
-	}
-        
-        /* Wakeup clients so they can return. */
+	lock_kernel();
+
+	/* Wakeup clients so they can return. */
 	list_for_each_entry_safe(req, tmp, &vcp->vc_pending, uc_chain) {
+		list_del(&req->uc_chain);
+
 		/* Async requests need to be freed here */
 		if (req->uc_flags & REQ_ASYNC) {
 			CODA_FREE(req->uc_data, sizeof(struct coda_in_hdr));
@@ -330,13 +325,17 @@ static int coda_psdev_release(struct ino
 		}
 		req->uc_flags |= REQ_ABORT;
 		wake_up(&req->uc_sleep);
-        }
-        
-	list_for_each_entry(req, &vcp->vc_processing, uc_chain) {
+	}
+
+	list_for_each_entry_safe(req, tmp, &vcp->vc_processing, uc_chain) {
+		list_del(&req->uc_chain);
+
 		req->uc_flags |= REQ_ABORT;
-	        wake_up(&req->uc_sleep);
-        }
+		wake_up(&req->uc_sleep);
+	}
 
+	file->private_data = NULL;
+	vcp->vc_inuse--;
 	unlock_kernel();
 	return 0;
 }
diff -puN fs/coda/upcall.c~coda-cleanup-dev-cfs-open-and-close-handling fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-cleanup-dev-cfs-open-and-close-handling
+++ a/fs/coda/upcall.c
@@ -641,8 +641,7 @@ int venus_statfs(struct dentry *dentry, 
  * 
  */
 
-static inline void coda_waitfor_upcall(struct upc_req *vmp,
-				       struct venus_comm *vcommp)
+static inline void coda_waitfor_upcall(struct upc_req *vmp)
 {
 	DECLARE_WAITQUEUE(wait, current);
 
@@ -655,10 +654,6 @@ static inline void coda_waitfor_upcall(s
 		else
 			set_current_state(TASK_UNINTERRUPTIBLE);
 
-                /* venus died */
-                if ( !vcommp->vc_inuse )
-                        break;
-
 		/* got a reply */
 		if ( vmp->uc_flags & ( REQ_WRITE | REQ_ABORT ) )
 			break;
@@ -738,7 +733,7 @@ static int coda_upcall(struct coda_sb_in
 	 * ENODEV.  */
 
 	/* Go to sleep.  Wake up on signals only after the timeout. */
-	coda_waitfor_upcall(req, vcommp);
+	coda_waitfor_upcall(req);
 
 	if (vcommp->vc_inuse) {      /* i.e. Venus is still alive */
 	    /* Op went through, interrupt or not... */
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
