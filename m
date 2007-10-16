From: akpm@linux-foundation.org
Subject: - reiserfs-use-generic_cont_expand_simple.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:01 -0700
Message-ID: <200710162033.l9GKX1B1014672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966051AbXJPVqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:46:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     reiserfs: use generic_cont_expand_simple
has been removed from the -mm tree.  Its filename was
     reiserfs-use-generic_cont_expand_simple.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: use generic_cont_expand_simple
From: Vladimir Saveliev <vs@namesys.com>

This patch makes reiserfs to use AOP_FLAG_CONT_EXPAND
in order to get rid of the special generic_cont_expand routine

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/inode.c~reiserfs-use-generic_cont_expand_simple fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-use-generic_cont_expand_simple
+++ a/fs/reiserfs/inode.c
@@ -2562,13 +2562,20 @@ static int reiserfs_write_begin(struct f
 	int ret;
 	int old_ref = 0;
 
+ 	inode = mapping->host;
+	*fsdata = 0;
+ 	if (flags & AOP_FLAG_CONT_EXPAND &&
+ 	    (pos & (inode->i_sb->s_blocksize - 1)) == 0) {
+ 		pos ++;
+		*fsdata = (void *)(unsigned long)flags;
+	}
+
 	index = pos >> PAGE_CACHE_SHIFT;
 	page = __grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
 	*pagep = page;
 
-	inode = mapping->host;
 	reiserfs_wait_on_write_block(inode->i_sb);
 	fix_tail_page_for_writing(page);
 	if (reiserfs_transaction_running(inode->i_sb)) {
@@ -2678,6 +2685,8 @@ static int reiserfs_write_end(struct fil
 	struct reiserfs_transaction_handle *th;
 	unsigned start;
 
+	if ((unsigned long)fsdata & AOP_FLAG_CONT_EXPAND)
+		pos ++;
 
 	reiserfs_wait_on_write_block(inode->i_sb);
 	if (reiserfs_transaction_running(inode->i_sb))
@@ -3065,7 +3074,7 @@ int reiserfs_setattr(struct dentry *dent
 		}
 		/* fill in hole pointers in the expanding truncate case. */
 		if (attr->ia_size > inode->i_size) {
-			error = generic_cont_expand(inode, attr->ia_size);
+			error = generic_cont_expand_simple(inode, attr->ia_size);
 			if (REISERFS_I(inode)->i_prealloc_count > 0) {
 				int err;
 				struct reiserfs_transaction_handle th;
_

Patches currently in -mm which might be from vs@namesys.com are

origin.patch
fs-reiserfs-cleanups.patch
try-to-reap-reiserfs-pages-left-around-by-invalidatepage.patch
reiserfs-fix-kernel-panic-on-corrupted-directory.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
make-reiserfs-stop-using-struct-file-for-internal.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate.patch
reiser4-fix-readpage_unix_file.patch
reiser4-fix-for-new-aops-patches.patch
reiser4-do-not-allocate-struct-file-on-stack.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
reiser4-cryptcompress-misc-fixups-2.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
reiser4-change-error-code-base.patch
reiser4-use-lzo-library-functions.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
git-nfsd-broke-reiser4.patch
