Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7591BD9D3
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 02:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748400055; cv=none; b=buNlzSxUZY/rDsIPqGmp7OVUvvO8C+0bCWKQKAWtRoWAFM+ZcwxRkZgHvBU9fyyiiWYBjz1YvJxaVoNS1vJHzC46DDAoMS0wnX5eTEaAMcCKBrkXjY2IGdP1yntJVhKCT75roCGs0hISfX6I0NMR3JkMddgl6wVV2TftIUV3V2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748400055; c=relaxed/simple;
	bh=qAqto3/KwPvyBGmjD/nj2GQ7/dkEx/f+mKmuQpfFFUw=;
	h=Date:To:From:Subject:Message-Id; b=TSEk5z496I8p7QmJ//Fz+6AKxItpNaKLzCKJ9RmBbIOoR8qMajXuCaBfUDOuMptrMLzEVw9pyNJ9rjgS6N/fmneNAVBsmqJX0/BRr0Ha4yuz4/Mgb+6txVWzw3pc2A9B2r2VYr5IdcAqNc1IHeO5r7Mblj54T+wC7hKupdutaEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uR9g1/6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uR9g1/6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89455C4CEE9;
	Wed, 28 May 2025 02:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748400054;
	bh=qAqto3/KwPvyBGmjD/nj2GQ7/dkEx/f+mKmuQpfFFUw=;
	h=Date:To:From:Subject:From;
	b=uR9g1/6R8qXMyzY+tXtnwahYdI4IMskXouYl77u+VCh67LjdadXtbUJXCSn6HAM3j
	 z75NJiLMtv1TZN+v/z1jwlS6TvriRZxg7jzxRy92cLrOljlHLSTHDDGrAqfGVzLnhi
	 Y6fkXHW40kesrTVgDocrOpFUaFP8Jt1mfj/6tpm0=
Date: Tue, 27 May 2025 19:40:54 -0700
To: mm-commits@vger.kernel.org,chanho.min@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-add-optional-full-compressed-block-caching.patch removed from -mm tree
Message-Id: <20250528024054.89455C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: add optional full compressed block caching
has been removed from the -mm tree.  Its filename was
     squashfs-add-optional-full-compressed-block-caching.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chanho Min <chanho.min@lge.com>
Subject: squashfs: add optional full compressed block caching
Date: Wed, 21 May 2025 16:25:59 +0900

The commit 93e72b3c612adcaca1 ("squashfs: migrate from ll_rw_block usage
to BIO") removed caching of compressed blocks in SquashFS, causing fio
performance regression in workloads with repeated file reads.  Without
caching, every read triggers disk I/O, severely impacting performance in
tools like fio.

This patch introduces a new CONFIG_SQUASHFS_COMP_CACHE_FULL Kconfig option
to enable caching of all compressed blocks, restoring performance to
pre-BIO migration levels.  When enabled, all pages in a BIO are cached in
the page cache, reducing disk I/O for repeated reads.  The fio test
results with this patch confirm the performance restoration:

For example, fio tests (iodepth=1, numjobs=1,
ioengine=psync) show a notable performance restoration:

Disable CONFIG_SQUASHFS_COMP_CACHE_FULL:
  IOPS=815, BW=102MiB/s (107MB/s)(6113MiB/60001msec)
Enable CONFIG_SQUASHFS_COMP_CACHE_FULL:
  IOPS=2223, BW=278MiB/s (291MB/s)(16.3GiB/59999msec)

The tradeoff is increased memory usage due to caching all compressed
blocks.  The CONFIG_SQUASHFS_COMP_CACHE_FULL option allows users to enable
this feature selectively, balancing performance and memory usage for
workloads with frequent repeated reads.

Link: https://lkml.kernel.org/r/20250521072559.2389-1-chanho.min@lge.com
Signed-off-by: Chanho Min <chanho.min@lge.com>
Reviewed-by Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/Kconfig |   21 +++++++++++++++++++++
 fs/squashfs/block.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- a/fs/squashfs/block.c~squashfs-add-optional-full-compressed-block-caching
+++ a/fs/squashfs/block.c
@@ -88,6 +88,10 @@ static int squashfs_bio_read_cached(stru
 	struct bio_vec *bv;
 	int idx = 0;
 	int err = 0;
+#ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
+	struct page **cache_pages = kmalloc_array(page_count,
+			sizeof(void *), GFP_KERNEL | __GFP_ZERO);
+#endif
 
 	bio_for_each_segment_all(bv, fullbio, iter_all) {
 		struct page *page = bv->bv_page;
@@ -110,6 +114,11 @@ static int squashfs_bio_read_cached(stru
 			head_to_cache = page;
 		else if (idx == page_count - 1 && index + length != read_end)
 			tail_to_cache = page;
+#ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
+		/* Cache all pages in the BIO for repeated reads */
+		else if (cache_pages)
+			cache_pages[idx] = page;
+#endif
 
 		if (!bio || idx != end_idx) {
 			struct bio *new = bio_alloc_clone(bdev, fullbio,
@@ -163,6 +172,25 @@ static int squashfs_bio_read_cached(stru
 		}
 	}
 
+#ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
+	if (!cache_pages)
+		goto out;
+
+	for (idx = 0; idx < page_count; idx++) {
+		if (!cache_pages[idx])
+			continue;
+		int ret = add_to_page_cache_lru(cache_pages[idx], cache_mapping,
+						(read_start >> PAGE_SHIFT) + idx,
+						GFP_NOIO);
+
+		if (!ret) {
+			SetPageUptodate(cache_pages[idx]);
+			unlock_page(cache_pages[idx]);
+		}
+	}
+	kfree(cache_pages);
+out:
+#endif
 	return 0;
 }
 
--- a/fs/squashfs/Kconfig~squashfs-add-optional-full-compressed-block-caching
+++ a/fs/squashfs/Kconfig
@@ -149,6 +149,27 @@ config SQUASHFS_XATTR
 
 	  If unsure, say N.
 
+config SQUASHFS_COMP_CACHE_FULL
+	bool "Enable full caching of compressed blocks"
+	depends on SQUASHFS
+	default n
+	help
+	  This option enables caching of all compressed blocks, Without caching,
+	  repeated reads of the same files trigger excessive disk I/O, significantly
+	  reducinng performance in workloads like fio-based benchmarks.
+
+	  For example, fio tests (iodepth=1, numjobs=1, ioengine=psync) show:
+	   With caching: IOPS=2223, BW=278MiB/s (291MB/s)
+	   Without caching: IOPS=815, BW=102MiB/s (107MB/s)
+
+	  Enabling this option restores performance to pre-regression levels by
+	  caching all compressed blocks in the page cache, reducing disk I/O for
+	  repeated reads. However, this increases memory usage, which may be a
+	  concern in memory-constrained environments.
+
+	  Enable this option if your workload involves frequent repeated reads and
+	  memory usage is not a limiting factor. If unsure, say N.
+
 config SQUASHFS_ZLIB
 	bool "Include support for ZLIB compressed file systems"
 	depends on SQUASHFS
_

Patches currently in -mm which might be from chanho.min@lge.com are


