From: akpm@linux-foundation.org
Subject: + regulator-core-kbuild-files.patch added to -mm tree
Date: Fri, 02 May 2008 16:57:50 -0700
Message-ID: <200805022357.m42Nvofj021831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935368AbYEBX6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     regulator: core kbuild files
has been added to the -mm tree.  Its filename is
     regulator-core-kbuild-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: core kbuild files
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This patch adds kernel build support for the regulator core.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig           |    2 +
 drivers/regulator/Kconfig  |   49 +++++++++++++++++++++++++++++++++++
 drivers/regulator/Makefile |   10 +++++++
 3 files changed, 61 insertions(+)

diff -puN arch/arm/Kconfig~regulator-core-kbuild-files arch/arm/Kconfig
--- a/arch/arm/Kconfig~regulator-core-kbuild-files
+++ a/arch/arm/Kconfig
@@ -1166,6 +1166,8 @@ source "drivers/dma/Kconfig"
 
 source "drivers/dca/Kconfig"
 
+source "drivers/regulator/Kconfig"
+
 source "drivers/uio/Kconfig"
 
 endmenu
diff -puN /dev/null drivers/regulator/Kconfig
--- /dev/null
+++ a/drivers/regulator/Kconfig
@@ -0,0 +1,49 @@
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
+config REGULATOR_FIXED_VOLTAGE
+	tristate
+	default n
+	select REGULATOR
+
+config REGULATOR_VIRTUAL_CONSUMER
+	tristate "Virtual regulator consumer support"
+	default n
+	select REGULATOR
+	help
+	  This driver provides a virtual consumer for the voltage and
+          current regulator API which provides sysfs controls for
+          configuring the supplies requested.  This is mainly useful
+          for test purposes.
+
+          If unsure, say no.
+
+endmenu
diff -puN /dev/null drivers/regulator/Makefile
--- /dev/null
+++ a/drivers/regulator/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for regulator drivers.
+#
+
+
+obj-$(CONFIG_REGULATOR) += core.o
+obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
+obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
+
+ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-consumer-device-interface.patch
regulator-regulator-driver-interface.patch
regulator-machine-driver-interface.patch
regulator-fixed-regulator-interface.patch
regulator-regulator-framework-core.patch
regulator-add-support-for-fixed-regulators.patch
regulator-regulator-test-harness.patch
regulator-core-kbuild-files.patch
regulator-documentation-overview.patch
regulator-documentation-consumer-interface.patch
regulator-documentation-regulator-driver.patch
regulator-documentation-machine.patch
regulator-documentation-abi.patch

