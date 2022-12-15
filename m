Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76B3C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiLOXKX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiLOXJn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE64D23383
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 665A5B81CD6
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05364C433EF;
        Thu, 15 Dec 2022 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145776;
        bh=IsRlzrc12y+3glnZGk9KFRn4lHGDRB9satNFLx9fXec=;
        h=Date:To:From:Subject:From;
        b=KdAiBtZkyERensKKyiec+8QC2UJbpfZjm54SIL2KymLW25tweTLjjTq4iFxmK91+M
         UhS+USGQdHyQeeuFlHWv3/qfzaYWNyxG/79pumlZOj4FJYsW1FKZzruEXRQmH3U8LA
         8JWqu3vmxbNm4QPA0ksV2VneGb6fNrqJWBQqvSUM=
Date:   Thu, 15 Dec 2022 15:09:35 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-use-b_folio-in-mark_buffer_dirty.patch added to mm-unstable branch
Message-Id: <20221215230936.05364C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: use b_folio in mark_buffer_dirty()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-use-b_folio-in-mark_buffer_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-use-b_folio-in-mark_buffer_dirty.patch

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
Subject: buffer: use b_folio in mark_buffer_dirty()
Date: Thu, 15 Dec 2022 21:43:57 +0000

Removes about four calls to compound_head().  Two of them are inline which
removes 132 bytes from the kernel text.

Link: https://lkml.kernel.org/r/20221215214402.3522366-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/buffer.c~buffer-use-b_folio-in-mark_buffer_dirty
+++ a/fs/buffer.c
@@ -1095,16 +1095,16 @@ void mark_buffer_dirty(struct buffer_hea
 	}
 
 	if (!test_set_buffer_dirty(bh)) {
-		struct page *page = bh->b_page;
+		struct folio *folio = bh->b_folio;
 		struct address_space *mapping = NULL;
 
-		lock_page_memcg(page);
-		if (!TestSetPageDirty(page)) {
-			mapping = page_mapping(page);
+		folio_memcg_lock(folio);
+		if (!folio_test_set_dirty(folio)) {
+			mapping = folio->mapping;
 			if (mapping)
-				__set_page_dirty(page, mapping, 0);
+				__folio_mark_dirty(folio, mapping, 0);
 		}
-		unlock_page_memcg(page);
+		folio_memcg_unlock(folio);
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch

