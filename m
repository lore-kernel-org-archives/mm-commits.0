From: akpm@linux-foundation.org
Subject: - gru-driver-v3-driver-misc-makefile-kconfig-changes.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:13 -0700
Message-ID: <200807301916.m6UJGDUF011106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827AbYG3TRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:17:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     GRU Driver: driver/misc Makefile & Kconfig changes
has been removed from the -mm tree.  Its filename was
     gru-driver-v3-driver-misc-makefile-kconfig-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU Driver: driver/misc Makefile & Kconfig changes
From: Jack Steiner <steiner@sgi.com>

Driver/misc changes for the GRU driver

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig  |   23 +++++++++++++++++++++++
 drivers/misc/Makefile |    1 +
 2 files changed, 24 insertions(+)

diff -puN drivers/misc/Kconfig~gru-driver-v3-driver-misc-makefile-kconfig-changes drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~gru-driver-v3-driver-misc-makefile-kconfig-changes
+++ a/drivers/misc/Kconfig
@@ -450,4 +450,27 @@ config HP_ILO
 	  To compile this driver as a module, choose M here: the
 	  module will be called hpilo.
 
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
diff -puN drivers/misc/Makefile~gru-driver-v3-driver-misc-makefile-kconfig-changes drivers/misc/Makefile
--- a/drivers/misc/Makefile~gru-driver-v3-driver-misc-makefile-kconfig-changes
+++ a/drivers/misc/Makefile
@@ -28,4 +28,5 @@ obj-$(CONFIG_INTEL_MENLOW)	+= intel_menl
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
+obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch
linux-next.patch

