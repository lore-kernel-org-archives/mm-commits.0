From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 31/54] asm-generic: improve the flush_dcache_page
 stub
Date: Sun, 07 Jun 2020 21:41:45 -0700
Message-ID: <20200608044145.ctvUr3RLY%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHElq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:46 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: asm-generic: improve the flush_dcache_page stub

There is a magic ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE cpp symbol that
guards non-stub availability of flush_dcache_pagge.  Use that to
check if flush_dcache_pagg is implemented.

Link: http://lkml.kernel.org/r/20200515143646.3857579-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/cacheflush.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/asm-generic/cacheflush.h~asm-generic-improve-the-flush_dcache_page-stub
+++ a/include/asm-generic/cacheflush.h
@@ -2,8 +2,6 @@
 #ifndef _ASM_GENERIC_CACHEFLUSH_H
 #define _ASM_GENERIC_CACHEFLUSH_H
 
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
