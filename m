From: akpm@linux-foundation.org
Subject: [folded-merged]
 xtensa-implement-flush_icache_user_range-fix.patch removed from -mm tree
Date: Sun, 07 Jun 2020 21:20:31 -0700
Message-ID: <20200608042031.E5OLvXdV9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgFHEUe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:20:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@zankel.net, hch@lst.de, jcmvbkbc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: fix flush_icache_user_range in noMMU configs
has been removed from the -mm tree.  Its filename was
     xtensa-implement-flush_icache_user_range-fix.patch

This patch was dropped because it was folded into xtensa-implement-flush_icache_user_range.patch

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: xtensa: fix flush_icache_user_range in noMMU configs

flush_icache_user_range definition for xtensa is placed under preprocessor
condition that is not processed in noMMU configurations, resulting in the
following build errors:

  fs/exec.c:1065:3: error: implicit declaration of function
  `flush_icache_user_range'
  fs/binfmt_flat.c:857:2: error: implicit declaration of function
  `flush_icache_user_range'

Move definition outside conditional compilation block.

Link: http://lkml.kernel.org/r/20200525221556.4270-1-jcmvbkbc@gmail.com
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/cacheflush.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/xtensa/include/asm/cacheflush.h~xtensa-implement-flush_icache_user_range-fix
+++ a/arch/xtensa/include/asm/cacheflush.h
@@ -107,8 +107,6 @@ void flush_cache_page(struct vm_area_str
 #define flush_cache_page  local_flush_cache_page
 #endif
 
-#define flush_icache_user_range flush_icache_range
