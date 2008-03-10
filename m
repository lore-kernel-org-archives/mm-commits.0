From: akpm@linux-foundation.org
Subject: - regulator-kbuild.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:37:52 -0700
Message-ID: <200803101937.m2AJbqLi001926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbYCJTiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     regulator: kbuild
has been removed from the -mm tree.  Its filename was
     regulator-kbuild.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: kbuild
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This patch adds Makefile and Kconfig for regulator core.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Kconfig            |    2 ++
 drivers/Makefile           |    1 +
 drivers/regulator/Kconfig  |   32 ++++++++++++++++++++++++++++++++
 drivers/regulator/Makefile |    7 +++++++
 4 files changed, 42 insertions(+)

diff -puN drivers/Kconfig~regulator-kbuild drivers/Kconfig
--- a/drivers/Kconfig~regulator-kbuild
+++ a/drivers/Kconfig
@@ -92,6 +92,8 @@ source "drivers/edac/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
+source "drivers/regulator/Kconfig"
+
 source "drivers/dma/Kconfig"
 
 source "drivers/dca/Kconfig"
diff -puN drivers/Makefile~regulator-kbuild drivers/Makefile
--- a/drivers/Makefile~regulator-kbuild
+++ a/drivers/Makefile
@@ -87,6 +87,7 @@ obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
+obj-$(CONFIG_REGULATOR)	+= regulator/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
diff -puN /dev/null drivers/regulator/Kconfig
--- /dev/null
+++ a/drivers/regulator/Kconfig
@@ -0,0 +1,32 @@
+menu "Voltage and Current regulators"
+
+config REGULATOR
+	bool "Voltage and Current Regulator Support"
+	default n
+	help
+	  Generic Voltage and Current Regulator support.
+
+	  This framework is designed to provide a generic interface to voltage
+	  and current regulators within the Linux kernel. It's intended to
+	  provide voltage and current control to client or consumer drivers and
+	  also provide status information to user space applications through a
+	  sysfs interface.
+
+	  The intention is to allow systems to dynamically control regulator
+	  output in order to save power and prolong battery life. This applies
+	  to both voltage regulators (where voltage output is controllable) and
+	  current sinks (where current output is controllable).
+
+	  This framework safely compiles out if not selected so that client
+	  drivers can still be used in systems with no software controllable
+	  regulators.
+
+	  If unsure, say no.
+
+config REGULATOR_DEBUG
+	bool "Regulator debug support"
+	depends on REGULATOR
+	help
+	  Say yes here to enable debugging support.
+
+endmenu
diff -puN /dev/null drivers/regulator/Makefile
--- /dev/null
+++ a/drivers/regulator/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for regulator drivers.
+#
+
+obj-$(CONFIG_REGULATOR) += reg-core.o
+
+ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-kbuild.patch
regulator-maintainers.patch

