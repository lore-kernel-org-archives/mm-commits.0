Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74BEFBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645193; cv=none; b=aISnjSPu6usMhalz/OAbazdfm/nJRKooUpI6ls3eouFrEy4g1z04NJjk1R2PqVS+g3wz1viBkocoD/8ZsGSx6i9R7XRfwzU81ReMQ394bXMKXNhLg5aAQepGChqgMWz9hsElmTSuU9lxf7Xco70MvZVNDz46bgq9F5kf6P6IeqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645193; c=relaxed/simple;
	bh=0Jxxp5Db2ekW01gbQ3f3imEWYmlEzfhyLIN+yq/9CLE=;
	h=Date:To:From:Subject:Message-Id; b=mmsDgErRmhqb4NlVL0FUo+faiBITPG+2hvku7H+FIX+TytU6y2qZkWzA7ktbXxn6W9KWaghgWaZf5LS/BqLTEVSpcK1JYWWrAbdSMey0iHcwQgonYceTPbqwAbUEE25pu+1woO9H1KRIgp5KbekPvlCw9zGAM+6GSNvVTv90HlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=THvSpSH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="THvSpSH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F67C43399;
	Thu, 22 Feb 2024 23:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645192;
	bh=0Jxxp5Db2ekW01gbQ3f3imEWYmlEzfhyLIN+yq/9CLE=;
	h=Date:To:From:Subject:From;
	b=THvSpSH3Qj4OZuccl/V/yaBP54tTzimknVFLyk15bbYBn38MmT05sW/aGtzxkujKU
	 a6nKx3XzZiy5+x9orWK8tDPt3sdIi8QlyJd9DRg63VBAinL1SahpEESw2eXUd0G5Dr
	 26GXzn4sW1dEnt3LYTx8FhhtM7qndSw4VWX4Cq3I=
Date: Thu, 22 Feb 2024 15:39:51 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-convert-dat-to-use-kmap_local.patch removed from -mm tree
Message-Id: <20240222233952.57F67C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert DAT to use kmap_local
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-dat-to-use-kmap_local.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert DAT to use kmap_local
Date: Mon, 22 Jan 2024 23:01:54 +0900

Concerning the code of the metadata file DAT for disk address translation,
convert all parts that use the deprecated kmap_atomic to use kmap_local. 
All transformations are directly possible.

Link: https://lkml.kernel.org/r/20240122140202.6950-8-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dat.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/fs/nilfs2/dat.c~nilfs2-convert-dat-to-use-kmap_local
+++ a/fs/nilfs2/dat.c
@@ -91,13 +91,13 @@ void nilfs_dat_commit_alloc(struct inode
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MAX);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	nilfs_palloc_commit_alloc_entry(dat, req);
 	nilfs_dat_commit_entry(dat, req);
@@ -115,13 +115,13 @@ static void nilfs_dat_commit_free(struct
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
 
@@ -145,12 +145,12 @@ void nilfs_dat_commit_start(struct inode
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(nilfs_mdt_cno(dat));
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
 }
@@ -167,12 +167,12 @@ int nilfs_dat_prepare_end(struct inode *
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	if (blocknr == 0) {
 		ret = nilfs_palloc_prepare_free_entry(dat, req);
@@ -202,7 +202,7 @@ void nilfs_dat_commit_end(struct inode *
 	sector_t blocknr;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	end = start = le64_to_cpu(entry->de_start);
@@ -212,7 +212,7 @@ void nilfs_dat_commit_end(struct inode *
 	}
 	entry->de_end = cpu_to_le64(end);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	if (blocknr == 0)
 		nilfs_dat_commit_free(dat, req);
@@ -227,12 +227,12 @@ void nilfs_dat_abort_end(struct inode *d
 	sector_t blocknr;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	if (start == nilfs_mdt_cno(dat) && blocknr == 0)
 		nilfs_palloc_abort_free_entry(dat, req);
@@ -362,7 +362,7 @@ int nilfs_dat_move(struct inode *dat, __
 		}
 	}
 
-	kaddr = kmap_atomic(entry_bh->b_page);
+	kaddr = kmap_local_page(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	if (unlikely(entry->de_blocknr == cpu_to_le64(0))) {
 		nilfs_crit(dat->i_sb,
@@ -370,13 +370,13 @@ int nilfs_dat_move(struct inode *dat, __
 			   __func__, (unsigned long long)vblocknr,
 			   (unsigned long long)le64_to_cpu(entry->de_start),
 			   (unsigned long long)le64_to_cpu(entry->de_end));
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		brelse(entry_bh);
 		return -EINVAL;
 	}
 	WARN_ON(blocknr == 0);
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	mark_buffer_dirty(entry_bh);
 	nilfs_mdt_mark_dirty(dat);
@@ -426,7 +426,7 @@ int nilfs_dat_translate(struct inode *da
 		}
 	}
 
-	kaddr = kmap_atomic(entry_bh->b_page);
+	kaddr = kmap_local_page(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	blocknr = le64_to_cpu(entry->de_blocknr);
 	if (blocknr == 0) {
@@ -436,7 +436,7 @@ int nilfs_dat_translate(struct inode *da
 	*blocknrp = blocknr;
 
  out:
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	brelse(entry_bh);
 	return ret;
 }
@@ -457,7 +457,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode
 						   0, &entry_bh);
 		if (ret < 0)
 			return ret;
-		kaddr = kmap_atomic(entry_bh->b_page);
+		kaddr = kmap_local_page(entry_bh->b_page);
 		/* last virtual block number in this block */
 		first = vinfo->vi_vblocknr;
 		do_div(first, entries_per_block);
@@ -473,7 +473,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode
 			vinfo->vi_end = le64_to_cpu(entry->de_end);
 			vinfo->vi_blocknr = le64_to_cpu(entry->de_blocknr);
 		}
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		brelse(entry_bh);
 	}
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


