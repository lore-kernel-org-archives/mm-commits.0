From: akpm@linux-foundation.org
Subject: [merged] parisc-remove-the-second-argument-of-kmap_atomic.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:31 -0700
Message-ID: <20130508183431.7F0CC31C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:59808 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab3EHSec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:32 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so195833ghr.0
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhaohongjiang@huawei.com, deller@gmx.de, eike-kernel@sf-tec.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: remove the second argument of kmap_atomic()
has been removed from the -mm tree.  Its filename was
     parisc-remove-the-second-argument-of-kmap_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: parisc: remove the second argument of kmap_atomic()

kmap_atomic() requires only one argument now.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/cache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/parisc/kernel/cache.c~parisc-remove-the-second-argument-of-kmap_atomic arch/parisc/kernel/cache.c
--- a/arch/parisc/kernel/cache.c~parisc-remove-the-second-argument-of-kmap_atomic
+++ a/arch/parisc/kernel/cache.c
@@ -606,7 +606,7 @@ void clear_user_highpage(struct page *pa
 	/* Clear using TMPALIAS region.  The page doesn't need to
 	   be flushed but the kernel mapping needs to be purged.  */
 
-	vto = kmap_atomic(page, KM_USER0);
+	vto = kmap_atomic(page);
 
 	/* The PA-RISC 2.0 Architecture book states on page F-6:
 	   "Before a write-capable translation is enabled, *all*
@@ -641,8 +641,8 @@ void copy_user_highpage(struct page *to,
 	   the `to' page must be flushed in copy_user_page_asm since
 	   it can be used to bring in executable code.  */
 
-	vfrom = kmap_atomic(from, KM_USER0);
-	vto = kmap_atomic(to, KM_USER1);
+	vfrom = kmap_atomic(from);
+	vto = kmap_atomic(to);
 
 	purge_kernel_dcache_page_asm((unsigned long)vto);
 	purge_tlb_start(flags);
_

Patches currently in -mm which might be from zhaohongjiang@huawei.com are

origin.patch
drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic.patch

