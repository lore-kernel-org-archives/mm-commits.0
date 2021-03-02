Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD9EC433DB
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF6B64F39
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCBXee (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361114AbhCBXZX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:25:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C93764F32;
        Tue,  2 Mar 2021 23:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614727482;
        bh=rUH74RPxqp5qmngMmsLmE5yxVHOSEoW4+uUqe7IJdLM=;
        h=Date:From:To:Subject:From;
        b=0ntZLBVLoEnB/d7P630wSaTH/0VvO4DOvLsK/jLtTnwGVr+c+/Nb20mf3tOKPxwcB
         uLvhe0KLnDdocP6WA24JSBQgNIjXqRK1WbTtVQjTPKQMePP0fzfG2OeRSGYla6Mg4J
         5+tgaitMyWWJrxGpoem5xsb4YAb3snXdlD2sACSA=
Date:   Tue, 02 Mar 2021 15:24:41 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@lst.de, mm-commits@vger.kernel.org
Subject:  + swap-fix-swapfile-read-write-offset.patch added to -mm
 tree
Message-ID: <20210302232441.wpJ0EuO_2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: fix swapfile read/write offset
has been added to the -mm tree.  Its filename is
     swap-fix-swapfile-read-write-offset.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/swap-fix-swapfile-read-write-offset.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/swap-fix-swapfile-read-write-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

swap-fix-swapfile-read-write-offset.patch

