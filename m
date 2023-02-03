Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5662C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjBCGoX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjBCGmm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619AE2C67D
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F10CF61DAB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52878C4339C;
        Fri,  3 Feb 2023 06:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406322;
        bh=NESSaKSwrCjSHgTWf64bsqKDr3RQKA1qPKVqL9x+S/s=;
        h=Date:To:From:Subject:From;
        b=nzmT1lXfMeOPheiyJN7ktCO/qt9AFOKrX8nrPd4ODAHbqN1bG9hDoeNcxlEoem61d
         7hdRv5RYqX1aXaNRK4uPI89gi0XAnkPSXG0VS6GoZb3wmwn9O+hGl0a9qjHhvPvcJH
         oiIGnHO0WM99esoHvMZDhmZFxMv6wUdd6ylNQOE0=
Date:   Thu, 02 Feb 2023 22:38:41 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mpage-stop-using-bdev_readwrite_page.patch removed from -mm tree
Message-Id: <20230203063842.52878C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mpage: stop using bdev_{read,write}_page
has been removed from the -mm tree.  Its filename was
     mpage-stop-using-bdev_readwrite_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mpage: stop using bdev_{read,write}_page
Date: Wed, 25 Jan 2023 14:34:30 +0100

Patch series "remove ->rw_page".

This series removes the ->rw_page block_device_operation, which is an old
and clumsy attempt at a simple read/write fast path for the block layer. 
It isn't actually used by the fastest block layer operations that we
support (polled I/O through io_uring), but only used by the mpage buffered
I/O helpers which are some of the slowest I/O we have and do not make any
difference there at all, and zram which is a block device abused to
duplicate the zram functionality.

Given that zram is heavily used we need to make sure there is a good
replacement for synchronous I/O, so this series adds a new flag for
drivers that complete I/O synchronously and uses that flag to use on-stack
bios and synchronous submission for them in the swap code.


This patch (of 7):

These are micro-optimizations for synchronous I/O, which do not matter
compared to all the other inefficiencies in the legacy buffer_head based
mpage code.

Link: https://lkml.kernel.org/r/20230125133436.447864-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230125133436.447864-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/mpage.c~mpage-stop-using-bdev_readwrite_page
+++ a/fs/mpage.c
@@ -269,11 +269,6 @@ static struct bio *do_mpage_readpage(str
 
 alloc_new:
 	if (args->bio == NULL) {
-		if (first_hole == blocks_per_page) {
-			if (!bdev_read_page(bdev, blocks[0] << (blkbits - 9),
-								&folio->page))
-				goto out;
-		}
 		args->bio = bio_alloc(bdev, bio_max_segs(args->nr_pages), opf,
 				      gfp);
 		if (args->bio == NULL)
@@ -585,11 +580,6 @@ page_is_mapped:
 
 alloc_new:
 	if (bio == NULL) {
-		if (first_unmapped == blocks_per_page) {
-			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
-								page, wbc))
-				goto out;
-		}
 		bio = bio_alloc(bdev, BIO_MAX_VECS,
 				REQ_OP_WRITE | wbc_to_write_flags(wbc),
 				GFP_NOFS);
_

Patches currently in -mm which might be from hch@lst.de are


