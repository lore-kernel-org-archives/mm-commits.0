Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C61E189F56
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855660; cv=none; b=QkhcX6PoldTAlH6pQol8V5lIh7ZxS7oKAb2mT2VmniMS/JuWnBCicTV7hLAKZTpC30i89WHm4ogzdsbGm8Mj/ANgb5nWZ6v7pfI73JVQgHtT81Ya1/RLArxcMiJxU9Ch0O4ur3nYBoj9C1hlpcXd5rjJtbDop796xtuh14uxE6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855660; c=relaxed/simple;
	bh=6ZQtC6bjDrXHi34qEQtDCW5OLTkAy5hp2Ef5FW7NJf4=;
	h=Date:To:From:Subject:Message-Id; b=cES5esTeGkUlsuYE6qhmAQs06BPn384RJ8jQwO2xzcOtR5jsu0eC6ChrqYYrb/FtZ4RTFDgH0P2HRY2kuEJvRQ/bMwju4qaJ2Dl+QYQNqCRef+GTKAmGV8CxIru4iwSrQYFDC7IBDna5NSpAZSzrXdv89xyLzgYV/Cl2fVP/6p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YxnQQZ1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YxnQQZ1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B13C4CECF;
	Wed,  6 Nov 2024 01:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855660;
	bh=6ZQtC6bjDrXHi34qEQtDCW5OLTkAy5hp2Ef5FW7NJf4=;
	h=Date:To:From:Subject:From;
	b=YxnQQZ1rd8je50K8dxwK7DqpLWdqFNB94ke3Zy4uZcYpAYoC37MjUcuLrbBkWsG5s
	 lNfJItvcJFDZDdEqOLtqhR1g0vIEoG/Ggdkj1ggDR+YoszwxK9ZQyHdZrB5do4zcio
	 Tx3dlDfkdZBdxHNQKC65dOqEyPt8BjOsIzePOtfw=
Date: Tue, 05 Nov 2024 17:14:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-dat-file-to-be-folio-based.patch removed from -mm tree
Message-Id: <20241106011419.E8B13C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert DAT file to be folio-based
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-dat-file-to-be-folio-based.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert DAT file to be folio-based
Date: Thu, 24 Oct 2024 18:25:40 +0900

Regarding the DAT, a metadata file that manages virtual block addresses,
convert the page-based implementation to a folio-based implementation.

Link: https://lkml.kernel.org/r/20241024092602.13395-7-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dat.c |   98 ++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 46 deletions(-)

--- a/fs/nilfs2/dat.c~nilfs2-convert-dat-file-to-be-folio-based
+++ a/fs/nilfs2/dat.c
@@ -89,15 +89,15 @@ int nilfs_dat_prepare_alloc(struct inode
 void nilfs_dat_commit_alloc(struct inode *dat, struct nilfs_palloc_req *req)
 {
 	struct nilfs_dat_entry *entry;
-	void *kaddr;
+	size_t offset;
 
-	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
-	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
-					     req->pr_entry_bh, kaddr);
+	offset = nilfs_palloc_entry_offset(dat, req->pr_entry_nr,
+					   req->pr_entry_bh);
+	entry = kmap_local_folio(req->pr_entry_bh->b_folio, offset);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MAX);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_local(kaddr);
+	kunmap_local(entry);
 
 	nilfs_palloc_commit_alloc_entry(dat, req);
 	nilfs_dat_commit_entry(dat, req);
@@ -113,15 +113,15 @@ static void nilfs_dat_commit_free(struct
 				  struct nilfs_palloc_req *req)
 {
 	struct nilfs_dat_entry *entry;
-	void *kaddr;
+	size_t offset;
 
-	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
-	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
-					     req->pr_entry_bh, kaddr);
+	offset = nilfs_palloc_entry_offset(dat, req->pr_entry_nr,
+					   req->pr_entry_bh);
+	entry = kmap_local_folio(req->pr_entry_bh->b_folio, offset);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_local(kaddr);
+	kunmap_local(entry);
 
 	nilfs_dat_commit_entry(dat, req);
 
