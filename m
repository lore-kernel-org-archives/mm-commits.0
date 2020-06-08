From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 44/54] asm-generic: add a flush_icache_user_range
 stub
Date: Sun, 07 Jun 2020 21:42:26 -0700
Message-ID: <20200608044226.9VEpFjQ9W%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgFHEm0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:26 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: asm-generic: add a flush_icache_user_range stub

Define flush_icache_user_range to flush_icache_range unless the
architecture provides its own implementation.

Link: http://lkml.kernel.org/r/20200515143646.3857579-21-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/cacheflush.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/asm-generic/cacheflush.h~asm-generic-add-a-flush_icache_user_range-stub
+++ a/include/asm-generic/cacheflush.h
@@ -66,6 +66,10 @@ static inline void flush_icache_range(un
 }
 #endif
 
+#ifndef flush_icache_user_range
+#define flush_icache_user_range flush_icache_range
+#endif
+
 #ifndef flush_icache_page
 static inline void flush_icache_page(struct vm_area_struct *vma,
 				     struct page *page)
_
