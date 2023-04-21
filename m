Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D362C77B76
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbjDUVws (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbjDUVwn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF031728
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8C1E65326
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9B4C4339B;
        Fri, 21 Apr 2023 21:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113961;
        bh=b8Ia6CZeCZrziqHrHs33+UHDBLxahUG/RcnW2jptQWA=;
        h=Date:To:From:Subject:From;
        b=EhanpiE9BzGnGEdnzPJI706EZfQdpqeNu+uLg+dReZH66/Zs/zLLsTPqJfu934dUa
         ak0qGG3ms6GUrbWXhWDSj7C9x1+sCcwxTFJY/uY16jKj++Cpa6k+SwuwRpBl4FCW3a
         2h+010CP/lMdwqroKvm5rNRaVwWg+VxYk0Gp9l2M=
Date:   Fri, 21 Apr 2023 14:52:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mcgrof@kernel.org, hare@suse.de,
        brauner@kernel.org, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-buffer-add-folio_create_empty_buffers-helper.patch removed from -mm tree
Message-Id: <20230421215241.4B9B4C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/buffer: add folio_create_empty_buffers helper
has been removed from the -mm tree.  Its filename was
     fs-buffer-add-folio_create_empty_buffers-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: fs/buffer: add folio_create_empty_buffers helper
Date: Mon, 17 Apr 2023 14:36:17 +0200

Folio version of create_empty_buffers().  This is required to convert
create_page_buffers() to folio_create_buffers() later in the series.

It removes several calls to compound_head() as it works directly on folio
compared to create_empty_buffers().  Hence, create_empty_buffers() has
been modified to call folio_create_empty_buffers().

Link: https://lkml.kernel.org/r/20230417123618.22094-4-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   28 +++++++++++++++++-----------
 include/linux/buffer_head.h |    2 ++
 2 files changed, 19 insertions(+), 11 deletions(-)

--- a/fs/buffer.c~fs-buffer-add-folio_create_empty_buffers-helper
+++ a/fs/buffer.c
@@ -1594,18 +1594,17 @@ out:
 }
 EXPORT_SYMBOL(block_invalidate_folio);
 
-
 /*
  * We attach and possibly dirty the buffers atomically wrt
  * block_dirty_folio() via private_lock.  try_to_free_buffers
- * is already excluded via the page lock.
+ * is already excluded via the folio lock.
  */
-void create_empty_buffers(struct page *page,
-			unsigned long blocksize, unsigned long b_state)
+void folio_create_empty_buffers(struct folio *folio, unsigned long blocksize,
+				unsigned long b_state)
 {
 	struct buffer_head *bh, *head, *tail;
 
-	head = alloc_page_buffers(page, blocksize, true);
+	head = folio_alloc_buffers(folio, blocksize, true);
 	bh = head;
 	do {
 		bh->b_state |= b_state;
@@ -1614,19 +1613,26 @@ void create_empty_buffers(struct page *p
 	} while (bh);
 	tail->b_this_page = head;
 
-	spin_lock(&page->mapping->private_lock);
-	if (PageUptodate(page) || PageDirty(page)) {
+	spin_lock(&folio->mapping->private_lock);
+	if (folio_test_uptodate(folio) || folio_test_dirty(folio)) {
 		bh = head;
 		do {
-			if (PageDirty(page))
+			if (folio_test_dirty(folio))
 				set_buffer_dirty(bh);
-			if (PageUptodate(page))
+			if (folio_test_uptodate(folio))
 				set_buffer_uptodate(bh);
 			bh = bh->b_this_page;
 		} while (bh != head);
 	}
-	attach_page_private(page, head);
-	spin_unlock(&page->mapping->private_lock);
+	folio_attach_private(folio, head);
+	spin_unlock(&folio->mapping->private_lock);
+}
+EXPORT_SYMBOL(folio_create_empty_buffers);
+
+void create_empty_buffers(struct page *page,
+			unsigned long blocksize, unsigned long b_state)
+{
+	folio_create_empty_buffers(page_folio(page), blocksize, b_state);
 }
 EXPORT_SYMBOL(create_empty_buffers);
 
--- a/include/linux/buffer_head.h~fs-buffer-add-folio_create_empty_buffers-helper
+++ a/include/linux/buffer_head.h
@@ -205,6 +205,8 @@ struct buffer_head *alloc_page_buffers(s
 		bool retry);
 void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
+void folio_create_empty_buffers(struct folio *folio, unsigned long blocksize,
+				unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_async_write(struct buffer_head *bh, int uptodate);
_

Patches currently in -mm which might be from p.raghav@samsung.com are


