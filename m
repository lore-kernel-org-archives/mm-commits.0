Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59684E1D2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970565; cv=none; b=K1Ec33rTZV3vXIwlF3sAHc4hWFOi7RbeduIG3S6KhZzXvQZVJWj9fe3705BiFH47ej9umOaQ1VMofCbnc5Wx7picnnfJf3cHyIF8PrV86iilDcpJsCzUfYq7Pd3k671D9VWTce2mMb3zKiGdQ+E0HvVgwi0mfoLE3uBT/F3hBfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970565; c=relaxed/simple;
	bh=bzKeckyZuEnEgMc9CZc/ZvmeNZjBJAE06nEYXyqcizk=;
	h=Date:To:From:Subject:Message-Id; b=Hvx0jpYFcbKnu6O716ywKsURDUmemqaRZLxvWlmGNOQb6JmTKHv+wbbeXIemMUFbDCiYTzZigkHuk0JPCEwsECm9d4qQftNiOkOb2KEUESSE6aG3yoCjmgmXI0EGcPiJ9Yfx/BTJo7Z+gf+3Fi+z+DShK/eyYWTX67yhC1IJMLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u6OJaejv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u6OJaejv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE9EC43390;
	Tue, 23 Jan 2024 00:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970565;
	bh=bzKeckyZuEnEgMc9CZc/ZvmeNZjBJAE06nEYXyqcizk=;
	h=Date:To:From:Subject:From;
	b=u6OJaejvCBLN9aSR+n7KQY+W1TjNVbMqYNJQjurrvA30tZx9u4ETQwyobUIo/76tz
	 zDZ36XGVVPw/QOHSsuih4yZz8f8TwutVBS5gLBNXuHg0tXBlwHEFtcXW94o7m2iU5g
	 JF1zsoaEqc8/G5/KNUW3iSr+Kl2UH7VgfP43QISI=
Date: Mon, 22 Jan 2024 16:42:42 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004245.0CE9EC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert persistent object allocator to use kmap_local
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch

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
Subject: nilfs2: convert persistent object allocator to use kmap_local
Date: Mon, 22 Jan 2024 23:01:53 +0900

Regarding the allocator code that is commonly used in the ondisk inode
metadata file ifile and the disk address translation metadata file DAT,
convert the parts that use the deprecated kmap_atomic() and kmap() to use
kmap_local.

Most can be converted directly, but only
nilfs_palloc_prepare_alloc_entry() needs to be rewritten to change mapping
sections so that multiple kmap_local/kunmap_local calls are nested and
disk I/O can be avoided within the mapping sections.

Link: https://lkml.kernel.org/r/20240122140202.6950-7-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   91 ++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 45 deletions(-)

