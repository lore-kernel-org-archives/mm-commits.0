From: akpm@linux-foundation.org
Subject: +
 powerpc-mm-fix-undefined-reference-to-__kernel_map_pages-on-fsl-ppc64.patch added to -mm tree
Date: Mon, 26 Jan 2015 12:34:28 -0800
Message-ID: <54c6a4d4.+ocK/WrvX7WQSnGZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbbAZUe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 15:34:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kim.phillips@freescale.com, akinobu.mita@gmail.com, benh@kernel.crashing.org, iamjoonsoo.kim@lge.com, k.khlebnikov@samsung.com, mpe@ellerman.id.au, paulus@samba.org, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: fix undefined reference to  `.__kernel_map_pages' on FSL PPC64
has been added to the -mm tree.  Its filename is
     powerpc-mm-fix-undefined-reference-to-__kernel_map_pages-on-fsl-ppc64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-fix-undefined-reference-to-__kernel_map_pages-on-fsl-ppc64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-fix-undefined-reference-to-__kernel_map_pages-on-fsl-ppc64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kim Phillips <kim.phillips@freescale.com>
Subject: powerpc/mm: fix undefined reference to  `.__kernel_map_pages' on FSL PPC64

arch/powerpc has __kernel_map_pages implementations in mm/pgtable_32.c, and
mm/hash_utils_64.c, of which the former is built for PPC32, and the latter
for PPC64 machines with PPC_STD_MMU.  Fix arch/powerpc/Kconfig to not select
ARCH_SUPPORTS_DEBUG_PAGEALLOC when CONFIG_PPC_STD_MMU_64 isn't defined,
i.e., for 64-bit book3e builds to use the generic __kernel_map_pages()
in mm/debug-pagealloc.c.

  LD      init/built-in.o
mm/built-in.o: In function `kernel_map_pages':
include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
Makefile:925: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1

Fixes: 031bc5743f15 ("mm/debug-pagealloc: make debug-pagealloc boottime configurable")
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
CC: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Scott Wood <scottwood@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/Kconfig~powerpc-mm-fix-undefined-reference-to-__kernel_map_pages-on-fsl-ppc64 arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-mm-fix-undefined-reference-to-__kernel_map_pages-on-fsl-ppc64
+++ a/arch/powerpc/Kconfig
@@ -256,6 +256,7 @@ config PPC_OF_PLATFORM_PCI
 	default n
 
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	depends on PPC32 || PPC_STD_MMU_64
 	def_bool y
 
 config ARCH_SUPPORTS_UPROBES
_

Patches currently in -mm which might be from kim.phillips@freescale.com are

powerpc-mm-fix-undefined-reference-to-__kernel_map_pages-on-fsl-ppc64.patch
mm-slub-fix-typo.patch

