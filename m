From: akpm@linux-foundation.org
Subject: +
 mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy.patch added to -mm tree
Date: Thu, 09 Jul 2015 15:33:32 -0700
Message-ID: <559ef6bc.dHZqDSxNt3Vc7ikH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbbGIWdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: change is_page_busy() return from int to bool
has been added to the -mm tree.  Its filename is
     mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Krause <xerofoify@gmail.com>
Subject: mm/dmapool.c: change is_page_busy() return from int to bool

This makes the function is_page_busy() return bool rather then an int now
due to this particular function's single return statement only ever
evaulating to either one or zero.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/dmapool.c~mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy mm/dmapool.c
--- a/mm/dmapool.c~mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy
+++ a/mm/dmapool.c
@@ -242,7 +242,7 @@ static struct dma_page *pool_alloc_page(
 	return page;
 }
 
-static inline int is_page_busy(struct dma_page *page)
+static inline bool is_page_busy(struct dma_page *page)
 {
 	return page->in_use != 0;
 }
_

Patches currently in -mm which might be from xerofoify@gmail.com are

hugetlb-make-the-function-vma_shareable-bool.patch
mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy.patch
linux-next.patch

