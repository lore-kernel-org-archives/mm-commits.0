From: akpm@linux-foundation.org
Subject: - x86-configurable-dmi-scanning-code.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:41 -0700
Message-ID: <200804282155.m3SLtfXm018124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936183AbYD1V4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.petazzoni@free-electrons.com, hpa@zytor.com, mingo@elte.hu, mpm@selenic.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: configurable DMI scanning code
has been removed from the -mm tree.  Its filename was
     x86-configurable-dmi-scanning-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: configurable DMI scanning code
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Turn CONFIG_DMI into a selectable option if EMBEDDED is defined, in
order to be able to remove the DMI table scanning code if it's not
needed, and then reduce the kernel code size.

With CONFIG_DMI (i.e before) :

   text    data     bss     dec     hex filename
1076076  128656   98304 1303036  13e1fc vmlinux

Without CONFIG_DMI (i.e after) :

   text    data     bss     dec     hex filename
1068092  126308   98304 1292704  13b9a0 vmlinux

Result:

   text    data     bss     dec     hex filename
  -7984   -2348       0  -10332   -285c vmlinux

The new option appears in "Processor type and features", only when
CONFIG_EMBEDDED is defined.

This patch is part of the Linux Tiny project, and is based on previous work
done by Matt Mackall <mpm@selenic.com>.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Anvin" <hpa@zytor.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig    |   12 +++++++++---
 include/linux/dmi.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN arch/x86/Kconfig~x86-configurable-dmi-scanning-code arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-configurable-dmi-scanning-code
+++ a/arch/x86/Kconfig
@@ -86,9 +86,6 @@ config GENERIC_GPIO
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 
-config DMI
-	def_bool y
-
 config RWSEM_GENERIC_SPINLOCK
 	def_bool !X86_XADD
 
@@ -485,6 +482,15 @@ config HPET_EMULATE_RTC
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
+config DMI
+	default y
+	bool "Enable DMI scanning" if EMBEDDED
+	help
+	  Enabled scanning of DMI to identify machine quirks. Say Y
+	  here unless you have verified that your setup is not
+	  affected by entries in the DMI blacklist. Required by PNP
+	  BIOS code.
+
 config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
diff -puN include/linux/dmi.h~x86-configurable-dmi-scanning-code include/linux/dmi.h
--- a/include/linux/dmi.h~x86-configurable-dmi-scanning-code
+++ a/include/linux/dmi.h
@@ -90,6 +90,7 @@ static inline int dmi_check_system(const
 static inline const char * dmi_get_system_info(int field) { return NULL; }
 static inline const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from) { return NULL; }
+static inline void dmi_scan_machine(void) { return; }
 static inline int dmi_get_year(int year) { return 0; }
 static inline int dmi_name_in_vendors(const char *s) { return 0; }
 #define dmi_available 0
_

Patches currently in -mm which might be from thomas.petazzoni@free-electrons.com are

origin.patch
use-directly-kmalloc-and-kfree-in-init-initramfsc.patch

