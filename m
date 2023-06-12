Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D148C88CB5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjFLVu5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjFLVup (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BCEE9
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CD6162F78
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5654C433D2;
        Mon, 12 Jun 2023 21:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606643;
        bh=eOK6DuxmlN7UN1fA0xrIuMPVO4mbjRr9qAGQHI9yzmM=;
        h=Date:To:From:Subject:From;
        b=jg5VbiqBieuH7OSGM2QK6dK3vJrHMlVB2fvIIV6tJEcvc1Acft4AKvjxccZro2PM6
         owY/cS5jCg7BdmTc4bvo+jKbWUgVKjW6PnusbAq/4XqUkoNJUh041Zhg1vsthdYXjF
         CVLdMg5lue3CB+XpQ6Pc20gZyY/KGqeGR15OG+SE=
Date:   Mon, 12 Jun 2023 14:50:43 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-link_dev_buffers-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230612215043.A5654C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: convert link_dev_buffers to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-link_dev_buffers-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-link_dev_buffers-to-take-a-folio.patch

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
Subject: buffer: convert link_dev_buffers to take a folio
Date: Mon, 12 Jun 2023 22:01:39 +0100

Its one caller already has a folio, so switch it to use the folio API. 
Removes a hidden call to compound_head().

Link: https://lkml.kernel.org/r/20230612210141.730128-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/buffer.c~buffer-convert-link_dev_buffers-to-take-a-folio
+++ a/fs/buffer.c
@@ -907,8 +907,8 @@ struct buffer_head *alloc_page_buffers(s
 }
 EXPORT_SYMBOL_GPL(alloc_page_buffers);
 
-static inline void
-link_dev_buffers(struct page *page, struct buffer_head *head)
+static inline void link_dev_buffers(struct folio *folio,
+		struct buffer_head *head)
 {
 	struct buffer_head *bh, *tail;
 
@@ -918,7 +918,7 @@ link_dev_buffers(struct page *page, stru
 		bh = bh->b_this_page;
 	} while (bh);
 	tail->b_this_page = head;
-	attach_page_private(page, head);
+	folio_attach_private(folio, head);
 }
 
 static sector_t blkdev_max_block(struct block_device *bdev, unsigned int size)
@@ -1013,7 +1013,7 @@ grow_dev_page(struct block_device *bdev,
 	 * run under the folio lock.
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
-	link_dev_buffers(&folio->page, bh);
+	link_dev_buffers(folio, bh);
 	end_block = folio_init_buffers(folio, bdev,
 			(sector_t)index << sizebits, size);
 	spin_unlock(&inode->i_mapping->private_lock);
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

