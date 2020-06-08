From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 46/54] xtensa: implement flush_icache_user_range
Date: Sun, 07 Jun 2020 21:42:32 -0700
Message-ID: <20200608044232.3FNEI-3vu%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgFHEmd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:33 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@zankel.net, hch@lst.de, jcmvbkbc@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: xtensa: implement flush_icache_user_range

The Xtensa implementation of flush_icache_range seems to be able to
cope with user addresses.  Just define flush_icache_user_range to
flush_icache_range.

[jcmvbkbc@gmail.com: fix flush_icache_user_range in noMMU configs]
  Link: http://lkml.kernel.org/r/20200525221556.4270-1-jcmvbkbc@gmail.com
Link: http://lkml.kernel.org/r/20200515143646.3857579-23-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/cacheflush.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/xtensa/include/asm/cacheflush.h~xtensa-implement-flush_icache_user_range
+++ a/arch/xtensa/include/asm/cacheflush.h
@@ -145,6 +145,8 @@ void local_flush_cache_page(struct vm_ar
 
 #endif
 
+#define flush_icache_user_range flush_icache_range
+
 /* Ensure consistency between data and instruction cache. */
 #define local_flush_icache_range(start, end)				\
 	do {								\
_
