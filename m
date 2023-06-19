Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0A5EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjFSXM6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjFSXM5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:12:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC5210E2
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B1D360F32
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F52AC433CA;
        Mon, 19 Jun 2023 23:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216320;
        bh=5FGhEb9puv38iAs6kbZKRHvpYRs9iEykp0ungmgSV3Q=;
        h=Date:To:From:Subject:From;
        b=hXx9QD908z4oIXgR/UctO2wMqUzKb3Kpg+O7+qTInOig4N2jJJqehQpHhMBLIuNDA
         jezLk8wb8P+ykGKbN3SrQwTDjLX+f/zmIuuAAesRHfznOQs4ea1AilVRzL9p5rTfOg
         y57B09CdZQUysDVzxNMtDS2K53M0ikd2U0LbNKRQ=
Date:   Mon, 19 Jun 2023 16:11:59 -0700
To:     mm-commits@vger.kernel.org, dan.carpenter@linaro.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] buffer-convert-block_truncate_page-to-use-a-folio-fix.patch removed from -mm tree
Message-Id: <20230619231200.5F52AC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer-convert-block_truncate_page-to-use-a-folio-fix
has been removed from the -mm tree.  Its filename was
     buffer-convert-block_truncate_page-to-use-a-folio-fix.patch

This patch was dropped because it was folded into buffer-convert-block_truncate_page-to-use-a-folio.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: buffer-convert-block_truncate_page-to-use-a-folio-fix
Date: Thu, 15 Jun 2023 19:32:26 +0100

fix check of filemap_grab_folio() return value

Link: https://lkml.kernel.org/r/ZItZOt+XxV12HtzL@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/buffer.c~buffer-convert-block_truncate_page-to-use-a-folio-fix
+++ a/fs/buffer.c
@@ -2617,8 +2617,8 @@ int block_truncate_page(struct address_s
 	iblock = (sector_t)index << (PAGE_SHIFT - inode->i_blkbits);
 	
 	folio = filemap_grab_folio(mapping, index);
-	if (!folio)
-		return -ENOMEM;
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
 
 	bh = folio_buffers(folio);
 	if (!bh) {
_

Patches currently in -mm which might be from willy@infradead.org are

gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch
gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch
gfs2-convert-gfs2_write_jdata_page-to-gfs2_write_jdata_folio.patch
buffer-convert-__block_write_full_page-to-__block_write_full_folio.patch
gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch
buffer-make-block_write_full_page-handle-large-folios-correctly.patch
buffer-convert-block_page_mkwrite-to-use-a-folio.patch
buffer-convert-__block_commit_write-to-take-a-folio.patch
buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers.patch
buffer-convert-grow_dev_page-to-use-a-folio.patch
buffer-convert-init_page_buffers-to-folio_init_buffers.patch
buffer-convert-link_dev_buffers-to-take-a-folio.patch
buffer-use-a-folio-in-__find_get_block_slow.patch
buffer-convert-block_truncate_page-to-use-a-folio.patch

