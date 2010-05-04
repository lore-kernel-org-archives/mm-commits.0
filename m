From: akpm@linux-foundation.org
Subject: + rapidio-add-debug-configuration-option.patch added to -mm tree
Date: Tue, 04 May 2010 16:25:12 -0700
Message-ID: <201005042325.o44NPCrA025142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934506Ab0EDXZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 19:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add debug configuration option
has been added to the -mm tree.  Its filename is
     rapidio-add-debug-configuration-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add debug configuration option
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add debug configuration option for RapidIO subsystem.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/Kconfig           |   11 +++++++++++
 drivers/rapidio/Makefile          |    4 ++++
 drivers/rapidio/switches/Makefile |    4 ++++
 3 files changed, 19 insertions(+)

diff -puN drivers/rapidio/Kconfig~rapidio-add-debug-configuration-option drivers/rapidio/Kconfig
--- a/drivers/rapidio/Kconfig~rapidio-add-debug-configuration-option
+++ a/drivers/rapidio/Kconfig
@@ -21,3 +21,14 @@ config RAPIDIO_ENABLE_RX_TX_PORTS
 	  than Maintenance transfers.
 
 source "drivers/rapidio/switches/Kconfig"
+
+config RAPIDIO_DEBUG
+	bool "RapidIO subsystem debug messages"
+	depends on RAPIDIO
+	help
+	  Say Y here if you want the RapidIO subsystem to produce a bunch of
+	  debug messages to the system log. Select this if you are having a
+	  problem with the RapidIO subsystem and want to see more of what is
+	  going on.
+
+	  If you are unsure about this, say N here.
diff -puN drivers/rapidio/Makefile~rapidio-add-debug-configuration-option drivers/rapidio/Makefile
--- a/drivers/rapidio/Makefile~rapidio-add-debug-configuration-option
+++ a/drivers/rapidio/Makefile
@@ -4,3 +4,7 @@
 obj-y += rio.o rio-access.o rio-driver.o rio-scan.o rio-sysfs.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
+
+ifeq ($(CONFIG_RAPIDIO_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
diff -puN drivers/rapidio/switches/Makefile~rapidio-add-debug-configuration-option drivers/rapidio/switches/Makefile
--- a/drivers/rapidio/switches/Makefile~rapidio-add-debug-configuration-option
+++ a/drivers/rapidio/switches/Makefile
@@ -6,3 +6,7 @@ obj-$(CONFIG_RAPIDIO_TSI57X)	+= tsi57x.o
 obj-$(CONFIG_RAPIDIO_CPS_XX)	+= idtcps.o
 obj-$(CONFIG_RAPIDIO_TSI568)	+= tsi568.o
 obj-$(CONFIG_RAPIDIO_TSI500)	+= tsi500.o
+
+ifeq ($(CONFIG_RAPIDIO_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-idt-cps-tsi-switches.patch
rapidio-add-switch-locking-during-discovery.patch
rapidio-add-port-write-handling-for-em.patch
rapidio-powerpc-85xx-add-port-write-message-handler-for-srio-port.patch
rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch
rapidio-fix-typos-and-minor-edits.patch
rapidio-add-debug-configuration-option.patch
rapidio-modify-initialization-of-switch-operations.patch
rapidio-add-switch-domain-routines.patch
rapidio-use-default-route-value-for-cps-switches.patch

