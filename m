Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED3578F51;
	Thu, 19 Dec 2024 03:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577538; cv=none; b=PhsNgHIw4LsAX3Pvvi6et5xzegJey4Q0+/YKd6GqooaKom6u49mMTI/teEgTtlGcahEI5ntgAPpsJygIFFMCxD9VIep8Z8gjpIoVUVZv7HoODSZi5T3+rW1NN9JpdohncqQryY7cV8DRhLbli7LP9XoOVUsjoOVa+Or7VRSk1cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577538; c=relaxed/simple;
	bh=k2g7RQLAhSkL+pnTvBS7UIeSqSVxSZyofD0waq5JV7A=;
	h=Date:To:From:Subject:Message-Id; b=jUaCPNGVAHHHzsUIv1+UVQyUIV9tgmWpHmRAq05upZVGn42ULjUTW+U0LUxGA8Udxkk/gXHDq3slJp72Q3mGxlnBnIK/jkzZ5R4KQHZnE+tMS2vu1IgJ2FOUpXOwl+fMuPOLzavjXOE+/ATp9bKg4v4MXr7ANmm0W5TtUSv+7Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PzZkw2Wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PzZkw2Wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D2AC4CECD;
	Thu, 19 Dec 2024 03:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577537;
	bh=k2g7RQLAhSkL+pnTvBS7UIeSqSVxSZyofD0waq5JV7A=;
	h=Date:To:From:Subject:From;
	b=PzZkw2WgFNvMsPTwRNeJK+liYM36mm/FRD9AVRoSV1Yf1FKtzieueH8YYoE3T+DVY
	 NBO1a8Lcmx7oubyX3oxXTYIPfKT16evKcVM5MMSzhTGQ1N3T+lCQCSQKw0EWxWTkLX
	 /QIMZyZsEn2ifK8ymg0mFX9rR17SCOBNijzzCsjw=
Date: Wed, 18 Dec 2024 19:05:36 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages.patch removed from -mm tree
Message-Id: <20241219030537.74D2AC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix buffer head leaks in calls to truncate_inode_pages()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix buffer head leaks in calls to truncate_inode_pages()
Date: Fri, 13 Dec 2024 01:43:28 +0900

When block_invalidatepage was converted to block_invalidate_folio, the
fallback to block_invalidatepage in folio_invalidate() if the
address_space_operations method invalidatepage (currently
invalidate_folio) was not set, was removed.

Unfortunately, some pseudo-inodes in nilfs2 use empty_aops set by
inode_init_always_gfp() as is, or explicitly set it to
address_space_operations.  Therefore, with this change,
block_invalidatepage() is no longer called from folio_invalidate(), and as
a result, the buffer_head structures attached to these pages/folios are no
longer freed via try_to_free_buffers().

Thus, these buffer heads are now leaked by truncate_inode_pages(), which
cleans up the page cache from inode evict(), etc.

Three types of caches use empty_aops: gc inode caches and the DAT shadow
inode used by GC, and b-tree node caches.  Of these, b-tree node caches
explicitly call invalidate_mapping_pages() during cleanup, which involves
calling try_to_free_buffers(), so the leak was not visible during normal
operation but worsened when GC was performed.

Fix this issue by using address_space_operations with invalidate_folio set
to block_invalidate_folio instead of empty_aops, which will ensure the
same behavior as before.

Link: https://lkml.kernel.org/r/20241212164556.21338-1-konishi.ryusuke@gmail.com
Fixes: 7ba13abbd31e ("fs: Turn block_invalidatepage into block_invalidate_folio")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c  |    1 +
 fs/nilfs2/gcinode.c |    2 +-
 fs/nilfs2/inode.c   |    5 +++++
 fs/nilfs2/nilfs.h   |    1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/btnode.c~nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages
+++ a/fs/nilfs2/btnode.c
@@ -35,6 +35,7 @@ void nilfs_init_btnc_inode(struct inode
 	ii->i_flags = 0;
 	memset(&ii->i_bmap_data, 0, sizeof(struct nilfs_bmap));
 	mapping_set_gfp_mask(btnc_inode->i_mapping, GFP_NOFS);
+	btnc_inode->i_mapping->a_ops = &nilfs_buffer_cache_aops;
 }
 
 void nilfs_btnode_cache_clear(struct address_space *btnc)
--- a/fs/nilfs2/gcinode.c~nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages
+++ a/fs/nilfs2/gcinode.c
@@ -163,7 +163,7 @@ int nilfs_init_gcinode(struct inode *ino
 
 	inode->i_mode = S_IFREG;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
-	inode->i_mapping->a_ops = &empty_aops;
+	inode->i_mapping->a_ops = &nilfs_buffer_cache_aops;
 
 	ii->i_flags = 0;
 	nilfs_bmap_init_gc(ii->i_bmap);
--- a/fs/nilfs2/inode.c~nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages
+++ a/fs/nilfs2/inode.c
@@ -276,6 +276,10 @@ const struct address_space_operations ni
 	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
+const struct address_space_operations nilfs_buffer_cache_aops = {
+	.invalidate_folio	= block_invalidate_folio,
+};
+
 static int nilfs_insert_inode_locked(struct inode *inode,
 				     struct nilfs_root *root,
 				     unsigned long ino)
@@ -681,6 +685,7 @@ struct inode *nilfs_iget_for_shadow(stru
 	NILFS_I(s_inode)->i_flags = 0;
 	memset(NILFS_I(s_inode)->i_bmap, 0, sizeof(struct nilfs_bmap));
 	mapping_set_gfp_mask(s_inode->i_mapping, GFP_NOFS);
+	s_inode->i_mapping->a_ops = &nilfs_buffer_cache_aops;
 
 	err = nilfs_attach_btree_node_cache(s_inode);
 	if (unlikely(err)) {
--- a/fs/nilfs2/nilfs.h~nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages
+++ a/fs/nilfs2/nilfs.h
@@ -401,6 +401,7 @@ extern const struct file_operations nilf
 extern const struct inode_operations nilfs_file_inode_operations;
 extern const struct file_operations nilfs_file_operations;
 extern const struct address_space_operations nilfs_aops;
+extern const struct address_space_operations nilfs_buffer_cache_aops;
 extern const struct inode_operations nilfs_dir_inode_operations;
 extern const struct inode_operations nilfs_special_inode_operations;
 extern const struct inode_operations nilfs_symlink_inode_operations;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


