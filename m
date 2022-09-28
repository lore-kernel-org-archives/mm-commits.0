Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F067CC32771
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 17:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbiI1RO4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 13:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiI1ROL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 13:14:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540ACEDD1B
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 10:13:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45E1861F3B
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 17:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F508C433D7;
        Wed, 28 Sep 2022 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664385215;
        bh=J8qDH5t33/USF0hsCcQTpHmN0eWhxCgPv41q6ouPzcE=;
        h=Date:To:From:Subject:From;
        b=qLgj7/zyC5axSViQ8Jx4lDa8bYlrDCro8POW7nqUb/XoaWNzajAK3UwMb15agy+z9
         XuJclvHtdpn9Ls+hWlmR2s6qZDruALM0XXPBjDWHlxfjmy/DD5pKmn6D/kAPtGNoyg
         pzBWOsfnPUe5eh2x1oI3oGy+4cLhEUTooNGYBeZU=
Date:   Wed, 28 Sep 2022 10:13:28 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org, willy@infradead.org,
        surenb@google.com, josef@toxicpanda.com,
        hsiangkao@linux.alibaba.com, hannes@cmpxchg.org, dsterba@suse.com,
        clm@fb.com, chao@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] btrfs-add-manual-psi-accounting-for-compressed-reads.patch removed from -mm tree
Message-Id: <20220928171335.7F508C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: btrfs: add manual PSI accounting for compressed reads
has been removed from the -mm tree.  Its filename was
     btrfs-add-manual-psi-accounting-for-compressed-reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: btrfs: add manual PSI accounting for compressed reads
Date: Thu, 15 Sep 2022 10:41:58 +0100

btrfs compressed reads try to always read the entire compressed chunk,
even if only a subset is requested.  Currently this is covered by the
magic PSI accounting underneath submit_bio, but that is about to go away. 
Instead add manual psi_memstall_{enter,leave} annotations.

Note that for readahead this really should be using readahead_expand, but
the additionals reads are also done for plain ->read_folio where
readahead_expand can't work, so this overall logic is left as-is for now.

Link: https://lkml.kernel.org/r/20220915094200.139713-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David Sterba <dsterba@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/compression.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/btrfs/compression.c~btrfs-add-manual-psi-accounting-for-compressed-reads
+++ a/fs/btrfs/compression.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
+#include <linux/psi.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
 #include <linux/log2.h>
@@ -518,7 +519,8 @@ static u64 bio_end_offset(struct bio *bi
  */
 static noinline int add_ra_bio_pages(struct inode *inode,
 				     u64 compressed_end,
-				     struct compressed_bio *cb)
+				     struct compressed_bio *cb,
+				     unsigned long *pflags)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	unsigned long end_index;
@@ -587,6 +589,9 @@ static noinline int add_ra_bio_pages(str
 			continue;
 		}
 
+		if (PageWorkingset(page))
+			psi_memstall_enter(pflags);
+
 		ret = set_page_extent_mapped(page);
 		if (ret < 0) {
 			unlock_page(page);
@@ -673,6 +678,8 @@ void btrfs_submit_compressed_read(struct
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
+	/* Initialize to 1 to make skip psi_memstall_leave unless needed */
+	unsigned long pflags = 1;
 	blk_status_t ret;
 	int ret2;
 	int i;
@@ -728,7 +735,7 @@ void btrfs_submit_compressed_read(struct
 		goto fail;
 	}
 
-	add_ra_bio_pages(inode, em_start + em_len, cb);
+	add_ra_bio_pages(inode, em_start + em_len, cb, &pflags);
 
 	/* include any pages we added in add_ra-bio_pages */
 	cb->len = bio->bi_iter.bi_size;
@@ -809,6 +816,9 @@ void btrfs_submit_compressed_read(struct
 		}
 	}
 
+	if (!pflags)
+		psi_memstall_leave(&pflags);
+
 	if (refcount_dec_and_test(&cb->pending_ios))
 		finish_compressed_bio_read(cb);
 	return;
_

Patches currently in -mm which might be from hch@lst.de are

erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch
block-remove-psi-accounting-from-the-bio-layer.patch

