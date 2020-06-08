From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 47/54] arm: rename flush_cache_user_range to
 flush_icache_user_range
Date: Sun, 07 Jun 2020 21:42:34 -0700
Message-ID: <20200608044234._zgq8D1FN%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgFHEmf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:35 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org, linux@armlinux.org.uk, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: arm: rename flush_cache_user_range to flush_icache_user_range

flush_icache_user_range will be the name for a generic primitive.
Move the arm name so that arm already has an implementation.

Link: http://lkml.kernel.org/r/20200515143646.3857579-24-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cacheflush.h |    4 ++--
 arch/arm/kernel/traps.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/cacheflush.h~arm-rename-flush_cache_user_range-to-flush_icache_user_range
+++ a/arch/arm/include/asm/cacheflush.h
@@ -258,11 +258,11 @@ extern void flush_cache_page(struct vm_a
 #define flush_cache_dup_mm(mm) flush_cache_mm(mm)
 
 /*
- * flush_cache_user_range is used when we want to ensure that the
+ * flush_icache_user_range is used when we want to ensure that the
  * Harvard caches are synchronised for the user space address range.
  * This is used for the ARM private sys_cacheflush system call.
  */
-#define flush_cache_user_range(s,e)	__cpuc_coherent_user_range(s,e)
+#define flush_icache_user_range(s,e)	__cpuc_coherent_user_range(s,e)
 
 /*
  * Perform necessary cache operations to ensure that data previously
--- a/arch/arm/kernel/traps.c~arm-rename-flush_cache_user_range-to-flush_icache_user_range
+++ a/arch/arm/kernel/traps.c
@@ -566,7 +566,7 @@ __do_cache_op(unsigned long start, unsig
 		if (fatal_signal_pending(current))
 			return 0;
 
-		ret = flush_cache_user_range(start, start + chunk);
+		ret = flush_icache_user_range(start, start + chunk);
 		if (ret)
 			return ret;
 
_
