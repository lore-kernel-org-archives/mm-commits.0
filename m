Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D4FC4320E
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C22B460F41
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhGWWJt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 18:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233043AbhGWWJs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 18:09:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89EBD60F43;
        Fri, 23 Jul 2021 22:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080620;
        bh=VT0jA7M4m+6KxrRNuoL7f5ibGCYI46+8v9WeUxzFHEI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IJ2IBWzDQmXZaqmmKEwGAsB2C1/0AM8Qi1/9ybFRDSA8/+3cjuEAaLg+du5ZJSfx3
         IO/qywRCoAgcu4hCSdzz6LYFZfYpdBIwYLpSPNdDyEpQ5JoUv/C3zZs5URE16Ft2lY
         VFFGEK8m9jKhAnsOOXwYlVInajZuv+fudNRklRag=
Date:   Fri, 23 Jul 2021 15:50:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chaitanya.kulkarni@wdc.com, hch@lst.de,
        ira.weiny@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 07/15] mm: use kmap_local_page in memzero_page
Message-ID: <20210723225020.fbnIBOjkH%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: use kmap_local_page in memzero_page

The commit message introducing the global memzero_page explicitly mentions
switching to kmap_local_page in the commit log but doesn't actually do
that.

Link: https://lkml.kernel.org/r/20210713055231.137602-3-hch@lst.de
Fixes: 28961998f858 ("iov_iter: lift memzero_page() to highmem.h")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/highmem.h~mm-use-kmap_local_page-in-memzero_page
+++ a/include/linux/highmem.h
@@ -324,10 +324,10 @@ static inline void memcpy_to_page(struct
 
 static inline void memzero_page(struct page *page, size_t offset, size_t len)
 {
-	char *addr = kmap_atomic(page);
+	char *addr = kmap_local_page(page);
 	memset(addr + offset, 0, len);
 	flush_dcache_page(page);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 }
 
 #endif /* _LINUX_HIGHMEM_H */
_
