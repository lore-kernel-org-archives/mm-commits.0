Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F61C88CB2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjFLVu5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbjFLVur (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BD219A
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19F4262F79
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730B3C433EF;
        Mon, 12 Jun 2023 21:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606645;
        bh=EYHQWvTVXMvSm3ShQ0m+nkgSE9nY/XFBbEi4Pe5OHD4=;
        h=Date:To:From:Subject:From;
        b=kMEDmpeG9Av51BbcFmmv/2zBLI2msEJ8LrQTp+jmkZKZQz6cOOuIPle/9C18kJYun
         O9Pz/6OwwD6fSfPuAWDctEQfUTonkq0r8X0MZfz9CfurqaDoASVhfPyF/ZI5nbO0sa
         edsBGcM+dMetT7u5fXzjLj/kgHL5ozv9ISF4eWaQ=
Date:   Mon, 12 Jun 2023 14:50:44 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-use-a-folio-in-__find_get_block_slow.patch added to mm-unstable branch
Message-Id: <20230612215045.730B3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: use a folio in __find_get_block_slow()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-use-a-folio-in-__find_get_block_slow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-use-a-folio-in-__find_get_block_slow.patch

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
Subject: buffer: use a folio in __find_get_block_slow()
Date: Mon, 12 Jun 2023 22:01:40 +0100

Saves a call to compound_head() and may be needed to support block size >
PAGE_SIZE.

Link: https://lkml.kernel.org/r/20230612210141.730128-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/buffer.c~buffer-use-a-folio-in-__find_get_block_slow
+++ a/fs/buffer.c
@@ -195,19 +195,19 @@ __find_get_block_slow(struct block_devic
 	pgoff_t index;
 	struct buffer_head *bh;
 	struct buffer_head *head;
-	struct page *page;
+	struct folio *folio;
 	int all_mapped = 1;
 	static DEFINE_RATELIMIT_STATE(last_warned, HZ, 1);
 
 	index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
-	page = find_get_page_flags(bd_mapping, index, FGP_ACCESSED);
-	if (!page)
+	folio = __filemap_get_folio(bd_mapping, index, FGP_ACCESSED, 0);
+	if (IS_ERR(folio))
 		goto out;
 
 	spin_lock(&bd_mapping->private_lock);
-	if (!page_has_buffers(page))
+	head = folio_buffers(folio);
+	if (!head)
 		goto out_unlock;
-	head = page_buffers(page);
 	bh = head;
 	do {
 		if (!buffer_mapped(bh))
@@ -237,7 +237,7 @@ __find_get_block_slow(struct block_devic
 	}
 out_unlock:
 	spin_unlock(&bd_mapping->private_lock);
-	put_page(page);
+	folio_put(folio);
 out:
 	return ret;
 }
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

