Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315CAE7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244754AbjJDUWv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244920AbjJDUW2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467BC1731
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ABBC433C8;
        Wed,  4 Oct 2023 20:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450892;
        bh=QkLy+/iUScRoJmju0RoaiE3kxKS+3xlfBmgWV1R9kR0=;
        h=Date:To:From:Subject:From;
        b=LUhePPp6jheS5Z1chxaCs8/L9c6r8I4aK8hZk1c9AZru8Tvws2+9SZhSOxGm+hxVD
         9b2i3bDfFVBd5xfNwHP00wRyj5m1a5cW2vioy+f0sC2dOxe1b5Z1E9DIZrEBt2UHAO
         Z/tRF52unBaCfVXJJrgIJNTfbIBvDC86bdfjtM3k=
Date:   Wed, 04 Oct 2023 13:21:30 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-pass-gfp-flags-to-folio_alloc_buffers.patch removed from -mm tree
Message-Id: <20231004202132.A7ABBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: pass GFP flags to folio_alloc_buffers()
has been removed from the -mm tree.  Its filename was
     buffer-pass-gfp-flags-to-folio_alloc_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: pass GFP flags to folio_alloc_buffers()
Date: Thu, 14 Sep 2023 16:00:04 +0100

Patch series "Add and use bdev_getblk()", v2.

This patch series fixes a bug reported by Hui Zhu; see proposed
patches v1 and v2:
https://lore.kernel.org/linux-fsdevel/20230811035705.3296-1-teawaterz@linux.alibaba.com/
https://lore.kernel.org/linux-fsdevel/20230811071519.1094-1-teawaterz@linux.alibaba.com/

I decided to go in a rather different direction for this fix, and fix a
related problem at the same time.  I don't think there's any urgency to
rush this into Linus' tree, nor have I marked it for stable.  Reasonable
people may disagree.


This patch (of 8):

Instead of creating entirely new flags, inherit them from grow_dev_page().
The other callers create the same flags that this function used to
create.

Link: https://lkml.kernel.org/r/20230914150011.843330-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230914150011.843330-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hui Zhu <teawater@antgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   17 +++++++++--------
 include/linux/buffer_head.h |    2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/buffer.c~buffer-pass-gfp-flags-to-folio_alloc_buffers
+++ a/fs/buffer.c
@@ -915,16 +915,12 @@ int remove_inode_buffers(struct inode *i
  * which may not fail from ordinary buffer allocations.
  */
 struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
-					bool retry)
+					gfp_t gfp)
 {
 	struct buffer_head *bh, *head;
-	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
 
-	if (retry)
-		gfp |= __GFP_NOFAIL;
-
 	/* The folio lock pins the memcg */
 	memcg = folio_memcg(folio);
 	old_memcg = set_active_memcg(memcg);
@@ -967,7 +963,11 @@ EXPORT_SYMBOL_GPL(folio_alloc_buffers);
 struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 				       bool retry)
 {
-	return folio_alloc_buffers(page_folio(page), size, retry);
+	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
+	if (retry)
+		gfp |= __GFP_NOFAIL;
+
+	return folio_alloc_buffers(page_folio(page), size, gfp);
 }
 EXPORT_SYMBOL_GPL(alloc_page_buffers);
 
@@ -1069,7 +1069,7 @@ grow_dev_page(struct block_device *bdev,
 			goto failed;
 	}
 
-	bh = folio_alloc_buffers(folio, size, true);
+	bh = folio_alloc_buffers(folio, size, gfp_mask | __GFP_ACCOUNT);
 
 	/*
 	 * Link the folio to the buffers and initialise them.  Take the
@@ -1644,8 +1644,9 @@ void folio_create_empty_buffers(struct f
 				unsigned long b_state)
 {
 	struct buffer_head *bh, *head, *tail;
+	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT | __GFP_NOFAIL;
 
-	head = folio_alloc_buffers(folio, blocksize, true);
+	head = folio_alloc_buffers(folio, blocksize, gfp);
 	bh = head;
 	do {
 		bh->b_state |= b_state;
--- a/include/linux/buffer_head.h~buffer-pass-gfp-flags-to-folio_alloc_buffers
+++ a/include/linux/buffer_head.h
@@ -198,7 +198,7 @@ void touch_buffer(struct buffer_head *bh
 void folio_set_bh(struct buffer_head *bh, struct folio *folio,
 		  unsigned long offset);
 struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
-					bool retry);
+					gfp_t gfp);
 struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		bool retry);
 void create_empty_buffers(struct page *, unsigned long,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

