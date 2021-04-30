Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449ECC43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27E6B6146D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhD3F4h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230229AbhD3F4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1647F61459;
        Fri, 30 Apr 2021 05:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762139;
        bh=B6dyTCRZoQXPlc0OoaAziH5ITrLkVTWXFIZMbiJRrPU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HtSc9mu0s4gQ3ERaBW5YBICS6olhG2pGNOCD7RtcrL3Wx2oRHGhkiFcsV1QI02Lsl
         TQJEYT42EJIIx8GjJG40VnUp469UCdHFgKOus8iYz7jPyjZqk60syNZQcGCKOJdPpd
         P3K9EIcVDI8mrVWNlv1S+4rYX/8VMUirs8WZZ6Ds=
Date:   Thu, 29 Apr 2021 22:55:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sunrui26@huawei.com,
        torvalds@linux-foundation.org, willy@infradead.org,
        zhangshaokun@hisilicon.com
Subject:  [patch 048/178] mm/filemap: update stale comment
Message-ID: <20210430055538.TWVW3_28y%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rui Sun <sunrui26@huawei.com>
Subject: mm/filemap: update stale comment

Commit a6de4b4873e1 ("mm: convert find_get_entry to return the head page")
uses @index instead of @offset, but the comment is stale, update it.

Link: https://lkml.kernel.org/r/1617948260-50724-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: Rui Sun <sunrui26@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-update-stale-comment
+++ a/mm/filemap.c
@@ -1767,7 +1767,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  * @mapping: the address_space to search
  * @index: The page cache index.
  *
- * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * Looks up the page cache slot at @mapping & @index.  If there is a
  * page cache page, the head page is returned with an increased refcount.
  *
  * If the slot holds a shadow entry of a previously evicted page, or a
_
