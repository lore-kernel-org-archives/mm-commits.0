Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0022CCA473
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 19:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiFFTlJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiFFTlI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 15:41:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C330312A88
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 12:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D669B81B40
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 19:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CF7C34119;
        Mon,  6 Jun 2022 19:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654544463;
        bh=ezZ76usUlRIMfp5yNdtRWXvEwlKZmO2N4DGf0AXr244=;
        h=Date:To:From:Subject:From;
        b=AhwSJqbvE34Z5TV9O4ZhfPCNEYLyJE8IWDEEv1VdIqaHtjfSMimMzv237nX0YPlun
         UurkNm0yXJlh7D7FmKEDucOolqZzpzymMb1WOJAb5xbjCWSD+7DArQYzzGS0eW9QOt
         g7icdeFMTesWA6Cu9eu9LedBCD4DJ2rd9rdhVUYc=
Date:   Mon, 06 Jun 2022 12:41:02 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, m.szyprowski@samsung.com, miaoxie@huawei.com,
        lkp@intel.com, hsinyi@chromium.org, houtao1@huawei.com,
        phillip@squashfs.org.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-always-build-file-direct-version-of-page-actor.patch added to mm-nonmm-unstable branch
Message-Id: <20220606194103.02CF7C34119@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: always build "file direct" version of page actor
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-always-build-file-direct-version-of-page-actor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-always-build-file-direct-version-of-page-actor.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: always build "file direct" version of page actor
Date: Mon, 6 Jun 2022 23:03:04 +0800

Squashfs_readahead uses the "file direct" version of the page
actor, and so build it unconditionally.

Link: https://lkml.kernel.org/r/20220606150305.1883410-3-hsinyi@chromium.org
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Hou Tao <houtao1@huawei.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Xiongwei Song <Xiongwei.Song@windriver.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Zheng Liang <zhengliang6@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/Makefile     |    4 +--
 fs/squashfs/page_actor.h |   41 -------------------------------------
 2 files changed, 2 insertions(+), 43 deletions(-)

--- a/fs/squashfs/Makefile~squashfs-always-build-file-direct-version-of-page-actor
+++ a/fs/squashfs/Makefile
@@ -5,9 +5,9 @@
 
 obj-$(CONFIG_SQUASHFS) += squashfs.o
 squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
-squashfs-y += namei.o super.o symlink.o decompressor.o
+squashfs-y += namei.o super.o symlink.o decompressor.o page_actor.o
 squashfs-$(CONFIG_SQUASHFS_FILE_CACHE) += file_cache.o
-squashfs-$(CONFIG_SQUASHFS_FILE_DIRECT) += file_direct.o page_actor.o
+squashfs-$(CONFIG_SQUASHFS_FILE_DIRECT) += file_direct.o
 squashfs-$(CONFIG_SQUASHFS_DECOMP_SINGLE) += decompressor_single.o
 squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI) += decompressor_multi.o
 squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU) += decompressor_multi_percpu.o
--- a/fs/squashfs/page_actor.h~squashfs-always-build-file-direct-version-of-page-actor
+++ a/fs/squashfs/page_actor.h
@@ -6,46 +6,6 @@
  * Phillip Lougher <phillip@squashfs.org.uk>
  */
 
-#ifndef CONFIG_SQUASHFS_FILE_DIRECT
-struct squashfs_page_actor {
-	void	**page;
-	int	pages;
-	int	length;
-	int	next_page;
-};
-
-static inline struct squashfs_page_actor *squashfs_page_actor_init(void **page,
-	int pages, int length)
-{
-	struct squashfs_page_actor *actor = kmalloc(sizeof(*actor), GFP_KERNEL);
-
-	if (actor == NULL)
-		return NULL;
-
-	actor->length = length ? : pages * PAGE_SIZE;
-	actor->page = page;
-	actor->pages = pages;
-	actor->next_page = 0;
-	return actor;
-}
-
-static inline void *squashfs_first_page(struct squashfs_page_actor *actor)
-{
-	actor->next_page = 1;
-	return actor->page[0];
-}
-
-static inline void *squashfs_next_page(struct squashfs_page_actor *actor)
-{
-	return actor->next_page == actor->pages ? NULL :
-		actor->page[actor->next_page++];
-}
-
-static inline void squashfs_finish_page(struct squashfs_page_actor *actor)
-{
-	/* empty */
-}
-#else
 struct squashfs_page_actor {
 	union {
 		void		**buffer;
@@ -76,4 +36,3 @@ static inline void squashfs_finish_page(
 	actor->squashfs_finish_page(actor);
 }
 #endif
-#endif
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-always-build-file-direct-version-of-page-actor.patch

