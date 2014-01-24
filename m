From: akpm@linux-foundation.org
Subject: [merged] tile-use-generic-fixmaph.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:17 -0800
Message-ID: <52e2b841.K6MT950R0E5WrPFa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXTAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cmetcalf@tilera.com, msalter@redhat.com

Subject: [merged] tile-use-generic-fixmaph.patch removed from -mm tree
To: msalter@redhat.com,cmetcalf@tilera.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:17 -0800


The patch titled
     Subject: tile: use generic fixmap.h
has been removed from the -mm tree.  Its filename was
     tile-use-generic-fixmaph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: tile: use generic fixmap.h

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/fixmap.h |   33 -------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff -puN arch/tile/include/asm/fixmap.h~tile-use-generic-fixmaph arch/tile/include/asm/fixmap.h
--- a/arch/tile/include/asm/fixmap.h~tile-use-generic-fixmaph
+++ a/arch/tile/include/asm/fixmap.h
@@ -25,9 +25,6 @@
 #include <asm/kmap_types.h>
 #endif
 
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
 /*
  * Here we define all the compile-time 'special' virtual
  * addresses. The point is to have a constant address at
@@ -83,35 +80,7 @@ enum fixed_addresses {
 #define FIXADDR_START		(FIXADDR_TOP + PAGE_SIZE - __FIXADDR_SIZE)
 #define FIXADDR_BOOT_START	(FIXADDR_TOP + PAGE_SIZE - __FIXADDR_BOOT_SIZE)
 
-extern void __this_fixmap_does_not_exist(void);
-
-/*
- * 'index to address' translation. If anyone tries to use the idx
- * directly without tranlation, we catch the bug with a NULL-deference
- * kernel oops. Illegal ranges of incoming indices are caught too.
- */
-static __always_inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	/*
-	 * this branch gets completely eliminated after inlining,
-	 * except when someone tries to use fixaddr indices in an
-	 * illegal way. (such as mixing up address types or using
-	 * out-of-range indices).
-	 *
-	 * If it doesn't get removed, the linker will complain
-	 * loudly with a reasonably clear error message..
-	 */
-	if (idx >= __end_of_fixed_addresses)
-		__this_fixmap_does_not_exist();
-
-	return __fix_to_virt(idx);
-}
