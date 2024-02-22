Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8B2137928
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645191; cv=none; b=GyH3yLG+NSK9+8bBXj7HfRdxPeXQ/ooOyK30vvoiyzdrMmnEMBEVC3VTsFjrRBLsrrNu15jjpniXutnuFS4GYqVLVJZJeXOER+UUrVt4rwZGcWVoieaXAhsgSl4XJMAlMopH9fxUnG7/WyOOVv02BBY9oso+Ief2PscYQkmCp6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645191; c=relaxed/simple;
	bh=gev2L8v7WSXhuqKE2Ic5khli4mlZTc4TxPfe0dPBiXY=;
	h=Date:To:From:Subject:Message-Id; b=ioE4nN45meo4ZKyf7hZ4lb6N2CMMZeh85HFljw27EcbdeEHViINYBB3EWBOBPy8xtkUdusV1EFXt/p1O839gI/4Oa11yN9qL3RN9RoX6qolrt1zUKzo1clNpSonEI+g1RV5qCYYM5bQYe2GbSJLO20IfvHpVwYrPwEuiCg5FwsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T8EkQj6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T8EkQj6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE4EC43390;
	Thu, 22 Feb 2024 23:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645190;
	bh=gev2L8v7WSXhuqKE2Ic5khli4mlZTc4TxPfe0dPBiXY=;
	h=Date:To:From:Subject:From;
	b=T8EkQj6JIjOAxy+U4kPQKI0mXkLOHUYEvkSk24CWYBqW5/zpRC8gLFasryNV6q6X1
	 X06z8pZYywzQxdNVtxVh4/So+58vXxADzIM995FNSx+m5K+w4FNDdsE30oCKSFLI1h
	 hjArpiiR+e2hI17nz5FCvXHfx4LZ+p2SjL3LRstM=
Date: Thu, 22 Feb 2024 15:39:50 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-convert-sufile-to-use-kmap_local.patch removed from -mm tree
Message-Id: <20240222233950.7DE4EC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert sufile to use kmap_local
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-sufile-to-use-kmap_local.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert sufile to use kmap_local
Date: Mon, 22 Jan 2024 23:01:52 +0900

Concerning the code of the metadata file sufile for segment management,
convert all parts that uses the deprecated kmap_atomic() to use
kmap_local.  All transformations are directly possible here.

Link: https://lkml.kernel.org/r/20240122140202.6950-6-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |   86 +++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

--- a/fs/nilfs2/sufile.c~nilfs2-convert-sufile-to-use-kmap_local
+++ a/fs/nilfs2/sufile.c
@@ -107,11 +107,11 @@ static void nilfs_sufile_mod_counter(str
 	struct nilfs_sufile_header *header;
 	void *kaddr;
 
-	kaddr = kmap_atomic(header_bh->b_page);
+	kaddr = kmap_local_page(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	le64_add_cpu(&header->sh_ncleansegs, ncleanadd);
 	le64_add_cpu(&header->sh_ndirtysegs, ndirtyadd);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	mark_buffer_dirty(header_bh);
 }
@@ -315,10 +315,10 @@ int nilfs_sufile_alloc(struct inode *suf
 	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
 	if (ret < 0)
 		goto out_sem;
-	kaddr = kmap_atomic(header_bh->b_page);
+	kaddr = kmap_local_page(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	last_alloc = le64_to_cpu(header->sh_last_alloc);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	nsegments = nilfs_sufile_get_nsegments(sufile);
 	maxsegnum = sui->allocmax;
@@ -352,7 +352,7 @@ int nilfs_sufile_alloc(struct inode *suf
 							   &su_bh);
 		if (ret < 0)
 			goto out_header;
-		kaddr = kmap_atomic(su_bh->b_page);
+		kaddr = kmap_local_page(su_bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum, su_bh, kaddr);
 
@@ -363,14 +363,14 @@ int nilfs_sufile_alloc(struct inode *suf
 				continue;
 			/* found a clean segment */
 			nilfs_segment_usage_set_dirty(su);
-			kunmap_atomic(kaddr);
+			kunmap_local(kaddr);
 
-			kaddr = kmap_atomic(header_bh->b_page);
+			kaddr = kmap_local_page(header_bh->b_page);
 			header = kaddr + bh_offset(header_bh);
 			le64_add_cpu(&header->sh_ncleansegs, -1);
 			le64_add_cpu(&header->sh_ndirtysegs, 1);
 			header->sh_last_alloc = cpu_to_le64(segnum);
-			kunmap_atomic(kaddr);
+			kunmap_local(kaddr);
 
 			sui->ncleansegs--;
 			mark_buffer_dirty(header_bh);
@@ -384,7 +384,7 @@ int nilfs_sufile_alloc(struct inode *suf
 			goto out_header;
 		}
 
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		brelse(su_bh);
 	}
 
@@ -406,16 +406,16 @@ void nilfs_sufile_do_cancel_free(struct
 	struct nilfs_segment_usage *su;
 	void *kaddr;
 
-	kaddr = kmap_atomic(su_bh->b_page);
+	kaddr = kmap_local_page(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (unlikely(!nilfs_segment_usage_clean(su))) {
 		nilfs_warn(sufile->i_sb, "%s: segment %llu must be clean",
 			   __func__, (unsigned long long)segnum);
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		return;
 	}
 	nilfs_segment_usage_set_dirty(su);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	nilfs_sufile_mod_counter(header_bh, -1, 1);
 	NILFS_SUI(sufile)->ncleansegs--;
@@ -432,11 +432,11 @@ void nilfs_sufile_do_scrap(struct inode
 	void *kaddr;
 	int clean, dirty;
 
-	kaddr = kmap_atomic(su_bh->b_page);
+	kaddr = kmap_local_page(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (su->su_flags == cpu_to_le32(BIT(NILFS_SEGMENT_USAGE_DIRTY)) &&
 	    su->su_nblocks == cpu_to_le32(0)) {
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		return;
 	}
 	clean = nilfs_segment_usage_clean(su);
@@ -446,7 +446,7 @@ void nilfs_sufile_do_scrap(struct inode
 	su->su_lastmod = cpu_to_le64(0);
 	su->su_nblocks = cpu_to_le32(0);
 	su->su_flags = cpu_to_le32(BIT(NILFS_SEGMENT_USAGE_DIRTY));
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
 	NILFS_SUI(sufile)->ncleansegs -= clean;
@@ -463,12 +463,12 @@ void nilfs_sufile_do_free(struct inode *
 	void *kaddr;
 	int sudirty;
 
-	kaddr = kmap_atomic(su_bh->b_page);
+	kaddr = kmap_local_page(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_clean(su)) {
 		nilfs_warn(sufile->i_sb, "%s: segment %llu is already clean",
 			   __func__, (unsigned long long)segnum);
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		return;
 	}
 	if (unlikely(nilfs_segment_usage_error(su)))
@@ -481,7 +481,7 @@ void nilfs_sufile_do_free(struct inode *
 			   (unsigned long long)segnum);
 
 	nilfs_segment_usage_set_clean(su);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	mark_buffer_dirty(su_bh);
 
 	nilfs_sufile_mod_counter(header_bh, 1, sudirty ? (u64)-1 : 0);
@@ -509,12 +509,12 @@ int nilfs_sufile_mark_dirty(struct inode
 	if (ret)
 		goto out_sem;
 
-	kaddr = kmap_atomic(bh->b_page);
+	kaddr = kmap_local_page(bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
 	if (unlikely(nilfs_segment_usage_error(su))) {
 		struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
 
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		brelse(bh);
 		if (nilfs_segment_is_active(nilfs, segnum)) {
 			nilfs_error(sufile->i_sb,
@@ -532,7 +532,7 @@ int nilfs_sufile_mark_dirty(struct inode
 		ret = -EIO;
 	} else {
 		nilfs_segment_usage_set_dirty(su);
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		mark_buffer_dirty(bh);
 		nilfs_mdt_mark_dirty(sufile);
 		brelse(bh);
@@ -562,7 +562,7 @@ int nilfs_sufile_set_segment_usage(struc
 	if (ret < 0)
 		goto out_sem;
 
-	kaddr = kmap_atomic(bh->b_page);
+	kaddr = kmap_local_page(bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
 	if (modtime) {
 		/*
@@ -573,7 +573,7 @@ int nilfs_sufile_set_segment_usage(struc
 		su->su_lastmod = cpu_to_le64(modtime);
 	}
 	su->su_nblocks = cpu_to_le32(nblocks);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	mark_buffer_dirty(bh);
 	nilfs_mdt_mark_dirty(sufile);
@@ -614,7 +614,7 @@ int nilfs_sufile_get_stat(struct inode *
 	if (ret < 0)
 		goto out_sem;
 
-	kaddr = kmap_atomic(header_bh->b_page);
+	kaddr = kmap_local_page(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	sustat->ss_nsegs = nilfs_sufile_get_nsegments(sufile);
 	sustat->ss_ncleansegs = le64_to_cpu(header->sh_ncleansegs);
@@ -624,7 +624,7 @@ int nilfs_sufile_get_stat(struct inode *
 	spin_lock(&nilfs->ns_last_segment_lock);
 	sustat->ss_prot_seq = nilfs->ns_prot_seq;
 	spin_unlock(&nilfs->ns_last_segment_lock);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	brelse(header_bh);
 
  out_sem:
@@ -640,15 +640,15 @@ void nilfs_sufile_do_set_error(struct in
 	void *kaddr;
 	int suclean;
 
-	kaddr = kmap_atomic(su_bh->b_page);
+	kaddr = kmap_local_page(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_error(su)) {
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		return;
 	}
 	suclean = nilfs_segment_usage_clean(su);
 	nilfs_segment_usage_set_error(su);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	if (suclean) {
 		nilfs_sufile_mod_counter(header_bh, -1, 0);
@@ -717,7 +717,7 @@ static int nilfs_sufile_truncate_range(s
 			/* hole */
 			continue;
 		}
-		kaddr = kmap_atomic(su_bh->b_page);
+		kaddr = kmap_local_page(su_bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum, su_bh, kaddr);
 		su2 = su;
@@ -726,7 +726,7 @@ static int nilfs_sufile_truncate_range(s
 			     ~BIT(NILFS_SEGMENT_USAGE_ERROR)) ||
 			    nilfs_segment_is_active(nilfs, segnum + j)) {
 				ret = -EBUSY;
-				kunmap_atomic(kaddr);
+				kunmap_local(kaddr);
 				brelse(su_bh);
 				goto out_header;
 			}
@@ -738,7 +738,7 @@ static int nilfs_sufile_truncate_range(s
 				nc++;
 			}
 		}
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		if (nc > 0) {
 			mark_buffer_dirty(su_bh);
 			ncleaned += nc;
@@ -823,10 +823,10 @@ int nilfs_sufile_resize(struct inode *su
 		sui->allocmin = 0;
 	}
 
-	kaddr = kmap_atomic(header_bh->b_page);
+	kaddr = kmap_local_page(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	header->sh_ncleansegs = cpu_to_le64(sui->ncleansegs);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	mark_buffer_dirty(header_bh);
 	nilfs_mdt_mark_dirty(sufile);
@@ -891,7 +891,7 @@ ssize_t nilfs_sufile_get_suinfo(struct i
 			continue;
 		}
 
-		kaddr = kmap_atomic(su_bh->b_page);
+		kaddr = kmap_local_page(su_bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum, su_bh, kaddr);
 		for (j = 0; j < n;
@@ -904,7 +904,7 @@ ssize_t nilfs_sufile_get_suinfo(struct i
 				si->sui_flags |=
 					BIT(NILFS_SEGMENT_USAGE_ACTIVE);
 		}
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		brelse(su_bh);
 	}
 	ret = nsegs;
@@ -973,7 +973,7 @@ ssize_t nilfs_sufile_set_suinfo(struct i
 		goto out_header;
 
 	for (;;) {
-		kaddr = kmap_atomic(bh->b_page);
+		kaddr = kmap_local_page(bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, sup->sup_segnum, bh, kaddr);
 
@@ -1010,7 +1010,7 @@ ssize_t nilfs_sufile_set_suinfo(struct i
 			su->su_flags = cpu_to_le32(sup->sup_sui.sui_flags);
 		}
 
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 
 		sup = (void *)sup + supsz;
 		if (sup >= supend)
@@ -1115,7 +1115,7 @@ int nilfs_sufile_trim_fs(struct inode *s
 			continue;
 		}
 
-		kaddr = kmap_atomic(su_bh->b_page);
+		kaddr = kmap_local_page(su_bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(sufile, segnum,
 				su_bh, kaddr);
 		for (i = 0; i < n; ++i, ++segnum, su = (void *)su + susz) {
@@ -1145,7 +1145,7 @@ int nilfs_sufile_trim_fs(struct inode *s
 			}
 
 			if (nblocks >= minlen) {
-				kunmap_atomic(kaddr);
+				kunmap_local(kaddr);
 
 				ret = blkdev_issue_discard(nilfs->ns_bdev,
 						start * sects_per_block,
@@ -1157,7 +1157,7 @@ int nilfs_sufile_trim_fs(struct inode *s
 				}
 
 				ndiscarded += nblocks;
-				kaddr = kmap_atomic(su_bh->b_page);
+				kaddr = kmap_local_page(su_bh->b_page);
 				su = nilfs_sufile_block_get_segment_usage(
 					sufile, segnum, su_bh, kaddr);
 			}
@@ -1166,7 +1166,7 @@ int nilfs_sufile_trim_fs(struct inode *s
 			start = seg_start;
 			nblocks = seg_end - seg_start + 1;
 		}
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		put_bh(su_bh);
 	}
 
@@ -1246,10 +1246,10 @@ int nilfs_sufile_read(struct super_block
 		goto failed;
 
 	sui = NILFS_SUI(sufile);
-	kaddr = kmap_atomic(header_bh->b_page);
+	kaddr = kmap_local_page(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	sui->ncleansegs = le64_to_cpu(header->sh_ncleansegs);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	brelse(header_bh);
 
 	sui->allocmax = nilfs_sufile_get_nsegments(sufile) - 1;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


