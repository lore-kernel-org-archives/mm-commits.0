From: akpm@linux-foundation.org
Subject: + arm-use-generic-fixmaph.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:55 -0800
Message-ID: <52af5acb.hc0bj709ZkcicsZx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3LPTz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@arm.linux.org.uk, msalter@redhat.com

Subject: + arm-use-generic-fixmaph.patch added to -mm tree
To: msalter@redhat.com,linux@arm.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:55 -0800


The patch titled
     Subject: arm: use generic fixmap.h
has been added to the -mm tree.  Its filename is
     arm-use-generic-fixmaph.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-use-generic-fixmaph.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-use-generic-fixmaph.patch

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
Subject: arm: use generic fixmap.h

ARM is different from other architectures in that fixmap pages are indexed
with a positive offset from FIXADDR_START.  Other architectures index with
a negative offset from FIXADDR_TOP.  In order to use the generic fixmap.h
definitions, this patch redefines FIXADDR_TOP to be inclusive of the
useable range.  That is, FIXADDR_TOP is the virtual address of the topmost
fixed page.  The newly defined FIXADDR_END is the first virtual address
past the fixed mappings.

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/fixmap.h |   29 ++++++++---------------------
 arch/arm/mm/init.c            |    2 +-
 2 files changed, 9 insertions(+), 22 deletions(-)

diff -puN arch/arm/include/asm/fixmap.h~arm-use-generic-fixmaph arch/arm/include/asm/fixmap.h
--- a/arch/arm/include/asm/fixmap.h~arm-use-generic-fixmaph
+++ a/arch/arm/include/asm/fixmap.h
@@ -14,28 +14,15 @@
  */
 
 #define FIXADDR_START		0xfff00000UL
-#define FIXADDR_TOP		0xfffe0000UL
-#define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
+#define FIXADDR_END		0xfffe0000UL
+#define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 
-#define FIX_KMAP_BEGIN		0
-#define FIX_KMAP_END		(FIXADDR_SIZE >> PAGE_SHIFT)
+enum fixed_addresses {
+	FIX_KMAP_BEGIN,
+	FIX_KMAP_END = (FIXADDR_TOP - FIXADDR_START) >> PAGE_SHIFT,
+	__end_of_fixed_addresses
+};
 
-#define __fix_to_virt(x)	(FIXADDR_START + ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	(((x) - FIXADDR_START) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-static inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	if (idx >= FIX_KMAP_END)
-		__this_fixmap_does_not_exist();
-	return __fix_to_virt(idx);
-}
-
-static inline unsigned int virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
+#include <asm-generic/fixmap.h>
 
 #endif
diff -puN arch/arm/mm/init.c~arm-use-generic-fixmaph arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arm-use-generic-fixmaph
+++ a/arch/arm/mm/init.c
@@ -631,7 +631,7 @@ void __init mem_init(void)
 			MLK(DTCM_OFFSET, (unsigned long) dtcm_end),
 			MLK(ITCM_OFFSET, (unsigned long) itcm_end),
 #endif
-			MLK(FIXADDR_START, FIXADDR_TOP),
+			MLK(FIXADDR_START, FIXADDR_END),
 			MLM(VMALLOC_START, VMALLOC_END),
 			MLM(PAGE_OFFSET, (unsigned long)high_memory),
 #ifdef CONFIG_HIGHMEM
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

