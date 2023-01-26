Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58339C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbjAZBY5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbjAZBYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:24:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7109730DD
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:24:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9A856171B
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44865C433D2;
        Thu, 26 Jan 2023 01:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674696284;
        bh=pMOUJ4Nmsh4KnAfQkogkdmWlNNY7zY4O/nL4+EmBndw=;
        h=Date:To:From:Subject:From;
        b=X0jrgHEL9JReLcsKhkDYEkrHj0K8qdQTPrIbsZiTkSp1xK6OxyP6PBAz5b4RV27lW
         IB5JSojPE2Otgla80QFrRWud8YrwU+RJikqF/RSiqaFoJM4FuiAqbZ1ZqnKLZ1rLue
         GOBHOoVve3K03NXYGhzWJ2qNspD0G5Xz9EXSRtD4=
Date:   Wed, 25 Jan 2023 17:24:43 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mpage-stop-using-bdev_readwrite_page.patch added to mm-unstable branch
Message-Id: <20230126012444.44865C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mpage: stop using bdev_{read,write}_page
has been added to the -mm mm-unstable branch.  Its filename is
     mpage-stop-using-bdev_readwrite_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mpage-stop-using-bdev_readwrite_page.patch

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

revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch
mm-reject-vmap-with-vm_flush_reset_perms.patch
mm-remove-__vfree.patch
mm-remove-__vfree_deferred.patch
mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch
mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch
mm-move-__remove_vm_area-out-of-va_remove_mappings.patch
mm-use-remove_vm_area-in-__vunmap.patch
mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch
mm-split-__vunmap.patch
mm-refactor-va_remove_mappings.patch
mpage-stop-using-bdev_readwrite_page.patch
mm-remove-the-swap_readpage-return-value.patch
mm-factor-out-a-swap_readpage_bdev-helper.patch
mm-use-an-on-stack-bio-for-synchronous-swapin.patch
mm-remove-the-__swap_writepage-return-value.patch
mm-factor-out-a-swap_writepage_bdev-helper.patch
block-remove-rw_page.patch

