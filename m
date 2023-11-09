Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30E3C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjKIV5Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjKIV5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:57:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970C63ABF
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:57:22 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327D7C433C8;
        Thu,  9 Nov 2023 21:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699567042;
        bh=NVFoS+ZvEpewYXFoGNpkCh/60SnNoesD6A57eQmOdPw=;
        h=Date:To:From:Subject:From;
        b=W1ump6h+n2CyFcjvgc46bMKEOYkpSAsIvo/2BbCuPYIywvtYxmOz30oc8/9vpfT2m
         LmvB9SwjmCaJ74mScReWq7NnbGFVTR5StfUMJsI+pGUZgoK5DTW+s7YwWrfA65sXw4
         nyfEzwIEgwXcQhgIGHeaFZtVlFVSbIZSmRJggAoI=
Date:   Thu, 09 Nov 2023 13:57:21 -0800
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, konishi.ryusuke@gmail.com, hare@suse.de,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-cast-block-to-loff_t-before-shifting-it.patch added to mm-unstable branch
Message-Id: <20231109215722.327D7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: cast block to loff_t before shifting it
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-cast-block-to-loff_t-before-shifting-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-cast-block-to-loff_t-before-shifting-it.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: cast block to loff_t before shifting it
Date: Thu, 9 Nov 2023 21:06:05 +0000

While sector_t is always defined as a u64 today, that hasn't always been
the case and it might not always be the same size as loff_t in the future.

Link: https://lkml.kernel.org/r/20231109210608.2252323-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/buffer.c~buffer-cast-block-to-loff_t-before-shifting-it
+++ a/fs/buffer.c
@@ -2008,7 +2008,7 @@ static int
 iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
 		const struct iomap *iomap)
 {
-	loff_t offset = block << inode->i_blkbits;
+	loff_t offset = (loff_t)block << inode->i_blkbits;
 
 	bh->b_bdev = iomap->bdev;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch
mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