--- a/fs/nilfs2/alloc.c~nilfs2-convert-persistent-object-allocator-to-use-kmap_local
+++ a/fs/nilfs2/alloc.c
@@ -525,54 +525,55 @@ int nilfs_palloc_prepare_alloc_entry(str
 		ret = nilfs_palloc_get_desc_block(inode, group, 1, &desc_bh);
 		if (ret < 0)
 			return ret;
-		desc_kaddr = kmap(desc_bh->b_page);
+		desc_kaddr = kmap_local_page(desc_bh->b_page);
 		desc = nilfs_palloc_block_get_group_desc(
 			inode, group, desc_bh, desc_kaddr);
 		n = nilfs_palloc_rest_groups_in_desc_block(inode, group,
 							   maxgroup);
-		for (j = 0; j < n; j++, desc++, group++) {
+		for (j = 0; j < n; j++, desc++, group++, group_offset = 0) {
 			lock = nilfs_mdt_bgl_lock(inode, group);
-			if (nilfs_palloc_group_desc_nfrees(desc, lock) > 0) {
-				ret = nilfs_palloc_get_bitmap_block(
-					inode, group, 1, &bitmap_bh);
-				if (ret < 0)
-					goto out_desc;
-				bitmap_kaddr = kmap(bitmap_bh->b_page);
-				bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
-				pos = nilfs_palloc_find_available_slot(
-					bitmap, group_offset,
-					entries_per_group, lock);
-				if (pos >= 0) {
-					/* found a free entry */
-					nilfs_palloc_group_desc_add_entries(
-						desc, lock, -1);
-					req->pr_entry_nr =
-						entries_per_group * group + pos;
-					kunmap(desc_bh->b_page);
-					kunmap(bitmap_bh->b_page);
-
-					req->pr_desc_bh = desc_bh;
-					req->pr_bitmap_bh = bitmap_bh;
-					return 0;
-				}
-				kunmap(bitmap_bh->b_page);
-				brelse(bitmap_bh);
+			if (nilfs_palloc_group_desc_nfrees(desc, lock) == 0)
+				continue;
+
+			kunmap_local(desc_kaddr);
+			ret = nilfs_palloc_get_bitmap_block(inode, group, 1,
+							    &bitmap_bh);
+			if (unlikely(ret < 0)) {
+				brelse(desc_bh);
+				return ret;
 			}
 
-			group_offset = 0;
+			desc_kaddr = kmap_local_page(desc_bh->b_page);
+			desc = nilfs_palloc_block_get_group_desc(
+				inode, group, desc_bh, desc_kaddr);
+
+			bitmap_kaddr = kmap_local_page(bitmap_bh->b_page);
+			bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
+			pos = nilfs_palloc_find_available_slot(
+				bitmap, group_offset, entries_per_group, lock);
+			kunmap_local(bitmap_kaddr);
+			if (pos >= 0)
+				goto found;
+
+			brelse(bitmap_bh);
 		}
 
-		kunmap(desc_bh->b_page);
+		kunmap_local(desc_kaddr);
 		brelse(desc_bh);
 	}
 
 	/* no entries left */
 	return -ENOSPC;
 
- out_desc:
-	kunmap(desc_bh->b_page);
-	brelse(desc_bh);
-	return ret;
+found:
+	/* found a free entry */
+	nilfs_palloc_group_desc_add_entries(desc, lock, -1);
+	req->pr_entry_nr = entries_per_group * group + pos;
+	kunmap_local(desc_kaddr);
+
+	req->pr_desc_bh = desc_bh;
+	req->pr_bitmap_bh = bitmap_bh;
+	return 0;
 }
 
 /**
@@ -606,10 +607,10 @@ void nilfs_palloc_commit_free_entry(stru
 	spinlock_t *lock;
 
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
-	desc_kaddr = kmap(req->pr_desc_bh->b_page);
+	desc_kaddr = kmap_local_page(req->pr_desc_bh->b_page);
 	desc = nilfs_palloc_block_get_group_desc(inode, group,
 						 req->pr_desc_bh, desc_kaddr);
-	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
+	bitmap_kaddr = kmap_local_page(req->pr_bitmap_bh->b_page);
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	lock = nilfs_mdt_bgl_lock(inode, group);
 
@@ -621,8 +622,8 @@ void nilfs_palloc_commit_free_entry(stru
 	else
 		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
-	kunmap(req->pr_bitmap_bh->b_page);
-	kunmap(req->pr_desc_bh->b_page);
+	kunmap_local(bitmap_kaddr);
+	kunmap_local(desc_kaddr);
 
 	mark_buffer_dirty(req->pr_desc_bh);
 	mark_buffer_dirty(req->pr_bitmap_bh);
@@ -647,10 +648,10 @@ void nilfs_palloc_abort_alloc_entry(stru
 	spinlock_t *lock;
 
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
-	desc_kaddr = kmap(req->pr_desc_bh->b_page);
+	desc_kaddr = kmap_local_page(req->pr_desc_bh->b_page);
 	desc = nilfs_palloc_block_get_group_desc(inode, group,
 						 req->pr_desc_bh, desc_kaddr);
-	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
+	bitmap_kaddr = kmap_local_page(req->pr_bitmap_bh->b_page);
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	lock = nilfs_mdt_bgl_lock(inode, group);
 
@@ -662,8 +663,8 @@ void nilfs_palloc_abort_alloc_entry(stru
 	else
 		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
-	kunmap(req->pr_bitmap_bh->b_page);
-	kunmap(req->pr_desc_bh->b_page);
+	kunmap_local(bitmap_kaddr);
+	kunmap_local(desc_kaddr);
 
 	brelse(req->pr_bitmap_bh);
 	brelse(req->pr_desc_bh);
@@ -755,7 +756,7 @@ int nilfs_palloc_freev(struct inode *ino
 		/* Get the first entry number of the group */
 		group_min_nr = (__u64)group * epg;
 
-		bitmap_kaddr = kmap(bitmap_bh->b_page);
+		bitmap_kaddr = kmap_local_page(bitmap_bh->b_page);
 		bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 		lock = nilfs_mdt_bgl_lock(inode, group);
 
@@ -801,7 +802,7 @@ int nilfs_palloc_freev(struct inode *ino
 			entry_start = rounddown(group_offset, epb);
 		} while (true);
 
-		kunmap(bitmap_bh->b_page);
+		kunmap_local(bitmap_kaddr);
 		mark_buffer_dirty(bitmap_bh);
 		brelse(bitmap_bh);
 
@@ -815,11 +816,11 @@ int nilfs_palloc_freev(struct inode *ino
 					   inode->i_ino);
 		}
 
-		desc_kaddr = kmap_atomic(desc_bh->b_page);
+		desc_kaddr = kmap_local_page(desc_bh->b_page);
 		desc = nilfs_palloc_block_get_group_desc(
 			inode, group, desc_bh, desc_kaddr);
 		nfree = nilfs_palloc_group_desc_add_entries(desc, lock, n);
-		kunmap_atomic(desc_kaddr);
+		kunmap_local(desc_kaddr);
 		mark_buffer_dirty(desc_bh);
 		nilfs_mdt_mark_dirty(inode);
 		brelse(desc_bh);
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

