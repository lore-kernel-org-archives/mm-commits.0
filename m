From: akpm@linux-foundation.org
Subject: +
 lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch added to -mm tree
Date: Wed, 16 Apr 2014 12:05:55 -0700
Message-ID: <534ed493.sRmkLlQDzREV5CZZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaDPTF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:05:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, benh@kernel.crashing.org, lauraa@codeaurora.org

Subject: + lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch added to -mm tree
To: lauraa@codeaurora.org,benh@kernel.crashing.org,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:05:55 -0700


The patch titled
     Subject: powerpc: include asm/dma.h explicitly
has been added to the -mm tree.  Its filename is
     lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-compactionc-isolate_freepages_block-small-tuneup.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch
debugging-keep-track-of-page-owners.patch

