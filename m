Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F873EEAA53
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 16:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbjINQGg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241552AbjINQGg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 12:06:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F771BEF
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 09:06:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A78BC433C7;
        Thu, 14 Sep 2023 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694707591;
        bh=9gEQX/2AtKQzZBNK9Q9SGDeE/srDCFCvMC/oEtIzII8=;
        h=Date:To:From:Subject:From;
        b=Fd9UsNkPqm/COnuDm7CfFz/1CuSmbSMyvtaqdHioNvUHAdOs6uEA5hiUBt+Ev9Nr2
         0DQoKexlob0EvdJa+0MKxbL0gWvVyj5M5Ks1uZehRFJOPryZnyFZQF/Ga/Ut9DhX1V
         guKSONBiNqfbhZDz+C/ds8TtTbN+7giqhfRb0JX0=
Date:   Thu, 14 Sep 2023 09:06:30 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-pass-gfp-flags-to-folio_alloc_buffers.patch added to mm-unstable branch
Message-Id: <20230914160631.8A78BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: pass GFP flags to folio_alloc_buffers()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-pass-gfp-flags-to-folio_alloc_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-pass-gfp-flags-to-folio_alloc_buffers.patch

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
@@ -195,7 +195,7 @@ void touch_buffer(struct buffer_head *bh
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

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch

