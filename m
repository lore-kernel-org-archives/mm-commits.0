Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C659CC43467
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9127F22201
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633142;
	bh=umda5VvvFk+Rk1c4Nnne7vL4b2Oth4jSp8pirx9cPXU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kNNTGiVUtOupknw0nuth7CIlq9tfqo9XA3ygsJM1LSfpZP6YmgYROs9btTWpbmG05
	 l0mjbc8+7NpgHKY2EqXVesBedYZMplrFiOQoVn8suzNQZs5WE0PBZkBE1fzD9YjzQU
	 7X7nkYjj6/LsVhmscJjz6Zy/jtRqiKjccphEbLZ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgJMXwW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbgJMXwG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E5B521D7A;
        Tue, 13 Oct 2020 23:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633125;
        bh=umda5VvvFk+Rk1c4Nnne7vL4b2Oth4jSp8pirx9cPXU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OpLHoz6QuvAXzjUZCrBBLErPdm9evNyFMY3bzEzsznxHz2TlVtoIsOBolvaCO81Fr
         jH4n5wN80qh3eVKj9y5qrPJ8IToumtUr+JBJF9qeR5K5YhInPQ8C8Zzs8qcS63cfb+
         Vs/LSE63b7YyDWaX5C37paavNmLJMl+O4KXhYT7s=
Date:   Tue, 13 Oct 2020 16:52:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hsiangkao@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 068/181] swap: rename SWP_FS to SWAP_FS_OPS to
 avoid ambiguity
Message-ID: <20201013235204.X4UTbkTUX%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
