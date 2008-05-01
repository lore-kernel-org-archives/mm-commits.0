From: akpm@linux-foundation.org
Subject: - reiser4-new-export_ops-fixup.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:19 -0700
Message-ID: <200805010923.m419NJOS030085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755045AbYEAJXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, musv@gmx.de, mm-commits@vger.kernel.org


The patch titled
     reiser4: new export_ops fixup
has been removed from the -mm tree.  Its filename was
     reiser4-new-export_ops-fixup.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: new export_ops fixup
From: Edward Shishkin <edward.shishkin@gmail.com>

Added missed reiser4_{init, exit}_context()

Cc: Sven Muller <musv@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/export_ops.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN fs/reiser4/export_ops.c~reiser4-new-export_ops-fixup fs/reiser4/export_ops.c
--- a/fs/reiser4/export_ops.c~reiser4-new-export_ops-fixup
+++ a/fs/reiser4/export_ops.c
@@ -257,19 +257,28 @@ static struct dentry *reiser4_get_dentry
 {
 	struct inode *dir;
 	dir_plugin *dplug;
+	struct dentry *result;
+	reiser4_context *ctx;
 
 	assert("nikita-3527", child != NULL);
-	/* see comment in reiser4_get_dentry() about following assertion */
-	assert("nikita-3528", is_in_reiser4_context());
 
 	dir = child->d_inode;
 	assert("nikita-3529", dir != NULL);
+
+	ctx = reiser4_init_context(dir->i_sb);
+	if (IS_ERR(ctx))
+		return (void *)ctx;
+
 	dplug = inode_dir_plugin(dir);
 	assert("nikita-3531", ergo(dplug != NULL, dplug->get_parent != NULL));
-	if (dplug != NULL)
-		return dplug->get_parent(dir);
-	else
+
+	if (unlikely(dplug == NULL)) {
+		reiser4_exit_context(ctx);
 		return ERR_PTR(RETERR(-ENOTDIR));
+	}
+	result = dplug->get_parent(dir);
+	reiser4_exit_context(ctx);
+	return result;
 }
 
 /**
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

origin.patch
reiser4.patch
reiser4-new-export_ops-fixup.patch
reiser4-specify-splice-file-operations.patch
reiser4-fix-dummy-ioctl_cryptcompress.patch
reiser4-granulate-rw-serialization-when-accessing-file-conversion-set.patch
reiser4-fix-disk-cluster-synchronization.patch
reiser4-use-balance_dirty_pages_ratelimited_nr.patch
reiser4-correct-references-to-filemap_nopage.patch
reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch
reiser4-code-cleanups.patch

