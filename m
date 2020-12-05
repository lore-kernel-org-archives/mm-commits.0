Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F06EC433FE
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 01:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 082A422D6F
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 01:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbgLEBAV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 20:00:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgLEBAV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 20:00:21 -0500
Date:   Fri, 04 Dec 2020 16:59:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607129981;
        bh=fSjFI0vZ2JMHbOGayPu+mQmGzJivy72gUjSFNRbeih0=;
        h=From:To:Subject:From;
        b=jTFUH9Eoc/AMl0UOnJR2fx7qb2YIl0weNJT58XDPvsdcrOBQOZBZr4AU3Su6XZ2wy
         rWm4e/LRpwWmh1gD2fRJsr18ZYvC6ykS7LhxkyESbjecLreqEkx4vdvUowWhgjbK/O
         6wDnSCPse4Q6CSuYg9LpJw8S/9XE9x1reKS4KY8k=
From:   akpm@linux-foundation.org
To:     jonathanh@nvidia.com, liu.hailong6@zte.com.cn,
        m.szyprowski@samsung.com, mm-commits@vger.kernel.org,
        qcai@redhat.com, rppt@kernel.org, sfr@canb.auug.org.au
Subject:  [failures]
 =?US-ASCII?Q?mm-memblock-use-a-more-appropriate-order-calculation-when-f?=
 =?US-ASCII?Q?ree-memblock-pages.patch?= removed from -mm tree
Message-ID: <20201205005940.ztFbAZFWC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: use a more appropriate order calculation when free memblock pages
has been removed from the -mm tree.  Its filename was
     mm-memblock-use-a-more-appropriate-order-calculation-when-free-memblock-pages.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Hailong Liu <liu.hailong6@zte.com.cn>
Subject: mm/memblock: use a more appropriate order calculation when free memblock pages

When system in the booting stage, pages span from [start, end] of a
memblock are freed to buddy in a order as large as possible (less than
MAX_ORDER) at first, then decrease gradually to a proper order(less than
end) in a loop.

However, *min(MAX_ORDER - 1UL, __ffs(start))* can not get the largest
order in some cases.  Instead, *__ffs(end - start)* may be more
appropriate and meaningful.

Link: https://lkml.kernel.org/r/20201203152311.5272-1-carver4lio@163.com
Signed-off-by: Hailong Liu <liu.hailong6@zte.com.cn>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qian Cai <qcai@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Jon Hunter <jonathanh@nvidia.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~mm-memblock-use-a-more-appropriate-order-calculation-when-free-memblock-pages
+++ a/mm/memblock.c
@@ -2010,7 +2010,7 @@ static void __init __free_pages_memory(u
 	int order;
 
 	while (start < end) {
-		order = min(MAX_ORDER - 1UL, __ffs(start));
+		order = min(MAX_ORDER - 1UL, __ffs(end - start));
 
 		while (start + (1UL << order) > end)
 			order--;
_

Patches currently in -mm which might be from liu.hailong6@zte.com.cn are


