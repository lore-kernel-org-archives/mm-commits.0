From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 29/54] asm-generic: fix the inclusion guards for
 cacheflush.h
Date: Sun, 07 Jun 2020 21:41:39 -0700
Message-ID: <20200608044139.b-tvxhfMf%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEll (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:41 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: asm-generic: fix the inclusion guards for cacheflush.h

cacheflush.h uses a somewhat to generic include guard name that clashes
with various arch files.  Use a more specific one.

Link: http://lkml.kernel.org/r/20200515143646.3857579-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/cacheflush.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/asm-generic/cacheflush.h~asm-generic-fix-the-inclusion-guards-for-cacheflushh
+++ a/include/asm-generic/cacheflush.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __ASM_CACHEFLUSH_H
-#define __ASM_CACHEFLUSH_H
+#ifndef _ASM_GENERIC_CACHEFLUSH_H
+#define _ASM_GENERIC_CACHEFLUSH_H
 
 /* Keep includes the same across arches.  */
 #include <linux/mm.h>
@@ -109,4 +109,4 @@ static inline void flush_cache_vunmap(un
 	memcpy(dst, src, len)
 #endif
 
-#endif /* __ASM_CACHEFLUSH_H */
+#endif /* _ASM_GENERIC_CACHEFLUSH_H */
_
