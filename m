From: akpm@linux-foundation.org
Subject: + rapidio-add-modular-build-option-for-the-subsystem-core.patch
 added to -mm tree
Date: Fri, 28 Jun 2013 14:19:40 -0700
Message-ID: <51cdfdec.ADP/gR1JmJuYUeHU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3F1VTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 17:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stef.van.os@Prodrive.nl, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, jdelvare@suse.de, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: + rapidio-add-modular-build-option-for-the-subsystem-core.patch added to -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,jdelvare@suse.de,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,stef.van.os@Prodrive.nl
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 14:19:40 -0700


The patch titled
     Subject: rapidio: add modular build option for the subsystem core
has been added to the -mm tree.  Its filename is
     rapidio-add-modular-build-option-for-the-subsystem-core.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add modular build option for the subsystem core

Add a configuration option to build RapidIO subsystem core code as a
loadable kernel module.  Currently this option is available only for
x86-based platforms, with the additional patch for PowerPC planned to be
provided later.

This patch replaces kernel command line parameter "riohdid=" with its
module-specific analog "rapidio.hdid=".

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig         |    4 ++--
 drivers/rapidio/Makefile |    4 +++-
 drivers/rapidio/rio.c    |   27 ++++++++++++++-------------
 3 files changed, 19 insertions(+), 16 deletions(-)

diff -puN arch/x86/Kconfig~rapidio-add-modular-build-option-for-the-subsystem-core arch/x86/Kconfig
--- a/arch/x86/Kconfig~rapidio-add-modular-build-option-for-the-subsystem-core
+++ a/arch/x86/Kconfig
@@ -2259,11 +2259,11 @@ source "drivers/pcmcia/Kconfig"
 source "drivers/pci/hotplug/Kconfig"
 
 config RAPIDIO
-	bool "RapidIO support"
+	tristate "RapidIO support"
 	depends on PCI
 	default n
 	help
-	  If you say Y here, the kernel will include drivers and
+	  If enabled this option will include drivers and the core
 	  infrastructure code to support RapidIO interconnect devices.
 
 source "drivers/rapidio/Kconfig"
diff -puN drivers/rapidio/Makefile~rapidio-add-modular-build-option-for-the-subsystem-core drivers/rapidio/Makefile
--- a/drivers/rapidio/Makefile~rapidio-add-modular-build-option-for-the-subsystem-core
+++ a/drivers/rapidio/Makefile
@@ -1,7 +1,9 @@
 #
 # Makefile for RapidIO interconnect services
 #
-obj-y += rio.o rio-access.o rio-driver.o rio-sysfs.o
+obj-$(CONFIG_RAPIDIO) += rapidio.o
+rapidio-y := rio.o rio-access.o rio-driver.o rio-sysfs.o
+
 obj-$(CONFIG_RAPIDIO_ENUM_BASIC) += rio-scan.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
diff -puN drivers/rapidio/rio.c~rapidio-add-modular-build-option-for-the-subsystem-core drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-modular-build-option-for-the-subsystem-core
+++ a/drivers/rapidio/rio.c
@@ -5,7 +5,7 @@
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
  *
- * Copyright 2009 Integrated Device Technology, Inc.
+ * Copyright 2009 - 2013 Integrated Device Technology, Inc.
  * Alex Bounine <alexandre.bounine@idt.com>
  *
  * This program is free software; you can redistribute  it and/or modify it
@@ -30,6 +30,17 @@
 
 #include "rio.h"
 
+MODULE_DESCRIPTION("RapidIO Subsystem Core");
+MODULE_AUTHOR("Matt Porter <mporter@kernel.crashing.org>");
+MODULE_AUTHOR("Alexandre Bounine <alexandre.bounine@idt.com>");
+MODULE_LICENSE("GPL");
+
+static int hdid[RIO_MAX_MPORTS];
+static int ids_num;
+module_param_array(hdid, int, &ids_num, 0);
+MODULE_PARM_DESC(hdid,
+	"Destination ID assignment to local RapidIO controllers");
+
 static LIST_HEAD(rio_devices);
 static DEFINE_SPINLOCK(rio_global_list_lock);
 
@@ -1860,24 +1871,14 @@ no_disc:
 	return 0;
 }
 
-static int hdids[RIO_MAX_MPORTS + 1];
-
 static int rio_get_hdid(int index)
 {
-	if (!hdids[0] || hdids[0] <= index || index >= RIO_MAX_MPORTS)
+	if (ids_num == 0 || ids_num <= index || index >= RIO_MAX_MPORTS)
 		return -1;
 
-	return hdids[index + 1];
-}
-
-static int rio_hdid_setup(char *str)
-{
-	(void)get_options(str, ARRAY_SIZE(hdids), hdids);
-	return 1;
+	return hdid[index];
 }
 
-__setup("riohdid=", rio_hdid_setup);
