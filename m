Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154ACC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  4 Nov 2022 23:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiKDXbQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKDXbP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2022 19:31:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580D9388A
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 16:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C800462390
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 23:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A68AC433C1;
        Fri,  4 Nov 2022 23:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667604672;
        bh=xdl4PGuG5PZxZH14/GwLzuNcr6JzwSyXdzncHbk+j8o=;
        h=Date:To:From:Subject:From;
        b=yEJpwqlUSb9wOEr+k9LioFDyXeN6A37Jm0bW9YKPDEDWpbCa51nFjUkHoOoFgsfGZ
         iMCXA7WNH6eBF9wKL9YoL/rtHWsxx3jFrNGlwuWRvzRFLYMrFeqFRL3jjIl7XRgVo7
         hZSrtUfgR+Bc62mrWISXxw/vItwpgN+vIG2mj5i0=
Date:   Fri, 04 Nov 2022 16:31:11 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org, surenb@google.com,
        linux@leemhuis.info, josef@toxicpanda.com, hch@lst.de,
        dsterba@suse.com, clm@fb.com, chao@kernel.org, axboe@kernel.dk,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-fix-leaked-psi-pressure-state.patch added to mm-hotfixes-unstable branch
Message-Id: <20221104233112.1A68AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fix leaked psi pressure state
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-fix-leaked-psi-pressure-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-fix-leaked-psi-pressure-state.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: fs: fix leaked psi pressure state
Date: Thu, 3 Nov 2022 17:34:31 -0400

When psi annotations were added to to btrfs compression reads, the psi
state tracking over add_ra_bio_pages and btrfs_submit_compressed_read was
faulty.  A pressure state, once entered, is never left.  This results in
incorrectly elevated pressure, which triggers OOM kills.

pflags record the *previous* memstall state when we enter a new one.  The
code tried to initialize pflags to 1, and then optimize the leave call
when we either didn't enter a memstall, or were already inside a nested
stall.  However, there can be multiple PageWorkingset pages in the bio, at
which point it's that path itself that enters repeatedly and overwrites
pflags.  This causes us to miss the exit.

Enter the stall only once if needed, then unwind correctly.

erofs has the same problem, fix that up too.  And move the memstall exit
past submit_bio() to restore submit accounting originally added by
b8e24a9300b0 ("block: annotate refault stalls from IO submission").

Link: https://lkml.kernel.org/r/Y2UHRqthNUwuIQGS@cmpxchg.org
Fixes: 4088a47e78f9 ("btrfs: add manual PSI accounting for compressed reads")
Fixes: 99486c511f68 ("erofs: add manual PSI accounting for the compressed address space")
Fixes: 118f3663fbc6 ("block: remove PSI accounting from the bio layer")
Link: https://lore.kernel.org/r/d20a0a85-e415-cf78-27f9-77dd7a94bc8d@leemhuis.info/
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
Tested-by: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Sterba <dsterba@suse.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/compression.c |   14 ++++++++------
 fs/erofs/zdata.c       |   18 +++++++++++-------
 2 files changed, 19 insertions(+), 13 deletions(-)

--- a/fs/btrfs/compression.c~fs-fix-leaked-psi-pressure-state
+++ a/fs/btrfs/compression.c
@@ -512,7 +512,7 @@ static u64 bio_end_offset(struct bio *bi
 static noinline int add_ra_bio_pages(struct inode *inode,
 				     u64 compressed_end,
 				     struct compressed_bio *cb,
-				     unsigned long *pflags)
+				     int *memstall, unsigned long *pflags)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	unsigned long end_index;
@@ -581,8 +581,10 @@ static noinline int add_ra_bio_pages(str
 			continue;
 		}
 
-		if (PageWorkingset(page))
+		if (!*memstall && PageWorkingset(page)) {
 			psi_memstall_enter(pflags);
+			*memstall = 1;
+		}
 
 		ret = set_page_extent_mapped(page);
 		if (ret < 0) {
@@ -670,8 +672,8 @@ void btrfs_submit_compressed_read(struct
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
-	/* Initialize to 1 to make skip psi_memstall_leave unless needed */
-	unsigned long pflags = 1;
+	unsigned long pflags;
+	int memstall = 0;
 	blk_status_t ret;
 	int ret2;
 	int i;
@@ -727,7 +729,7 @@ void btrfs_submit_compressed_read(struct
 		goto fail;
 	}
 
-	add_ra_bio_pages(inode, em_start + em_len, cb, &pflags);
+	add_ra_bio_pages(inode, em_start + em_len, cb, &memstall, &pflags);
 
 	/* include any pages we added in add_ra-bio_pages */
 	cb->len = bio->bi_iter.bi_size;
@@ -807,7 +809,7 @@ void btrfs_submit_compressed_read(struct
 		}
 	}
 
-	if (!pflags)
+	if (memstall)
 		psi_memstall_leave(&pflags);
 
 	if (refcount_dec_and_test(&cb->pending_ios))
--- a/fs/erofs/zdata.c~fs-fix-leaked-psi-pressure-state
+++ a/fs/erofs/zdata.c
@@ -1412,8 +1412,8 @@ static void z_erofs_submit_queue(struct
 	struct block_device *last_bdev;
 	unsigned int nr_bios = 0;
 	struct bio *bio = NULL;
-	/* initialize to 1 to make skip psi_memstall_leave unless needed */
-	unsigned long pflags = 1;
+	unsigned long pflags;
+	int memstall = 0;
 
 	bi_private = jobqueueset_init(sb, q, fgq, force_fg);
 	qtail[JQ_BYPASS] = &q[JQ_BYPASS]->head;
@@ -1463,14 +1463,18 @@ static void z_erofs_submit_queue(struct
 			if (bio && (cur != last_index + 1 ||
 				    last_bdev != mdev.m_bdev)) {
 submit_bio_retry:
-				if (!pflags)
-					psi_memstall_leave(&pflags);
 				submit_bio(bio);
+				if (memstall) {
+					psi_memstall_leave(&pflags);
+					memstall = 0;
+				}
 				bio = NULL;
 			}
 
-			if (unlikely(PageWorkingset(page)))
+			if (unlikely(PageWorkingset(page)) && !memstall) {
 				psi_memstall_enter(&pflags);
+				memstall = 1;
+			}
 
 			if (!bio) {
 				bio = bio_alloc(mdev.m_bdev, BIO_MAX_VECS,
@@ -1500,9 +1504,9 @@ submit_bio_retry:
 	} while (owned_head != Z_EROFS_PCLUSTER_TAIL);
 
 	if (bio) {
-		if (!pflags)
-			psi_memstall_leave(&pflags);
 		submit_bio(bio);
+		if (memstall)
+			psi_memstall_leave(&pflags);
 	}
 
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

fs-fix-leaked-psi-pressure-state.patch
mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file.patch
mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats.patch
mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch

