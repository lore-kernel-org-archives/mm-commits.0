Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFB5C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 19:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348019AbiFMTRj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241940AbiFMTQm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 15:16:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6845B65E7
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 10:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2419CB811A6
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 17:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5927C34114;
        Mon, 13 Jun 2022 17:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655141374;
        bh=VbDs+kQjKHIZQHEroI6tm+HXELeEcsF2vkLcV+LcMfM=;
        h=Date:To:From:Subject:From;
        b=xPHa3PRSgNOVabGegbnCpSiuEJl0vcm8ZWWNhaQ8qrRe6GNWmXS17gBLZvHV14Jh3
         u/N1MAHadwjtrapT7eooV/BkwJ/fIqJdHg1t/4lt6ZCTv3zeU2gLunEM3n0KorlUPX
         Y1AlU8CXxI1aGyprxT7/MVwALzVHeAmclkDDCIKE=
Date:   Mon, 13 Jun 2022 10:29:34 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, m.szyprowski@samsung.com, miaoxie@huawei.com,
        lkp@intel.com, hsinyi@chromium.org, houtao1@huawei.com,
        phillip@squashfs.org.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-always-build-file-direct-version-of-page-actor.patch added to mm-nonmm-unstable branch
Message-Id: <20220613172934.D5927C34114@smtp.kernel.org>
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
Date: Mon, 13 Jun 2022 16:28:01 +0800

Squashfs_readahead uses the "file direct" version of the page
actor, and so build it unconditionally.

Link: https://lkml.kernel.org/r/20220613082802.1301238-3-hsinyi@chromium.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Hou Tao <houtao1@huawei.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Xiongwei Song <Xiongwei.Song@windriver.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Zheng Liang <zhengliang6@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/Makefile     |    4 +--
 fs/squashfs/page_actor.h |   46 -------------------------------------
 2 files changed, 2 insertions(+), 48 deletions(-)

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
@@ -6,51 +6,6 @@
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
-
-static inline void squashfs_actor_nobuff(struct squashfs_page_actor *actor)
-{
-	/* empty */
-}
-#else
 struct squashfs_page_actor {
 	union {
 		void		**buffer;
@@ -91,4 +46,3 @@ static inline void squashfs_actor_nobuff
 	actor->alloc_buffer = 0;
 }
 #endif
-#endif
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-extend-page-actor-to-handle-missing-pages.patch
squashfs-dont-use-intermediate-buffer-if-pages-missing.patch
squashfs-always-build-file-direct-version-of-page-actor.patch

