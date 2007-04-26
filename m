From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-allow-unprivileged-fuse-mounts.patch removed from -mm tree
Date: Wed, 25 Apr 2007 18:57:21 -0700
Message-ID: <200704260157.l3Q1vL6j018416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423075AbXDZB5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, ebiederm@xmission.com, hch@lst.de, linuxram@us.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     unprivileged mounts: allow unprivileged fuse mounts
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-allow-unprivileged-fuse-mounts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: unprivileged mounts: allow unprivileged fuse mounts
From: Miklos Szeredi <mszeredi@suse.cz>

Use FS_SAFE for "fuse" fs type, but not for "fuseblk".

FUSE was designed from the beginning to be safe for unprivileged users.  This
has also been verified in practice over many years.  In addition unprivileged
mounts require the parent mount to be owned by the user, which is more strict
than the current userspace policy.

This will enable future installations to remove the suid-root fusermount
utility.

Don't require the "user_id=" and "group_id=" options for unprivileged mounts,
but if they are present, verify them for sanity.

Disallow the "allow_other" option for unprivileged mounts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN fs/fuse/inode.c~unprivileged-mounts-allow-unprivileged-fuse-mounts fs/fuse/inode.c
--- a/fs/fuse/inode.c~unprivileged-mounts-allow-unprivileged-fuse-mounts
+++ a/fs/fuse/inode.c
@@ -311,6 +311,19 @@ static int parse_fuse_opt(char *opt, str
 	d->max_read = ~0;
 	d->blksize = 512;
 
+	/*
+	 * For unprivileged mounts use current uid/gid.  Still allow
+	 * "user_id" and "group_id" options for compatibility, but
+	 * only if they match these values.
+	 */
+	if (!capable(CAP_SYS_ADMIN)) {
+		d->user_id = current->uid;
+		d->user_id_present = 1;
+		d->group_id = current->gid;
+		d->group_id_present = 1;
+
+	}
+
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
 		int value;
@@ -339,6 +352,8 @@ static int parse_fuse_opt(char *opt, str
 		case OPT_USER_ID:
 			if (match_int(&args[0], &value))
 				return 0;
+			if (d->user_id_present && d->user_id != value)
+				return 0;
 			d->user_id = value;
 			d->user_id_present = 1;
 			break;
@@ -346,6 +361,8 @@ static int parse_fuse_opt(char *opt, str
 		case OPT_GROUP_ID:
 			if (match_int(&args[0], &value))
 				return 0;
+			if (d->group_id_present && d->group_id != value)
+				return 0;
 			d->group_id = value;
 			d->group_id_present = 1;
 			break;
@@ -538,6 +555,10 @@ static int fuse_fill_super(struct super_
 	if (!parse_fuse_opt((char *) data, &d, is_bdev))
 		return -EINVAL;
 
+	/* This is a privileged option */
+	if ((d.flags & FUSE_ALLOW_OTHER) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (is_bdev) {
 #ifdef CONFIG_BLOCK
 		if (!sb_set_blocksize(sb, d.blksize))
@@ -641,6 +662,7 @@ static struct file_system_type fuse_fs_t
 	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb,
 	.kill_sb	= kill_anon_super,
+	.fs_flags	= FS_SAFE,
 };
 
 #ifdef CONFIG_BLOCK
_

Patches currently in -mm which might be from mszeredi@suse.cz are

split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
add-file-position-info-to-proc-fix.patch
check-privileges-before-setting-mount-propagation.patch
consolidate-generic_writepages-and-mpage_writepages.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
