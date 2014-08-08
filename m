From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch removed
 from -mm tree
Date: Fri, 08 Aug 2014 14:00:17 -0700
Message-ID: <53e53a61.eyzViQEWLj6iOurg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:57367 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbaHHVAT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:00:19 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so252827igi.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:00:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, benh@kernel.crashing.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: include asm/dma.h explicitly
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch

This patch was dropped because it was folded into lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: powerpc: include asm/dma.h explicitly

commit ff35bd54456e18878c361a8a2deeb41c9688458f (lib/scatterlist: make
ARCH_HAS_SG_CHAIN an actual Kconfig) changed powerpc to use the generic
scatterlist.h.  The powerpc scatterlist.h header was including asm/dma.h
as well so removing the include broke a few things:

arch/powerpc/platforms/52xx/efika.c: In function 'efika_probe':
arch/powerpc/platforms/52xx/efika.c:210:2: error: 'ISA_DMA_THRESHOLD' undeclared
arch/powerpc/platforms/52xx/efika.c:211:2: error: 'DMA_MODE_READ' undeclared
arch/powerpc/platforms/52xx/efika.c:212:2: error: 'DMA_MODE_WRITE' undeclared

Explicitly include asm/dma.h where necessary.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild test robot <fengguang.wu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/52xx/efika.c     |    1 +
 arch/powerpc/platforms/amigaone/setup.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/powerpc/platforms/52xx/efika.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix arch/powerpc/platforms/52xx/efika.c
--- a/arch/powerpc/platforms/52xx/efika.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix
+++ a/arch/powerpc/platforms/52xx/efika.c
@@ -13,6 +13,7 @@
 #include <generated/utsrelease.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <asm/dma.h>
 #include <asm/prom.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/amigaone/setup.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix arch/powerpc/platforms/amigaone/setup.c
--- a/arch/powerpc/platforms/amigaone/setup.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix
+++ a/arch/powerpc/platforms/amigaone/setup.c
@@ -24,6 +24,7 @@
 #include <asm/i8259.h>
 #include <asm/time.h>
 #include <asm/udbg.h>
+#include <asm/dma.h>
 
 extern void __flush_disable_L1(void);
 
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch
lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch

