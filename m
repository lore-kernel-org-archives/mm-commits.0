From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-mm-fix-undefined-reference-to-__kernel_map_pages-on-fsl-ppc64.patch removed from -mm tree
Date: Fri, 30 Jan 2015 11:29:54 -0800
Message-ID: <54cbdbb2.sl9Jim8fLizT9Jk1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbbA3T3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 14:29:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kim.phillips@freescale.com, akinobu.mita@gmail.com, benh@kernel.crashing.org, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mpe@ellerman.id.au, paulus@samba.org, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: fix undefined reference to  `.__kernel_map_pages' on FSL PPC64
has been removed from the -mm tree.  Its filename was
     powerpc-mm-fix-undefined-reference-to-__kernel_map_pages-on-fsl-ppc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
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

mailmap-update-konstantin-khlebnikovs-email-address.patch
mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs.patch
mm-slub-fix-typo.patch
linux-next.patch

