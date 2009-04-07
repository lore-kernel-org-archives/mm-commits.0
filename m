From: akpm@linux-foundation.org
Subject: [merged] nilfs2-use-unlocked_ioctl.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:37 -0700
Message-ID: <200904071909.n37J9bQt012424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760327AbZDGTMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     nilfs2: use unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     nilfs2-use-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: use unlocked_ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Pekka Enberg suggested converting ->ioctl operations to use
->unlocked_ioctl to avoid BKL.

The conversion was verified to be safe, so I will take it on this
occasion.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |    2 +-
 fs/nilfs2/file.c  |    2 +-
 fs/nilfs2/ioctl.c |    4 ++--
 fs/nilfs2/nilfs.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/nilfs2/dir.c~nilfs2-use-unlocked_ioctl fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c~nilfs2-use-unlocked_ioctl
+++ a/fs/nilfs2/dir.c
@@ -702,7 +702,7 @@ struct file_operations nilfs_dir_operati
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= nilfs_readdir,
-	.ioctl		= nilfs_ioctl,
+	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_ioctl,
 #endif	/* CONFIG_COMPAT */
diff -puN fs/nilfs2/file.c~nilfs2-use-unlocked_ioctl fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-use-unlocked_ioctl
+++ a/fs/nilfs2/file.c
@@ -140,7 +140,7 @@ struct file_operations nilfs_file_operat
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
-	.ioctl		= nilfs_ioctl,
+	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_ioctl,
 #endif	/* CONFIG_COMPAT */
diff -puN fs/nilfs2/ioctl.c~nilfs2-use-unlocked_ioctl fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-use-unlocked_ioctl
+++ a/fs/nilfs2/ioctl.c
@@ -600,9 +600,9 @@ static int nilfs_ioctl_sync(struct inode
 	return 0;
 }
 
-int nilfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		unsigned long arg)
+long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	void __user *argp = (void * __user *)arg;
 
 	switch (cmd) {
diff -puN fs/nilfs2/nilfs.h~nilfs2-use-unlocked_ioctl fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-use-unlocked_ioctl
+++ a/fs/nilfs2/nilfs.h
@@ -242,7 +242,7 @@ extern void nilfs_set_link(struct inode 
 extern int nilfs_sync_file(struct file *, struct dentry *, int);
 
 /* ioctl.c */
-int nilfs_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+long nilfs_ioctl(struct file *, unsigned int, unsigned long);
 int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, void __user *);
 
 /* inode.c */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

