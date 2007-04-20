From: akpm@linux-foundation.org
Subject: - locks-create-posix-to-flock-helper-functions.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:16 -0700
Message-ID: <200704200638.l3K6cGht008743@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423017AbXDTGii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, eshel@almaden.ibm.com, hch@infradead.org, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: create posix-to-flock helper functions
has been removed from the -mm tree.  Its filename was
     locks-create-posix-to-flock-helper-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: locks: create posix-to-flock helper functions
From: J. Bruce Fields <bfields@citi.umich.edu> - unquoted

Factor out a bit of messy code by creating posix-to-flock counterparts to the
existing flock-to-posix helper functions.

Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   61 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 25 deletions(-)

diff -puN fs/locks.c~locks-create-posix-to-flock-helper-functions fs/locks.c
--- a/fs/locks.c~locks-create-posix-to-flock-helper-functions
+++ a/fs/locks.c
@@ -1611,6 +1611,38 @@ asmlinkage long sys_flock(unsigned int f
 	return error;
 }
 
+static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
+{
+	flock->l_pid = fl->fl_pid;
+#if BITS_PER_LONG == 32
+	/*
+	 * Make sure we can represent the posix lock via
+	 * legacy 32bit flock.
+	 */
+	if (fl->fl_start > OFFT_OFFSET_MAX)
+		return -EOVERFLOW;
+	if (fl->fl_end != OFFSET_MAX && fl->fl_end > OFFT_OFFSET_MAX)
+		return -EOVERFLOW;
+#endif
+	flock->l_start = fl->fl_start;
+	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
+		fl->fl_end - fl->fl_start + 1;
+	flock->l_whence = 0;
+	return 0;
+}
+
+#if BITS_PER_LONG == 32
+static void posix_lock_to_flock64(struct flock64 *flock, struct file_lock *fl)
+{
+	flock->l_pid = fl->fl_pid;
+	flock->l_start = fl->fl_start;
+	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
+		fl->fl_end - fl->fl_start + 1;
+	flock->l_whence = 0;
+	flock->l_type = fl->fl_type;
+}
+#endif
+
 /* Report the first existing lock that would conflict with l.
  * This implements the F_GETLK command of fcntl().
  */
@@ -1645,24 +1677,9 @@ int fcntl_getlk(struct file *filp, struc
  
 	flock.l_type = F_UNLCK;
 	if (fl != NULL) {
-		flock.l_pid = fl->fl_pid;
-#if BITS_PER_LONG == 32
-		/*
-		 * Make sure we can represent the posix lock via
-		 * legacy 32bit flock.
-		 */
-		error = -EOVERFLOW;
-		if (fl->fl_start > OFFT_OFFSET_MAX)
+		error = posix_lock_to_flock(&flock, fl);
+		if (error)
 			goto out;
-		if ((fl->fl_end != OFFSET_MAX)
-		    && (fl->fl_end > OFFT_OFFSET_MAX))
-			goto out;
-#endif
-		flock.l_start = fl->fl_start;
-		flock.l_len = fl->fl_end == OFFSET_MAX ? 0 :
-			fl->fl_end - fl->fl_start + 1;
-		flock.l_whence = 0;
-		flock.l_type = fl->fl_type;
 	}
 	error = -EFAULT;
 	if (!copy_to_user(l, &flock, sizeof(flock)))
@@ -1798,14 +1815,8 @@ int fcntl_getlk64(struct file *filp, str
 	}
  
 	flock.l_type = F_UNLCK;
-	if (fl != NULL) {
-		flock.l_pid = fl->fl_pid;
-		flock.l_start = fl->fl_start;
-		flock.l_len = fl->fl_end == OFFSET_MAX ? 0 :
-			fl->fl_end - fl->fl_start + 1;
-		flock.l_whence = 0;
-		flock.l_type = fl->fl_type;
-	}
+	if (fl != NULL)
+		posix_lock_to_flock64(&flock, fl);
 	error = -EFAULT;
 	if (!copy_to_user(l, &flock, sizeof(flock)))
 		error = 0;
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

auth_gss-unregister-gss_domain-when-unloading-module.patch
git-nfs-server-cluster-locking-api.patch
remove-nfs4_acl_add_ace.patch
