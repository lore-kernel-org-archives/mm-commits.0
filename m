From: akpm@linux-foundation.org
Subject: + x86-configurable-dmi-scanning-code.patch added to -mm tree
Date: Mon, 11 Feb 2008 13:28:44 -0800
Message-ID: <200802112129.m1BLSihb001252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbYBKWZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 17:25:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.petazzoni@free-electrons.com, hpa@zytor.com, mingo@elte.hu, mpm@selenic.com, tglx@linutronix.de


The patch titled
     x86: configurable DMI scanning code
has been added to the -mm tree.  Its filename is
     x86-configurable-dmi-scanning-code.patch

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

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Anvin" <hpa@zytor.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig    |   12 +++++++++---
 include/linux/dmi.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN arch/x86/Kconfig~x86-configurable-dmi-scanning-code arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-configurable-dmi-scanning-code
+++ a/arch/x86/Kconfig
@@ -87,9 +87,6 @@ config GENERIC_GPIO
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 
-config DMI
-	def_bool y
-
 config RWSEM_GENERIC_SPINLOCK
 	def_bool !X86_XADD
 
@@ -429,6 +426,15 @@ config HPET_EMULATE_RTC
 
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

x86-configurable-dmi-scanning-code.patch
