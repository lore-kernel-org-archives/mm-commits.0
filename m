From: akpm@linux-foundation.org
Subject: [merged] sh-use-generic-fixmaph.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:15 -0800
Message-ID: <52e2b83f.e211NuAz29eEi8Qq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXTAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lethal@linux-sh.org, msalter@redhat.com

Subject: [merged] sh-use-generic-fixmaph.patch removed from -mm tree
To: msalter@redhat.com,lethal@linux-sh.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:15 -0800


The patch titled
     Subject: sh: use generic fixmap.h
has been removed from the -mm tree.  Its filename was
     sh-use-generic-fixmaph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: sh: use generic fixmap.h

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/fixmap.h |   39 +--------------------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

diff -puN arch/sh/include/asm/fixmap.h~sh-use-generic-fixmaph arch/sh/include/asm/fixmap.h
--- a/arch/sh/include/asm/fixmap.h~sh-use-generic-fixmaph
+++ a/arch/sh/include/asm/fixmap.h
@@ -79,13 +79,6 @@ extern void __set_fixmap(enum fixed_addr
 			 unsigned long phys, pgprot_t flags);
 extern void __clear_fixmap(enum fixed_addresses idx, pgprot_t flags);
 
-#define set_fixmap(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL)
-/*
- * Some hardware wants to get fixmapped without caching.
- */
-#define set_fixmap_nocache(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
 /*
  * used by vmalloc.c.
  *
@@ -101,36 +94,8 @@ extern void __clear_fixmap(enum fixed_ad
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
 
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-/*
- * 'index to address' translation. If anyone tries to use the idx
- * directly without tranlation, we catch the bug with a NULL-deference
- * kernel oops. Illegal ranges of incoming indices are caught too.
- */
-static inline unsigned long fix_to_virt(const unsigned int idx)
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
+#define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
 
-        return __fix_to_virt(idx);
-}
+#include <asm-generic/fixmap.h>
 
-static inline unsigned long virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
 #endif
_

Patches currently in -mm which might be from msalter@redhat.com are

origin.patch
arm-use-generic-fixmaph.patch
linux-next.patch

