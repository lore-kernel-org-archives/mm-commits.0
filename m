Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3E2C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 552E561D09
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhF2Ci6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhF2Ci5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A181C61D04;
        Tue, 29 Jun 2021 02:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934190;
        bh=bsKDSYkFH1W1S88dtxT6IO6YYh5weC6KFCgXbA6SOLQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cFT9Q6fnjx8k8MpTkJB44tamHWZPLmyAXheGr6FhnDrBZdILPNv9PzzDWFdwyKfuq
         2qaxXpcGiKPzhx1/CabRfKzpnDHeVVvPYl8X1X8E+2QqU0TZAHHT/aGP8s0jQ209jO
         V7xa7dAgLjCRQK0LU1FAdh867+g6SipWwVGL5wgg=
Date:   Mon, 28 Jun 2021 19:36:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 062/192] mm: move page dirtying prototypes from
 mm.h
Message-ID: <20210629023630.7L277w5E4%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move page dirtying prototypes from mm.h

These functions implement the address_space ->set_page_dirty operation and
should live in pagemap.h, not mm.h so that the rest of the kernel doesn't
get funny ideas about calling them directly.

Link: https://lkml.kernel.org/r/20210615162342.1669332-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dax.c           |    1 +
 fs/zonefs/super.c       |    2 +-
 include/linux/mm.h      |    3 ---
 include/linux/pagemap.h |    4 ++++
 4 files changed, 6 insertions(+), 4 deletions(-)

--- a/fs/fuse/dax.c~mm-move-page-dirtying-prototypes-from-mmh
+++ a/fs/fuse/dax.c
@@ -9,6 +9,7 @@
 #include <linux/delay.h>
 #include <linux/dax.h>
 #include <linux/uio.h>
+#include <linux/pagemap.h>
 #include <linux/pfn_t.h>
 #include <linux/iomap.h>
 #include <linux/interval_tree.h>
--- a/fs/zonefs/super.c~mm-move-page-dirtying-prototypes-from-mmh
+++ a/fs/zonefs/super.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2019 Western Digital Corporation or its affiliates.
  */
 #include <linux/module.h>
-#include <linux/fs.h>
+#include <linux/pagemap.h>
 #include <linux/magic.h>
 #include <linux/iomap.h>
 #include <linux/init.h>
--- a/include/linux/mm.h~mm-move-page-dirtying-prototypes-from-mmh
+++ a/include/linux/mm.h
@@ -1850,9 +1850,6 @@ extern int try_to_release_page(struct pa
 extern void do_invalidatepage(struct page *page, unsigned int offset,
 			      unsigned int length);
 
-void __set_page_dirty(struct page *, struct address_space *, int warn);
-int __set_page_dirty_nobuffers(struct page *page);
-int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 void account_page_cleaned(struct page *page, struct address_space *mapping,
--- a/include/linux/pagemap.h~mm-move-page-dirtying-prototypes-from-mmh
+++ a/include/linux/pagemap.h
@@ -702,6 +702,10 @@ int wait_on_page_writeback_killable(stru
 extern void end_page_writeback(struct page *page);
 void wait_for_stable_page(struct page *page);
 
+void __set_page_dirty(struct page *, struct address_space *, int warn);
+int __set_page_dirty_nobuffers(struct page *page);
+int __set_page_dirty_no_writeback(struct page *page);
+
 void page_endio(struct page *page, bool is_write, int err);
 
 /**
_
