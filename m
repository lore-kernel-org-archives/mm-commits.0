From: akpm@linux-foundation.org
Subject: [merged] linux-typesh-always-use-unsigned-long-for-pgoff_t.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:51 -0800
Message-ID: <54de5cdf.EAN2Rc8nEn7PPSOQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbbBMUVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, arnd@arndb.de, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/types.h: Always use unsigned long for pgoff_t
has been removed from the -mm tree.  Its filename was
     linux-typesh-always-use-unsigned-long-for-pgoff_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux/types.h: Always use unsigned long for pgoff_t

Everybody uses unsigned long for pgoff_t, and no one ever overrode the
definition of pgoff_t.  Keep it that way, and remove the option of
overriding it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/types.h~linux-typesh-always-use-unsigned-long-for-pgoff_t include/linux/types.h
--- a/include/linux/types.h~linux-typesh-always-use-unsigned-long-for-pgoff_t
+++ a/include/linux/types.h
@@ -135,12 +135,9 @@ typedef unsigned long blkcnt_t;
 #endif
 
 /*
- * The type of an index into the pagecache.  Use a #define so asm/types.h
- * can override it.
+ * The type of an index into the pagecache.
  */
-#ifndef pgoff_t
 #define pgoff_t unsigned long
-#endif
 
 /* A dma_addr_t can hold any valid DMA or bus address for the platform */
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
fs-affs-fix-casting-in-printed-messages.patch
linux-next.patch

