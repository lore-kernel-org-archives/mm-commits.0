From: akpm@linux-foundation.org
Subject: - bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:47 -0700
Message-ID: <200805162253.m4GMrlmB003169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757282AbYEPWyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     BKL-removal: convert CIFS over to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BKL-removal: convert CIFS over to unlocked_ioctl
From: Andi Kleen <andi@firstfloor.org>

cifs_ioctl doesn't seem to need the BKL for anything, so convert it over to
use unlocked_ioctl.

Signed-off-by: Andi Kleen <andi@firstfloor.org>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c |   10 +++++-----
 fs/cifs/cifsfs.h |    4 ++--
 fs/cifs/ioctl.c  |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/cifs/cifsfs.c~bkl-removal-convert-cifs-over-to-unlocked_ioctl fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~bkl-removal-convert-cifs-over-to-unlocked_ioctl
+++ a/fs/cifs/cifsfs.c
@@ -657,7 +657,7 @@ const struct file_operations cifs_file_o
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl	= cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -677,7 +677,7 @@ const struct file_operations cifs_file_d
 	.flush = cifs_flush,
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -697,7 +697,7 @@ const struct file_operations cifs_file_n
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl	= cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -716,7 +716,7 @@ const struct file_operations cifs_file_d
 	.flush = cifs_flush,
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -731,7 +731,7 @@ const struct file_operations cifs_dir_op
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	.dir_notify = cifs_dir_notify,
 #endif /* CONFIG_CIFS_EXPERIMENTAL */
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 };
 
 static void
diff -puN fs/cifs/cifsfs.h~bkl-removal-convert-cifs-over-to-unlocked_ioctl fs/cifs/cifsfs.h
--- a/fs/cifs/cifsfs.h~bkl-removal-convert-cifs-over-to-unlocked_ioctl
+++ a/fs/cifs/cifsfs.h
@@ -95,8 +95,8 @@ extern int 	cifs_setxattr(struct dentry 
 			size_t, int);
 extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
-extern int cifs_ioctl(struct inode *inode, struct file *filep,
-		       unsigned int command, unsigned long arg);
+extern long cifs_ioctl(struct file *filep, unsigned int command,
+		unsigned long arg);
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 extern const struct export_operations cifs_export_ops;
diff -puN fs/cifs/ioctl.c~bkl-removal-convert-cifs-over-to-unlocked_ioctl fs/cifs/ioctl.c
--- a/fs/cifs/ioctl.c~bkl-removal-convert-cifs-over-to-unlocked_ioctl
+++ a/fs/cifs/ioctl.c
@@ -30,9 +30,9 @@
 
 #define CIFS_IOC_CHECKUMOUNT _IO(0xCF, 2)
 
-int cifs_ioctl(struct inode *inode, struct file *filep,
-		unsigned int command, unsigned long arg)
+long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 {
+	struct inode *inode = filep->f_dentry->d_inode;
 	int rc = -ENOTTY; /* strange error - but the precedent */
 	int xid;
 	struct cifs_sb_info *cifs_sb;
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
x86-use-explicit-copy-in-vdso_gettimeofday.patch
git-kbuild-fixes.patch
common-implementation-of-iterative-div-mod.patch
add-an-inlined-version-of-iter_div_u64_rem.patch
always_inline-timespec_add_ns.patch
profile-likely-unlikely-macros.patch

