From: akpm@linux-foundation.org
Subject: [merged] jfs-free-sbi-memory-in-error-path.patch removed from -mm tree
Date: Wed, 19 May 2010 10:30:46 -0400
Message-ID: <201005191732.o4JHWCTi025723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268Ab0ESRcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:32:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, shaggy@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jfs: free sbi memory in error path
has been removed from the -mm tree.  Its filename was
     jfs-free-sbi-memory-in-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jfs: free sbi memory in error path
From: Jan Blunck <jblunck@suse.de>

I spotted the missing kfree() while removing the BKL.

[akpm@linux-foundation.org: avoid multiple returns so it doesn't happen again]
Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/super.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/jfs/super.c~jfs-free-sbi-memory-in-error-path fs/jfs/super.c
--- a/fs/jfs/super.c~jfs-free-sbi-memory-in-error-path
+++ a/fs/jfs/super.c
@@ -446,10 +446,8 @@ static int jfs_fill_super(struct super_b
 	/* initialize the mount flag and determine the default error handler */
 	flag = JFS_ERR_REMOUNT_RO;
 
-	if (!parse_options((char *) data, sb, &newLVSize, &flag)) {
-		kfree(sbi);
-		return -EINVAL;
-	}
+	if (!parse_options((char *) data, sb, &newLVSize, &flag))
+		goto out_kfree;
 	sbi->flag = flag;
 
 #ifdef CONFIG_JFS_POSIX_ACL
@@ -458,7 +456,7 @@ static int jfs_fill_super(struct super_b
 
 	if (newLVSize) {
 		printk(KERN_ERR "resize option for remount only\n");
-		return -EINVAL;
+		goto out_kfree;
 	}
 
 	/*
@@ -478,7 +476,7 @@ static int jfs_fill_super(struct super_b
 	inode = new_inode(sb);
 	if (inode == NULL) {
 		ret = -ENOMEM;
-		goto out_kfree;
+		goto out_unload;
 	}
 	inode->i_ino = 0;
 	inode->i_nlink = 1;
@@ -550,9 +548,10 @@ out_mount_failed:
 	make_bad_inode(sbi->direct_inode);
 	iput(sbi->direct_inode);
 	sbi->direct_inode = NULL;
-out_kfree:
+out_unload:
 	if (sbi->nls_tab)
 		unload_nls(sbi->nls_tab);
+out_kfree:
 	kfree(sbi);
 	return ret;
 }
_

Patches currently in -mm which might be from jblunck@suse.de are

linux-next.patch
osst-update-ppos-instead-of-using-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

