Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49F2C25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjJYXsE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjJYXrx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:47:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DB913D
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D884DC433C8;
        Wed, 25 Oct 2023 23:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277670;
        bh=QG8FnqG4jtDwvCLHSQGPe+qK2sbdYLh7MMmMAzZMgjM=;
        h=Date:To:From:Subject:From;
        b=ALGMkZLWfCwJ9fTPWf5nEvns+dif2iODIxqzwcOOmFPf2a/txAok3Bpge/uXoqmOv
         l6q3jJIifzmdRxP/b+rXG/7fIcHNFT0C1eHT+Be2QlYDJvJxkGNtF0HjDP36nlGyvX
         yUWsnnvndXTnd26P+LwJkrzz+7amuhYobwFhTqRI=
Date:   Wed, 25 Oct 2023 16:47:50 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch removed from -mm tree
Message-Id: <20231025234750.D884DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: make folio_create_empty_buffers() return a buffer_head
has been removed from the -mm tree.  Its filename was
     buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: make folio_create_empty_buffers() return a buffer_head
Date: Mon, 16 Oct 2023 21:10:49 +0100

Patch series "Finish the create_empty_buffers() transition", v2.

Pankaj recently added folio_create_empty_buffers() as the folio equivalent
to create_empty_buffers().  This patch set finishes the conversion by
first converting all remaining filesystems to call
folio_create_empty_buffers(), then renaming it back to
create_empty_buffers().  I took the opportunity to make a few
simplifications like making folio_create_empty_buffers() return the head
buffer and extracting get_nth_bh() from nilfs2.

A few of the patches in this series aren't directly related to
create_empty_buffers(), but I saw them while I was working on this and
thought they'd be easy enough to add to this series.  Compile-tested only,
other than ext4.


This patch (of 26):

Almost all callers want to know the first BH that was allocated for this
folio.  We already have that handy, so return it.

Link: https://lkml.kernel.org/r/20231016201114.1928083-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231016201114.1928083-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   24 +++++++++++++-----------
 include/linux/buffer_head.h |    4 ++--
 2 files changed, 15 insertions(+), 13 deletions(-)

--- a/fs/buffer.c~buffer-make-folio_create_empty_buffers-return-a-buffer_head
+++ a/fs/buffer.c
@@ -1641,8 +1641,8 @@ EXPORT_SYMBOL(block_invalidate_folio);
  * block_dirty_folio() via private_lock.  try_to_free_buffers
  * is already excluded via the folio lock.
  */
-void folio_create_empty_buffers(struct folio *folio, unsigned long blocksize,
-				unsigned long b_state)
+struct buffer_head *folio_create_empty_buffers(struct folio *folio,
+		unsigned long blocksize, unsigned long b_state)
 {
 	struct buffer_head *bh, *head, *tail;
 	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT | __GFP_NOFAIL;
@@ -1669,6 +1669,8 @@ void folio_create_empty_buffers(struct f
 	}
 	folio_attach_private(folio, head);
 	spin_unlock(&folio->mapping->private_lock);
+
+	return head;
 }
 EXPORT_SYMBOL(folio_create_empty_buffers);
 
@@ -1770,13 +1772,15 @@ static struct buffer_head *folio_create_
 						struct inode *inode,
 						unsigned int b_state)
 {
+	struct buffer_head *bh;
+
 	BUG_ON(!folio_test_locked(folio));
 
-	if (!folio_buffers(folio))
-		folio_create_empty_buffers(folio,
-					   1 << READ_ONCE(inode->i_blkbits),
-					   b_state);
-	return folio_buffers(folio);
+	bh = folio_buffers(folio);
+	if (!bh)
+		bh = folio_create_empty_buffers(folio,
+				1 << READ_ONCE(inode->i_blkbits), b_state);
+	return bh;
 }
 
 /*
@@ -2676,10 +2680,8 @@ int block_truncate_page(struct address_s
 		return PTR_ERR(folio);
 
 	bh = folio_buffers(folio);
-	if (!bh) {
-		folio_create_empty_buffers(folio, blocksize, 0);
-		bh = folio_buffers(folio);
-	}
+	if (!bh)
+		bh = folio_create_empty_buffers(folio, blocksize, 0);
 
 	/* Find the buffer that contains "offset" */
 	offset = offset_in_folio(folio, from);
--- a/include/linux/buffer_head.h~buffer-make-folio_create_empty_buffers-return-a-buffer_head
+++ a/include/linux/buffer_head.h
@@ -203,8 +203,8 @@ struct buffer_head *alloc_page_buffers(s
 		bool retry);
 void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
-void folio_create_empty_buffers(struct folio *folio, unsigned long blocksize,
-				unsigned long b_state);
+struct buffer_head *folio_create_empty_buffers(struct folio *folio,
+		unsigned long blocksize, unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_async_write(struct buffer_head *bh, int uptodate);
_

Patches currently in -mm which might be from willy@infradead.org are


