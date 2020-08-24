Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9280DC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65115207DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598302843;
	bh=2UVoj5zIpFh5ZnIw3wCaV5loZCQ40QoVzpDYjwFtBnY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wuaV1IvYjz/BY/RPv9ojXZlw6+vYp2qKI8fV4gPrccbmqUG75P7aPc2cdqXVSVryy
	 OBWgQLkuvEZy352FCmbj5GO18TYmdYvrywxYcw2DCss7Oyl1DkXdFUzMOQfHQMyzk9
	 iLKyEFiNN934+QlZI4kZTZX74nw//qhbJXR6d04I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHXVAm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727814AbgHXVAj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 17:00:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC053207DF;
        Mon, 24 Aug 2020 21:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598302837;
        bh=2UVoj5zIpFh5ZnIw3wCaV5loZCQ40QoVzpDYjwFtBnY=;
        h=Date:From:To:Subject:From;
        b=TB6Wi60NceN0x3GeS3z44ldQLDbvmZvN3R0z4r56zIMs97Iti3sZvKSkIeb0505Y5
         lqkXwaS49DnXua04HmOg53/OaSaCksu+TdtUjnhRwxkXqysDu0oqx10Ph+3h2KlRP9
         mbcICNgQgYiKy1kNhHV9Cdr/VyY584rjks2BHcHU=
Date:   Mon, 24 Aug 2020 14:00:37 -0700
From:   akpm@linux-foundation.org
To:     hsiangkao@redhat.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity.patch added to -mm
 tree
Message-ID: <20200824210037.uHG9MESL9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: rename SWP_FS to SWAP_FS_OPS to avoid ambiguity
has been added to the -mm tree.  Its filename is
     swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gao Xiang <hsiangkao@redhat.com>
Subject: swap: rename SWP_FS to SWAP_FS_OPS to avoid ambiguity

SWP_FS is used to make swap_{read,write}page() go through the filesystem,
and it's only used for swap files over NFS for now.  Otherwise it will
directly submit IO to blockdev according to swapfile extents reported by
filesystems in advance.

As Matthew pointed out [1], SWP_FS naming is somewhat confusing, so let's
rename to SWP_FS_OPS.

[1] https://lore.kernel.org/r/20200820113448.GM17456@casper.infradead.org

Link: https://lkml.kernel.org/r/20200822113019.11319-1-hsiangkao@redhat.com
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/page_io.c         |    6 +++---
 mm/swap_state.c      |    2 +-
 mm/swapfile.c        |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/swap.h~swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity
+++ a/include/linux/swap.h
@@ -170,7 +170,7 @@ enum {
 	SWP_CONTINUED	= (1 << 5),	/* swap_map has count continuation */
 	SWP_BLKDEV	= (1 << 6),	/* its a block device */
 	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
-	SWP_FS		= (1 << 8),	/* swap file goes through fs */
+	SWP_FS_OPS	= (1 << 8),	/* swapfile operations go through fs */
 	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
--- a/mm/page_io.c~swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity
+++ a/mm/page_io.c
@@ -302,7 +302,7 @@ int __swap_writepage(struct page *page,
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	if (data_race(sis->flags & SWP_FS)) {
+	if (data_race(sis->flags & SWP_FS_OPS)) {
 		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
@@ -393,7 +393,7 @@ int swap_readpage(struct page *page, boo
 		goto out;
 	}
 
-	if (data_race(sis->flags & SWP_FS)) {
+	if (data_race(sis->flags & SWP_FS_OPS)) {
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
@@ -455,7 +455,7 @@ int swap_set_page_dirty(struct page *pag
 {
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	if (data_race(sis->flags & SWP_FS)) {
+	if (data_race(sis->flags & SWP_FS_OPS)) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
 
 		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
--- a/mm/swapfile.c~swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity
+++ a/mm/swapfile.c
@@ -2433,7 +2433,7 @@ static int setup_swap_extents(struct swa
 		if (ret >= 0)
 			sis->flags |= SWP_ACTIVATED;
 		if (!ret) {
-			sis->flags |= SWP_FS;
+			sis->flags |= SWP_FS_OPS;
 			ret = add_swap_extent(sis, 0, sis->max, 0);
 			*span = sis->pages;
 		}
--- a/mm/swap_state.c~swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity
+++ a/mm/swap_state.c
@@ -631,7 +631,7 @@ struct page *swap_cluster_readahead(swp_
 		goto skip;
 
 	/* Test swap type to make sure the dereference is safe */
-	if (likely(si->flags & (SWP_BLKDEV | SWP_FS))) {
+	if (likely(si->flags & (SWP_BLKDEV | SWP_FS_OPS))) {
 		struct inode *inode = si->swap_file->f_mapping->host;
 		if (inode_read_congested(inode))
 			goto skip;
_

Patches currently in -mm which might be from hsiangkao@redhat.com are

mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake.patch
swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity.patch

