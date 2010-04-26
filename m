From: akpm@linux-foundation.org
Subject: [merged] reiserfs-fix-permissions-on-reiserfs_priv.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:25:54 -0400
Message-ID: <201004261727.o3QHRTc8009034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab0DZR1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, edward.shishkin@gmail.com, fweisbec@gmail.com, matt@mattmccutchen.net, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix permissions on .reiserfs_priv
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-permissions-on-reiserfs_priv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix permissions on .reiserfs_priv
From: Jeff Mahoney <jeffm@suse.com>

Commit 677c9b2e393a0cd203bd54e9c18b012b2c73305a ("reiserfs: remove
privroot hiding in lookup") removed the magic from the lookup code to hide
the .reiserfs_priv directory since it was getting loaded at mount-time
instead.  The intent was that the entry would be hidden from the user via
a poisoned d_compare, but this was faulty.

This introduced a security issue where unprivileged users could access and
modify extended attributes or ACLs belonging to other users, including
root.

This patch resolves the issue by properly hiding .reiserfs_priv.  This was
the intent of the xattr poisoning code, but it appears to have never
worked as expected.  This is fixed by using d_revalidate instead of
d_compare.

This patch makes -oexpose_privroot a no-op.  I'm fine leaving it this way.
The effort involved in working out the corner cases wrt permissions and
caching outweigh the benefit of the feature.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
Reported-by: Matt McCutchen <matt@mattmccutchen.net>
Tested-by: Matt McCutchen <matt@mattmccutchen.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/dir.c   |    2 --
 fs/reiserfs/xattr.c |   17 ++++-------------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff -puN fs/reiserfs/dir.c~reiserfs-fix-permissions-on-reiserfs_priv fs/reiserfs/dir.c
--- a/fs/reiserfs/dir.c~reiserfs-fix-permissions-on-reiserfs_priv
+++ a/fs/reiserfs/dir.c
@@ -46,8 +46,6 @@ static inline bool is_privroot_deh(struc
 				   struct reiserfs_de_head *deh)
 {
 	struct dentry *privroot = REISERFS_SB(dir->d_sb)->priv_root;
-	if (reiserfs_expose_privroot(dir->d_sb))
-		return 0;
 	return (dir == dir->d_parent && privroot->d_inode &&
 	        deh->deh_objectid == INODE_PKEY(privroot->d_inode)->k_objectid);
 }
diff -puN fs/reiserfs/xattr.c~reiserfs-fix-permissions-on-reiserfs_priv fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-fix-permissions-on-reiserfs_priv
+++ a/fs/reiserfs/xattr.c
@@ -973,21 +973,13 @@ int reiserfs_permission(struct inode *in
 	return generic_permission(inode, mask, NULL);
 }
 
-/* This will catch lookups from the fs root to .reiserfs_priv */
-static int
-xattr_lookup_poison(struct dentry *dentry, struct qstr *q1, struct qstr *name)
+static int xattr_hide_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
-	struct dentry *priv_root = REISERFS_SB(dentry->d_sb)->priv_root;
-	if (container_of(q1, struct dentry, d_name) == priv_root)
-		return -ENOENT;
-	if (q1->len == name->len &&
-		   !memcmp(q1->name, name->name, name->len))
-		return 0;
-	return 1;
+	return -EPERM;
 }
 
 static const struct dentry_operations xattr_lookup_poison_ops = {
-	.d_compare = xattr_lookup_poison,
+	.d_revalidate = xattr_hide_revalidate,
 };
 
 int reiserfs_lookup_privroot(struct super_block *s)
@@ -1001,8 +993,7 @@ int reiserfs_lookup_privroot(struct supe
 				strlen(PRIVROOT_NAME));
 	if (!IS_ERR(dentry)) {
 		REISERFS_SB(s)->priv_root = dentry;
-		if (!reiserfs_expose_privroot(s))
-			s->s_root->d_op = &xattr_lookup_poison_ops;
+		dentry->d_op = &xattr_lookup_poison_ops;
 		if (dentry->d_inode)
 			dentry->d_inode->i_flags |= S_PRIVATE;
 	} else
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
linux-next.patch
buffer_head-remove-redundant-test-from-wait_on_buffer.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch

