Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F087DC001B3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjFSX0f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjFSXYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B763ECA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 552F660FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6EFC433C8;
        Mon, 19 Jun 2023 23:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216987;
        bh=sUW5atOaZobrOqcsIKenIRioOt+ytkcVstZxhaotTUM=;
        h=Date:To:From:Subject:From;
        b=CG73irXGl5oAclZMJ7VC2ib1ssmCKEsZUXGiPubGV33w/LJCcOg5V2ELUqT3FXuYy
         iG/TkrFBtyYJTaR+rsHuhbUCqoV/sczRYfHgTxk0J3b+d9Hxf0p7NtNImN8ptRlPU+
         pfKdeIcquhKQnPUuxs74gnus3tOaazJk7hjQpwWA=
Date:   Mon, 19 Jun 2023 16:23:07 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-make-block_write_full_page-handle-large-folios-correctly.patch removed from -mm tree
Message-Id: <20230619232307.AF6EFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: make block_write_full_page() handle large folios correctly
has been removed from the -mm tree.  Its filename was
     buffer-make-block_write_full_page-handle-large-folios-correctly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: make block_write_full_page() handle large folios correctly
Date: Mon, 12 Jun 2023 22:01:33 +0100

Keep the interface as struct page, but work entirely on the folio
internally.  Removes several PAGE_SIZE assumptions and removes some
references to page->index and page->mapping.

Link: https://lkml.kernel.org/r/20230612210141.730128-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/fs/buffer.c~buffer-make-block_write_full_page-handle-large-folios-correctly
+++ a/fs/buffer.c
@@ -2678,33 +2678,31 @@ int block_write_full_page(struct page *p
 			struct writeback_control *wbc)
 {
 	struct folio *folio = page_folio(page);
-	struct inode * const inode = page->mapping->host;
+	struct inode * const inode = folio->mapping->host;
 	loff_t i_size = i_size_read(inode);
-	const pgoff_t end_index = i_size >> PAGE_SHIFT;
-	unsigned offset;
 
-	/* Is the page fully inside i_size? */
-	if (page->index < end_index)
+	/* Is the folio fully inside i_size? */
+	if (folio_pos(folio) + folio_size(folio) <= i_size)
 		return __block_write_full_folio(inode, folio, get_block, wbc,
 					       end_buffer_async_write);
 
-	/* Is the page fully outside i_size? (truncate in progress) */
-	offset = i_size & (PAGE_SIZE-1);
-	if (page->index >= end_index+1 || !offset) {
+	/* Is the folio fully outside i_size? (truncate in progress) */
+	if (folio_pos(folio) >= i_size) {
 		folio_unlock(folio);
 		return 0; /* don't care */
 	}
 
 	/*
-	 * The page straddles i_size.  It must be zeroed out on each and every
+	 * The folio straddles i_size.  It must be zeroed out on each and every
 	 * writepage invocation because it may be mmapped.  "A file is mapped
 	 * in multiples of the page size.  For a file that is not a multiple of
-	 * the  page size, the remaining memory is zeroed when mapped, and
+	 * the page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_segment(page, offset, PAGE_SIZE);
+	folio_zero_segment(folio, offset_in_folio(folio, i_size),
+			folio_size(folio));
 	return __block_write_full_folio(inode, folio, get_block, wbc,
-							end_buffer_async_write);
+			end_buffer_async_write);
 }
 EXPORT_SYMBOL(block_write_full_page);
 
_

Patches currently in -mm which might be from willy@infradead.org are


