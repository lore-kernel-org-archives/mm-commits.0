From: akpm@linux-foundation.org
Subject: + mm-cma-fix-alignment-requirements-for-contiguous-regions.patch added to -mm tree
Date: Fri, 24 Aug 2012 14:38:05 -0700
Message-ID: <20120824213805.AA6721E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:60118 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2HXViG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 17:38:06 -0400
Received: by yenq13 with SMTP id q13so334583yen.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 14:38:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, mina86@mina86.com


The patch titled
     Subject: mm: cma: fix alignment requirements for contiguous regions
has been added to the -mm tree.  Its filename is
     mm-cma-fix-alignment-requirements-for-contiguous-regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: fix alignment requirements for contiguous regions

Contiguous Memory Allocator requires each of its regions to be aligned in
such a way that it is possible to change migration type for all pageblocks
holding it and then isolate page of largest possible order from the buddy
allocator (which is MAX_ORDER-1).  This patch relaxes alignment
requirements by one order, because MAX_ORDER alignment is not really
needed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/dma-contiguous.c~mm-cma-fix-alignment-requirements-for-contiguous-regions drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~mm-cma-fix-alignment-requirements-for-contiguous-regions
+++ a/drivers/base/dma-contiguous.c
@@ -250,7 +250,7 @@ int __init dma_declare_contiguous(struct
 		return -EINVAL;
 
 	/* Sanitise input arguments */
-	alignment = PAGE_SIZE << max(MAX_ORDER, pageblock_order);
+	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
 	base = ALIGN(base, alignment);
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

linux-next.patch
mm-cma-fix-alignment-requirements-for-contiguous-regions.patch

