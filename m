From: akpm@linux-foundation.org
Subject: + powerpc-use-generic-fixmaph.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:55 -0800
Message-ID: <52af5acb.+Fmf/M2U41laiwgj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3LPTz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulus@samba.org, benh@kernel.crashing.org, msalter@redhat.com

Subject: + powerpc-use-generic-fixmaph.patch added to -mm tree
To: msalter@redhat.com,benh@kernel.crashing.org,paulus@samba.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:55 -0800


The patch titled
     Subject: powerpc: use generic fixmap.h
has been added to the -mm tree.  Its filename is
     powerpc-use-generic-fixmaph.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-use-generic-fixmaph.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-use-generic-fixmaph.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: powerpc: use generic fixmap.h

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fixmap.h |   44 +---------------------------
 1 file changed, 2 insertions(+), 42 deletions(-)

diff -puN arch/powerpc/include/asm/fixmap.h~powerpc-use-generic-fixmaph arch/powerpc/include/asm/fixmap.h
--- a/arch/powerpc/include/asm/fixmap.h~powerpc-use-generic-fixmaph
+++ a/arch/powerpc/include/asm/fixmap.h
@@ -58,52 +58,12 @@ enum fixed_addresses {
 extern void __set_fixmap (enum fixed_addresses idx,
 					phys_addr_t phys, pgprot_t flags);
 
-#define set_fixmap(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL)
-/*
- * Some hardware wants to get fixmapped without caching.
- */
-#define set_fixmap_nocache(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL_NCG)
-
-#define clear_fixmap(idx) \
-		__set_fixmap(idx, 0, __pgprot(0))
-
 #define __FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START		(FIXADDR_TOP - __FIXADDR_SIZE)
 
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
-        return __fix_to_virt(idx);
-}
+#define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NCG
 
-static inline unsigned long virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
+#include <asm-generic/fixmap.h>
 
 #endif /* !__ASSEMBLY__ */
 #endif
_

Patches currently in -mm which might be from msalter@redhat.com are

add-generic-fixmaph.patch
x86-use-generic-fixmaph.patch
arm-use-generic-fixmaph.patch
hexagon-use-generic-fixmaph.patch
metag-use-generic-fixmaph.patch
microblaze-use-generic-fixmaph.patch
mips-use-generic-fixmaph.patch
powerpc-use-generic-fixmaph.patch
sh-use-generic-fixmaph.patch
tile-use-generic-fixmaph.patch
um-use-generic-fixmaph.patch
linux-next.patch

