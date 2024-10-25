Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F4420EA4B
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 19:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729885072; cv=none; b=PVCkI88SPJOVFZ6O4Xh1Uwc1yZn5SzsD/UPJH2ClEYBNvx4tpvTzDw6GKEmJTO+ITNTbqMOeIgOcjiBlz3T76XiwG7USLa0H01RMXmx+y9ixPDGwUzyNCiBOHhwZINrruP2iHjKS+YLOwa/5t0YxGQeihbccuvPQim7MpXaQr5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729885072; c=relaxed/simple;
	bh=BafYFcMmq+Nn0SC4CEhc/fB/i39GoBgnJlnRHksfrxw=;
	h=Date:To:From:Subject:Message-Id; b=YSe0ZgYBm1eah4twqHjRDQPnMnc6PM34A9EBj47o3ol44ioYmOsDqzwEks0Z4UXac468hgJSk8xNWtWxlb5kwH6o6A+xV4DOpu2HfgniViQyIVapLFb2lnfmejpWxY4Sl+euOK37X3EUJaUrCgsLJ3nCYEkHdTWZFldI838AdU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QTSs+C58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QTSs+C58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D3BC4CECC;
	Fri, 25 Oct 2024 19:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729885071;
	bh=BafYFcMmq+Nn0SC4CEhc/fB/i39GoBgnJlnRHksfrxw=;
	h=Date:To:From:Subject:From;
	b=QTSs+C58uWLVTGfYQw6hJ/fLJNgrzEvSg4TO37I20th5zM0HYgrp7vWWhkINF104R
	 BkZENAhI1k37BanNDb46ew3w19D1Quq8onjVObd4i8fShagoAVS6nh4TUYVWLQhZ0v
	 JrJZJYq3BpZMAL+SDQRtjAlbizEArrGWYnwcMtwI=
Date: Fri, 25 Oct 2024 12:37:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-persistent-object-allocator-to-be-folio-based.patch added to mm-nonmm-unstable branch
Message-Id: <20241025193751.B5D3BC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert persistent object allocator to be folio-based
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-persistent-object-allocator-to-be-folio-based.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-persistent-object-allocator-to-be-folio-based.patch

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
Subject: nilfs2: convert persistent object allocator to be folio-based
Date: Thu, 24 Oct 2024 18:25:38 +0900

Regarding the persistent oject allocator, a common mechanism for
allocating objects in metadata files such as inodes and DAT entries,
convert the page-based implementation to a folio-based implementation.

In this conversion, helper functions nilfs_palloc_group_desc_offset() and
nilfs_palloc_bitmap_offset() are added and used to calculate the byte
offset within a folio of a group descriptor structure and bitmap,
respectively, to replace kmap_local_page with kmap_local_folio.

In addition, a helper function called nilfs_palloc_entry_offset() is
provided to facilitate common calculation of the byte offset within a
folio of metadata file entries managed in the persistent object allocator
format.

Link: https://lkml.kernel.org/r/20241024092602.13395-5-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |  137 +++++++++++++++++++++++++++-----------------
 fs/nilfs2/alloc.h |    2 
 2 files changed, 89 insertions(+), 50 deletions(-)

--- a/fs/nilfs2/alloc.c~nilfs2-convert-persistent-object-allocator-to-be-folio-based
+++ a/fs/nilfs2/alloc.c
@@ -339,19 +339,55 @@ static int nilfs_palloc_delete_entry_blo
 }
 
 /**
- * nilfs_palloc_block_get_group_desc - get kernel address of a group descriptor
+ * nilfs_palloc_group_desc_offset - calculate the byte offset of a group
+ *                                  descriptor in the folio containing it
  * @inode: inode of metadata file using this allocator
  * @group: group number
- * @bh: buffer head of the buffer storing the group descriptor block
- * @kaddr: kernel address mapped for the page including the buffer
+ * @bh:    buffer head of the group descriptor block
+ *
+ * Return: Byte offset in the folio of the group descriptor for @group.
+ */
+static size_t nilfs_palloc_group_desc_offset(const struct inode *inode,
+					     unsigned long group,
+					     const struct buffer_head *bh)
+{
+	return offset_in_folio(bh->b_folio, bh->b_data) +
+		sizeof(struct nilfs_palloc_group_desc) *
+		(group % nilfs_palloc_groups_per_desc_block(inode));
+}
+
+/**
+ * nilfs_palloc_bitmap_offset - calculate the byte offset of a bitmap block
+ *                              in the folio containing it
+ * @bh: buffer head of the bitmap block
+ *
+ * Return: Byte offset in the folio of the bitmap block for @bh.
  */
-static struct nilfs_palloc_group_desc *
-nilfs_palloc_block_get_group_desc(const struct inode *inode,
-				  unsigned long group,
-				  const struct buffer_head *bh, void *kaddr)
+static size_t nilfs_palloc_bitmap_offset(const struct buffer_head *bh)
 {
-	return (struct nilfs_palloc_group_desc *)(kaddr + bh_offset(bh)) +
-		group % nilfs_palloc_groups_per_desc_block(inode);
+	return offset_in_folio(bh->b_folio, bh->b_data);
+}
+
+/**
+ * nilfs_palloc_entry_offset - calculate the byte offset of an entry in the
+ *                             folio containing it
+ * @inode: inode of metadata file using this allocator
+ * @nr:    serial number of the entry (e.g. inode number)
+ * @bh:    buffer head of the entry block
+ *
+ * Return: Byte offset in the folio of the entry @nr.
+ */
+size_t nilfs_palloc_entry_offset(const struct inode *inode, __u64 nr,
+				 const struct buffer_head *bh)
+{
+	unsigned long entry_index_in_group, entry_index_in_block;
+
+	nilfs_palloc_group(inode, nr, &entry_index_in_group);
+	entry_index_in_block = entry_index_in_group %
+		NILFS_MDT(inode)->mi_entries_per_block;
+
+	return offset_in_folio(bh->b_folio, bh->b_data) +
+		entry_index_in_block * NILFS_MDT(inode)->mi_entry_size;
 }
 
 /**
@@ -508,7 +544,7 @@ int nilfs_palloc_prepare_alloc_entry(str
 	struct buffer_head *desc_bh, *bitmap_bh;
 	struct nilfs_palloc_group_desc *desc;
 	unsigned char *bitmap;
-	void *desc_kaddr, *bitmap_kaddr;
+	size_t doff, boff;
 	unsigned long group, maxgroup, ngroups;
 	unsigned long group_offset, maxgroup_offset;
 	unsigned long n, entries_per_group;
@@ -531,17 +567,17 @@ int nilfs_palloc_prepare_alloc_entry(str
 		ret = nilfs_palloc_get_desc_block(inode, group, 1, &desc_bh);
 		if (ret < 0)
 			return ret;
-		desc_kaddr = kmap_local_page(desc_bh->b_page);
-		desc = nilfs_palloc_block_get_group_desc(
-			inode, group, desc_bh, desc_kaddr);
+
+		doff = nilfs_palloc_group_desc_offset(inode, group, desc_bh);
+		desc = kmap_local_folio(desc_bh->b_folio, doff);
 		n = nilfs_palloc_rest_groups_in_desc_block(inode, group,
 							   maxgroup);
-		for (j = 0; j < n; j++, desc++, group++, group_offset = 0) {
+		for (j = 0; j < n; j++, group++, group_offset = 0) {
 			lock = nilfs_mdt_bgl_lock(inode, group);
-			if (nilfs_palloc_group_desc_nfrees(desc, lock) == 0)
+			if (nilfs_palloc_group_desc_nfrees(&desc[j], lock) == 0)
 				continue;
 
-			kunmap_local(desc_kaddr);
+			kunmap_local(desc);
 			ret = nilfs_palloc_get_bitmap_block(inode, group, 1,
 							    &bitmap_bh);
 			if (unlikely(ret < 0)) {
@@ -549,12 +585,14 @@ int nilfs_palloc_prepare_alloc_entry(str
 				return ret;
 			}
 
-			desc_kaddr = kmap_local_page(desc_bh->b_page);
-			desc = nilfs_palloc_block_get_group_desc(
-				inode, group, desc_bh, desc_kaddr);
+			/*
+			 * Re-kmap the folio containing the first (and
+			 * subsequent) group descriptors.
+			 */
+			desc = kmap_local_folio(desc_bh->b_folio, doff);
 
-			bitmap_kaddr = kmap_local_page(bitmap_bh->b_page);
-			bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
+			boff = nilfs_palloc_bitmap_offset(bitmap_bh);
+			bitmap = kmap_local_folio(bitmap_bh->b_folio, boff);
 			pos = nilfs_palloc_find_available_slot(
 				bitmap, group_offset, entries_per_group, lock,
 				wrap);
@@ -564,14 +602,14 @@ int nilfs_palloc_prepare_alloc_entry(str
 			 * beginning, the wrap flag only has an effect on the
 			 * first search.
 			 */
-			kunmap_local(bitmap_kaddr);
+			kunmap_local(bitmap);
 			if (pos >= 0)
 				goto found;
 
 			brelse(bitmap_bh);
 		}
 
-		kunmap_local(desc_kaddr);
+		kunmap_local(desc);
 		brelse(desc_bh);
 	}
 
@@ -580,9 +618,9 @@ int nilfs_palloc_prepare_alloc_entry(str
 
 found:
 	/* found a free entry */
-	nilfs_palloc_group_desc_add_entries(desc, lock, -1);
+	nilfs_palloc_group_desc_add_entries(&desc[j], lock, -1);
 	req->pr_entry_nr = entries_per_group * group + pos;
-	kunmap_local(desc_kaddr);
+	kunmap_local(desc);
 
 	req->pr_desc_bh = desc_bh;
 	req->pr_bitmap_bh = bitmap_bh;
@@ -613,18 +651,18 @@ void nilfs_palloc_commit_alloc_entry(str
 void nilfs_palloc_commit_free_entry(struct inode *inode,
 				    struct nilfs_palloc_req *req)
 {
-	struct nilfs_palloc_group_desc *desc;
 	unsigned long group, group_offset;
+	size_t doff, boff;
+	struct nilfs_palloc_group_desc *desc;
 	unsigned char *bitmap;
-	void *desc_kaddr, *bitmap_kaddr;
 	spinlock_t *lock;
 
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
-	desc_kaddr = kmap_local_page(req->pr_desc_bh->b_page);
-	desc = nilfs_palloc_block_get_group_desc(inode, group,
-						 req->pr_desc_bh, desc_kaddr);
-	bitmap_kaddr = kmap_local_page(req->pr_bitmap_bh->b_page);
-	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
+	doff = nilfs_palloc_group_desc_offset(inode, group, req->pr_desc_bh);
+	desc = kmap_local_folio(req->pr_desc_bh->b_folio, doff);
+
+	boff = nilfs_palloc_bitmap_offset(req->pr_bitmap_bh);
+	bitmap = kmap_local_folio(req->pr_bitmap_bh->b_folio, boff);
 	lock = nilfs_mdt_bgl_lock(inode, group);
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
@@ -635,8 +673,8 @@ void nilfs_palloc_commit_free_entry(stru
 	else
 		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
-	kunmap_local(bitmap_kaddr);
-	kunmap_local(desc_kaddr);
+	kunmap_local(bitmap);
+	kunmap_local(desc);
 
 	mark_buffer_dirty(req->pr_desc_bh);
 	mark_buffer_dirty(req->pr_bitmap_bh);
@@ -655,17 +693,17 @@ void nilfs_palloc_abort_alloc_entry(stru
 				    struct nilfs_palloc_req *req)
 {
 	struct nilfs_palloc_group_desc *desc;
-	void *desc_kaddr, *bitmap_kaddr;
+	size_t doff, boff;
 	unsigned char *bitmap;
 	unsigned long group, group_offset;
 	spinlock_t *lock;
 
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
-	desc_kaddr = kmap_local_page(req->pr_desc_bh->b_page);
-	desc = nilfs_palloc_block_get_group_desc(inode, group,
-						 req->pr_desc_bh, desc_kaddr);
-	bitmap_kaddr = kmap_local_page(req->pr_bitmap_bh->b_page);
-	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
+	doff = nilfs_palloc_group_desc_offset(inode, group, req->pr_desc_bh);
+	desc = kmap_local_folio(req->pr_desc_bh->b_folio, doff);
+
+	boff = nilfs_palloc_bitmap_offset(req->pr_bitmap_bh);
+	bitmap = kmap_local_folio(req->pr_bitmap_bh->b_folio, boff);
 	lock = nilfs_mdt_bgl_lock(inode, group);
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
@@ -676,8 +714,8 @@ void nilfs_palloc_abort_alloc_entry(stru
 	else
 		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
-	kunmap_local(bitmap_kaddr);
-	kunmap_local(desc_kaddr);
+	kunmap_local(bitmap);
+	kunmap_local(desc);
 
 	brelse(req->pr_bitmap_bh);
 	brelse(req->pr_desc_bh);
@@ -741,7 +779,7 @@ int nilfs_palloc_freev(struct inode *ino
 	struct buffer_head *desc_bh, *bitmap_bh;
 	struct nilfs_palloc_group_desc *desc;
 	unsigned char *bitmap;
-	void *desc_kaddr, *bitmap_kaddr;
+	size_t doff, boff;
 	unsigned long group, group_offset;
 	__u64 group_min_nr, last_nrs[8];
 	const unsigned long epg = nilfs_palloc_entries_per_group(inode);
@@ -769,8 +807,8 @@ int nilfs_palloc_freev(struct inode *ino
 		/* Get the first entry number of the group */
 		group_min_nr = (__u64)group * epg;
 
-		bitmap_kaddr = kmap_local_page(bitmap_bh->b_page);
-		bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
+		boff = nilfs_palloc_bitmap_offset(bitmap_bh);
+		bitmap = kmap_local_folio(bitmap_bh->b_folio, boff);
 		lock = nilfs_mdt_bgl_lock(inode, group);
 
 		j = i;
@@ -815,7 +853,7 @@ int nilfs_palloc_freev(struct inode *ino
 			entry_start = rounddown(group_offset, epb);
 		} while (true);
 
-		kunmap_local(bitmap_kaddr);
+		kunmap_local(bitmap);
 		mark_buffer_dirty(bitmap_bh);
 		brelse(bitmap_bh);
 
@@ -829,11 +867,10 @@ int nilfs_palloc_freev(struct inode *ino
 					   inode->i_ino);
 		}
 
-		desc_kaddr = kmap_local_page(desc_bh->b_page);
-		desc = nilfs_palloc_block_get_group_desc(
-			inode, group, desc_bh, desc_kaddr);
+		doff = nilfs_palloc_group_desc_offset(inode, group, desc_bh);
+		desc = kmap_local_folio(desc_bh->b_folio, doff);
 		nfree = nilfs_palloc_group_desc_add_entries(desc, lock, n);
-		kunmap_local(desc_kaddr);
+		kunmap_local(desc);
 		mark_buffer_dirty(desc_bh);
 		nilfs_mdt_mark_dirty(inode);
 		brelse(desc_bh);
--- a/fs/nilfs2/alloc.h~nilfs2-convert-persistent-object-allocator-to-be-folio-based
+++ a/fs/nilfs2/alloc.h
@@ -33,6 +33,8 @@ int nilfs_palloc_get_entry_block(struct
 				 struct buffer_head **);
 void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
 				   const struct buffer_head *, void *);
+size_t nilfs_palloc_entry_offset(const struct inode *inode, __u64 nr,
+				 const struct buffer_head *bh);
 
 int nilfs_palloc_count_max_entries(struct inode *, u64, u64 *);
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch
nilfs2-convert-segment-buffer-to-be-folio-based.patch
nilfs2-convert-common-metadata-file-code-to-be-folio-based.patch
nilfs2-convert-segment-usage-file-to-be-folio-based.patch
nilfs2-convert-persistent-object-allocator-to-be-folio-based.patch
nilfs2-convert-inode-file-to-be-folio-based.patch
nilfs2-convert-dat-file-to-be-folio-based.patch
nilfs2-remove-nilfs_palloc_block_get_entry.patch
nilfs2-convert-checkpoint-file-to-be-folio-based.patch

