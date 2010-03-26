From: akpm@linux-foundation.org
Subject: [merged] reiserfs-fix-oops-while-creating-privroot-with-selinux-enabled.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:37:13 -0400
Message-ID: <201003261938.o2QJcCYf016673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab0CZTiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix oops while creating privroot with selinux enabled
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-oops-while-creating-privroot-with-selinux-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix oops while creating privroot with selinux enabled
From: Jeff Mahoney <jeffm@suse.com>

Commit 57fe60df ("reiserfs: add atomic addition of selinux attributes
during inode creation") contains a bug that will cause it to oops when
mounting a file system that didn't previously contain extended attributes
on a system using security.* xattrs.

The issue is that while creating the privroot during mount
reiserfs_security_init calls reiserfs_xattr_jcreate_nblocks which
dereferences the xattr root.  The xattr root doesn't exist, so we get an
oops.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=15309

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr_security.c   |    2 +-
 include/linux/reiserfs_xattr.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/reiserfs/xattr_security.c~reiserfs-fix-oops-while-creating-privroot-with-selinux-enabled fs/reiserfs/xattr_security.c
--- a/fs/reiserfs/xattr_security.c~reiserfs-fix-oops-while-creating-privroot-with-selinux-enabled
+++ a/fs/reiserfs/xattr_security.c
@@ -76,7 +76,7 @@ int reiserfs_security_init(struct inode 
 		return error;
 	}
 
-	if (sec->length) {
+	if (sec->length && reiserfs_xattrs_initialized(inode->i_sb)) {
 		blocks = reiserfs_xattr_jcreate_nblocks(inode) +
 			 reiserfs_xattr_nblocks(inode, sec->length);
 		/* We don't want to count the directories twice if we have
diff -puN include/linux/reiserfs_xattr.h~reiserfs-fix-oops-while-creating-privroot-with-selinux-enabled include/linux/reiserfs_xattr.h
--- a/include/linux/reiserfs_xattr.h~reiserfs-fix-oops-while-creating-privroot-with-selinux-enabled
+++ a/include/linux/reiserfs_xattr.h
@@ -70,6 +70,11 @@ int reiserfs_security_write(struct reise
 void reiserfs_security_free(struct reiserfs_security_handle *sec);
 #endif
 
+static inline int reiserfs_xattrs_initialized(struct super_block *sb)
+{
+	return REISERFS_SB(sb)->priv_root != NULL;
+}
+
 #define xattr_size(size) ((size) + sizeof(struct reiserfs_xattr_header))
 static inline loff_t reiserfs_xattr_nblocks(struct inode *inode, loff_t size)
 {
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
linux-next.patch
delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch

