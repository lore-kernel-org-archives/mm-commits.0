Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40457C32771
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 17:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbiI1RPM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 13:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbiI1ROa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 13:14:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBDCF1D4C
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 10:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B19AD61CD3
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 17:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FACC433D6;
        Wed, 28 Sep 2022 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664385222;
        bh=PBQ0cBjCg8oZxoOk4fJN2V+BcuFlPPcYn0VB6BWeKt0=;
        h=Date:To:From:Subject:From;
        b=oUbUYxLPQ5kMLSNnuuD8fgvF26Z7OT8qD0RdfRoRNB6yoe3+C3zb/EAIEPzQKoASk
         WzQIqT8aTjGJh6k16ImxeTF4Q/UuWcloF1Wyx168VND9Nv/7QHk02frVsdGEjCfDIc
         3T0QcswsFDoVo43Mg5zR3hCz3q4aAnBCOiy5LKzo=
Date:   Wed, 28 Sep 2022 10:13:36 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org, willy@infradead.org,
        surenb@google.com, josef@toxicpanda.com,
        hsiangkao@linux.alibaba.com, hannes@cmpxchg.org, dsterba@suse.com,
        clm@fb.com, chao@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch removed from -mm tree
Message-Id: <20220928171341.E2FACC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: erofs: add manual PSI accounting for the compressed address space
has been removed from the -mm tree.  Its filename was
     erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: erofs: add manual PSI accounting for the compressed address space
Date: Thu, 15 Sep 2022 10:41:59 +0100

erofs uses an additional address space for compressed data read from disk
in addition to the one directly associated with the inode.  Reading into
the lower address space is open coded using add_to_page_cache_lru instead
of using the filemap.c helper for page allocation micro-optimizations,
which means it is not covered by the MM PSI annotations for ->read_folio
and ->readahead, so add manual ones instead.

Link: https://lkml.kernel.org/r/20220915094200.139713-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/erofs/zdata.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/erofs/zdata.c~erofs-add-manual-psi-accounting-for-the-compressed-address-space
+++ a/fs/erofs/zdata.c
@@ -7,6 +7,7 @@
 #include "zdata.h"
 #include "compress.h"
 #include <linux/prefetch.h>
+#include <linux/psi.h>
 
 #include <trace/events/erofs.h>
 
@@ -1365,6 +1366,8 @@ static void z_erofs_submit_queue(struct
 	struct block_device *last_bdev;
 	unsigned int nr_bios = 0;
 	struct bio *bio = NULL;
+	/* initialize to 1 to make skip psi_memstall_leave unless needed */
+	unsigned long pflags = 1;
 
 	bi_private = jobqueueset_init(sb, q, fgq, force_fg);
 	qtail[JQ_BYPASS] = &q[JQ_BYPASS]->head;
@@ -1414,10 +1417,15 @@ static void z_erofs_submit_queue(struct
 			if (bio && (cur != last_index + 1 ||
 				    last_bdev != mdev.m_bdev)) {
 submit_bio_retry:
+				if (!pflags)
+					psi_memstall_leave(&pflags);
 				submit_bio(bio);
 				bio = NULL;
 			}
 
+			if (unlikely(PageWorkingset(page)))
+				psi_memstall_enter(&pflags);
+
 			if (!bio) {
 				bio = bio_alloc(mdev.m_bdev, BIO_MAX_VECS,
 						REQ_OP_READ, GFP_NOIO);
@@ -1445,8 +1453,11 @@ submit_bio_retry:
 			move_to_bypass_jobqueue(pcl, qtail, owned_head);
 	} while (owned_head != Z_EROFS_PCLUSTER_TAIL);
 
-	if (bio)
+	if (bio) {
+		if (!pflags)
+			psi_memstall_leave(&pflags);
 		submit_bio(bio);
+	}
 
 	/*
 	 * although background is preferred, no one is pending for submission.
_

Patches currently in -mm which might be from hch@lst.de are

block-remove-psi-accounting-from-the-bio-layer.patch

