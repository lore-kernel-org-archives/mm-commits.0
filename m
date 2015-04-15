From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 15:37:42 -0700
Message-ID: <552ee836.BVaIs0VdZ6MNF0nu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbbDOWhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mempool: add missing include
has been removed from the -mm tree.  Its filename was
     mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch

This patch was dropped because it was folded into mm-mempool-poison-elements-backed-by-slab-allocator.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mempool: add missing include

This is a fix^3 for the mempool poisoning patch, which introduces
a compile-time error on some ARM randconfig builds:

mm/mempool.c: In function 'check_element':
mm/mempool.c:65:16: error: implicit declaration of function 'kmap_atomic' [-Werror=implicit-function-declaration]
   void *addr = kmap_atomic((struct page *)element);

The problem is clearly the missing declaration, and including
linux/highmem.h fixes it.

Fixes: a3db5a8463b0db ("mm, mempool: poison elements backed by page allocator fix fix")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix mm/mempool.c
--- a/mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix
+++ a/mm/mempool.c
@@ -11,6 +11,7 @@
 
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/highmem.h>
 #include <linux/kmemleak.h>
 #include <linux/export.h>
 #include <linux/mempool.h>
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
mm-mempool-poison-elements-backed-by-slab-allocator.patch

