Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB50C77B72
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 00:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjDRAvT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 20:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDRAvQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 20:51:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6672D47
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 17:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6766D62B91
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 00:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC989C433D2;
        Tue, 18 Apr 2023 00:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681779073;
        bh=QN/JgKNhISFF0gjk/hTOLuR0X4H1wveijHMcWvbVMAw=;
        h=Date:To:From:Subject:From;
        b=YOp24F2mebHhrw/5HDQv802ctsjQHmQfnzUz87w3SmeQ4+qMuKTH0ieidDLY9gIUv
         qhVeT0S2yLfc8C2i5WdJx1pL8XB8NV/i/B0HJsJF4A0Vjpk0N67EcAN1uP0dwxN+wd
         6XEVgfo6ib+s7Hpp/wARrzi1jc5hB7iLpf0jHboc=
Date:   Mon, 17 Apr 2023 17:51:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mcgrof@kernel.org, hare@suse.de,
        brauner@kernel.org, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-add-folio_alloc_buffers-helper.patch added to mm-unstable branch
Message-Id: <20230418005113.BC989C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: add folio_alloc_buffers() helper
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-add-folio_alloc_buffers-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-add-folio_alloc_buffers-helper.patch

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
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: buffer: add folio_alloc_buffers() helper
Date: Mon, 17 Apr 2023 14:36:16 +0200

Folio version of alloc_page_buffers() helper.  This is required to convert
create_page_buffers() to folio_create_buffers() later in the series.

alloc_page_buffers() has been modified to call folio_alloc_buffers() which
adds one call to compound_head() but folio_alloc_buffers() removes one
call to compound_head() compared to the existing alloc_page_buffers()
implementation.

Link: https://lkml.kernel.org/r/20230417123618.22094-3-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   23 +++++++++++++++--------
 include/linux/buffer_head.h |    2 ++
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/fs/buffer.c~buffer-add-folio_alloc_buffers-helper
+++ a/fs/buffer.c
@@ -843,7 +843,7 @@ int remove_inode_buffers(struct inode *i
 }
 
 /*
- * Create the appropriate buffers when given a page for data area and
+ * Create the appropriate buffers when given a folio for data area and
  * the size of each buffer.. Use the bh->b_this_page linked list to
  * follow the buffers created.  Return NULL if unable to create more
  * buffers.
@@ -851,8 +851,8 @@ int remove_inode_buffers(struct inode *i
  * The retry flag is used to differentiate async IO (paging, swapping)
  * which may not fail from ordinary buffer allocations.
  */
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
-		bool retry)
+struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
+					bool retry)
 {
 	struct buffer_head *bh, *head;
 	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
@@ -862,12 +862,12 @@ struct buffer_head *alloc_page_buffers(s
 	if (retry)
 		gfp |= __GFP_NOFAIL;
 
-	/* The page lock pins the memcg */
-	memcg = page_memcg(page);
+	/* The folio lock pins the memcg */
+	memcg = folio_memcg(folio);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
-	offset = PAGE_SIZE;
+	offset = folio_size(folio);
 	while ((offset -= size) >= 0) {
 		bh = alloc_buffer_head(gfp);
 		if (!bh)
@@ -879,8 +879,8 @@ struct buffer_head *alloc_page_buffers(s
 
 		bh->b_size = size;
 
-		/* Link the buffer to its page */
-		set_bh_page(bh, page, offset);
+		/* Link the buffer to its folio */
+		folio_set_bh(bh, folio, offset);
 	}
 out:
 	set_active_memcg(old_memcg);
@@ -899,6 +899,13 @@ no_grow:
 
 	goto out;
 }
+EXPORT_SYMBOL_GPL(folio_alloc_buffers);
+
+struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
+				       bool retry)
+{
+	return folio_alloc_buffers(page_folio(page), size, retry);
+}
 EXPORT_SYMBOL_GPL(alloc_page_buffers);
 
 static inline void
--- a/include/linux/buffer_head.h~buffer-add-folio_alloc_buffers-helper
+++ a/include/linux/buffer_head.h
@@ -199,6 +199,8 @@ void set_bh_page(struct buffer_head *bh,
 void folio_set_bh(struct buffer_head *bh, struct folio *folio,
 		  unsigned long offset);
 bool try_to_free_buffers(struct folio *);
+struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
+					bool retry);
 struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		bool retry);
 void create_empty_buffers(struct page *, unsigned long,
_

Patches currently in -mm which might be from p.raghav@samsung.com are

orangefs-use-folios-in-orangefs_readahead.patch
mpage-split-submit_bio-and-bio-end_io-handler-for-reads-and-writes.patch
mpage-use-folios-in-bio-end_io-handler.patch
fs-buffer-add-folio_set_bh-helper.patch
buffer-add-folio_alloc_buffers-helper.patch
fs-buffer-add-folio_create_empty_buffers-helper.patch
fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch

