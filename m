From: akpm@linux-foundation.org
Subject: [merged] fs-romfs-superc-convert-printk-to-pr_foo.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:41:10 -0700
Message-ID: <53ea6dd6.3Dxf8LR6TBsQj5P5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:41715 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaHLTlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:11 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2671119pde.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/romfs/super.c: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     fs-romfs-superc-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/romfs/super.c: convert printk to pr_foo()

Use current logging functions. Coalesce formats.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN fs/romfs/super.c~fs-romfs-superc-convert-printk-to-pr_foo fs/romfs/super.c
--- a/fs/romfs/super.c~fs-romfs-superc-convert-printk-to-pr_foo
+++ a/fs/romfs/super.c
@@ -380,7 +380,7 @@ static struct inode *romfs_iget(struct s
 eio:
 	ret = -EIO;
 error:
-	printk(KERN_ERR "ROMFS: read error for inode 0x%lx\n", pos);
+	pr_err("ROMFS: read error for inode 0x%lx\n", pos);
 	return ERR_PTR(ret);
 }
 
@@ -507,14 +507,13 @@ static int romfs_fill_super(struct super
 	if (rsb->word0 != ROMSB_WORD0 || rsb->word1 != ROMSB_WORD1 ||
 	    img_size < ROMFH_SIZE) {
 		if (!silent)
-			printk(KERN_WARNING "VFS:"
-			       " Can't find a romfs filesystem on dev %s.\n",
+			pr_warn("VFS: Can't find a romfs filesystem on dev %s.\n",
 			       sb->s_id);
 		goto error_rsb_inval;
 	}
 
 	if (romfs_checksum(rsb, min_t(size_t, img_size, 512))) {
-		printk(KERN_ERR "ROMFS: bad initial checksum on dev %s.\n",
+		pr_err("ROMFS: bad initial checksum on dev %s.\n",
 		       sb->s_id);
 		goto error_rsb_inval;
 	}
@@ -523,7 +522,7 @@ static int romfs_fill_super(struct super
 
 	len = strnlen(rsb->name, ROMFS_MAXFN);
 	if (!silent)
-		printk(KERN_NOTICE "ROMFS: Mounting image '%*.*s' through %s\n",
+		pr_notice("ROMFS: Mounting image '%*.*s' through %s\n",
 		       (unsigned) len, (unsigned) len, rsb->name, storage);
 
 	kfree(rsb);
@@ -614,7 +613,7 @@ static int __init init_romfs_fs(void)
 {
 	int ret;
 
-	printk(KERN_INFO "ROMFS MTD (C) 2007 Red Hat, Inc.\n");
+	pr_info("ROMFS MTD (C) 2007 Red Hat, Inc.\n");
 
 	romfs_inode_cachep =
 		kmem_cache_create("romfs_i",
@@ -623,13 +622,12 @@ static int __init init_romfs_fs(void)
 				  romfs_i_init_once);
 
 	if (!romfs_inode_cachep) {
-		printk(KERN_ERR
-		       "ROMFS error: Failed to initialise inode cache\n");
+		pr_err("ROMFS error: Failed to initialise inode cache\n");
 		return -ENOMEM;
 	}
 	ret = register_filesystem(&romfs_fs_type);
 	if (ret) {
-		printk(KERN_ERR "ROMFS error: Failed to register filesystem\n");
+		pr_err("ROMFS error: Failed to register filesystem\n");
 		goto error_register;
 	}
 	return 0;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

