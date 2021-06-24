Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1B3C49EA5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A4F9613BA
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFXUbp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhFXUbo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1566D61241;
        Thu, 24 Jun 2021 20:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624566565;
        bh=8vRScHVJ3D+c1A45XTkF4lA/WI7bqh+5b99zVuTYvzc=;
        h=Date:From:To:Subject:From;
        b=fsi2X034tlYKraeZuRYSo5jbocf8Vl7YLUgQSEzOQIuBomL30D6R15VCRYLQShtft
         dYmQ/jHOQUSMjZeebPHDBaH2CL7Zlspnv7RGT3vPdZI4l9M8VILVNJTQSkhAzECtPw
         BBvddmQyJQaw3P75HdJL1z2MhDFrnJQd5Y6izAsk=
Date:   Thu, 24 Jun 2021 13:29:24 -0700
From:   akpm@linux-foundation.org
To:     code@tyhicks.com, hch@lst.de, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 mm-require-set_page_dirty-to-be-explicitly-wire-up-fix.patch added to -mm
 tree
Message-ID: <20210624202924.IGqRE-8KR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ecryptfs: add a ->set_page_dirty cludge
has been added to the -mm tree.  Its filename is
     mm-require-set_page_dirty-to-be-explicitly-wire-up-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-require-set_page_dirty-to-be-explicitly-wire-up-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-require-set_page_dirty-to-be-explicitly-wire-up-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-require-set_page_dirty-to-be-explicitly-wire-up-fix.patch

