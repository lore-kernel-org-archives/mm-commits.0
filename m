From: akpm@linux-foundation.org
Subject: [folded] reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:19:40 -0800
Message-ID: <201002032019.o13KJekg016673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757867Ab0BCUTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:19:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: handling error returned by d_obtain_alias fixup
has been removed from the -mm tree.  Its filename was
     reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: handling error returned by d_obtain_alias fixup
From: Edward Shishkin <edward.shishkin@gmail.com>

. Fix up incorrect handling errors reterned by d_obtain_alias.
. Make quilt, checkpatch happy:
  remove comment with "joke not for everyone".

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/dir_plugin_common.c  |   10 +---------
 fs/reiser4/plugin/file_plugin_common.c |    5 +----
 2 files changed, 2 insertions(+), 13 deletions(-)

diff -puN fs/reiser4/plugin/dir_plugin_common.c~reiser4-handling-error-returned-by-d_obtain_alias-fixup fs/reiser4/plugin/dir_plugin_common.c
--- a/fs/reiser4/plugin/dir_plugin_common.c~reiser4-handling-error-returned-by-d_obtain_alias-fixup
+++ a/fs/reiser4/plugin/dir_plugin_common.c
@@ -56,10 +56,7 @@ struct dentry *get_parent_common(struct 
 		check_light_weight(parent, child);
 		reiser4_iget_complete(parent);
 		dentry = d_obtain_alias(parent);
-		if (dentry == NULL) {
-			iput(parent);
-			dentry = ERR_PTR(RETERR(-ENOMEM));
-		} else
+		if (!IS_ERR(dentry))
 			dentry->d_op = &get_super_private(s)->ops.dentry;
 	} else if (PTR_ERR(parent) == -ENOENT)
 		dentry = ERR_PTR(RETERR(-ESTALE));
@@ -353,11 +350,6 @@ int reiser4_dir_done_common(struct inode
 	result = reiser4_rem_entry_common(object, &goodby_dots, &entry);
 	reiser4_free_dentry_fsdata(&goodby_dots);
 	if (unlikely(result != 0 && result != -ENOMEM && result != -ENOENT))
-		/* only worth a warning
-
-		   "values of B will give rise to dom!\n"
-		   -- v6src/s2/mv.c:89
-		 */
 		warning("nikita-2252", "Cannot remove dot of %lli: %i",
 			(unsigned long long)get_inode_oid(object), result);
 	return 0;
diff -puN fs/reiser4/plugin/file_plugin_common.c~reiser4-handling-error-returned-by-d_obtain_alias-fixup fs/reiser4/plugin/file_plugin_common.c
--- a/fs/reiser4/plugin/file_plugin_common.c~reiser4-handling-error-returned-by-d_obtain_alias-fixup
+++ a/fs/reiser4/plugin/file_plugin_common.c
@@ -476,10 +476,7 @@ struct dentry *wire_get_common(struct su
 	if (!IS_ERR(inode)) {
 		reiser4_iget_complete(inode);
 		dentry = d_obtain_alias(inode);
-		if (dentry == NULL) {
-			iput(inode);
-			dentry = ERR_PTR(-ENOMEM);
-		} else
+		if (!IS_ERR(dentry))
 			dentry->d_op = &get_super_private(sb)->ops.dentry;
 	} else if (PTR_ERR(inode) == -ENOENT)
 		/*
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-improve-writeback_inodes_wb.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
reiser4-update-names-of-quota-methods.patch
reiser4-use-set_page_dirty_notag.patch
fs-reiser4-add-parenths-around-x-y.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-rename-psched-to-dispatch.patch
reiser4-drop-journal-info.patch
reiser4-fix-compile-warnings.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup.patch
reiser4-some-changes-from-reiser4-2631-patch.patch
reiser4-some-comments-were-still-mentioning-pdflush.patch
reiser4-writeback_inodes-implementation.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch

