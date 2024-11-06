Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEE4189F56
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855655; cv=none; b=nc0D8/8pTXqI3svrlLk8gIL5VztF7aQJjmdy4SDiqBN8w0yp8U/bonuMf1r/RuBnyfMmL5zQZqzoYkMaaMK7ufuUbc7f6W4dcbalMIl/zj5hq8Qn/p+NxvBRfNBFXQpcqjE2U5R49sUHoR7FfKPkwgrBu0eTJYbjyK4eWzmqXwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855655; c=relaxed/simple;
	bh=88Yt7U/1lg0+BlzTC4fePEpyrPEqOzoxhpv97H8uuSA=;
	h=Date:To:From:Subject:Message-Id; b=jNGahm5yLcdz8Qlfv3wnBGKLlMzP9xsnKBT8pnmWdluVfeOUGt9Cp8A9GMy7Xm7H3QvSB3aN3RX1/AofvK7740bUIoq1tlvWjKdx326yOBpnBXwMenO/9xTRq1+r7wfUWn+zjhVtN0euMjXGzlyNCOcT02aP+QcBEqOHIU3xWNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rkr2k8aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rkr2k8aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7127CC4CECF;
	Wed,  6 Nov 2024 01:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855655;
	bh=88Yt7U/1lg0+BlzTC4fePEpyrPEqOzoxhpv97H8uuSA=;
	h=Date:To:From:Subject:From;
	b=Rkr2k8aaGtepAt7OQGgG5LyZtLLGOF90fm8dO+HwFMBzT5WggJR/dFhhpUyaEsEQp
	 QElTrcXt+QW8PpkEV3aC6cQKCtQ81mkFVih7bQO/vdUBChIIkXBJGcW80leg4EV6rz
	 /LVx2Lb6AmNCHJEKPUqyv6vYYv2a/l4HRedRLZ0A=
Date: Tue, 05 Nov 2024 17:14:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-common-metadata-file-code-to-be-folio-based.patch removed from -mm tree
Message-Id: <20241106011415.7127CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert common metadata file code to be folio-based
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-common-metadata-file-code-to-be-folio-based.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert common metadata file code to be folio-based
Date: Thu, 24 Oct 2024 18:25:36 +0900

In the common routines for metadata files, nilfs_mdt_insert_new_block(),
which inserts a new block buffer into the cache, is still page-based, and
there are two places where bh_offset() is used.  Convert these to
page-based.

Link: https://lkml.kernel.org/r/20241024092602.13395-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c  |    8 +++++---
 fs/nilfs2/cpfile.c |    4 ++--
 fs/nilfs2/mdt.c    |   21 +++++++++++++--------
 3 files changed, 20 insertions(+), 13 deletions(-)

--- a/fs/nilfs2/alloc.c~nilfs2-convert-common-metadata-file-code-to-be-folio-based
+++ a/fs/nilfs2/alloc.c
@@ -177,12 +177,14 @@ nilfs_palloc_entry_blkoff(const struct i
  * nilfs_palloc_desc_block_init - initialize buffer of a group descriptor block
  * @inode: inode of metadata file
  * @bh: buffer head of the buffer to be initialized
- * @kaddr: kernel address mapped for the page including the buffer
+ * @from: kernel address mapped for a chunk of the block
+ *
+ * This function does not yet support the case where block size > PAGE_SIZE.
  */
 static void nilfs_palloc_desc_block_init(struct inode *inode,
-					 struct buffer_head *bh, void *kaddr)
+					 struct buffer_head *bh, void *from)
 {
-	struct nilfs_palloc_group_desc *desc = kaddr + bh_offset(bh);
+	struct nilfs_palloc_group_desc *desc = from;
 	unsigned long n = nilfs_palloc_groups_per_desc_block(inode);
 	__le32 nfrees;
 
--- a/fs/nilfs2/cpfile.c~nilfs2-convert-common-metadata-file-code-to-be-folio-based
+++ a/fs/nilfs2/cpfile.c
@@ -113,9 +113,9 @@ nilfs_cpfile_block_get_checkpoint(const
 
 static void nilfs_cpfile_block_init(struct inode *cpfile,
 				    struct buffer_head *bh,
-				    void *kaddr)
+				    void *from)
 {
-	struct nilfs_checkpoint *cp = kaddr + bh_offset(bh);
+	struct nilfs_checkpoint *cp = from;
 	size_t cpsz = NILFS_MDT(cpfile)->mi_entry_size;
 	int n = nilfs_cpfile_checkpoints_per_block(cpfile);
 
--- a/fs/nilfs2/mdt.c~nilfs2-convert-common-metadata-file-code-to-be-folio-based
+++ a/fs/nilfs2/mdt.c
@@ -33,7 +33,8 @@ nilfs_mdt_insert_new_block(struct inode
 					      struct buffer_head *, void *))
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	void *kaddr;
+	struct folio *folio = bh->b_folio;
+	void *from;
 	int ret;
 
 	/* Caller exclude read accesses using page lock */
@@ -47,12 +48,14 @@ nilfs_mdt_insert_new_block(struct inode
 
 	set_buffer_mapped(bh);
 
-	kaddr = kmap_local_page(bh->b_page);
-	memset(kaddr + bh_offset(bh), 0, i_blocksize(inode));
+	/* Initialize block (block size > PAGE_SIZE not yet supported) */
+	from = kmap_local_folio(folio, offset_in_folio(folio, bh->b_data));
+	memset(from, 0, bh->b_size);
 	if (init_block)
-		init_block(inode, bh, kaddr);
-	flush_dcache_page(bh->b_page);
-	kunmap_local(kaddr);
+		init_block(inode, bh, from);
+	kunmap_local(from);
+
+	flush_dcache_folio(folio);
 
 	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
@@ -571,7 +574,8 @@ int nilfs_mdt_freeze_buffer(struct inode
 	if (!bh_frozen)
 		bh_frozen = create_empty_buffers(folio, 1 << blkbits, 0);
 
-	bh_frozen = get_nth_bh(bh_frozen, bh_offset(bh) >> blkbits);
+	bh_frozen = get_nth_bh(bh_frozen,
+			       offset_in_folio(folio, bh->b_data) >> blkbits);
 
 	if (!buffer_uptodate(bh_frozen))
 		nilfs_copy_buffer(bh_frozen, bh);
@@ -601,7 +605,8 @@ nilfs_mdt_get_frozen_buffer(struct inode
 	if (!IS_ERR(folio)) {
 		bh_frozen = folio_buffers(folio);
 		if (bh_frozen) {
-			n = bh_offset(bh) >> inode->i_blkbits;
+			n = offset_in_folio(folio, bh->b_data) >>
+				inode->i_blkbits;
 			bh_frozen = get_nth_bh(bh_frozen, n);
 		}
 		folio_unlock(folio);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


