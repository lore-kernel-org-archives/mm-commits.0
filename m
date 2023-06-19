Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2CEEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjFSX0h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjFSXYt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE1019BC
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 540BE60F32
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC565C433C8;
        Mon, 19 Jun 2023 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216988;
        bh=58rTfjOnw57Bp8O3fblaYs9qBupcOuflVxw8PBUEfgw=;
        h=Date:To:From:Subject:From;
        b=XkYIeXjYeItctTYpIiUphtuBQqfcVGBMiPA/mj87w+jA1d5vlb6i3swTANHhmUsnC
         zhblG7bbXe6kXp6hekHk86I5/cmuVXfyS+UjgxUR3rmZn2VAMGTXgHx6gCY6W6mPOf
         ov5ICtTRfk1Uu+xX8FQy7aWBEndo0INS/uR6qoH0=
Date:   Mon, 19 Jun 2023 16:23:08 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-convert-block_page_mkwrite-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230619232308.AC565C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: convert block_page_mkwrite() to use a folio
has been removed from the -mm tree.  Its filename was
     buffer-convert-block_page_mkwrite-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: convert block_page_mkwrite() to use a folio
Date: Mon, 12 Jun 2023 22:01:34 +0100

If any page in a folio is dirtied, dirty the entire folio.  Removes a
number of hidden calls to compound_head() and references to page->mapping
and page->index.  Fixes a pre-existing bug where we could mark a folio as
dirty if the file is truncated to a multiple of the page size just as we
take the page fault.  I don't believe this bug has any bad effect, it's
just inefficient.

Link: https://lkml.kernel.org/r/20230612210141.730128-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/fs/buffer.c~buffer-convert-block_page_mkwrite-to-use-a-folio
+++ a/fs/buffer.c
@@ -2564,38 +2564,37 @@ EXPORT_SYMBOL(block_commit_write);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 			 get_block_t get_block)
 {
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	struct inode *inode = file_inode(vma->vm_file);
 	unsigned long end;
 	loff_t size;
 	int ret;
 
-	lock_page(page);
+	folio_lock(folio);
 	size = i_size_read(inode);
-	if ((page->mapping != inode->i_mapping) ||
-	    (page_offset(page) > size)) {
+	if ((folio->mapping != inode->i_mapping) ||
+	    (folio_pos(folio) >= size)) {
 		/* We overload EFAULT to mean page got truncated */
 		ret = -EFAULT;
 		goto out_unlock;
 	}
 
-	/* page is wholly or partially inside EOF */
-	if (((page->index + 1) << PAGE_SHIFT) > size)
-		end = size & ~PAGE_MASK;
-	else
-		end = PAGE_SIZE;
+	end = folio_size(folio);
+	/* folio is wholly or partially inside EOF */
+	if (folio_pos(folio) + end > size)
+		end = size - folio_pos(folio);
 
-	ret = __block_write_begin(page, 0, end, get_block);
+	ret = __block_write_begin_int(folio, 0, end, get_block, NULL);
 	if (!ret)
-		ret = block_commit_write(page, 0, end);
+		ret = block_commit_write(&folio->page, 0, end);
 
 	if (unlikely(ret < 0))
 		goto out_unlock;
-	set_page_dirty(page);
-	wait_for_stable_page(page);
+	folio_mark_dirty(folio);
+	folio_wait_stable(folio);
 	return 0;
 out_unlock:
-	unlock_page(page);
+	folio_unlock(folio);
 	return ret;
 }
 EXPORT_SYMBOL(block_page_mkwrite);
_

Patches currently in -mm which might be from willy@infradead.org are


