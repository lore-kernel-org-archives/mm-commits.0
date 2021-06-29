Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70454C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 581C561D08
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhF2Cii (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231917AbhF2Cie (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DEB661D04;
        Tue, 29 Jun 2021 02:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934166;
        bh=8Q9LZIA0jxgMo3IOZhhdMdUw8zSeSrmEHZ9RsQsK+R4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ss6yDo7jl56TrLcQCBCny500MoofMJj7WRmwtQu7dFtF7shf1RGGX/bMPhrpKKtPO
         utcHaccl/lbofF8503XwN3Yybdqja/elPOIrkDCVc0XyUUzjljpibeYffyMDOV3n+r
         dFxugIv9nco0sYy0hdNVhrIgXXwbXnXKsujZ438w=
Date:   Mon, 28 Jun 2021 19:36:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gregkh@linuxfoundation.org, hch@lst.de,
        jack@suse.cz, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 054/192] fs: unexport __set_page_dirty
Message-ID: <20210629023606.-g3FR-iHP%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
