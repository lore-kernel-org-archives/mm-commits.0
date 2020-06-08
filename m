From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 28/54] unicore32: remove flush_cache_user_range
Date: Sun, 07 Jun 2020 21:41:36 -0700
Message-ID: <20200608044136.9tGmqZEUk%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEli (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:38 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gxt@pku.edu.cn, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: unicore32: remove flush_cache_user_range

flush_cache_user_range is an ARMism not used by any generic or unicore32
specific code.

Link: http://lkml.kernel.org/r/20200515143646.3857579-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/include/asm/cacheflush.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/unicore32/include/asm/cacheflush.h~unicore32-remove-flush_cache_user_range
+++ a/arch/unicore32/include/asm/cacheflush.h
@@ -133,14 +133,6 @@ extern void flush_cache_page(struct vm_a
 #define flush_cache_dup_mm(mm) flush_cache_mm(mm)
 
 /*
- * flush_cache_user_range is used when we want to ensure that the
- * Harvard caches are synchronised for the user space address range.
- * This is used for the UniCore private sys_cacheflush system call.
- */
-#define flush_cache_user_range(vma, start, end) \
-	__cpuc_coherent_user_range((start) & PAGE_MASK, PAGE_ALIGN(end))
