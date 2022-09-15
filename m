Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4208ECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 21:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiIOVap (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 17:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiIOVan (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 17:30:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88820956BE
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 14:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 277D86264E
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 21:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BC6C433B5;
        Thu, 15 Sep 2022 21:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663277441;
        bh=k1UofBZZgAgCKhhWx7U6G57wOPEEWpMXJOfve2iplAM=;
        h=Date:To:From:Subject:From;
        b=0G4ja2bprQsBiWTyC7BlY5TeAvabZvKrrZW6yyjW2VzEGvEnyK71Y2yJhcI1rvBfB
         SZMI/FH9D+3CRmLCyefZ7EasVSed0+JmKpZijxWX9OWZEoTOgh2BA3+upDYWxo+T4Z
         6noqHjp6ve/dsRXgRrcogVNqdsr1pNUrG54/wmRI=
Date:   Thu, 15 Sep 2022 14:30:41 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org, willy@infradead.org,
        surenb@google.com, josef@toxicpanda.com,
        hsiangkao@linux.alibaba.com, hannes@cmpxchg.org, dsterba@suse.com,
        clm@fb.com, chao@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + btrfs-add-manual-psi-accounting-for-compressed-reads.patch added to mm-unstable branch
Message-Id: <20220915213041.80BC6C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: add manual PSI accounting for compressed reads
has been added to the -mm mm-unstable branch.  Its filename is
     btrfs-add-manual-psi-accounting-for-compressed-reads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/btrfs-add-manual-psi-accounting-for-compressed-reads.patch

This patch will later appear in the mm-unstable branch at
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

frontswap-dont-call-init-if-no-ops-are-registered.patch
mm-add-psi-accounting-around-read_folio-and-readahead-calls.patch
sched-psi-export-psi_memstall_enterleave.patch
btrfs-add-manual-psi-accounting-for-compressed-reads.patch
erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch
block-remove-psi-accounting-from-the-bio-layer.patch

