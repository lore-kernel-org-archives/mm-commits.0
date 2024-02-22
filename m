Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F14013BAE2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645191; cv=none; b=Opt9/5LsiV5liGLsxhqE6GAlLmOqG++Xn8la84LBuSzc5yEzidRoXeGTFFqf4p4lx1rG0CMPdzU4IYlwN6MoN/ArtzASmCJM9PVdm15W5Ri7+X48uaRWCR0jWyKrGfTsCTL4hpKB/oAcUXFaoSt7q3K+Iyixa4TEYmdYJxDHrp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645191; c=relaxed/simple;
	bh=RkXDsUxWSf9HISJbEXSwJ88O1/fZ1zFqn2wwOsn8Vpo=;
	h=Date:To:From:Subject:Message-Id; b=ZYuqCGJjJqlcmQsFvGa4zy8hrOk5WMVO9kx3t9sMgTF1SI1jCRfqOdNS5udklUUet6ehtLZBXMLOI0SVxfw56P7TijhQ835xAxiZok/RxTMGJnJ/HFBecEk0wpspg3dFVXMxbnI2V6ITyYK9XlNCjU0CFmT1Cd1arwPwLYIv+K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=na0MUJ/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="na0MUJ/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEC3C433C7;
	Thu, 22 Feb 2024 23:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645191;
	bh=RkXDsUxWSf9HISJbEXSwJ88O1/fZ1zFqn2wwOsn8Vpo=;
	h=Date:To:From:Subject:From;
	b=na0MUJ/lt3fweFbgFa+WqU6v/qnJr2JQgQmoMPUfI1jGrSoBJi11KEzLjjwkDvEJH
	 K6fvWcIUJ746HGZybfas/PJk+TOzOnfQjLpTpXPrvDM5Ac7YTOmPbdRzcf99WyrEaW
	 EeQL/m2S9wGCjOEoQhhCRUt46Ut+LMFXC/kgW8eM=
Date: Thu, 22 Feb 2024 15:39:50 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch removed from -mm tree
Message-Id: <20240222233951.5EEC3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert persistent object allocator to use kmap_local
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


