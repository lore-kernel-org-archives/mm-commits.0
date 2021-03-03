Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9456CC433E6
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E31464E7C
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhCDA6q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243134AbhCCWzw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 17:55:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44FF964EF3;
        Wed,  3 Mar 2021 22:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614812090;
        bh=KwqHQxfBe9XeJnF1aFENO5gQgNxghEH84ySgaAA3tQ0=;
        h=Date:From:To:Subject:From;
        b=0FKHQsg8SsCcaE9B9ECJWXDIED7eeUVHf5RnT6Dfy/E/dFlatUKoHfLEA75/RBv4s
         SV3rHciEKD1dnuipRbVG2OVoqAh8hrFGVZNNaeoFUebt5niL6ymk2DQy85KvuZYbdA
         vr+88bJ7WP33g3pVPLxGaXk+KkDG5aSgw6UXZYOw=
Date:   Wed, 03 Mar 2021 14:54:49 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@lst.de, mm-commits@vger.kernel.org
Subject:  [merged] swap-fix-swapfile-read-write-offset.patch
 removed from -mm tree
Message-ID: <20210303225449.9rPBdm3cr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: fix swapfile read/write offset
has been removed from the -mm tree.  Its filename was
     swap-fix-swapfile-read-write-offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: swap: fix swapfile read/write offset

We're not factoring in the start of the file for where to write and read
the swapfile, which leads to very unfortunate side effects of writing
where we should not be...

Link: https://lkml.kernel.org/r/6f9da9c6-c6c5-08fe-95ea-940954456c40@kernel.dk
Fixes: 48d15436fde6 ("mm: remove get_swap_bio")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/page_io.c         |    5 -----
 mm/swapfile.c        |   17 +++++++++++++++--
 3 files changed, 16 insertions(+), 7 deletions(-)

--- a/include/linux/swap.h~swap-fix-swapfile-read-write-offset
+++ a/include/linux/swap.h
@@ -485,6 +485,7 @@ struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+sector_t swap_page_sector(struct page *page);
 
 static inline void put_swap_device(struct swap_info_struct *si)
 {
--- a/mm/page_io.c~swap-fix-swapfile-read-write-offset
+++ a/mm/page_io.c
@@ -254,11 +254,6 @@ out:
 	return ret;
 }
 
-static sector_t swap_page_sector(struct page *page)
-{
-	return (sector_t)__page_file_index(page) << (PAGE_SHIFT - 9);
-}
-
 static inline void count_swpout_vm_event(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
--- a/mm/swapfile.c~swap-fix-swapfile-read-write-offset
+++ a/mm/swapfile.c
@@ -199,8 +199,8 @@ static int discard_swap(struct swap_info
 	return err;		/* That will often be -EOPNOTSUPP */
 }
 
-static struct swap_extent *
-offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
+struct swap_extent *offset_to_swap_extent(struct swap_info_struct *sis,
+					  unsigned long offset)
 {
 	struct swap_extent *se;
 	struct rb_node *rb;
@@ -1858,6 +1858,19 @@ sector_t swapdev_block(int type, pgoff_t
 	return se->start_block + (offset - se->start_page);
 }
 
+sector_t swap_page_sector(struct page *page)
+{
+	struct swap_info_struct *sis = page_swap_info(page);
+	struct swap_extent *se;
+	sector_t sector;
+	pgoff_t offset;
+
+	offset = __page_file_index(page);
+	se = offset_to_swap_extent(sis, offset);
+	sector = se->start_block + (offset - se->start_page);
+	return sector << (PAGE_SHIFT - 9);
+}
+
 /*
  * Return either the total number of swap pages of given type, or the number
  * of free pages of that type (depending on @free)
_

Patches currently in -mm which might be from axboe@kernel.dk are

mm-provide-filemap_range_needs_writeback-helper.patch
mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch
iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch

