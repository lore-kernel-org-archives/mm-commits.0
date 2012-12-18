From: akpm@linux-foundation.org
Subject: [to-be-updated] kconfig-centralise-config_arch_no_virt_to_bus.patch removed from -mm tree
Date: Tue, 18 Dec 2012 15:14:44 -0800
Message-ID: <20121218231444.B18B882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:62549 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LRXOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 18:14:46 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so153041qch.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 15:14:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, benh@kernel.crashing.org, bhelgaas@google.com, davem@davemloft.net, geert@linux-m68k.org, hartleys@visionengravers.com, james.hogan@imgtec.com, lethal@linux-sh.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS
has been removed from the -mm tree.  Its filename was
     kconfig-centralise-config_arch_no_virt_to_bus.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS

Make it easier for more architectures to select it and thus disable
drivers that use virt_to_bus().

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig         |    7 +++++++
 arch/powerpc/Kconfig |    4 +---
 arch/sh/Kconfig      |    4 +---
 arch/sparc/Kconfig   |    4 +---
 4 files changed, 10 insertions(+), 9 deletions(-)

diff -puN arch/Kconfig~kconfig-centralise-config_arch_no_virt_to_bus arch/Kconfig
--- a/arch/Kconfig~kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/Kconfig
@@ -290,6 +290,13 @@ config ARCH_WANT_OLD_COMPAT_IPC
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	bool
 
+config ARCH_NO_VIRT_TO_BUS
+	bool
+	help
+	  An architecture should select this if it cannot (or will not)
+	  implement virt_to_bus().  All new architectures should probably
+	  select this.
+
 config GENERIC_KERNEL_THREAD
 	bool
 
diff -puN arch/powerpc/Kconfig~kconfig-centralise-config_arch_no_virt_to_bus arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/powerpc/Kconfig
@@ -87,9 +87,6 @@ config GENERIC_GPIO
 	help
 	  Generic GPIO API support
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool PPC64
-
 config PPC
 	bool
 	default y
@@ -101,6 +98,7 @@ config PPC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_NO_VIRT_TO_BUS if PPC64
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
diff -puN arch/sh/Kconfig~kconfig-centralise-config_arch_no_virt_to_bus arch/sh/Kconfig
--- a/arch/sh/Kconfig~kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/sh/Kconfig
@@ -15,6 +15,7 @@ config SUPERH
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
+	select ARCH_NO_VIRT_TO_BUS
 	select PERF_USE_VMALLOC
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
@@ -151,9 +152,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 config ARCH_HAS_DEFAULT_IDLE
 	def_bool y
 
diff -puN arch/sparc/Kconfig~kconfig-centralise-config_arch_no_virt_to_bus arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/sparc/Kconfig
@@ -21,6 +21,7 @@ config SPARC
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_NO_VIRT_TO_BUS
 	select RTC_CLASS
 	select RTC_DRV_M48T59
 	select HAVE_DMA_ATTRS
@@ -144,9 +145,6 @@ config GENERIC_GPIO
 	help
 	  Generic GPIO API support
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
