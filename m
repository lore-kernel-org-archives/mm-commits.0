From: akpm@osdl.org
Subject: - struct-path-convert-sysv.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:15 -0800
Message-ID: <200612082005.kB8K5Fg8002279@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57471 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426321AbWLHUFT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert sysv
has been removed from the -mm tree.  Its filename was
     struct-path-convert-sysv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert sysv
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/sysv/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sysv/dir.c~struct-path-convert-sysv fs/sysv/dir.c
--- a/fs/sysv/dir.c~struct-path-convert-sysv
+++ a/fs/sysv/dir.c
@@ -70,7 +70,7 @@ fail:
 static int sysv_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	unsigned long pos = filp->f_pos;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
 	unsigned offset = pos & ~PAGE_CACHE_MASK;
 	unsigned long n = pos >> PAGE_CACHE_SHIFT;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

