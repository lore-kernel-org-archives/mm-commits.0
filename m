Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2F2C32771
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 21:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiIOVaz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 17:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIOVap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 17:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FC173319
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 14:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06E506264E
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 21:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618A2C433D7;
        Thu, 15 Sep 2022 21:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663277443;
        bh=pEyMn1I09UDF/svS8IqjEaHLhiDqU3FDmShVHnjfWno=;
        h=Date:To:From:Subject:From;
        b=QL6ECyzoq2bk2FKry7tBmrgYHklhyNBKlahc3nrlwUk0xHNDO3tHPMu8aW/oxNOeH
         WS4cPZbE2Z/72elM39YYkdqPhE5bJGgvDw3gz3wmT70ZNFRahJZ0FRXIjLEGD5I6iF
         ZbrEvTPEeX1QuvqXoiBu/pRdTPPgtCKz4faT1iiM=
Date:   Thu, 15 Sep 2022 14:30:42 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org, willy@infradead.org,
        surenb@google.com, josef@toxicpanda.com,
        hsiangkao@linux.alibaba.com, hannes@cmpxchg.org, dsterba@suse.com,
        clm@fb.com, chao@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch added to mm-unstable branch
Message-Id: <20220915213043.618A2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: erofs: add manual PSI accounting for the compressed address space
has been added to the -mm mm-unstable branch.  Its filename is
     erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch

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

frontswap-dont-call-init-if-no-ops-are-registered.patch
mm-add-psi-accounting-around-read_folio-and-readahead-calls.patch
sched-psi-export-psi_memstall_enterleave.patch
btrfs-add-manual-psi-accounting-for-compressed-reads.patch
erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch
block-remove-psi-accounting-from-the-bio-layer.patch

