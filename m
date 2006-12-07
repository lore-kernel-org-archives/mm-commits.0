From: akpm@osdl.org
Subject: - allow-hwrandom-core-to-be-a-module.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:50 -0800
Message-ID: <200612072305.kB7N5oSa030180@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52637 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163706AbWLGXG1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:06:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     allow hwrandom core to be a module
has been removed from the -mm tree.  Its filename was
     allow-hwrandom-core-to-be-a-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: allow hwrandom core to be a module
From: "Jan Beulich" <jbeulich@novell.com>

Despite it being small, there should be the option of making it a
module...

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/hw_random/Kconfig  |   19 +++++++++++--------
 drivers/char/hw_random/Makefile |    3 ++-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/char/hw_random/Kconfig~allow-hwrandom-core-to-be-a-module drivers/char/hw_random/Kconfig
--- a/drivers/char/hw_random/Kconfig~allow-hwrandom-core-to-be-a-module
+++ a/drivers/char/hw_random/Kconfig
@@ -3,17 +3,20 @@
 #
 
 config HW_RANDOM
-	bool "Hardware Random Number Generator Core support"
-	default y
+	tristate "Hardware Random Number Generator Core support"
+	default m
 	---help---
 	  Hardware Random Number Generator Core infrastructure.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called rng-core.
+
 	  If unsure, say Y.
 
 config HW_RANDOM_INTEL
 	tristate "Intel HW Random Number Generator support"
 	depends on HW_RANDOM && (X86 || IA64) && PCI
-	default y
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Intel i8xx-based motherboards.
@@ -26,7 +29,7 @@ config HW_RANDOM_INTEL
 config HW_RANDOM_AMD
 	tristate "AMD HW Random Number Generator support"
 	depends on HW_RANDOM && X86 && PCI
-	default y
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on AMD 76x-based motherboards.
@@ -39,7 +42,7 @@ config HW_RANDOM_AMD
 config HW_RANDOM_GEODE
 	tristate "AMD Geode HW Random Number Generator support"
 	depends on HW_RANDOM && X86 && PCI
-	default y
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on the AMD Geode LX.
@@ -52,7 +55,7 @@ config HW_RANDOM_GEODE
 config HW_RANDOM_VIA
 	tristate "VIA HW Random Number Generator support"
 	depends on HW_RANDOM && X86_32
-	default y
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on VIA based motherboards.
@@ -65,7 +68,7 @@ config HW_RANDOM_VIA
 config HW_RANDOM_IXP4XX
 	tristate "Intel IXP4xx NPU HW Random Number Generator support"
 	depends on HW_RANDOM && ARCH_IXP4XX
-	default y
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random
 	  Number Generator hardware found on the Intel IXP4xx NPU.
@@ -78,7 +81,7 @@ config HW_RANDOM_IXP4XX
 config HW_RANDOM_OMAP
 	tristate "OMAP Random Number Generator support"
 	depends on HW_RANDOM && (ARCH_OMAP16XX || ARCH_OMAP24XX)
-	default y
+	default HW_RANDOM
  	---help---
  	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on OMAP16xx and OMAP24xx multimedia
diff -puN drivers/char/hw_random/Makefile~allow-hwrandom-core-to-be-a-module drivers/char/hw_random/Makefile
--- a/drivers/char/hw_random/Makefile~allow-hwrandom-core-to-be-a-module
+++ a/drivers/char/hw_random/Makefile
@@ -2,7 +2,8 @@
 # Makefile for HW Random Number Generator (RNG) device drivers.
 #
 
-obj-$(CONFIG_HW_RANDOM) += core.o
+obj-$(CONFIG_HW_RANDOM) += rng-core.o
+rng-core-y := core.o
 obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
 obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
 obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
some-kbuild-fix.patch
move-kallsyms-data-to-rodata.patch

