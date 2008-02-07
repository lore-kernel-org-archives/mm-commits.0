From: akpm@linux-foundation.org
Subject: - fs-fat-refine-chmod-checks.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:26 -0800
Message-ID: <200802070020.m170K7pO006094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933447AbYBGAUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:20:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fs/fat/: refine chmod checks
has been removed from the -mm tree.  Its filename was
     fs-fat-refine-chmod-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/fat/: refine chmod checks
From: Jan Engelhardt <jengelh@computergmbh.de>

Prohibit mode changes in non-quiet mode that cannot be stored reliably with
the on-disk format.

Suppose a vfat filesystem is mounted with umask=0 and [not-quiet].  Then
all files will have mode 0777.  Trying to change the owner will fail,
because fat does not know about owners or groups.  chmod 0770, on the other
hand, will succeed, even though fat does not know about the permission
triplet [user/group/other].

So this patch changes fat's not-quiet behavior so that only UNIX modes are
accepted that can be mapped lossless between the fat disk format and the
local system.  There is only one attribute, and that is the readonly
attribute, which is mapped to the UNIX write permission bit(s).  chmod 0555
is therefore valid (taking away the +w bits <=> setting the readonly
attribute).  Since chmod 0775 and chmod 0755 is an ambiguous case as to
whether to set or clear the readonly bit, these modes are also denied.

In quiet mode, chmod and chown will continue to "succeed" as they did
before, meaning that a subsequent stat() will temporarily return the new
mode as long as the inode is not reread from disk, and chown will silently
do nothing, not even return the new uid/gid in stat().

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |   47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff -puN fs/fat/file.c~fs-fat-refine-chmod-checks fs/fat/file.c
--- a/fs/fat/file.c~fs-fat-refine-chmod-checks
+++ a/fs/fat/file.c
@@ -155,6 +155,42 @@ out:
 	return err;
 }
 
+static int check_mode(const struct msdos_sb_info *sbi, mode_t mode)
+{
+	mode_t req = mode & ~S_IFMT;
+
+	/*
+	 * Of the r and x bits, all (subject to umask) must be present. Of the
+	 * w bits, either all (subject to umask) or none must be present.
+	 */
+
+	if (S_ISREG(mode)) {
+		req &= ~sbi->options.fs_fmask;
+
+		if ((req & (S_IRUGO | S_IXUGO)) !=
+		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_fmask))
+			return -EPERM;
+
+		if ((req & S_IWUGO) != 0 &&
+		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_fmask))
+			return -EPERM;
+	} else if (S_ISDIR(mode)) {
+		req &= ~sbi->options.fs_dmask;
+
+		if ((req & (S_IRUGO | S_IXUGO)) !=
+		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_dmask))
+			return -EPERM;
+
+		if ((req & S_IWUGO) != 0 &&
+		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_dmask))
+			return -EPERM;
+	} else {
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 int fat_notify_change(struct dentry *dentry, struct iattr *attr)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
@@ -186,9 +222,7 @@ int fat_notify_change(struct dentry *den
 	if (((attr->ia_valid & ATTR_UID) &&
 	     (attr->ia_uid != sbi->options.fs_uid)) ||
 	    ((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != sbi->options.fs_gid)) ||
-	    ((attr->ia_valid & ATTR_MODE) &&
-	     (attr->ia_mode & ~MSDOS_VALID_MODE)))
+	     (attr->ia_gid != sbi->options.fs_gid)))
 		error = -EPERM;
 
 	if (error) {
@@ -196,6 +230,13 @@ int fat_notify_change(struct dentry *den
 			error = 0;
 		goto out;
 	}
+
+	if (attr->ia_valid & ATTR_MODE) {
+		error = check_mode(sbi, attr->ia_mode);
+		if (error != 0 && !sbi->options.quiet)
+			goto out;
+	}
+
 	error = inode_setattr(inode, attr);
 	if (error)
 		goto out;
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

origin.patch
git-dvb.patch
git-input.patch
git-kvm.patch
git-ocfs2.patch
git-unionfs.patch
git-watchdog.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
reiserfs-constify-function-pointer-tables.patch
procfs-constify-function-pointer-tables.patch
oss-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
