Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B5BC48BDF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B6C96137D
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhFOXZf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231463AbhFOXZe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 19:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13AF8613B3;
        Tue, 15 Jun 2021 23:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623799409;
        bh=uqPlqZuhDX4VaBoJgrk1UjGvHwqE0CLNorefNXrOk0Y=;
        h=Date:From:To:Subject:From;
        b=YWIK/sWy4OrZ4iFcEUvQoOegc1wC2F9hCLDWdx7LiQXhq0QsFYv64q1DDKv0+E1pa
         MfcPEMQcFxMULLwtS3QzeKG5J78CWq6cSpVVcskAC6c6c1iLhYMvg2WKU0aRbzrtuh
         Ms5tSaQTNso8bIi5uYK4yasmhVsAYusp2lurgvYE=
Date:   Tue, 15 Jun 2021 16:23:28 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, gregkh@linuxfoundation.org, hch@lst.de,
        jack@suse.cz, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  + mm-move-page-dirtying-prototypes-from-mmh.patch added
 to -mm tree
Message-ID: <20210615232328.kOc2PT08K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move page dirtying prototypes from mm.h
has been added to the -mm tree.  Its filename is
     mm-move-page-dirtying-prototypes-from-mmh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-page-dirtying-prototypes-from-mmh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-page-dirtying-prototypes-from-mmh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -752,6 +752,10 @@ int wait_on_page_writeback_killable(stru
 extern void end_page_writeback(struct page *page);
 void wait_for_stable_page(struct page *page);
 
+void __set_page_dirty(struct page *, struct address_space *, int warn);
+int __set_page_dirty_nobuffers(struct page *page);
+int __set_page_dirty_no_writeback(struct page *page);
+
 void page_endio(struct page *page, bool is_write, int err);
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch
mm-writeback-move-__set_page_dirty-to-core-mm.patch
mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch
iomap-use-__set_page_dirty_nobuffers.patch
fs-remove-anon_set_page_dirty.patch
fs-remove-noop_set_page_dirty.patch
mm-move-page-dirtying-prototypes-from-mmh.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix-2.patch
mm-thp-fix-strncpy-warning.patch