@@ -143,14 +143,14 @@ void nilfs_dat_commit_start(struct inode
 			    sector_t blocknr)
 {
 	struct nilfs_dat_entry *entry;
-	void *kaddr;
+	size_t offset;
 
-	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
-	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
-					     req->pr_entry_bh, kaddr);
+	offset = nilfs_palloc_entry_offset(dat, req->pr_entry_nr,
+					   req->pr_entry_bh);
+	entry = kmap_local_folio(req->pr_entry_bh->b_folio, offset);
 	entry->de_start = cpu_to_le64(nilfs_mdt_cno(dat));
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_local(kaddr);
+	kunmap_local(entry);
 
 	nilfs_dat_commit_entry(dat, req);
 }
@@ -160,19 +160,19 @@ int nilfs_dat_prepare_end(struct inode *
 	struct nilfs_dat_entry *entry;
 	__u64 start;
 	sector_t blocknr;
-	void *kaddr;
+	size_t offset;
 	int ret;
 
 	ret = nilfs_dat_prepare_entry(dat, req, 0);
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
-	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
-					     req->pr_entry_bh, kaddr);
+	offset = nilfs_palloc_entry_offset(dat, req->pr_entry_nr,
+					   req->pr_entry_bh);
+	entry = kmap_local_folio(req->pr_entry_bh->b_folio, offset);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_local(kaddr);
+	kunmap_local(entry);
 
 	if (blocknr == 0) {
 		ret = nilfs_palloc_prepare_free_entry(dat, req);
@@ -200,11 +200,11 @@ void nilfs_dat_commit_end(struct inode *
 	struct nilfs_dat_entry *entry;
 	__u64 start, end;
 	sector_t blocknr;
-	void *kaddr;
+	size_t offset;
 
-	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
-	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
-					     req->pr_entry_bh, kaddr);
+	offset = nilfs_palloc_entry_offset(dat, req->pr_entry_nr,
+					   req->pr_entry_bh);
+	entry = kmap_local_folio(req->pr_entry_bh->b_folio, offset);
 	end = start = le64_to_cpu(entry->de_start);
 	if (!dead) {
 		end = nilfs_mdt_cno(dat);
@@ -212,7 +212,7 @@ void nilfs_dat_commit_end(struct inode *
 	}
 	entry->de_end = cpu_to_le64(end);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_local(kaddr);
+	kunmap_local(entry);
 
 	if (blocknr == 0)
 		nilfs_dat_commit_free(dat, req);
@@ -225,14 +225,14 @@ void nilfs_dat_abort_end(struct inode *d
 	struct nilfs_dat_entry *entry;
 	__u64 start;
 	sector_t blocknr;
-	void *kaddr;
+	size_t offset;
 
-	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
-	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
-					     req->pr_entry_bh, kaddr);
+	offset = nilfs_palloc_entry_offset(dat, req->pr_entry_nr,
+					   req->pr_entry_bh);
+	entry = kmap_local_folio(req->pr_entry_bh->b_folio, offset);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_local(kaddr);
+	kunmap_local(entry);
 
 	if (start == nilfs_mdt_cno(dat) && blocknr == 0)
 		nilfs_palloc_abort_free_entry(dat, req);
@@ -336,7 +336,7 @@ int nilfs_dat_move(struct inode *dat, __
 {
 	struct buffer_head *entry_bh;
 	struct nilfs_dat_entry *entry;
-	void *kaddr;
+	size_t offset;
 	int ret;
 
 	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
@@ -359,21 +359,21 @@ int nilfs_dat_move(struct inode *dat, __
 		}
 	}
 
-	kaddr = kmap_local_page(entry_bh->b_page);
-	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
+	offset = nilfs_palloc_entry_offset(dat, vblocknr, entry_bh);
+	entry = kmap_local_folio(entry_bh->b_folio, offset);
 	if (unlikely(entry->de_blocknr == cpu_to_le64(0))) {
 		nilfs_crit(dat->i_sb,
 			   "%s: invalid vblocknr = %llu, [%llu, %llu)",
 			   __func__, (unsigned long long)vblocknr,
 			   (unsigned long long)le64_to_cpu(entry->de_start),
 			   (unsigned long long)le64_to_cpu(entry->de_end));
-		kunmap_local(kaddr);
+		kunmap_local(entry);
 		brelse(entry_bh);
 		return -EINVAL;
 	}
 	WARN_ON(blocknr == 0);
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_local(kaddr);
+	kunmap_local(entry);
 
 	mark_buffer_dirty(entry_bh);
 	nilfs_mdt_mark_dirty(dat);
@@ -407,7 +407,7 @@ int nilfs_dat_translate(struct inode *da
 	struct buffer_head *entry_bh, *bh;
 	struct nilfs_dat_entry *entry;
 	sector_t blocknr;
-	void *kaddr;
+	size_t offset;
 	int ret;
 
 	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
@@ -423,8 +423,8 @@ int nilfs_dat_translate(struct inode *da
 		}
 	}
 
-	kaddr = kmap_local_page(entry_bh->b_page);
-	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
+	offset = nilfs_palloc_entry_offset(dat, vblocknr, entry_bh);
+	entry = kmap_local_folio(entry_bh->b_folio, offset);
 	blocknr = le64_to_cpu(entry->de_blocknr);
 	if (blocknr == 0) {
 		ret = -ENOENT;
@@ -433,7 +433,7 @@ int nilfs_dat_translate(struct inode *da
 	*blocknrp = blocknr;
 
  out:
-	kunmap_local(kaddr);
+	kunmap_local(entry);
 	brelse(entry_bh);
 	return ret;
 }
@@ -442,11 +442,12 @@ ssize_t nilfs_dat_get_vinfo(struct inode
 			    size_t nvi)
 {
 	struct buffer_head *entry_bh;
-	struct nilfs_dat_entry *entry;
+	struct nilfs_dat_entry *entry, *first_entry;
 	struct nilfs_vinfo *vinfo = buf;
 	__u64 first, last;
-	void *kaddr;
+	size_t offset;
 	unsigned long entries_per_block = NILFS_MDT(dat)->mi_entries_per_block;
+	unsigned int entry_size = NILFS_MDT(dat)->mi_entry_size;
 	int i, j, n, ret;
 
 	for (i = 0; i < nvi; i += n) {
@@ -454,23 +455,28 @@ ssize_t nilfs_dat_get_vinfo(struct inode
 						   0, &entry_bh);
 		if (ret < 0)
 			return ret;
-		kaddr = kmap_local_page(entry_bh->b_page);
-		/* last virtual block number in this block */
+
 		first = vinfo->vi_vblocknr;
 		first = div64_ul(first, entries_per_block);
 		first *= entries_per_block;
+		/* first virtual block number in this block */
+
 		last = first + entries_per_block - 1;
+		/* last virtual block number in this block */
+
+		offset = nilfs_palloc_entry_offset(dat, first, entry_bh);
+		first_entry = kmap_local_folio(entry_bh->b_folio, offset);
 		for (j = i, n = 0;
 		     j < nvi && vinfo->vi_vblocknr >= first &&
 			     vinfo->vi_vblocknr <= last;
 		     j++, n++, vinfo = (void *)vinfo + visz) {
-			entry = nilfs_palloc_block_get_entry(
-				dat, vinfo->vi_vblocknr, entry_bh, kaddr);
+			entry = (void *)first_entry +
+				(vinfo->vi_vblocknr - first) * entry_size;
 			vinfo->vi_start = le64_to_cpu(entry->de_start);
 			vinfo->vi_end = le64_to_cpu(entry->de_end);
 			vinfo->vi_blocknr = le64_to_cpu(entry->de_blocknr);
 		}
-		kunmap_local(kaddr);
+		kunmap_local(first_entry);
 		brelse(entry_bh);
 	}
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


