From: akpm@linux-foundation.org
Subject: + fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch added to -mm tree
Date: Fri, 09 Apr 2010 16:15:41 -0700
Message-ID: <201004092315.o39NFgOw017227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab0DIXPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 19:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, al@alarsen.net, fweisbec@gmail.com, jack@suse.cz


The patch titled
     fs/: do not fallback to default_llseek() when readdir() uses BKL
has been added to the -mm tree.  Its filename is
     fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/: do not fallback to default_llseek() when readdir() uses BKL
From: jan Blunck <jblunck@suse.de>

Do not use the fallback default_llseek() if the readdir operation of the
filesystem still uses the big kernel lock.

Since llseek() modifies
file->f_pos of the directory directly it may need locking to not confuse
readdir which usually uses file->f_pos directly as well

Since the special characteristics of the BKL (unlocked on schedule) are
not necessary in this case, the inode mutex can be used for locking as
provided by generic_file_llseek().  This is only possible since all
filesystems, except reiserfs, either use a directory as a flat file or
with disk address offsets.  Reiserfs on the other hand uses a 32bit hash
off the filename as the offset so generic_file_llseek() can get used as
well since the hash is always smaller than sb->s_maxbytes (= (512 << 32) -
blocksize).

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Anders Larsen <al@alarsen.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/root.c          |    1 +
 fs/freevxfs/vxfs_lookup.c |    2 ++
 fs/isofs/dir.c            |    1 +
 fs/ncpfs/dir.c            |    1 +
 fs/qnx4/dir.c             |    1 +
 fs/reiserfs/dir.c         |    1 +
 fs/smbfs/dir.c            |    1 +
 fs/udf/dir.c              |    1 +
 8 files changed, 9 insertions(+)

diff -puN fs/autofs/root.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl fs/autofs/root.c
--- a/fs/autofs/root.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl
+++ a/fs/autofs/root.c
@@ -31,6 +31,7 @@ const struct file_operations autofs_root
 	.read		= generic_read_dir,
 	.readdir	= autofs_root_readdir,
 	.ioctl		= autofs_root_ioctl,
+	.llseek		= generic_file_llseek,
 };
 
 const struct inode_operations autofs_root_inode_operations = {
diff -puN fs/freevxfs/vxfs_lookup.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl fs/freevxfs/vxfs_lookup.c
--- a/fs/freevxfs/vxfs_lookup.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl
+++ a/fs/freevxfs/vxfs_lookup.c
@@ -57,6 +57,8 @@ const struct inode_operations vxfs_dir_i
 };
 
 const struct file_operations vxfs_dir_operations = {
+	.llseek =		generic_file_llseek,
+	.read =			generic_read_dir,
 	.readdir =		vxfs_readdir,
 };
 
diff -puN fs/isofs/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl fs/isofs/dir.c
--- a/fs/isofs/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl
+++ a/fs/isofs/dir.c
@@ -272,6 +272,7 @@ static int isofs_readdir(struct file *fi
 
 const struct file_operations isofs_dir_operations =
 {
+	.llseek = generic_file_llseek,
 	.read = generic_read_dir,
 	.readdir = isofs_readdir,
 };
diff -puN fs/ncpfs/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl
+++ a/fs/ncpfs/dir.c
@@ -49,6 +49,7 @@ extern int ncp_symlink(struct inode *, s
 		      
 const struct file_operations ncp_dir_operations =
 {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ncp_readdir,
 	.ioctl		= ncp_ioctl,
diff -puN fs/qnx4/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl fs/qnx4/dir.c
--- a/fs/qnx4/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl
+++ a/fs/qnx4/dir.c
@@ -77,6 +77,7 @@ out:
 
 const struct file_operations qnx4_dir_operations =
 {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= qnx4_readdir,
 	.fsync		= simple_fsync,
diff -puN fs/reiserfs/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl fs/reiserfs/dir.c
--- a/fs/reiserfs/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl
+++ a/fs/reiserfs/dir.c
@@ -18,6 +18,7 @@ static int reiserfs_dir_fsync(struct fil
 			      int datasync);
 
 const struct file_operations reiserfs_dir_operations = {
+	.llseek = generic_file_llseek,
 	.read = generic_read_dir,
 	.readdir = reiserfs_readdir,
 	.fsync = reiserfs_dir_fsync,
diff -puN fs/smbfs/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl fs/smbfs/dir.c
--- a/fs/smbfs/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl
+++ a/fs/smbfs/dir.c
@@ -37,6 +37,7 @@ static int smb_link(struct dentry *, str
 
 const struct file_operations smb_dir_operations =
 {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= smb_readdir,
 	.ioctl		= smb_ioctl,
diff -puN fs/udf/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl fs/udf/dir.c
--- a/fs/udf/dir.c~fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl
+++ a/fs/udf/dir.c
@@ -207,6 +207,7 @@ static int udf_readdir(struct file *filp
 
 /* readdir and lookup functions */
 const struct file_operations udf_dir_operations = {
+	.llseek			= generic_file_llseek,
 	.read			= generic_read_dir,
 	.readdir		= udf_readdir,
 	.ioctl			= udf_ioctl,
_

Patches currently in -mm which might be from jblunck@suse.de are

osst-update-ppos-instead-of-using-file-f_pos.patch
drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
zcrypt-use-nonseekable_open.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

