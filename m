From: akpm@linux-foundation.org
Subject: - introduce-config_has_dma.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:05 -0700
Message-ID: <200705080002.l48025m0008820@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967350AbXEHAER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, James.Bottomley@SteelEye.com, geert@linux-m68k.org, htejun@gmail.com, jeff@garzik.org, kyle@parisc-linux.org, linville@tuxdriver.com, schwidefsky@de.ibm.com, spyro@f2s.com, uclinux-v850@lsi.nec.co.jp, ysato@users.sourceforge.jp, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Introduce CONFIG_HAS_DMA
has been removed from the -mm tree.  Its filename was
     introduce-config_has_dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Introduce CONFIG_HAS_DMA
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Architectures that don't support DMA can say so by adding a config NO_DMA
to their Kconfig file.  This will prevent compilation of some dma specific
driver code.  Also dma-mapping-broken.h isn't needed anymore on at least
s390.  This avoids compilation and linking of otherwise dead/broken code.

Other architectures that include dma-mapping-broken.h are arm26, h8300,
m68k, m68knommu and v850.  If these could be converted as well we could get
rid of the header file.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
"John W. Linville" <linville@tuxdriver.com>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: <geert@linux-m68k.org>
Cc: <zippel@linux-m68k.org>
Cc: <spyro@f2s.com>
Cc: <uclinux-v850@lsi.nec.co.jp>
Cc: <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig              |    3 +++
 drivers/base/Makefile          |    4 ++--
 include/asm-s390/dma-mapping.h |    2 --
 lib/Kconfig                    |    5 +++++
 4 files changed, 10 insertions(+), 4 deletions(-)

diff -puN arch/s390/Kconfig~introduce-config_has_dma arch/s390/Kconfig
--- a/arch/s390/Kconfig~introduce-config_has_dma
+++ a/arch/s390/Kconfig
@@ -49,6 +49,9 @@ config GENERIC_BUG
 config NO_IOMEM
 	def_bool y
 
+config NO_DMA
+	def_bool y
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff -puN drivers/base/Makefile~introduce-config_has_dma drivers/base/Makefile
--- a/drivers/base/Makefile~introduce-config_has_dma
+++ a/drivers/base/Makefile
@@ -2,10 +2,10 @@
 
 obj-y			:= core.o sys.o bus.o dd.o \
 			   driver.o class.o platform.o \
-			   cpu.o firmware.o init.o map.o dmapool.o \
-			   dma-mapping.o devres.o \
+			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o
 obj-y			+= power/
+obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o dmapool.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff -puN include/asm-s390/dma-mapping.h~introduce-config_has_dma include/asm-s390/dma-mapping.h
--- a/include/asm-s390/dma-mapping.h~introduce-config_has_dma
+++ a/include/asm-s390/dma-mapping.h
@@ -9,6 +9,4 @@
 #ifndef _ASM_DMA_MAPPING_H
 #define _ASM_DMA_MAPPING_H
 
-#include <asm-generic/dma-mapping-broken.h>
-
 #endif /* _ASM_DMA_MAPPING_H */
diff -puN lib/Kconfig~introduce-config_has_dma lib/Kconfig
--- a/lib/Kconfig~introduce-config_has_dma
+++ a/lib/Kconfig
@@ -111,4 +111,9 @@ config HAS_IOPORT
 	depends on HAS_IOMEM && !NO_IOPORT
 	default y
 
+config HAS_DMA
+	boolean
+	depends on !NO_DMA
+	default y
+
 endmenu
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
s390-spinlock-initializer-cleanup.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
