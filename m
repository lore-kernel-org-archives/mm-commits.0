From: akpm@linux-foundation.org
Subject: + gfs2-nfs-lock-support-for-gfs2.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:41:16 -0700
Message-ID: <200704070541.l375fGOx028435@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45381 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965425AbXDGFlv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:41:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, swhiteho@redhat.com, trond.myklebust@fys.uio.no


The patch titled
     gfs2: nfs lock support for gfs2
has been added to the -mm tree.  Its filename is
     gfs2-nfs-lock-support-for-gfs2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gfs2: nfs lock support for gfs2
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

Add NFS lock support to GFS2.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/locking/dlm/plock.c |  104 ++++++++++++++++++++++++++++++----
 fs/gfs2/ops_file.c          |    5 +
 2 files changed, 99 insertions(+), 10 deletions(-)

diff -puN fs/gfs2/locking/dlm/plock.c~gfs2-nfs-lock-support-for-gfs2 fs/gfs2/locking/dlm/plock.c
--- a/fs/gfs2/locking/dlm/plock.c~gfs2-nfs-lock-support-for-gfs2
+++ a/fs/gfs2/locking/dlm/plock.c
@@ -25,6 +25,14 @@ struct plock_op {
 	struct gdlm_plock_info info;
 };
 
+struct plock_xop {
+	struct plock_op xop;
+	void *callback;
+	void *fl;
+	void *file;
+};
+
+
 static inline void set_version(struct gdlm_plock_info *info)
 {
 	info->version[0] = GDLM_PLOCK_VERSION_MAJOR;
@@ -64,12 +72,14 @@ int gdlm_plock(void *lockspace, struct l
 {
 	struct gdlm_ls *ls = lockspace;
 	struct plock_op *op;
+	struct plock_xop *xop;
 	int rv;
 
-	op = kzalloc(sizeof(*op), GFP_KERNEL);
-	if (!op)
+	xop = kzalloc(sizeof(*xop), GFP_KERNEL);
+	if (!xop)
 		return -ENOMEM;
 
+	op = &xop->xop;
 	op->info.optype		= GDLM_PLOCK_OP_LOCK;
 	op->info.pid		= fl->fl_pid;
 	op->info.ex		= (fl->fl_type == F_WRLCK);
@@ -79,9 +89,20 @@ int gdlm_plock(void *lockspace, struct l
 	op->info.start		= fl->fl_start;
 	op->info.end		= fl->fl_end;
 	op->info.owner		= (__u64)(long) fl->fl_owner;
+	if (fl->fl_lmops && fl->fl_lmops->fl_notify) {
+		xop->callback	= fl->fl_lmops->fl_notify;
+		/* might need to make a copy */
+		xop->fl		= fl;
+		xop->file	= file;
+	} else
+		xop->callback	= NULL;
 
 	send_op(op);
-	wait_event(recv_wq, (op->done != 0));
+
+	if (xop->callback == NULL)
+		wait_event(recv_wq, (op->done != 0));
+	else
+		return -EINPROGRESS;
 
 	spin_lock(&ops_lock);
 	if (!list_empty(&op->list)) {
@@ -99,7 +120,60 @@ int gdlm_plock(void *lockspace, struct l
 				  (unsigned long long)name->ln_number);
 	}
 
-	kfree(op);
+	kfree(xop);
+	return rv;
+}
+
+/* Returns failure iff a succesful lock operation should be canceled */
+static int gdlm_plock_callback(struct plock_op *op)
+{
+	struct file *file;
+	struct file_lock *fl;
+	int (*notify)(void *, void *, int) = NULL;
+	struct plock_xop *xop = (struct plock_xop *)op;
+	int rv = 0;
+
+	spin_lock(&ops_lock);
+	if (!list_empty(&op->list)) {
+		printk(KERN_INFO "plock op on list\n");
+		list_del(&op->list);
+	}
+	spin_unlock(&ops_lock);
+
+	/* check if the following 2 are still valid or make a copy */
+	file = xop->file;
+	fl = xop->fl;
+	notify = xop->callback;
+
+	if (op->info.rv) {
+		notify(fl, NULL, op->info.rv);
+		goto out;
+	}
+
+	/* got fs lock; bookkeep locally as well: */
+	if (posix_lock_file(file, fl, NULL)) {
+		/*
+		 * This can only happen in the case of kmalloc() failure.
+		 * The filesystem's own lock is the authoritative lock,
+		 * so a failure to get the lock locally is not a disaster.
+		 * As long as GFS cannot reliably cancel locks (especially
+		 * in a low-memory situation), we're better off ignoring
+		 * this failure than trying to recover.
+		 */
+		log_error("gdlm_plock: vfs lock error file %p fl %p",
+				file, fl);
+	}
+
+	rv = notify(fl, NULL, 0);
+	if (rv) {
+		/* XXX: We need to cancel the fs lock here: */
+		printk("gfs2 lock granted after lock request failed;"
+						" dangling lock!\n");
+		goto out;
+	}
+
+out:
+	kfree(xop);
 	return rv;
 }
 
@@ -138,6 +212,9 @@ int gdlm_punlock(void *lockspace, struct
 
 	rv = op->info.rv;
 
+	if (rv == -ENOENT)
+		rv = 0;
+
 	kfree(op);
 	return rv;
 }
@@ -161,6 +238,7 @@ int gdlm_plock_get(void *lockspace, stru
 	op->info.start		= fl->fl_start;
 	op->info.end		= fl->fl_end;
 
+
 	send_op(op);
 	wait_event(recv_wq, (op->done != 0));
 
@@ -173,9 +251,10 @@ int gdlm_plock_get(void *lockspace, stru
 
 	rv = op->info.rv;
 
-	if (rv == 0)
-		fl->fl_type = F_UNLCK;
-	else if (rv > 0) {
+	fl->fl_type = F_UNLCK;
+	if (rv == -ENOENT)
+		rv = 0;
+	else if (rv == 0 && op->info.pid != fl->fl_pid) {
 		fl->fl_type = (op->info.ex) ? F_WRLCK : F_RDLCK;
 		fl->fl_pid = op->info.pid;
 		fl->fl_start = op->info.start;
@@ -243,9 +322,14 @@ static ssize_t dev_write(struct file *fi
 	}
 	spin_unlock(&ops_lock);
 
-	if (found)
-		wake_up(&recv_wq);
-	else
+	if (found) {
+		struct plock_xop *xop;
+		xop = (struct plock_xop *)op;
+		if (xop->callback)
+			count = gdlm_plock_callback(op);
+		else
+			wake_up(&recv_wq);
+	} else
 		printk(KERN_INFO "gdlm dev_write no op %x %llx\n", info.fsid,
 			(unsigned long long)info.number);
 	return count;
diff -puN fs/gfs2/ops_file.c~gfs2-nfs-lock-support-for-gfs2 fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~gfs2-nfs-lock-support-for-gfs2
+++ a/fs/gfs2/ops_file.c
@@ -521,6 +521,11 @@ static int gfs2_lock(struct file *file, 
 		}
 	}
 
+	if (cmd == F_CANCELLK) {
+		/* Hack: */
+		cmd = F_SETLK;
+		fl->fl_type = F_UNLCK;
+	}
 	if (IS_GETLK(cmd))
 		return gfs2_lm_plock_get(sdp, &name, file, fl);
 	else if (fl->fl_type == F_UNLCK)
_

Patches currently in -mm which might be from eshel@almaden.ibm.com are

locks-trivial-removal-of-unnecessary-parentheses.patch
locks-create-posix-to-flock-helper-functions.patch
locks-make-lock-release-private-data-before-returning-in-getlk-case.patch
locks-give-posix_test_lock-same-interface-as-lock.patch
locks-factor-out-generic-filesystem-switch-from-test_lock.patch
locks-factor-out-generic-filesystem-switch-from-setlock-code.patch
locks-allow-vfsposix_lock_file-to-return-conflicting-lock.patch
locks-add-fl_notify-arguments-for-asynchronous-lock-return.patch
locks-add-lock-cancel-command.patch
nfsd4-convert-nfsv4-to-new-lock-interface.patch
lockd-save-lock-state-on-deferral.patch
lockd-handle-fl_notify-callbacks.patch
lockd-pass-cookie-in-nlmsvc_testlock.patch
lockd-handle-test_lock-deferrals.patch
lockd-always-preallocate-block-in-nlmsvc_lock.patch
lockd-add-code-to-handle-deferred-lock-requests.patch
gfs2-nfs-lock-support-for-gfs2.patch
