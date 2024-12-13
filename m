Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6C33207;
	Fri, 13 Dec 2024 01:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053118; cv=none; b=LkAMZGS4uRsGQVLwrxsSf5CDvITqfla0f/EcDIy2VIuOj60ibFkiRCNOF64uL+eDo30E1742l8N5BOT85TkHQ3Fp0qoCEXHOwTA+qbVDf3OT44RJ1+2/je7sVeLMGNt/OwlZCVvg+FBZxOzQmPpDCF2Ft1nSm8QwuTbXook1k+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053118; c=relaxed/simple;
	bh=cRlCO9f7lHG7C2rScbkQBdn7Kn1aj/JsxObtAB7TETs=;
	h=Date:To:From:Subject:Message-Id; b=dlb5oPr7AiofF4aXWTr3yKBOemz3vagcVstAjYd779TNqslNGNR5BrtzqI3iclswoKcbkCvcc7j8JUe/lZ81b3ah5TsKw/gtkQDFP0FkXc4CcfFLFLLC3zyZWI43zqNCWS4HJPJhVy7cdjPa1vr+bMUCIODPEBGkeqX+rdc31zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kzlOvs9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kzlOvs9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976C9C4CECE;
	Fri, 13 Dec 2024 01:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734053117;
	bh=cRlCO9f7lHG7C2rScbkQBdn7Kn1aj/JsxObtAB7TETs=;
	h=Date:To:From:Subject:From;
	b=kzlOvs9FvHfL+BegAxaGjw41ee975ehKpVzjZfVpvDH2XTaiVOchacHR8u+Cy28tq
	 LeBfvY0ZLtOfEas7hoN2nQaHioTFvNjf0ln457nJ0ESGLWzFVOJAAUWBcN27Fw3kdQ
	 eFDybET+yBU/Y7/OoouPSYVID5ZxQb2YHiSeMGLQ=
Date: Thu, 12 Dec 2024 17:25:16 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20241213012517.976C9C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix buffer head leaks in calls to truncate_inode_pages()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

nilfs2-fix-buffer-head-leaks-in-calls-to-truncate_inode_pages.patch

