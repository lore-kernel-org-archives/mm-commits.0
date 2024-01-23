Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF5853E0F
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970580; cv=none; b=VghuiDEiy8PSCM+mjWCV258Y/QAEIPxKhsPycPzVcCbHReZIV0i45ARU3Naht8iGe5FFwKnsL9SYHWCJmArbo0mTulby+hXsgy2mi95U+GA8mWqUlJBVaUPh+xUvnBpWPmhnIQRjk40MEIiQqxu05rPfkZjtu8Dbyw5K6MMOmOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970580; c=relaxed/simple;
	bh=ZXjfAs6T6rQZ0/0tOTbdZYSLfUl05v30528Z5YW6sQM=;
	h=Date:To:From:Subject:Message-Id; b=CPJ7XTCFxN9/XcHZV5Qoe95biQ3iroIVEpzZPRIYqSteM4ezRVy+cAylDsCbVt3ksGjD1Dw6kPlrGjNL8JTkt5tdVffIehT7zJknELNY5igSkcTsLXNg+VDW2/mKmetAZ0PXyjfOKjZ9sgZ+zfZtCGRt5kKlrQdxSAHbUiheBlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ya8OM3/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ya8OM3/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DDDC43390;
	Tue, 23 Jan 2024 00:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970580;
	bh=ZXjfAs6T6rQZ0/0tOTbdZYSLfUl05v30528Z5YW6sQM=;
	h=Date:To:From:Subject:From;
	b=Ya8OM3/w5Xh6JwNjpCqj2smUvzbWXSDq1UHZMU3W4p84Eev+0eYpXoZyB18SXr6MH
	 Fb4l/Gf2HOWSF6CxORx2LUNtLSh6WsYL+l17jZYsK1rLIQD6QQKIl/DMr9OqghrgwG
	 iUMvlgVxHXVyLWHXQZlZpaReUUYvpsaZpUhHuGs8=
Date: Mon, 22 Jan 2024 16:42:57 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-ifile-to-use-kmap_local.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004259.B7DDDC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert ifile to use kmap_local
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-ifile-to-use-kmap_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-ifile-to-use-kmap_local.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: nilfs2: convert ifile to use kmap_local
Date: Mon, 22 Jan 2024 23:01:57 +0900

Convert deprecated kmap() and kmap_atomic() to use kmap_local for the
ifile metadata file used to manage disk inodes.

In some usages, calls to kmap_local and kunmap_local are split into
different helpers, but those usages can be safely changed to local thread
kmap.

Link: https://lkml.kernel.org/r/20240122140202.6950-11-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ifile.c   |    4 ++--
 fs/nilfs2/ifile.h   |    7 +++----
 fs/nilfs2/inode.c   |    6 +++---
 fs/nilfs2/segment.c |    2 +-
 4 files changed, 9 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/ifile.c~nilfs2-convert-ifile-to-use-kmap_local
+++ a/fs/nilfs2/ifile.c
@@ -115,11 +115,11 @@ int nilfs_ifile_delete_inode(struct inod
 		return ret;
 	}
 
-	kaddr = kmap_atomic(req.pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req.pr_entry_bh->b_page);
 	raw_inode = nilfs_palloc_block_get_entry(ifile, req.pr_entry_nr,
 						 req.pr_entry_bh, kaddr);
 	raw_inode->i_flags = 0;
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	mark_buffer_dirty(req.pr_entry_bh);
 	brelse(req.pr_entry_bh);
--- a/fs/nilfs2/ifile.h~nilfs2-convert-ifile-to-use-kmap_local
+++ a/fs/nilfs2/ifile.h
@@ -21,15 +21,14 @@
 static inline struct nilfs_inode *
 nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
 {
-	void *kaddr = kmap(ibh->b_page);
+	void *kaddr = kmap_local_page(ibh->b_page);
 
 	return nilfs_palloc_block_get_entry(ifile, ino, ibh, kaddr);
 }
 
-static inline void nilfs_ifile_unmap_inode(struct inode *ifile, ino_t ino,
-					   struct buffer_head *ibh)
+static inline void nilfs_ifile_unmap_inode(struct nilfs_inode *raw_inode)
 {
-	kunmap(ibh->b_page);
+	kunmap_local(raw_inode);
 }
 
 int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
--- a/fs/nilfs2/inode.c~nilfs2-convert-ifile-to-use-kmap_local
+++ a/fs/nilfs2/inode.c
@@ -520,7 +520,7 @@ static int __nilfs_read_inode(struct sup
 			inode, inode->i_mode,
 			huge_decode_dev(le64_to_cpu(raw_inode->i_device_code)));
 	}
-	nilfs_ifile_unmap_inode(root->ifile, ino, bh);
+	nilfs_ifile_unmap_inode(raw_inode);
 	brelse(bh);
 	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	nilfs_set_inode_flags(inode);
@@ -529,7 +529,7 @@ static int __nilfs_read_inode(struct sup
 	return 0;
 
  failed_unmap:
-	nilfs_ifile_unmap_inode(root->ifile, ino, bh);
+	nilfs_ifile_unmap_inode(raw_inode);
 	brelse(bh);
 
  bad_inode:
@@ -814,7 +814,7 @@ void nilfs_update_inode(struct inode *in
 		raw_inode->i_device_code =
 			cpu_to_le64(huge_encode_dev(inode->i_rdev));
 
-	nilfs_ifile_unmap_inode(ifile, ino, ibh);
+	nilfs_ifile_unmap_inode(raw_inode);
 }
 
 #define NILFS_MAX_TRUNCATE_BLOCKS	16384  /* 64MB for 4KB block */
--- a/fs/nilfs2/segment.c~nilfs2-convert-ifile-to-use-kmap_local
+++ a/fs/nilfs2/segment.c
@@ -966,7 +966,7 @@ static void nilfs_fill_in_file_bmap(stru
 		raw_inode = nilfs_ifile_map_inode(ifile, ii->vfs_inode.i_ino,
 						  ibh);
 		nilfs_bmap_write(ii->i_bmap, raw_inode);
-		nilfs_ifile_unmap_inode(ifile, ii->vfs_inode.i_ino, ibh);
+		nilfs_ifile_unmap_inode(raw_inode);
 	}
 }
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-recovery-logic-to-use-kmap_local.patch
nilfs2-convert-segment-buffer-to-use-kmap_local.patch
nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch
nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch
nilfs2-convert-sufile-to-use-kmap_local.patch
nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch
nilfs2-convert-dat-to-use-kmap_local.patch
nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch
nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch
nilfs2-convert-ifile-to-use-kmap_local.patch
nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch
nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch
nilfs2-convert-cpfile-to-use-kmap_local.patch

