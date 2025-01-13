Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D59025761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742243; cv=none; b=TF2p9RbzxX3YxPoVPuN1rSdz2ovMCDBe6cECM/o3zGtOT9nhGQsjNrD04CvgvAFXUkpOBaWTog+gYEb6QW0T+aIEfgwadrykkJt+HXLESHBPJiFImzUA3VCCa3HZNkDOWAqUynOEL5McwlPkAbkeCiK2lhkbBOMCgT0Nni3g+pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742243; c=relaxed/simple;
	bh=GHJAv02rU8sO01BDstppustkSohU8k2YeUVFamEf7QU=;
	h=Date:To:From:Subject:Message-Id; b=Hc6Zy6ncy3WxrgBimpFkEHyM6b4Ge8GH+2QQOscVg75N5qpwMkHphVwBcM5jsTbQO9ZOjsVP9MKHEbaEEXqerfwT9B+6VNjW52+3NvJf4S692dIjijgbdiaoc7fjkjdiu77/Rf7kb+nPPJhdoVqF5DpPgD9vvj99pr7F2l0kDxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hbdf2hYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hbdf2hYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C96C4CED6;
	Mon, 13 Jan 2025 04:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742243;
	bh=GHJAv02rU8sO01BDstppustkSohU8k2YeUVFamEf7QU=;
	h=Date:To:From:Subject:From;
	b=Hbdf2hYvXe5EFLXSgSUCmzO0D3AXy6jOJgLYGkJHJBIQnDVKHpSlkAiw9PgFVqW0b
	 RyK31jU1vcRURgmfw8VWkuMZEGElpocEl+hku3bDr84vgzsmaTsphBEZiDvl8Ud6M/
	 VxdQPlRd+XED/7YxH+zC1BvkIGOJQ+uwfilUcFJg=
Date: Sun, 12 Jan 2025 20:24:02 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-make-squashfs_cache_init-return-err_ptr-enomem.patch removed from -mm tree
Message-Id: <20250113042402.E8C96C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: make squashfs_cache_init() return ERR_PTR(-ENOMEM)
has been removed from the -mm tree.  Its filename was
     squashfs-make-squashfs_cache_init-return-err_ptr-enomem.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: make squashfs_cache_init() return ERR_PTR(-ENOMEM)
Date: Sun, 29 Dec 2024 23:37:49 +0000

Patch series "mm, swap: rework of swap allocator locks".

This patchset reduces the amount of memory that Squashfs uses when
CONFIG_FILE_DIRECT is configured, and updates various out of date
information in the documentation and Kconfig.


This patch (of 4):

Make squashfs_cache_init() return an ERR_PTR(-ENOMEM) on failure rather
than NULL.

This tidies up some calling code, but, it also allows NULL to be returned
as a valid result when a cache hasn't be allocated.

Link: https://lkml.kernel.org/r/20241229233752.54481-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20241229233752.54481-2-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/cache.c |   10 +++++++---
 fs/squashfs/super.c |   17 ++++++++++-------
 2 files changed, 17 insertions(+), 10 deletions(-)

--- a/fs/squashfs/cache.c~squashfs-make-squashfs_cache_init-return-err_ptr-enomem
+++ a/fs/squashfs/cache.c
@@ -224,11 +224,15 @@ struct squashfs_cache *squashfs_cache_in
 	int block_size)
 {
 	int i, j;
-	struct squashfs_cache *cache = kzalloc(sizeof(*cache), GFP_KERNEL);
+	struct squashfs_cache *cache;
 
+	if (entries == 0)
+		return NULL;
+
+	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
 	if (cache == NULL) {
 		ERROR("Failed to allocate %s cache\n", name);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	cache->entry = kcalloc(entries, sizeof(*(cache->entry)), GFP_KERNEL);
@@ -281,7 +285,7 @@ struct squashfs_cache *squashfs_cache_in
 
 cleanup:
 	squashfs_cache_delete(cache);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 
--- a/fs/squashfs/super.c~squashfs-make-squashfs_cache_init-return-err_ptr-enomem
+++ a/fs/squashfs/super.c
@@ -314,26 +314,29 @@ static int squashfs_fill_super(struct su
 	sb->s_flags |= SB_RDONLY;
 	sb->s_op = &squashfs_super_ops;
 
-	err = -ENOMEM;
-
 	msblk->block_cache = squashfs_cache_init("metadata",
 			SQUASHFS_CACHED_BLKS, SQUASHFS_METADATA_SIZE);
-	if (msblk->block_cache == NULL)
+	if (IS_ERR(msblk->block_cache)) {
+		err = PTR_ERR(msblk->block_cache);
 		goto failed_mount;
+	}
 
 	/* Allocate read_page block */
 	msblk->read_page = squashfs_cache_init("data",
 		msblk->max_thread_num, msblk->block_size);
-	if (msblk->read_page == NULL) {
+	if (IS_ERR(msblk->read_page)) {
 		errorf(fc, "Failed to allocate read_page block");
+		err = PTR_ERR(msblk->read_page);
 		goto failed_mount;
 	}
 
 	if (msblk->devblksize == PAGE_SIZE) {
 		struct inode *cache = new_inode(sb);
 
-		if (cache == NULL)
+		if (cache == NULL) {
+			err = -ENOMEM;
 			goto failed_mount;
+		}
 
 		set_nlink(cache, 1);
 		cache->i_size = OFFSET_MAX;
@@ -406,8 +409,8 @@ handle_fragments:
 
 	msblk->fragment_cache = squashfs_cache_init("fragment",
 		min(SQUASHFS_CACHED_FRAGMENTS, fragments), msblk->block_size);
-	if (msblk->fragment_cache == NULL) {
-		err = -ENOMEM;
+	if (IS_ERR(msblk->fragment_cache)) {
+		err = PTR_ERR(msblk->fragment_cache);
 		goto failed_mount;
 	}
 
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


