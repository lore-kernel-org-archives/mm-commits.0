From: akpm@linux-foundation.org
Subject: +
 lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch added
 to -mm tree
Date: Wed, 16 Apr 2014 12:14:53 -0700
Message-ID: <534ed6ad.cMi/4ycp4bcpOCnD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbaDPTOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:14:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lauraa@codeaurora.org, benh@kernel.crashing.org, sfr@canb.auug.org.au

Subject: + lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch added to -mm tree
To: sfr@canb.auug.org.au,benh@kernel.crashing.org,lauraa@codeaurora.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:14:53 -0700


The patch titled
     Subject: lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig fix
has been added to the -mm tree.  Its filename is
     lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig fix

powerpc files now need asm/dma.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/dma-noncoherent.c |    1 +
 arch/powerpc/platforms/44x/warp.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/powerpc/mm/dma-noncoherent.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3 arch/powerpc/mm/dma-noncoherent.c
--- a/arch/powerpc/mm/dma-noncoherent.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3
+++ a/arch/powerpc/mm/dma-noncoherent.c
@@ -33,6 +33,7 @@
 #include <linux/export.h>
 
 #include <asm/tlbflush.h>
+#include <asm/dma.h>
 
 #include "mmu_decl.h"
 
diff -puN arch/powerpc/platforms/44x/warp.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3 arch/powerpc/platforms/44x/warp.c
--- a/arch/powerpc/platforms/44x/warp.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3
+++ a/arch/powerpc/platforms/44x/warp.c
@@ -25,6 +25,7 @@
 #include <asm/time.h>
 #include <asm/uic.h>
 #include <asm/ppc4xx.h>
+#include <asm/dma.h>
 
 
 static __initdata struct of_device_id warp_of_bus[] = {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch
kernel-forkc-export-kernel_thread-to-modules.patch

