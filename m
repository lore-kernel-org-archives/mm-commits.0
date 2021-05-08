Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E87C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD516141D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhEHWlm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWll (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8585A6140E;
        Sat,  8 May 2021 22:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513638;
        bh=8dN61m6k2tUNlyHhmZ2dXBJucS0DS7tE1uPWhIIRgYM=;
        h=Date:From:To:Subject:From;
        b=YncWpn1d9fAJsYH0dBUlVC/uKtnbL262IKqbG2D4PR3dyz2jvBgAWhfv2N+F2Q+cP
         /3aIdTWpNAUG9cuE+5BgZswCe83tLmKLeDAhlTTANUdW3GR23E9zdGQSGioO/TNMpX
         ixnIfj27m1mXkxVjfUOqa91W8fvdVgk6LfWRmwhU=
Date:   Sat, 08 May 2021 15:40:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sunrui26@huawei.com,
        willy@infradead.org, zhangshaokun@hisilicon.com
Subject:  [merged] mm-filemap-update-stale-comment.patch removed
 from -mm tree
Message-ID: <20210508224038.ti8uWA8XX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: update stale comment
has been removed from the -mm tree.  Its filename was
     mm-filemap-update-stale-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sunrui26@huawei.com are


