From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 45/54] sh: implement flush_icache_user_range
Date: Sun, 07 Jun 2020 21:42:28 -0700
Message-ID: <20200608044228.vFVM1qXtb%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgFHEm3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:29 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dalias@libc.org, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, ysato@users.sourceforge.jp

From: Christoph Hellwig <hch@lst.de>
Subject: sh: implement flush_icache_user_range

The SuperH implementation of flush_icache_range seems to be able to
cope with user addresses.  Just define flush_icache_user_range to
flush_icache_range.

Link: http://lkml.kernel.org/r/20200515143646.3857579-22-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/cacheflush.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sh/include/asm/cacheflush.h~sh-implement-flush_icache_user_range
+++ a/arch/sh/include/asm/cacheflush.h
@@ -46,6 +46,7 @@ extern void flush_cache_range(struct vm_
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 extern void flush_icache_range(unsigned long start, unsigned long end);
+#define flush_icache_user_range flush_icache_range
 extern void flush_icache_page(struct vm_area_struct *vma,
 				 struct page *page);
 extern void flush_cache_sigtramp(unsigned long address);
_
