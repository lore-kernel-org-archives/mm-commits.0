Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF54C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjASBVB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjASBTc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD65A6CCC8
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C37CB81D66
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028EBC433D2;
        Thu, 19 Jan 2023 01:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090986;
        bh=2uj/jCG5nuYc+1iLN8b5/TMA7FSYzgU2PSRHvSpQTC4=;
        h=Date:To:From:Subject:From;
        b=waxds3ls1XsqH8yShx0Nm4VC+Bu1Iu8nUx4Et/9x8FEEn2HV9kePVuputK4z5i5sk
         UUlkbkZw+SeS6kHUThZTPVETxFIF36xO2f/UuBnevnbFcjNvkchh/tKLoKF4SAW3Ks
         VodhOf82+uUdkIVeP0wIDe4Aawxhg74GL5O/OPEE=
Date:   Wed, 18 Jan 2023 17:16:25 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, hch@lst.de, jack@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-dont-allocate-blocks-beyond-eof-from-__mpage_writepage.patch removed from -mm tree
Message-Id: <20230119011626.028EBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: don't allocate blocks beyond EOF from __mpage_writepage
has been removed from the -mm tree.  Its filename was
     fs-dont-allocate-blocks-beyond-eof-from-__mpage_writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fs: don't allocate blocks beyond EOF from __mpage_writepage
Date: Tue, 3 Jan 2023 11:44:30 +0100

When __mpage_writepage() is called for a page beyond EOF, it will go and
allocate all blocks underlying the page.  This is not only unnecessary but
this way blocks can get leaked (e.g.  if a page beyond EOF is marked dirty
but in the end write fails and i_size is not extended).

Link: https://lkml.kernel.org/r/20230103104430.27749-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/mpage.c~fs-dont-allocate-blocks-beyond-eof-from-__mpage_writepage
+++ a/fs/mpage.c
@@ -524,6 +524,12 @@ static int __mpage_writepage(struct page
 	 */
 	BUG_ON(!PageUptodate(page));
 	block_in_file = (sector_t)page->index << (PAGE_SHIFT - blkbits);
+	/*
+	 * Whole page beyond EOF? Skip allocating blocks to avoid leaking
+	 * space.
+	 */
+	if (block_in_file >= (i_size + (1 << blkbits) - 1) >> blkbits)
+		goto page_is_mapped;
 	last_block = (i_size - 1) >> blkbits;
 	map_bh.b_page = page;
 	for (page_block = 0; page_block < blocks_per_page; ) {
_

Patches currently in -mm which might be from jack@suse.cz are


