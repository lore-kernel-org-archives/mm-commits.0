From: akpm@linux-foundation.org
Subject: - dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:41 -0700
Message-ID: <200709202115.l8KLFfTt002930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbXITV3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, duaneg@dghda.com, stable@kernel.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     dir_index: error out instead of BUG on corrupt dx dirs
has been removed from the -mm tree.  Its filename was
     dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dir_index: error out instead of BUG on corrupt dx dirs
From: Eric Sandeen <sandeen@redhat.com>

Convert asserts (BUGs) in dx_probe from bad on-disk data to recoverable
errors with helpful warnings.  With help catching other asserts from Duane
Griffin <duaneg@dghda.com>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |   34 ++++++++++++++++++++++++++++++----
 fs/ext4/namei.c |   34 ++++++++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 8 deletions(-)

diff -puN fs/ext3/namei.c~dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs fs/ext3/namei.c
--- a/fs/ext3/namei.c~dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs
+++ a/fs/ext3/namei.c
@@ -379,13 +379,28 @@ dx_probe(struct dentry *dentry, struct i
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "dx entry: limit != root limit");
+		brelse(bh);
+		*err = ERR_BAD_DX_DIR;
+		goto fail;
+	}
+
 	dxtrace (printk("Look up %x", hash));
 	while (1)
 	{
 		count = dx_get_count(entries);
-		assert (count && count <= dx_get_limit(entries));
+		if (!count || count > dx_get_limit(entries)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: no count or count > limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -423,8 +438,15 @@ dx_probe(struct dentry *dentry, struct i
 		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: limit != node limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
@@ -432,6 +454,10 @@ fail2:
 		frame--;
 	}
 fail:
+	if (*err == ERR_BAD_DX_DIR)
+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt dir inode %ld, running e2fsck is "
+			     "recommended.", dir->i_ino);
 	return NULL;
 }
 
diff -puN fs/ext4/namei.c~dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs fs/ext4/namei.c
--- a/fs/ext4/namei.c~dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs
+++ a/fs/ext4/namei.c
@@ -379,13 +379,28 @@ dx_probe(struct dentry *dentry, struct i
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext4_warning(dir->i_sb, __FUNCTION__,
+			     "dx entry: limit != root limit");
+		brelse(bh);
+		*err = ERR_BAD_DX_DIR;
+		goto fail;
+	}
+
 	dxtrace (printk("Look up %x", hash));
 	while (1)
 	{
 		count = dx_get_count(entries);
-		assert (count && count <= dx_get_limit(entries));
+		if (!count || count > dx_get_limit(entries)) {
+			ext4_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: no count or count > limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -423,8 +438,15 @@ dx_probe(struct dentry *dentry, struct i
 		if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext4_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: limit != node limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
@@ -432,6 +454,10 @@ fail2:
 		frame--;
 	}
 fail:
+	if (*err == ERR_BAD_DX_DIR)
+		ext4_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt dir inode %ld, running e2fsck is "
+			     "recommended.", dir->i_ino);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from sandeen@redhat.com are

remove-unused-bh-in-calls-to-ext234_get_group_desc.patch
limit-minixfs-printks-on-corrupted-dir-i_size.patch
