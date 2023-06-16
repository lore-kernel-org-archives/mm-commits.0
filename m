Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2ADDEB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 19:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjFPT7A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 15:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjFPT67 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 15:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFE01FFF
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 12:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AD75629C8
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 19:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995B4C433C8;
        Fri, 16 Jun 2023 19:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686945537;
        bh=jljZkymNLjYPuyv6oDrcKQhTTEFgaVO6h7+dllXZLk4=;
        h=Date:To:From:Subject:From;
        b=OpXcYwVtrBKKSPsi/X03xlBh3TBxEVAXhqVoT4TuiHfWtHkIR1e2q8Strt819Z7/A
         YkwAFG/AFVtvw0z6ZvbJZXcFt8ZvPwU8yjDjMKtC3drgGsh1DqDbjlsTz51Qj+qrMf
         3LO6ncVOmQ+ihbLP8VXWDcSO5VOeX/ebMwgTuUvs=
Date:   Fri, 16 Jun 2023 12:58:56 -0700
To:     mm-commits@vger.kernel.org, dan.carpenter@linaro.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-block_truncate_page-to-use-a-folio-fix.patch added to mm-unstable branch
Message-Id: <20230616195857.995B4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer-convert-block_truncate_page-to-use-a-folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-block_truncate_page-to-use-a-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-block_truncate_page-to-use-a-folio-fix.patch

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
buffer-convert-block_truncate_page-to-use-a-folio-fix.patch

