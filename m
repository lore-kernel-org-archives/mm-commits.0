Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C3413BAF8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645195; cv=none; b=dLr2Yd6gD8E5Gs3KaQ8avW4JszJdh8TY6u6mT3mtZrVApr0ZrysE0SIcE8r1z3jHx091TI8Iv2BPPUKG3Edto2IFZEeXc8Juo4QdPBEikUjZu87B822ouRkuoaH7icrcTkS/S8a7YgrQEPUIBIGiLEu+Nn3CLbNC7sRVZHVHmEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645195; c=relaxed/simple;
	bh=9AE5hECSztOcBsZZf5U8J5LBSxHhK8lEQi+2l/XxuFA=;
	h=Date:To:From:Subject:Message-Id; b=qje8Cb1aLE5qpGlM5SZPwNSjHJ3h+KhOk0NpYwVxkI3YovFDhHrtN3w4GYb40yLT/jBhSzxhQCDeXEdPNc/5PA6DrifSmQDk8lsS0s53bFtgO/529An4vzcN3QKwXCyTdY6PFnBw+wgLQnfhhkCRHFa6o5vi/l4FCc+gah7Wmn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=edQij1tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="edQij1tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D094BC433C7;
	Thu, 22 Feb 2024 23:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645194;
	bh=9AE5hECSztOcBsZZf5U8J5LBSxHhK8lEQi+2l/XxuFA=;
	h=Date:To:From:Subject:From;
	b=edQij1tbREj/LDbeB/8w8J6ZRHevo0e+LOQy1eT5lz78h/Obc1IIPAWTLv2ApGlbA
	 Pm5cQ7pTwqv31SYl2OI8Ex4t1HFt2UH9Dlt8avq9/GmVtA1v+FTrveBOWmhMvo1ZJL
	 EJedPUrZCbWFLa/+u/TXtQo/c+ung6HF0XrY066Q=
Date: Thu, 22 Feb 2024 15:39:54 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-convert-ifile-to-use-kmap_local.patch removed from -mm tree
Message-Id: <20240222233954.D094BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert ifile to use kmap_local
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-ifile-to-use-kmap_local.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


