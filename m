From: akpm@linux-foundation.org
Subject: [merged] fs-coda-logging-prefix-uniformization.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:31:27 -0700
Message-ID: <53960b8f.YTqF9/dVcHV0eOrE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFITb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jaharkes@cs.cmu.edu, fabf@skynet.be

Subject: [merged] fs-coda-logging-prefix-uniformization.patch removed from -mm tree
To: fabf@skynet.be,jaharkes@cs.cmu.edu,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:27 -0700


The patch titled
     Subject: fs/coda: logging prefix uniformization
has been removed from the -mm tree.  Its filename was
     fs-coda-logging-prefix-uniformization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/coda: logging prefix uniformization

- Add pr_fmt based on module name.

- Remove Coda: coda: from pr_foo()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/coda_linux.h |    6 ++++++
 fs/coda/dir.c        |    2 +-
 fs/coda/inode.c      |    2 +-
 fs/coda/psdev.c      |    6 +++---
 fs/coda/upcall.c     |    6 +++---
 5 files changed, 14 insertions(+), 8 deletions(-)

diff -puN fs/coda/coda_linux.h~fs-coda-logging-prefix-uniformization fs/coda/coda_linux.h
--- a/fs/coda/coda_linux.h~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/coda_linux.h
@@ -12,6 +12,12 @@
 #ifndef _LINUX_CODA_FS
 #define _LINUX_CODA_FS
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/param.h>
 #include <linux/mm.h>
diff -puN fs/coda/dir.c~fs-coda-logging-prefix-uniformization fs/coda/dir.c
--- a/fs/coda/dir.c~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/dir.c
@@ -589,7 +589,7 @@ int coda_revalidate_inode(struct inode *
 		coda_vattr_to_iattr(inode, &attr);
 
 		if ((old_mode & S_IFMT) != (inode->i_mode & S_IFMT)) {
-			pr_warn("Coda: inode %ld, fid %s changed type!\n",
+			pr_warn("inode %ld, fid %s changed type!\n",
 				inode->i_ino, coda_f2s(&(cii->c_fid)));
 		}
 
diff -puN fs/coda/inode.c~fs-coda-logging-prefix-uniformization fs/coda/inode.c
--- a/fs/coda/inode.c~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/inode.c
@@ -247,7 +247,7 @@ static void coda_put_super(struct super_
 	sb->s_fs_info = NULL;
 	mutex_unlock(&vcp->vc_mutex);
 
-	pr_info("Coda: Bye bye.\n");
+	pr_info("Bye bye.\n");
 }
 
 static void coda_evict_inode(struct inode *inode)
diff -puN fs/coda/psdev.c~fs-coda-logging-prefix-uniformization fs/coda/psdev.c
--- a/fs/coda/psdev.c~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/psdev.c
@@ -120,7 +120,7 @@ static ssize_t coda_psdev_write(struct f
 			goto out;
 		}
 		if ( nbytes > size ) {
-			pr_warn("Coda: downcall opc %d, uniq %d, too much!",
+			pr_warn("downcall opc %d, uniq %d, too much!",
 				hdr.opcode, hdr.unique);
 		        nbytes = size;
 		}
@@ -400,7 +400,7 @@ static int __init init_coda(void)
 	
 	status = register_filesystem(&coda_fs_type);
 	if (status) {
-		pr_warn("coda: failed to register filesystem!\n");
+		pr_warn("failed to register filesystem!\n");
 		goto out;
 	}
 	return 0;
@@ -422,7 +422,7 @@ static void __exit exit_coda(void)
 
 	err = unregister_filesystem(&coda_fs_type);
 	if (err != 0)
-		pr_warn("coda: failed to unregister filesystem\n");
+		pr_warn("failed to unregister filesystem\n");
 	for (i = 0; i < MAX_CODADEVS; i++)
 		device_destroy(coda_psdev_class, MKDEV(CODA_PSDEV_MAJOR, i));
 	class_destroy(coda_psdev_class);
diff -puN fs/coda/upcall.c~fs-coda-logging-prefix-uniformization fs/coda/upcall.c
--- a/fs/coda/upcall.c~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/upcall.c
@@ -675,7 +675,7 @@ static int coda_upcall(struct venus_comm
 	mutex_lock(&vcp->vc_mutex);
 
 	if (!vcp->vc_inuse) {
-		pr_notice("coda: Venus dead, not sending upcall\n");
+		pr_notice("Venus dead, not sending upcall\n");
 		error = -ENXIO;
 		goto exit;
 	}
@@ -725,7 +725,7 @@ static int coda_upcall(struct venus_comm
 
 	error = -EINTR;
 	if ((req->uc_flags & CODA_REQ_ABORT) || !signal_pending(current)) {
-		pr_warn("coda: Unexpected interruption.\n");
+		pr_warn("Unexpected interruption.\n");
 		goto exit;
 	}
 
@@ -735,7 +735,7 @@ static int coda_upcall(struct venus_comm
 
 	/* Venus saw the upcall, make sure we can send interrupt signal */
 	if (!vcp->vc_inuse) {
-		pr_info("coda: Venus dead, not sending signal.\n");
+		pr_info("Venus dead, not sending signal.\n");
 		goto exit;
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

