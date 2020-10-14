Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A351DC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 554A822253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709172;
	bh=HAwebTpbqQCpsTm6/PbMGhiGyuApPJGxbxTljr5MKV4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ySTG5Ga//n9PI9qcSGwPhhvrZEXE23mRSTydHdr5KHOGES7q/vjr9RgY8ZRR2h3kw
	 VcnTgS0CzO6Yid+t5ZPv8IhdY3177mLS0VYfnC3zfvtGCE0x9EwcngttBoyoyPJGtI
	 1rqdi1OCjUzALiaj6Np50kXaUMe/61VP5LEfRKNA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbgJNU7c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389499AbgJNU7b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A452820725;
        Wed, 14 Oct 2020 20:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709170;
        bh=HAwebTpbqQCpsTm6/PbMGhiGyuApPJGxbxTljr5MKV4=;
        h=Date:From:To:Subject:From;
        b=NFj/lNK/mx3IuGCy69q645/Uzh3tCY5b72SfHH+kCRuwmRdLPFTbk3JOn4zLnKjaC
         KFAXqjTyzldLrCINXp+nvvi2oSDTvlXtgDZcbDt/Z34hkdBfz4GKHkytix6WnG/Kte
         oEljs19oiEaoVCNVjVqXo2h7AzSAd0NA1pYr1hvg=
Date:   Wed, 14 Oct 2020 13:59:30 -0700
From:   akpm@linux-foundation.org
To:     hsiangkao@redhat.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity.patch removed from -mm
 tree
Message-ID: <20201014205930.SuJjsXeEQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: rename SWP_FS to SWAP_FS_OPS to avoid ambiguity
has been removed from the -mm tree.  Its filename was
     swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -312,7 +312,7 @@ int __swap_writepage(struct page *page,
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	if (data_race(sis->flags & SWP_FS)) {
+	if (data_race(sis->flags & SWP_FS_OPS)) {
 		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
@@ -403,7 +403,7 @@ int swap_readpage(struct page *page, boo
 		goto out;
 	}
 
-	if (data_race(sis->flags & SWP_FS)) {
+	if (data_race(sis->flags & SWP_FS_OPS)) {
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
@@ -467,7 +467,7 @@ int swap_set_page_dirty(struct page *pag
 {
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	if (data_race(sis->flags & SWP_FS)) {
+	if (data_race(sis->flags & SWP_FS_OPS)) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
 
 		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
--- a/mm/swapfile.c~swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity
+++ a/mm/swapfile.c
@@ -2437,7 +2437,7 @@ static int setup_swap_extents(struct swa
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
@@ -665,7 +665,7 @@ struct page *swap_cluster_readahead(swp_
 		goto skip;
 
 	/* Test swap type to make sure the dereference is safe */
-	if (likely(si->flags & (SWP_BLKDEV | SWP_FS))) {
+	if (likely(si->flags & (SWP_BLKDEV | SWP_FS_OPS))) {
 		struct inode *inode = si->swap_file->f_mapping->host;
 		if (inode_read_congested(inode))
 			goto skip;
_

Patches currently in -mm which might be from hsiangkao@redhat.com are


