From: akpm@linux-foundation.org
Subject: + gru-driver-v2-driver-misc-makefile-kconfig-changes.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:30:51 -0700
Message-ID: <200807010530.m615Up3h010845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYGAFbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:31:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, andrea@qumranet.com, holt@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     GRU driver: driver/misc Makefile & Kconfig changes
has been added to the -mm tree.  Its filename is
     gru-driver-v2-driver-misc-makefile-kconfig-changes.patch

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

gru-driver-v2-hardware-data-structures.patch
gru-driver-v2-gru-instructions-macros.patch
gru-driver-v2-driver-internal-header-files.patch
gru-driver-v2-kernel-services-header-files.patch
gru-driver-v2-driver-initialization-file-vma-ops.patch
gru-driver-v2-page-faults-exceptions.patch
gru-driver-v2-kernel-services-provide-by-driver.patch
gru-driver-v2-resource-management.patch
gru-driver-v2-proc-interfaces.patch
gru-driver-v2-tlb-flushing-mmuops-callouts.patch
gru-driver-v2-driver-makefile.patch
gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v2-driver-misc-makefile-kconfig-changes.patch

