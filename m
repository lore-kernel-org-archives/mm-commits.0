Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4106C32771
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 17:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiI1RPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 13:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiI1ROw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 13:14:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25F0EFF4C
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 10:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99524B8214D
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 17:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30689C433C1;
        Wed, 28 Sep 2022 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664385230;
        bh=owbhd7hk7iJpfcQ/XjDejEZqfEJtYc+WvJMEFA3qBPI=;
        h=Date:To:From:Subject:From;
        b=KmbkvvN/9SROj3WhO7uR6kl3e7S2cShSXNu58PMIwfkEIyZ4gzIB977MSuKr4Gqum
         L3EhnQgJbv/qJ3ei5LVFxt/UOmEe+AQFA7dOqSziFbsalHrk/oCsI0OgF5EM+WG5VI
         LNx/p4h5lC2s/iDfBE+9VtBsaAiKt7kwrUJ0QgYA=
Date:   Wed, 28 Sep 2022 10:13:42 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org, willy@infradead.org,
        surenb@google.com, josef@toxicpanda.com,
        hsiangkao@linux.alibaba.com, hannes@cmpxchg.org, dsterba@suse.com,
        clm@fb.com, chao@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] block-remove-psi-accounting-from-the-bio-layer.patch removed from -mm tree
Message-Id: <20220928171350.30689C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: block: remove PSI accounting from the bio layer
has been removed from the -mm tree.  Its filename was
     block-remove-psi-accounting-from-the-bio-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: block: remove PSI accounting from the bio layer
Date: Thu, 15 Sep 2022 10:42:00 +0100

PSI accounting is now done by the VM code, where it should have been since
the beginning.

Link: https://lkml.kernel.org/r/20220915094200.139713-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio.c               |    8 --------
 block/blk-core.c          |   17 -----------------
 fs/direct-io.c            |    2 --
 include/linux/blk_types.h |    1 -
 4 files changed, 28 deletions(-)

--- a/block/bio.c~block-remove-psi-accounting-from-the-bio-layer
+++ a/block/bio.c
@@ -1067,9 +1067,6 @@ void __bio_add_page(struct bio *bio, str
 
 	bio->bi_iter.bi_size += len;
 	bio->bi_vcnt++;
-
-	if (!bio_flagged(bio, BIO_WORKINGSET) && unlikely(PageWorkingset(page)))
-		bio_set_flag(bio, BIO_WORKINGSET);
 }
 EXPORT_SYMBOL_GPL(__bio_add_page);
 
@@ -1278,9 +1275,6 @@ out:
  * fit into the bio, or are requested in @iter, whatever is smaller. If
  * MM encounters an error pinning the requested pages, it stops. Error
  * is returned only if 0 pages could be pinned.
- *
- * It's intended for direct IO, so doesn't do PSI tracking, the caller is
- * responsible for setting BIO_WORKINGSET if necessary.
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 {
@@ -1296,8 +1290,6 @@ int bio_iov_iter_get_pages(struct bio *b
 		ret = __bio_iov_iter_get_pages(bio, iter);
 	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
 
-	/* don't account direct I/O as memory stall */
-	bio_clear_flag(bio, BIO_WORKINGSET);
 	return bio->bi_vcnt ? 0 : ret;
 }
 EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
--- a/block/blk-core.c~block-remove-psi-accounting-from-the-bio-layer
+++ a/block/blk-core.c
@@ -37,7 +37,6 @@
 #include <linux/t10-pi.h>
 #include <linux/debugfs.h>
 #include <linux/bpf.h>
-#include <linux/psi.h>
 #include <linux/part_stat.h>
 #include <linux/sched/sysctl.h>
 #include <linux/blk-crypto.h>
@@ -829,22 +828,6 @@ void submit_bio(struct bio *bio)
 		count_vm_events(PGPGOUT, bio_sectors(bio));
 	}
 
-	/*
-	 * If we're reading data that is part of the userspace workingset, count
-	 * submission time as memory stall.  When the device is congested, or
-	 * the submitting cgroup IO-throttled, submission can be a significant
-	 * part of overall IO time.
-	 */
-	if (unlikely(bio_op(bio) == REQ_OP_READ &&
-	    bio_flagged(bio, BIO_WORKINGSET))) {
-		unsigned long pflags;
-
-		psi_memstall_enter(&pflags);
-		submit_bio_noacct(bio);
-		psi_memstall_leave(&pflags);
-		return;
-	}
-
 	submit_bio_noacct(bio);
 }
 EXPORT_SYMBOL(submit_bio);
--- a/fs/direct-io.c~block-remove-psi-accounting-from-the-bio-layer
+++ a/fs/direct-io.c
@@ -421,8 +421,6 @@ static inline void dio_bio_submit(struct
 	unsigned long flags;
 
 	bio->bi_private = dio;
-	/* don't account direct I/O as memory stall */
-	bio_clear_flag(bio, BIO_WORKINGSET);
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	dio->refcount++;
--- a/include/linux/blk_types.h~block-remove-psi-accounting-from-the-bio-layer
+++ a/include/linux/blk_types.h
@@ -321,7 +321,6 @@ enum {
 	BIO_NO_PAGE_REF,	/* don't put release vec pages */
 	BIO_CLONED,		/* doesn't own data */
 	BIO_BOUNCED,		/* bio is a bounce bio */
-	BIO_WORKINGSET,		/* contains userspace workingset pages */
 	BIO_QUIET,		/* Make BIO Quiet */
 	BIO_CHAIN,		/* chained bio, ->bi_remaining in effect */
 	BIO_REFFED,		/* bio has elevated ->bi_cnt */
_

Patches currently in -mm which might be from hch@lst.de are


