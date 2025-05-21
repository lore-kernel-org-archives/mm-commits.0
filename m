Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAA81BCA0E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 20:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860362; cv=none; b=pSLn8lzgzOjWDFt42aYzYOlIdrZsk7WSnxca9ei4K83Qb4KS2oWcZMBTm3oFKaXyoHRaBMPuRCckmf4PYLX5UgVs3xPR+fse2Kd0mpRazcd3iCMjqmPTgKFpPx4xRK2yZPKcvq1TZb4jP9VlcG2gTxkJ+KQthsAVe75T7YAhxgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860362; c=relaxed/simple;
	bh=/tsiL7ZvsNA6cLB0s6+0veEP+1Ghma4vbogsN2lKO+0=;
	h=Date:To:From:Subject:Message-Id; b=lfjHpVZZIDwTJqROoKTefy/sV2T9DT98tOYX66X8GREpFyPhsqsvsfOeu8pSXEXbfey46o2Xqtp6R4OL40j7p1QOHiUz5qAJGG1QFE7x+7a1R2DlHAAK/3fQhQ6pdVW4Q0cgfs3cSnfkFi0TX6mBGFObj2pSfPneKThyu+ntY/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZtHkr+Ta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZtHkr+Ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DB9C4CEE4;
	Wed, 21 May 2025 20:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747860361;
	bh=/tsiL7ZvsNA6cLB0s6+0veEP+1Ghma4vbogsN2lKO+0=;
	h=Date:To:From:Subject:From;
	b=ZtHkr+TaJW8Ltg8KGTe3xpW2/k2CDSe9lonxJX/GBe6Yo3e45DLA42BSthMi0broO
	 kzIec5y2hY0j9V6XVlf4XU02JR+3La0YSMNm4eq9RrrZ3dPpW0wkXG/QyH3mVpPdo8
	 3h4Hv7WkuX7t1OjHC3NZMbggvKARLtKmq43Jv1Jc=
Date: Wed, 21 May 2025 13:46:01 -0700
To: mm-commits@vger.kernel.org,chanho.min@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-add-optional-full-compressed-block-caching.patch added to mm-nonmm-unstable branch
Message-Id: <20250521204601.C7DB9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: add optional full compressed block caching
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-add-optional-full-compressed-block-caching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-add-optional-full-compressed-block-caching.patch

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

squashfs-add-optional-full-compressed-block-caching.patch

