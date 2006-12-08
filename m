From: akpm@osdl.org
Subject: - struct-path-convert-zorro.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:29 -0800
Message-ID: <200612082005.kB8K5TqT002311@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57518 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426323AbWLHUFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert zorro
has been removed from the -mm tree.  Its filename was
     struct-path-convert-zorro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert zorro
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/zorro/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/zorro/proc.c~struct-path-convert-zorro drivers/zorro/proc.c
--- a/drivers/zorro/proc.c~struct-path-convert-zorro
+++ a/drivers/zorro/proc.c
@@ -47,7 +47,7 @@ proc_bus_zorro_lseek(struct file *file, 
 static ssize_t
 proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	struct inode *ino = file->f_dentry->d_inode;
+	struct inode *ino = file->f_path.dentry->d_inode;
 	struct proc_dir_entry *dp = PDE(ino);
 	struct zorro_dev *z = dp->data;
 	struct ConfigDev cd;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-zorro.patch

