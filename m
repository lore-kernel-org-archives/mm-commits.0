Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE1FC7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjFLVu2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjFLVu1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047EF18E
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CFB562E8C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EB0C433EF;
        Mon, 12 Jun 2023 21:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606625;
        bh=qdoJDu76kRXd08xBmWJWOrhVhkSAUwD9Hbal+xPqiYU=;
        h=Date:To:From:Subject:From;
        b=TZYre4ZDEvwD6t6VPh/MltHP4PL5KkDpdnOQYzvTRsup7sKOTkVB/yQJyfVFD2VeF
         QDt+fU/iUVG5XFYmyKQ7xmG7HE1fQE164Iy0vMVCvGz8QwCpF7Gv8gfkiyDdQFia5S
         lyul4nX/rHVyVJhl+OjGHTi3I+e32Z966s/B0Qms=
Date:   Mon, 12 Jun 2023 14:50:24 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-convert-gfs2_write_jdata_page-to-gfs2_write_jdata_folio.patch added to mm-unstable branch
Message-Id: <20230612215024.E2EB0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: convert gfs2_write_jdata_page() to gfs2_write_jdata_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-convert-gfs2_write_jdata_page-to-gfs2_write_jdata_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-convert-gfs2_write_jdata_page-to-gfs2_write_jdata_folio.patch

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
Subject: gfs2: convert gfs2_write_jdata_page() to gfs2_write_jdata_folio()
Date: Mon, 12 Jun 2023 22:01:30 +0100

Add support for large folios and remove some accesses to page->mapping and
page->index.

Link: https://lkml.kernel.org/r/20230612210141.730128-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/aops.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/fs/gfs2/aops.c~gfs2-convert-gfs2_write_jdata_page-to-gfs2_write_jdata_folio
+++ a/fs/gfs2/aops.c
@@ -82,33 +82,33 @@ static int gfs2_get_block_noalloc(struct
 }
 
 /**
- * gfs2_write_jdata_page - gfs2 jdata-specific version of block_write_full_page
- * @page: The page to write
+ * gfs2_write_jdata_folio - gfs2 jdata-specific version of block_write_full_page
+ * @folio: The folio to write
  * @wbc: The writeback control
  *
  * This is the same as calling block_write_full_page, but it also
  * writes pages outside of i_size
  */
-static int gfs2_write_jdata_page(struct page *page,
+static int gfs2_write_jdata_folio(struct folio *folio,
 				 struct writeback_control *wbc)
 {
-	struct inode * const inode = page->mapping->host;
+	struct inode * const inode = folio->mapping->host;
 	loff_t i_size = i_size_read(inode);
-	const pgoff_t end_index = i_size >> PAGE_SHIFT;
-	unsigned offset;
 
 	/*
-	 * The page straddles i_size.  It must be zeroed out on each and every
+	 * The folio straddles i_size.  It must be zeroed out on each and every
 	 * writepage invocation because it may be mmapped.  "A file is mapped
 	 * in multiples of the page size.  For a file that is not a multiple of
-	 * the  page size, the remaining memory is zeroed when mapped, and
+	 * the page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	offset = i_size & (PAGE_SIZE - 1);
-	if (page->index == end_index && offset)
-		zero_user_segment(page, offset, PAGE_SIZE);
+	if (folio_pos(folio) < i_size &&
+	    i_size < folio_pos(folio) + folio_size(folio))
+		folio_zero_segment(folio, offset_in_folio(folio, i_size),
+				folio_size(folio));
 
-	return __block_write_full_page(inode, page, gfs2_get_block_noalloc, wbc,
+	return __block_write_full_page(inode, &folio->page,
+				       gfs2_get_block_noalloc, wbc,
 				       end_buffer_async_write);
 }
 
@@ -137,7 +137,7 @@ static int __gfs2_jdata_write_folio(stru
 		}
 		gfs2_trans_add_databufs(ip, folio, 0, folio_size(folio));
 	}
-	return gfs2_write_jdata_page(&folio->page, wbc);
+	return gfs2_write_jdata_folio(folio, wbc);
 }
 
 /**
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

