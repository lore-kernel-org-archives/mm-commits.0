Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FB5C77B7C
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbjELXMi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjELXMh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 19:12:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E166A7C
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 16:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65C1A654F8
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 23:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5154C433EF;
        Fri, 12 May 2023 23:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683933154;
        bh=eGfsKoMjg9fYGy6pfyfmwxaudw/oTdUUGXUbU9MVLSQ=;
        h=Date:To:From:Subject:From;
        b=2v6Sa88K4/IfGb5n/yC0FcxAkI3CODl63LhMPw5v4zhw6z8c5ZfzDgYNg0EC7wYYc
         09SRAZBTwjhKDZMSbvv4PTyWNbp6o2NO2COOIJsBDLpzQOEe4LDossOSgqsf3ihFXT
         Bi5B1RTc68usO4LoftF0BWsEoIxrzobiY/XhwGnU=
Date:   Fri, 12 May 2023 16:12:34 -0700
To:     mm-commits@vger.kernel.org, pliard@google.com,
        phillip@squashfs.org.uk, hch@lst.de, vincent.whitchurch@axis.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-cache-partial-compressed-blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20230512231234.A5154C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: cache partial compressed blocks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-cache-partial-compressed-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-cache-partial-compressed-blocks.patch

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
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: squashfs: cache partial compressed blocks
Date: Fri, 12 May 2023 15:18:05 +0200

Before commit 93e72b3c612adcaca1 ("squashfs: migrate from ll_rw_block
usage to BIO"), compressed blocks read by squashfs were cached in the page
cache, but that is not the case after that commit.  That has lead to
squashfs having to re-read a lot of sectors from disk/flash.

For example, the first sectors of every metadata block need to be read
twice from the disk.  Once partially to read the length, and a second time
to read the block itself.  Also, in linear reads of large files, the last
sectors of one data block are re-read from disk when reading the next data
block, since the compressed blocks are of variable sizes and not aligned
to device blocks.  This extra I/O results in a degrade in read performance
of, for example, ~16% in one scenario on my ARM platform using squashfs
with dm-verity and NAND.

Since the decompressed data is cached in the page cache or squashfs'
internal metadata and fragment caches, caching _all_ compressed pages
would lead to a lot of double caching and is undesirable.  But make the
code cache any disk blocks which were only partially requested, since
these are the ones likely to include data which is needed by other file
system blocks.  This restores read performance in my test scenario.

The compressed block caching is only applied when the disk block size is
equal to the page size, to avoid having to deal with caching sub-page
reads.

Link: https://lkml.kernel.org/r/20230510-squashfs-cache-v2-1-42a501a17569@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Philippe Liard <pliard@google.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c          |  116 ++++++++++++++++++++++++++++++++-
 fs/squashfs/squashfs_fs_sb.h |    1 
 fs/squashfs/super.c          |   12 +++
 3 files changed, 126 insertions(+), 3 deletions(-)

--- a/fs/squashfs/block.c~squashfs-cache-partial-compressed-blocks
+++ a/fs/squashfs/block.c
@@ -76,10 +76,101 @@ static int copy_bio_to_actor(struct bio
 	return copied_bytes;
 }
 
+static int squashfs_bio_read_cached(struct bio *fullbio, struct address_space *cache_mapping,
+				    u64 index, int length, u64 read_start, u64 read_end,
+				    int page_count)
+{
+	struct page *head_to_cache = NULL, *tail_to_cache = NULL;
+	struct block_device *bdev = fullbio->bi_bdev;
+	struct bvec_iter_all iter_all;
+	struct bio *bio = NULL;
+	int prev_io_idx = -1;
+	struct bio_vec *bv;
+	int idx = 0;
+	int err = 0;
+
+	bio_for_each_segment_all(bv, fullbio, iter_all) {
+		struct page *page = bv->bv_page;
+		int retlen;
+
+		if (page->mapping == cache_mapping && PageUptodate(page)) {
+			idx++;
+			continue;
+		}
+
+		/*
+		 * We only use this when the device block size is the same as
+		 * the page size, so read_start and read_end cover full pages.
+		 *
+		 * Compare these to the original required index and length to
+		 * only cache pages which were requested partially, since these
+		 * are the ones which are likely to be needed when reading
+		 * adjacent blocks.
+		 */
+		if (idx == 0 && index != read_start)
+			head_to_cache = page;
+		else if (idx == page_count - 1 && index + length != read_end)
+			tail_to_cache = page;
+
+		if (!bio || idx != prev_io_idx + 1) {
+			unsigned int remaining_pages;
+			unsigned int this_nr_pages;
+
+submit_and_retry:
+			remaining_pages = page_count - idx;
+			this_nr_pages = min(remaining_pages, BIO_MAX_VECS);
+			bio = blk_next_bio(bio, bdev, this_nr_pages, REQ_OP_READ,
+					   GFP_NOIO);
+			bio->bi_iter.bi_sector = fullbio->bi_iter.bi_sector +
+						 idx * (PAGE_SIZE / SECTOR_SIZE);
+		}
+
+		retlen = bio_add_page(bio, bv->bv_page, bv->bv_len, bv->bv_offset);
+		if (retlen != bv->bv_len)
+			goto submit_and_retry;
+
+		prev_io_idx = idx;
+		idx++;
+	}
+
+	if (bio) {
+		err = submit_bio_wait(bio);
+		bio_put(bio);
+	}
+
+	if (err)
+		return err;
+
+	if (head_to_cache) {
+		int ret = add_to_page_cache_lru(head_to_cache, cache_mapping,
+						read_start, GFP_NOIO);
+
+		if (!ret) {
+			SetPageUptodate(head_to_cache);
+			unlock_page(head_to_cache);
+		}
+
+	}
+
+	if (tail_to_cache) {
+		int ret = add_to_page_cache_lru(tail_to_cache, cache_mapping,
+						read_end - PAGE_SIZE, GFP_NOIO);
+
+		if (!ret) {
+			SetPageUptodate(tail_to_cache);
+			unlock_page(tail_to_cache);
+		}
+	}
+
+	return 0;
+}
+
 static int squashfs_bio_read(struct super_block *sb, u64 index, int length,
 			     struct bio **biop, int *block_offset)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct inode *cache_inode = msblk->cache_inode;
+	struct address_space *cache_mapping = cache_inode ? cache_inode->i_mapping : NULL;
 	const u64 read_start = round_down(index, msblk->devblksize);
 	const sector_t block = read_start >> msblk->devblksize_log2;
 	const u64 read_end = round_up(index + length, msblk->devblksize);
@@ -99,13 +190,27 @@ static int squashfs_bio_read(struct supe
 	for (i = 0; i < page_count; ++i) {
 		unsigned int len =
 			min_t(unsigned int, PAGE_SIZE - offset, total_len);
-		struct page *page = alloc_page(GFP_NOIO);
+		struct page *page = NULL;
+
+		if (cache_mapping)
+			page = find_get_page(cache_mapping,
+					     read_start + i * PAGE_SIZE);
+		if (!page)
+			page = alloc_page(GFP_NOIO);
 
 		if (!page) {
 			error = -ENOMEM;
 			goto out_free_bio;
 		}
-		if (!bio_add_page(bio, page, len, offset)) {
+
+		if (cache_mapping) {
+			/*
+			 * Use the __ version to avoid merging since we need
+			 * each page to be separate when we check for and avoid
+			 * cached pages.
+			 */
+			__bio_add_page(bio, page, len, offset);
+		} else if (!bio_add_page(bio, page, len, offset)) {
 			error = -EIO;
 			goto out_free_bio;
 		}
@@ -113,7 +218,12 @@ static int squashfs_bio_read(struct supe
 		total_len -= len;
 	}
 
-	error = submit_bio_wait(bio);
+	if (cache_mapping)
+		error = squashfs_bio_read_cached(bio, cache_mapping, index,
+						 length, read_start, read_end,
+						 page_count);
+	else
+		error = submit_bio_wait(bio);
 	if (error)
 		goto out_free_bio;
 
--- a/fs/squashfs/squashfs_fs_sb.h~squashfs-cache-partial-compressed-blocks
+++ a/fs/squashfs/squashfs_fs_sb.h
@@ -47,6 +47,7 @@ struct squashfs_sb_info {
 	struct squashfs_cache			*block_cache;
 	struct squashfs_cache			*fragment_cache;
 	struct squashfs_cache			*read_page;
+	struct inode				*cache_inode;
 	int					next_meta_index;
 	__le64					*id_table;
 	__le64					*fragment_index;
--- a/fs/squashfs/super.c~squashfs-cache-partial-compressed-blocks
+++ a/fs/squashfs/super.c
@@ -329,6 +329,16 @@ static int squashfs_fill_super(struct su
 		goto failed_mount;
 	}
 
+	if (msblk->devblksize == PAGE_SIZE) {
+		msblk->cache_inode = new_inode(sb);
+		if (msblk->cache_inode == NULL)
+			goto failed_mount;
+
+		set_nlink(msblk->cache_inode, 1);
+		msblk->cache_inode->i_size = OFFSET_MAX;
+		mapping_set_gfp_mask(msblk->cache_inode->i_mapping, GFP_NOFS);
+	}
+
 	msblk->stream = squashfs_decompressor_setup(sb, flags);
 	if (IS_ERR(msblk->stream)) {
 		err = PTR_ERR(msblk->stream);
@@ -454,6 +464,7 @@ failed_mount:
 	squashfs_cache_delete(msblk->block_cache);
 	squashfs_cache_delete(msblk->fragment_cache);
 	squashfs_cache_delete(msblk->read_page);
+	iput(msblk->cache_inode);
 	msblk->thread_ops->destroy(msblk);
 	kfree(msblk->inode_lookup_table);
 	kfree(msblk->fragment_index);
@@ -572,6 +583,7 @@ static void squashfs_put_super(struct su
 		squashfs_cache_delete(sbi->block_cache);
 		squashfs_cache_delete(sbi->fragment_cache);
 		squashfs_cache_delete(sbi->read_page);
+		iput(sbi->cache_inode);
 		sbi->thread_ops->destroy(sbi);
 		kfree(sbi->id_table);
 		kfree(sbi->fragment_index);
_

Patches currently in -mm which might be from vincent.whitchurch@axis.com are

squashfs-cache-partial-compressed-blocks.patch

