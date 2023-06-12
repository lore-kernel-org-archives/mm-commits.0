Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8A3C88CB5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbjFLVui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbjFLVug (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEDE197
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4861862F72
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993C2C433D2;
        Mon, 12 Jun 2023 21:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606633;
        bh=KFkyl+rDkhaV1r/1PUsdcYvmuqUJvarT6nmXdc/Ed1Y=;
        h=Date:To:From:Subject:From;
        b=SvotjOWuzhOxgByYOU8y50XKBn9gDSRIqEmHB1DvGQFr0fH2UmJe6wgHOO4FHqbA2
         RmIktTBXa10m2Ty/hJ8wgQL+6VulrWD4YoveiCdLW7ytHYS3wswekRUYXQ6Kdl/Qsq
         NCqWauvfrb9o6SoTLg8SyBbVcx6RiPdT9wsB1n24=
Date:   Mon, 12 Jun 2023 14:50:33 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-block_page_mkwrite-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230612215033.993C2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: convert block_page_mkwrite() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-block_page_mkwrite-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-block_page_mkwrite-to-use-a-folio.patch

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

