From: akpm@linux-foundation.org
Subject: + dmi-clean-up-dmi-helper-declarations.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:37:32 -0800
Message-ID: <200802140037.m1E0bXV1022594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765511AbYBNAii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:38:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, Matt_Domsch@dell.com


The patch titled
     dmi: clean-up dmi helper declarations
has been added to the -mm tree.  Its filename is
     dmi-clean-up-dmi-helper-declarations.patch

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
Subject: dmi: clean-up dmi helper declarations
From: Jean Delvare <khali@linux-fr.org>

The declaration of dmi helper functions is a bit messy and inconsistent at the
moment:

* On ia64 they are declared in <asm/io.h>.
* On x86-64 they are declared in <asm/dmi.h>.
* On i386 they are declared both in <asm/io.h> and <asm/dmi.h>.

Fix the header files so that the dmi helper functions are consistently
defined in <asm/dmi.h>.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/dmi.h  |    5 +++++
 include/asm-ia64/io.h   |    5 -----
 include/asm-x86/dmi.h   |    1 +
 include/asm-x86/io_32.h |    5 -----
 4 files changed, 6 insertions(+), 10 deletions(-)

diff -puN include/asm-ia64/dmi.h~dmi-clean-up-dmi-helper-declarations include/asm-ia64/dmi.h
--- a/include/asm-ia64/dmi.h~dmi-clean-up-dmi-helper-declarations
+++ a/include/asm-ia64/dmi.h
@@ -3,4 +3,9 @@
 
 #include <asm/io.h>
 
+/* Use normal IO mappings for DMI */
+#define dmi_ioremap ioremap
+#define dmi_iounmap(x,l) iounmap(x)
+#define dmi_alloc(l) kmalloc(l, GFP_ATOMIC)
+
 #endif
diff -puN include/asm-ia64/io.h~dmi-clean-up-dmi-helper-declarations include/asm-ia64/io.h
--- a/include/asm-ia64/io.h~dmi-clean-up-dmi-helper-declarations
+++ a/include/asm-ia64/io.h
@@ -423,11 +423,6 @@ extern void __iomem * ioremap(unsigned l
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap (volatile void __iomem *addr);
 
-/* Use normal IO mappings for DMI */
-#define dmi_ioremap ioremap
-#define dmi_iounmap(x,l) iounmap(x)
-#define dmi_alloc(l) kmalloc(l, GFP_ATOMIC)
-
 /*
  * String version of IO memory access ops:
  */
diff -puN include/asm-x86/dmi.h~dmi-clean-up-dmi-helper-declarations include/asm-x86/dmi.h
--- a/include/asm-x86/dmi.h~dmi-clean-up-dmi-helper-declarations
+++ a/include/asm-x86/dmi.h
@@ -27,6 +27,7 @@ static inline void *dmi_alloc(unsigned l
 
 #endif
 
+/* Use early IO mappings for DMI because it's initialized early */
 #define dmi_ioremap early_ioremap
 #define dmi_iounmap early_iounmap
 
diff -puN include/asm-x86/io_32.h~dmi-clean-up-dmi-helper-declarations include/asm-x86/io_32.h
--- a/include/asm-x86/io_32.h~dmi-clean-up-dmi-helper-declarations
+++ a/include/asm-x86/io_32.h
@@ -139,11 +139,6 @@ extern void *early_ioremap(unsigned long
 extern void early_iounmap(void *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
-/* Use early IO mappings for DMI because it's initialized early */
-#define dmi_ioremap early_ioremap
-#define dmi_iounmap early_iounmap
-#define dmi_alloc alloc_bootmem
-
 /*
  * ISA I/O bus memory addresses are 1:1 with the physical address.
  */
_

Patches currently in -mm which might be from khali@linux-fr.org are

mm-only-enforce-acpi-resource-conflict-checks.patch
oz99x-i2c-button-and-led-support-driver.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
apanel-fix-kconfig-dependencies.patch
dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
dmi-clean-up-dmi-helper-declarations.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
