From: akpm@linux-foundation.org
Subject: - ext3-ext4-orphan-list-corruption-due-bad-inode.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:01 -0700
Message-ID: <200707162056.l6GKu1JI002002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758560AbXGPVK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@sw.ru, mm-commits@vger.kernel.org


The patch titled
     ext3/ext4: orphan list corruption due bad inode
has been removed from the -mm tree.  Its filename was
     ext3-ext4-orphan-list-corruption-due-bad-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3/ext4: orphan list corruption due bad inode
From: Vasily Averin <vvs@sw.ru>

After ext3 orphan list check has been added into ext3_destroy_inode()
(please see my previous patch) the following situation has been detected:

 EXT3-fs warning (device sda6): ext3_unlink: Deleting nonexistent file (37901290), 0
 Inode 00000101a15b7840: orphan list check failed!
 00000773 6f665f00 74616d72 00000573 65725f00 06737270 66000000 616d726f
...
 Call Trace: [<ffffffff80211ea9>] ext3_destroy_inode+0x79/0x90
  [<ffffffff801a2b16>] sys_unlink+0x126/0x1a0
  [<ffffffff80111479>] error_exit+0x0/0x81
  [<ffffffff80110aba>] system_call+0x7e/0x83

First messages said that unlinked inode has i_nlink=0, then ext3_unlink()
adds this inode into orphan list.

Second message means that this inode has not been removed from orphan list.
 Inode dump has showed that i_fop = &bad_file_ops and it can be set in
make_bad_inode() only.  Then I've found that ext3_read_inode() can call
make_bad_inode() without any error/warning messages, for example in the
following case:

...
        if (inode->i_nlink == 0) {
                if (inode->i_mode == 0 ||
                    !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS)) {
                        /* this inode is deleted */
                        brelse (bh);
                        goto bad_inode;
...

Bad inode can live some time, ext3_unlink can add it to orphan list, but
ext3_delete_inode() do not deleted this inode from orphan list.  As result
we can have orphan list corruption detected in ext3_destroy_inode().

However it is not clear for me how to fix this issue correctly.

As far as i see is_bad_inode() is called after iget() in all places
excluding ext3_lookup() and ext3_get_parent().  I believe it makes sense to
add bad inode check to these functions too and call iput if bad inode
detected.

Signed-off-by:	Vasily Averin <vvs@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |   10 ++++++++++
 fs/ext4/namei.c |   10 ++++++++++
 2 files changed, 20 insertions(+)

diff -puN fs/ext3/namei.c~ext3-ext4-orphan-list-corruption-due-bad-inode fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-ext4-orphan-list-corruption-due-bad-inode
+++ a/fs/ext3/namei.c
@@ -1019,6 +1019,11 @@ static struct dentry *ext3_lookup(struct
 
 		if (!inode)
 			return ERR_PTR(-EACCES);
+
+		if (is_bad_inode(inode)) {
+			iput(inode);
+			return ERR_PTR(-ENOENT);
+		}
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -1054,6 +1059,11 @@ struct dentry *ext3_get_parent(struct de
 	if (!inode)
 		return ERR_PTR(-EACCES);
 
+	if (is_bad_inode(inode)) {
+		iput(inode);
+		return ERR_PTR(-ENOENT);
+	}
+
 	parent = d_alloc_anon(inode);
 	if (!parent) {
 		iput(inode);
diff -puN fs/ext4/namei.c~ext3-ext4-orphan-list-corruption-due-bad-inode fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext3-ext4-orphan-list-corruption-due-bad-inode
+++ a/fs/ext4/namei.c
@@ -1017,6 +1017,11 @@ static struct dentry *ext4_lookup(struct
 
 		if (!inode)
 			return ERR_PTR(-EACCES);
+
+		if (is_bad_inode(inode)) {
+			iput(inode);
+			return ERR_PTR(-ENOENT);
+		}
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -1052,6 +1057,11 @@ struct dentry *ext4_get_parent(struct de
 	if (!inode)
 		return ERR_PTR(-EACCES);
 
+	if (is_bad_inode(inode)) {
+		iput(inode);
+		return ERR_PTR(-ENOENT);
+	}
+
 	parent = d_alloc_anon(inode);
 	if (!parent) {
 		iput(inode);
_

Patches currently in -mm which might be from vvs@sw.ru are

origin.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
