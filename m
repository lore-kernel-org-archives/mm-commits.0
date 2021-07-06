Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7606CC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57C8761955
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhGFTMv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhGFTMv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 911436128D;
        Tue,  6 Jul 2021 19:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598611;
        bh=qqGINUHCqCie/+r8swHqAzzlzdc76c5tKEdZZhy4alA=;
        h=Date:From:To:Subject:From;
        b=YB8o/grC98T/Y4e7bSDZaY0MA4mE3pM7Gto8L94FLy2l9eC+zIyb13Cr8nGsNHAeA
         f/WxXkRfLPgZgSMx19Gh1afIgw1nTjn6WAG+cze8ERHcbc62KGwAS8TYnXcaFQVGCn
         wL/+sCS9SLBmGMrpJZ4Oif8Cv8ppcdclEDShm3qU=
Date:   Tue, 06 Jul 2021 12:10:11 -0700
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [merged] fs-unexport-__set_page_dirty.patch removed from
 -mm tree
Message-ID: <20210706191011.uxSt_ua10%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: unexport __set_page_dirty
has been removed from the -mm tree.  Its filename was
     fs-unexport-__set_page_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


