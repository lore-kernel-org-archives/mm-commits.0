From: akpm@linux-foundation.org
Subject: - gru-driver-v2-driver-misc-makefile-kconfig-changes.patch removed from -mm tree
Date: Tue, 01 Jul 2008 01:04:30 -0700
Message-ID: <200807010804.m6184Uvh016408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406AbYGAIEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, andrea@qumranet.com, holt@sgi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     GRU driver: driver/misc Makefile & Kconfig changes
has been removed from the -mm tree.  Its filename was
     gru-driver-v2-driver-misc-makefile-kconfig-changes.patch

This patch was dropped because it needs mmu notifiers, which I don't have

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU driver: driver/misc Makefile & Kconfig changes
From: Jack Steiner <steiner@sgi.com>

Driver/misc changes for the GRU driver.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig  |   23 +++++++++++++++++++++++
 drivers/misc/Makefile |    1 +
 2 files changed, 24 insertions(+)

diff -puN drivers/misc/Kconfig~gru-driver-v2-driver-misc-makefile-kconfig-changes drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~gru-driver-v2-driver-misc-makefile-kconfig-changes
+++ a/drivers/misc/Kconfig
@@ -432,4 +432,27 @@ config SGI_XP
 	  this feature will allow for direct communication between SSIs
 	  based on a network adapter and DMA messaging.
 
+config SGI_GRU
+	tristate "SGI GRU driver"
+	depends on (X86_64 || IA64_SGI_UV || IA64_GENERIC) && SMP
+	default n
+	select MMU_NOTIFIER
+	---help---
+	The GRU is a hardware resource located in the system chipset. The GRU
+	contains memory that can be mmapped into the user address space. This memory is
+	used to communicate with the GRU to perform functions such as load/store,
+	scatter/gather, bcopy, AMOs, etc.  The GRU is directly accessed by user
+	instructions using user virtual addresses. GRU instructions (ex., bcopy) use
+	user virtual addresses for operands.
+
+	If you are not running on a SGI UV system, say N.
+
+config SGI_GRU_DEBUG
+	bool  "SGI GRU driver debug"
+	depends on SGI_GRU
+	default n
+	---help---
+	This option enables addition debugging code for the SGI GRU driver. If
+	you are unsure, say N.
+
 endif # MISC_DEVICES
diff -puN drivers/misc/Makefile~gru-driver-v2-driver-misc-makefile-kconfig-changes drivers/misc/Makefile
--- a/drivers/misc/Makefile~gru-driver-v2-driver-misc-makefile-kconfig-changes
+++ a/drivers/misc/Makefile
@@ -27,3 +27,4 @@ obj-$(CONFIG_INTEL_MENLOW)	+= intel_menl
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
+obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-driver-v2-driver-misc-makefile-kconfig-changes.patch

