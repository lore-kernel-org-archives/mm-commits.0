Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE20C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A347F2224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709180;
	bh=3o/tc3gzBIEDgcXeKbyVwp8fwo1oa81J7CufsZ0WYF4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WDhBs1t+KbtelPnS1F1pnbEXKkZcr2kkv6rxBeCekhZvL2QsmvVVByGUgPVG+QEO3
	 KrDccRsZYWTC8Q9SztZ8bMpJQKRCcGK1HaPWN9WJ9iI12QzCVGEY5Ym9TD+VdlFs+V
	 uKwvGy+IPGYD20WfE1UpWLRCHkFtH/xWogqFJpHg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389534AbgJNU7k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389383AbgJNU7k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:40 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 889452224D;
        Wed, 14 Oct 2020 20:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709179;
        bh=3o/tc3gzBIEDgcXeKbyVwp8fwo1oa81J7CufsZ0WYF4=;
        h=Date:From:To:Subject:From;
        b=ldrj/pEfh7kzMmPdOQ5iZP90oGGOu8Eh6zA5gJIhyL1kuMjUaI3hixX3oeyOBEz16
         8C5R4jh3YwesLjBQOeg/Xr6dDbznPA9mwYr4/T0hnyq+0oslTL9j7cWOqtulJk6jt3
         98CvEw5tOZ/DDaymleEs+054myfn6vaHqZYuyTdY=
Date:   Wed, 14 Oct 2020 13:59:39 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-swap-fix-confusing-comment-in-release_pages.patch removed from -mm tree
Message-ID: <20201014205939.y1eSyhFav%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: fix confusing comment in release_pages()
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-confusing-comment-in-release_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap.c: fix confusing comment in release_pages()

Since commit 07d802699528 ("mm: devmap: refactor 1-based refcounting for
ZONE_DEVICE pages"), we have renamed the func put_devmap_managed_page() to
page_is_devmap_managed().

Link: https://lkml.kernel.org/r/20200905084453.19353-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-fix-confusing-comment-in-release_pages
+++ a/mm/swap.c
@@ -902,7 +902,7 @@ void release_pages(struct page **pages,
 			}
 			/*
 			 * ZONE_DEVICE pages that return 'false' from
-			 * put_devmap_managed_page() do not require special
+			 * page_is_devmap_managed() do not require special
 			 * processing, and instead, expect a call to
 			 * put_page_testzero().
 			 */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

