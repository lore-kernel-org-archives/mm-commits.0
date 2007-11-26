From: akpm@linux-foundation.org
Subject: - revoke-support-for-ext2-and-ext3.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:36:17 -0800
Message-ID: <200711261936.lAQJaHI6019291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34023 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192AbXKZTg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:36:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     revoke: support for ext2 and ext3 and ext4
has been removed from the -mm tree.  Its filename was
     revoke-support-for-ext2-and-ext3.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: revoke: support for ext2 and ext3 and ext4
From: Pekka Enberg <penberg@cs.helsinki.fi>

Add revoke support to ext2, ext3 and ext4 by wiring f_ops->revoke with
generic_file_revoke.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/file.c |    1 +
 fs/ext3/file.c |    1 +
 fs/ext4/file.c |    1 +
 3 files changed, 3 insertions(+)

diff -puN fs/ext2/file.c~revoke-support-for-ext2-and-ext3 fs/ext2/file.c
--- a/fs/ext2/file.c~revoke-support-for-ext2-and-ext3
+++ a/fs/ext2/file.c
@@ -58,6 +58,7 @@ const struct file_operations ext2_file_o
 	.fsync		= ext2_sync_file,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke		= generic_file_revoke,
 };
 
 #ifdef CONFIG_EXT2_FS_XIP
diff -puN fs/ext3/file.c~revoke-support-for-ext2-and-ext3 fs/ext3/file.c
--- a/fs/ext3/file.c~revoke-support-for-ext2-and-ext3
+++ a/fs/ext3/file.c
@@ -122,6 +122,7 @@ const struct file_operations ext3_file_o
 	.fsync		= ext3_sync_file,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke         = generic_file_revoke,
 };
 
 const struct inode_operations ext3_file_inode_operations = {
diff -puN fs/ext4/file.c~revoke-support-for-ext2-and-ext3 fs/ext4/file.c
--- a/fs/ext4/file.c~revoke-support-for-ext2-and-ext3
+++ a/fs/ext4/file.c
@@ -122,6 +122,7 @@ const struct file_operations ext4_file_o
 	.fsync		= ext4_sync_file,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke         = generic_file_revoke,
 };
 
 const struct inode_operations ext4_file_inode_operations = {
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

git-unionfs.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-restructure-slab-alloc.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
slab-leaks3-default-y.patch
