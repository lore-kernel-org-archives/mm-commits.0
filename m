Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357B4C19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiG3BNL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbiG3BNK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC74E8D
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5693661C3A
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD06EC433D6;
        Sat, 30 Jul 2022 01:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143588;
        bh=K3XhXB7AwWj1QLE5LoccdOuFU+raviahTWDdWYJh9Q0=;
        h=Date:To:From:Subject:From;
        b=rMz+MLTQ2daWdL8hZ2Q4NJjvl1/kVckVq+EK5S8OWCpviSODMaFFYYSo6itIIq+zu
         i1YP1dEXqK4bSkqDSgN8f/7oAk7AAFNCfINR16jMMo3gdp8bBWjJWk/7kNXFn8OIeG
         QLomSisdNC5Vzsk2IixJGPALvmDETSlvLHIjB8iM=
Date:   Fri, 29 Jul 2022 18:13:08 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, m.szyprowski@samsung.com, miaoxie@huawei.com,
        lkp@intel.com, hsinyi@chromium.org, houtao1@huawei.com,
        phillip@squashfs.org.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-always-build-file-direct-version-of-page-actor.patch removed from -mm tree
Message-Id: <20220730011308.AD06EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: always build "file direct" version of page actor
has been removed from the -mm tree.  Its filename was
     squashfs-always-build-file-direct-version-of-page-actor.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: always build "file direct" version of page actor
Date: Fri, 17 Jun 2022 16:38:11 +0800

Squashfs_readahead uses the "file direct" version of the page actor, and
so build it unconditionally.

Link: https://lkml.kernel.org/r/20220617083810.337573-3-hsinyi@chromium.org
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


