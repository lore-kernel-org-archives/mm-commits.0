Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F599C2B9F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73C95613DF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhFOAWb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 20:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229689AbhFOAWb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 20:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E03613CD;
        Tue, 15 Jun 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623716411;
        bh=58lylFHV/bF/ycLezCu5H251MYBLbCCIlq2+/zN7ctU=;
        h=Date:From:To:Subject:From;
        b=UGj6bQ136cPIDTQGyQzfSDLKTN9jrwEpEfumDTiL9ybo0qIYef1SY6lLwhb1Kow0F
         smdTBbOr7kxUJgNp/GCI9uMzZ2yjzPGVPqu11tGdbV5dUQ+7VnXa3EG1dJ4T7/IbYQ
         1MA5X2Qf1ia53gSJAEKHkwLjwgDTbLVmgSAoXX4s=
Date:   Mon, 14 Jun 2021 17:20:10 -0700
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  + fs-unexport-__set_page_dirty.patch added to -mm tree
Message-ID: <20210615002010.n8U1pcT-W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: unexport __set_page_dirty
has been added to the -mm tree.  Its filename is
     fs-unexport-__set_page_dirty.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-unexport-__set_page_dirty.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-unexport-__set_page_dirty.patch

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
Subject: fs: unexport __set_page_dirty

Patch series "remove the implicit .set_page_dirty default".

This series cleans up a few lose ends around ->set_page_dirty, most
importantly removes the default to the buffer head based on if no method
is wired up.


This patch (of 3):

__set_page_dirty is only used by built-in code.

Link: https://lkml.kernel.org/r/20210614061512.3966143-1-hch@lst.de
Link: https://lkml.kernel.org/r/20210614061512.3966143-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/buffer.c~fs-unexport-__set_page_dirty
+++ a/fs/buffer.c
@@ -611,7 +611,6 @@ void __set_page_dirty(struct page *page,
 	}
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
-EXPORT_SYMBOL_GPL(__set_page_dirty);
 
 /*
  * Add a page to the dirty page list.
_

Patches currently in -mm which might be from hch@lst.de are

fs-unexport-__set_page_dirty.patch
fs-move-ramfs_aops-to-libfs.patch
mm-require-set_page_dirty-to-be-explicitly-wire-up.patch

