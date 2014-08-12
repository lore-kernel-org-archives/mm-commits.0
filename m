From: akpm@linux-foundation.org
Subject: [merged] fs-romfs-superc-use-pr_fmt-in-logging.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:12 -0700
Message-ID: <53ea6dd8.GU+SaOHOqhEjBA7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:44303 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaHLTlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:13 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1916436obb.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/romfs/super.c: use pr_fmt in logging
has been removed from the -mm tree.  Its filename was
     fs-romfs-superc-use-pr_fmt-in-logging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/romfs/super.c: use pr_fmt in logging

- Remove "Error" in format logging (already in pr_ level)

- Use modulename in pr_fmt instead of ROMFS: in each pr_ callsites.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/romfs/super.c~fs-romfs-superc-use-pr_fmt-in-logging fs/romfs/super.c
--- a/fs/romfs/super.c~fs-romfs-superc-use-pr_fmt-in-logging
+++ a/fs/romfs/super.c
@@ -56,6 +56,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
@@ -380,7 +382,7 @@ static struct inode *romfs_iget(struct s
 eio:
 	ret = -EIO;
 error:
-	pr_err("ROMFS: read error for inode 0x%lx\n", pos);
+	pr_err("read error for inode 0x%lx\n", pos);
 	return ERR_PTR(ret);
 }
 
@@ -513,8 +515,7 @@ static int romfs_fill_super(struct super
 	}
 
 	if (romfs_checksum(rsb, min_t(size_t, img_size, 512))) {
-		pr_err("ROMFS: bad initial checksum on dev %s.\n",
-		       sb->s_id);
+		pr_err("bad initial checksum on dev %s.\n", sb->s_id);
 		goto error_rsb_inval;
 	}
 
@@ -522,8 +523,8 @@ static int romfs_fill_super(struct super
 
 	len = strnlen(rsb->name, ROMFS_MAXFN);
 	if (!silent)
-		pr_notice("ROMFS: Mounting image '%*.*s' through %s\n",
-		       (unsigned) len, (unsigned) len, rsb->name, storage);
+		pr_notice("Mounting image '%*.*s' through %s\n",
+			  (unsigned) len, (unsigned) len, rsb->name, storage);
 
 	kfree(rsb);
 	rsb = NULL;
@@ -622,12 +623,12 @@ static int __init init_romfs_fs(void)
 				  romfs_i_init_once);
 
 	if (!romfs_inode_cachep) {
-		pr_err("ROMFS error: Failed to initialise inode cache\n");
+		pr_err("Failed to initialise inode cache\n");
 		return -ENOMEM;
 	}
 	ret = register_filesystem(&romfs_fs_type);
 	if (ret) {
-		pr_err("ROMFS error: Failed to register filesystem\n");
+		pr_err("Failed to register filesystem\n");
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

