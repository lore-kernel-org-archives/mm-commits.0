From: akpm@linux-foundation.org
Subject: - sysfs-fix-i_ino-handling-in-sysfs.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:51 -0700
Message-ID: <200704132328.l3DNSp8W012553@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60445 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161098AbXDMX3S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: fix i_ino handling in sysfs
has been removed from the -mm tree.  Its filename was
     sysfs-fix-i_ino-handling-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: fix i_ino handling in sysfs
From: Tejun Heo <htejun@gmail.com>

Inode number handling was incorrect in two ways.

1. sysfs uses the inode number allocated by new_inode() and never hashes
   it.  When reporting the inode number, it uses iunique() if inode is
   inaccessible.  This is incorrect because iunique() assumes the inodes are
   hashed.  This can cause duplicate inode numbers and the condition is likely
   to happen because new_inode() and iunique() use separate increasing static
   counters to scan for empty slot.

2. sysfs_dirent->s_dentry can go away anytime and can't be referenced
   unless the caller knows the dentry is not and not going to be deleted.

This patch makes sysfs report the pointer to sysfs_dirent as ino.  ino_t is
always as big as or larger than unsigned long && sysfs_dirent hierarchy is the
internal representation of the sysfs tree, so it makes sense and simple to
implement.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c   |   11 ++++-------
 fs/sysfs/inode.c |    1 +
 2 files changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/sysfs/dir.c~sysfs-fix-i_ino-handling-in-sysfs fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-fix-i_ino-handling-in-sysfs
+++ a/fs/sysfs/dir.c
@@ -504,19 +504,19 @@ static int sysfs_readdir(struct file * f
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
 	struct sysfs_dirent *cursor = filp->private_data;
 	struct list_head *p, *q = &cursor->s_sibling;
-	ino_t ino;
+	unsigned long ino;
 	int i = filp->f_pos;
 
 	switch (i) {
 		case 0:
-			ino = dentry->d_inode->i_ino;
+			ino = (unsigned long)parent_sd;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
 			i++;
 			/* fallthrough */
 		case 1:
-			ino = parent_ino(dentry);
+			ino = (unsigned long)dentry->d_parent->d_fsdata;
 			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -538,10 +538,7 @@ static int sysfs_readdir(struct file * f
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = (unsigned long)next;
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
diff -puN fs/sysfs/inode.c~sysfs-fix-i_ino-handling-in-sysfs fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~sysfs-fix-i_ino-handling-in-sysfs
+++ a/fs/sysfs/inode.c
@@ -140,6 +140,7 @@ struct inode * sysfs_new_inode(mode_t mo
 		inode->i_mapping->a_ops = &sysfs_aops;
 		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 		inode->i_op = &sysfs_inode_operations;
+		inode->i_ino = (unsigned long)sd;
 		lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
 		if (sd->s_iattr) {
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
