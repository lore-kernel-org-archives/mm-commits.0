From: akpm@linux-foundation.org
Subject: + mm-add-a-might_sleep_if-in-dma_pool_alloc.patch added to -mm tree
Date: Thu, 23 Sep 2010 14:23:57 -0700
Message-ID: <201009232123.o8NLNvZs019861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041Ab0IWVcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 17:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dima@android.com


The patch titled
     mm: add a might_sleep_if() to dma_pool_alloc()
has been added to the -mm tree.  Its filename is
     mm-add-a-might_sleep_if-in-dma_pool_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add a might_sleep_if() to dma_pool_alloc()
From: Dima Zavin <dima@android.com>

Buggy drivers (e.g.  fsl_udc) could call dma_pool_alloc from atomic
context with GFP_KERNEL.  In most instances, the first pool_alloc_page
call would succeed and the sleeping functions would never be called.  This
allowed the buggy drivers to slip through the cracks.

Add a might_sleep_if() checking for __GFP_WAIT in flags.

Signed-off-by: Dima Zavin <dima@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/dmapool.c~mm-add-a-might_sleep_if-in-dma_pool_alloc mm/dmapool.c
--- a/mm/dmapool.c~mm-add-a-might_sleep_if-in-dma_pool_alloc
+++ a/mm/dmapool.c
@@ -311,6 +311,8 @@ void *dma_pool_alloc(struct dma_pool *po
 	size_t offset;
 	void *retval;
 
+	might_sleep_if(mem_flags & __GFP_WAIT);
+
 	spin_lock_irqsave(&pool->lock, flags);
  restart:
 	list_for_each_entry(page, &pool->page_list, page_list) {
_

Patches currently in -mm which might be from dima@android.com are

mm-add-a-might_sleep_if-in-dma_pool_alloc.patch

