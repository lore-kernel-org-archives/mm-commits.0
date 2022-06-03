Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5295CCA482
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 17:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345370AbiFCRwY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346009AbiFCRuk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 13:50:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2CAFD2F
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 10:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43C55B82419
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 17:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F65C385B8;
        Fri,  3 Jun 2022 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654278414;
        bh=RltWqX5lR1HvCE9GMWE6f2Kv+JmkocYLe7Bra+CP5GE=;
        h=Date:To:From:Subject:From;
        b=hnNkNfbulP/igp4a95A+86qfvLqwsveVJSwg6O9zu56Rm53jzGpVpEpvEHoo4wt67
         36IRBjr+W9DypdAl3y0ovOPh6YhDj+sMTqNjrMhzskRuJMbue90wY9i21HaAPpfexm
         LkHadmY6ZGmBcBea3zQGva0tlOlcLP7Ng6BzEFSI=
Date:   Fri, 03 Jun 2022 10:46:53 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, miaoxie@huawei.com, lkp@intel.com,
        hsinyi@chromium.org, houtao1@huawei.com, phillip@squashfs.org.uk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] squashfs-always-build-file-direct-version-of-page-actor.patch removed from -mm tree
Message-Id: <20220603174654.04F65C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: always build "file direct" version of page actor
has been removed from the -mm tree.  Its filename was
     squashfs-always-build-file-direct-version-of-page-actor.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: always build "file direct" version of page actor
Date: Wed, 1 Jun 2022 18:39:21 +0800

Squashfs_readahead uses the "file direct" version of the page actor, and
so build it unconditionally.

Link: https://lkml.kernel.org/r/20220601103922.1338320-3-hsinyi@chromium.org
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Hou Tao <houtao1@huawei.com>
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


