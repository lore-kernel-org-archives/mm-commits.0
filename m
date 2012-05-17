From: akpm@linux-foundation.org
Subject: + drivers-cma-dont-fail-if-migration-returns-eagain.patch added to -mm tree
Date: Thu, 17 May 2012 16:20:19 -0700
Message-ID: <20120517232019.A718EA02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47418 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2EQXUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 May 2012 19:20:21 -0400
Received: by eaao13 with SMTP id o13so121134eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 17 May 2012 16:20:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, haojian.zhuang@gmail.com, minchan@kernel.org


The patch titled
     Subject: drivers/cma: don't fail if migration returns -EAGAIN
has been added to the -mm tree.  Its filename is
     drivers-cma-dont-fail-if-migration-returns-eagain.patch

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
Subject: drivers/cma: don't fail if migration returns -EAGAIN

alloc_contig_range() might return -EAGAIN if migrate_pages() fails for
some temporarily locked pages.  Such a case should not be fatal to
dma_alloc_from_contiguous(), which should retry the allocation, as in the
-EBUSY case.

Reported-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/dma-contiguous.c~drivers-cma-dont-fail-if-migration-returns-eagain drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~drivers-cma-dont-fail-if-migration-returns-eagain
+++ a/drivers/base/dma-contiguous.c
@@ -346,7 +346,7 @@ struct page *dma_alloc_from_contiguous(s
 		if (ret == 0) {
 			bitmap_set(cma->bitmap, pageno, count);
 			break;
-		} else if (ret != -EBUSY) {
+		} else if (ret != -EBUSY && ret != -EAGAIN) {
 			goto error;
 		}
 		pr_debug("%s(): memory range at %p is busy, retrying\n",
_
Subject: Subject: drivers/cma: don't fail if migration returns -EAGAIN

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
linux-next.patch
drivers-cma-dont-fail-if-migration-returns-eagain.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch

