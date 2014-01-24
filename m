From: akpm@linux-foundation.org
Subject: [merged] hexagon-use-generic-fixmaph.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:05 -0800
Message-ID: <52e2b835.YmCj3JWM1MfDG7cD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXTAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rkuo@codeaurora.org, msalter@redhat.com

Subject: [merged] hexagon-use-generic-fixmaph.patch removed from -mm tree
To: msalter@redhat.com,rkuo@codeaurora.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:05 -0800


The patch titled
     Subject: hexagon: use generic fixmap.h
has been removed from the -mm tree.  Its filename was
     hexagon-use-generic-fixmaph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: hexagon: use generic fixmap.h

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/fixmap.h |   40 ----------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff -puN arch/hexagon/include/asm/fixmap.h~hexagon-use-generic-fixmaph arch/hexagon/include/asm/fixmap.h
--- a/arch/hexagon/include/asm/fixmap.h~hexagon-use-generic-fixmaph
+++ a/arch/hexagon/include/asm/fixmap.h
@@ -26,45 +26,7 @@
  */
 #include <asm/mem-layout.h>
 
-/*
- * Full fixmap support involves set_fixmap() functions, but
- * these may not be needed if all we're after is an area for
- * highmem kernel mappings.
- */
-#define	__fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define	__virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-/**
- * fix_to_virt -- "index to address" translation.
- *
- * If anyone tries to use the idx directly without translation,
- * we catch the bug with a NULL-deference kernel oops. Illegal
- * ranges of incoming indices are caught too.
- */
-static inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	/*
-	 * This branch gets completely eliminated after inlining,
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
