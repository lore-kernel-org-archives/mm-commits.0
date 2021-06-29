Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21B9C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914B461CF1
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhF2AVz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AVy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:21:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 848AD61CF0;
        Tue, 29 Jun 2021 00:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624925967;
        bh=1Jb0UaT4Jy1scNslYn3jf7q7UQn4P31Xec07yqW5fyg=;
        h=Date:From:To:Subject:From;
        b=ZkyAjJL5d7Hb1KglfOV8PTKUAQm5CfO3E/byX/F6ByR52S3wfPdhIfCtrPwcDbBYC
         qFcDO6/iCi9jGJmKMIsKnIXmZZbnoeQ4VTmWu1JANpzEaoz/rx//itTr9op4BAC5q6
         BxDHcRKC19j1+GRsrudV2AiyKDJse1YaY0iq8RTQ=
Date:   Mon, 28 Jun 2021 17:19:27 -0700
From:   akpm@linux-foundation.org
To:     code@tyhicks.com, hch@lst.de, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [folded-merged]
 mm-require-set_page_dirty-to-be-explicitly-wire-up-fix.patch removed from
 -mm tree
Message-ID: <20210629001927.zgEmNYixL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ecryptfs: add a ->set_page_dirty cludge
has been removed from the -mm tree.  Its filename was
     mm-require-set_page_dirty-to-be-explicitly-wire-up-fix.patch

This patch was dropped because it was folded into mm-require-set_page_dirty-to-be-explicitly-wire-up.patch

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: ecryptfs: add a ->set_page_dirty cludge

"fix" ecryptfs to work the same as before the recent change to the
behavior without a ->set_page_dirty method.

Link: https://lkml.kernel.org/r/20210624125250.536369-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/ecryptfs/mmap.c~mm-require-set_page_dirty-to-be-explicitly-wire-up-fix
+++ a/fs/ecryptfs/mmap.c
@@ -533,7 +533,20 @@ static sector_t ecryptfs_bmap(struct add
 	return block;
 }
 
+#include <linux/buffer_head.h>
+
 const struct address_space_operations ecryptfs_aops = {
+	/*
+	 * XXX: This is pretty broken for multiple reasons: ecryptfs does not
+	 * actually use buffer_heads, and ecryptfs will crash without
+	 * CONFIG_BLOCK.  But it matches the behavior before the default for
+	 * address_space_operations without the ->set_page_dirty method was
+	 * cleaned up, so this is the best we can do without maintainer
+	 * feedback.
+	 */
+#ifdef CONFIG_BLOCK
+	.set_page_dirty = __set_page_dirty_buffers,
+#endif
 	.writepage = ecryptfs_writepage,
 	.readpage = ecryptfs_readpage,
 	.write_begin = ecryptfs_write_begin,
_

Patches currently in -mm which might be from hch@lst.de are

fs-unexport-__set_page_dirty.patch
fs-move-ramfs_aops-to-libfs.patch
mm-require-set_page_dirty-to-be-explicitly-wire-up.patch

