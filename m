From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 26/54] nds32: unexport flush_icache_page
Date: Sun, 07 Jun 2020 21:41:29 -0700
Message-ID: <20200608044129.kn8Xlqbt7%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHElb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:31 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deanbo422@gmail.com, green.hu@gmail.com, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: nds32: unexport flush_icache_page

flush_icache_page is only used by mm/memory.c.

Link: http://lkml.kernel.org/r/20200515143646.3857579-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/mm/cacheflush.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/nds32/mm/cacheflush.c~nds32-unexport-flush_icache_page
+++ a/arch/nds32/mm/cacheflush.c
@@ -35,7 +35,6 @@ void flush_icache_page(struct vm_area_st
 	kunmap_atomic((void *)kaddr);
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL(flush_icache_page);
 
 void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
 	                     unsigned long addr, int len)
_
