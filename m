From: akpm@linux-foundation.org
Subject: + geode-reboot-fixup-for-geode-machines-with-cs5536-boards.patch added to -mm tree
Date: Fri, 06 Jul 2007 10:40:57 -0700
Message-ID: <200707061740.l66Hev21010312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759960AbXGFRlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 13:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, ak@suse.de, alan@lxorguk.ukuu.org.uk, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     GEODE: reboot fixup for geode machines with CS5536 boards
has been added to the -mm tree.  Its filename is
     geode-reboot-fixup-for-geode-machines-with-cs5536-boards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: GEODE: reboot fixup for geode machines with CS5536 boards
From: Andres Salomon <dilinger@queued.net>

Writing to MSR 0x51400017 forces a hard reset on CS5536-based machines,
this has the reboot fixup do just that if such a board is detected.

Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig                |    4 ++--
 arch/i386/kernel/reboot_fixups.c |   13 +++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN arch/i386/Kconfig~geode-reboot-fixup-for-geode-machines-with-cs5536-boards arch/i386/Kconfig
--- a/arch/i386/Kconfig~geode-reboot-fixup-for-geode-machines-with-cs5536-boards
+++ a/arch/i386/Kconfig
@@ -451,8 +451,8 @@ config X86_REBOOTFIXUPS
 	  this config is intended, is when reboot ends with a stalled/hung
 	  system.
 
-	  Currently, the only fixup is for the Geode GX1/CS5530A/TROM2.1.
-	  combination.
+	  Currently, the only fixup is for the Geode machines using
+	  CS5530A and CS5536 chipsets.
 
 	  Say Y if you want to enable the fixup. Currently, it's safe to
 	  enable this option even if you don't need it.
diff -puN arch/i386/kernel/reboot_fixups.c~geode-reboot-fixup-for-geode-machines-with-cs5536-boards arch/i386/kernel/reboot_fixups.c
--- a/arch/i386/kernel/reboot_fixups.c~geode-reboot-fixup-for-geode-machines-with-cs5536-boards
+++ a/arch/i386/kernel/reboot_fixups.c
@@ -5,12 +5,14 @@
  *
  * List of supported fixups:
  * geode-gx1/cs5530a - Jaya Kumar <jayalk@intworks.biz>
+ * geode-gx/lx/cs5536 - Andres Salomon <dilinger@debian.org>
  *
  */
 
 #include <asm/delay.h>
 #include <linux/pci.h>
 #include <asm/reboot_fixups.h>
+#include <asm/msr.h>
 
 static void cs5530a_warm_reset(struct pci_dev *dev)
 {
@@ -21,6 +23,16 @@ static void cs5530a_warm_reset(struct pc
 	return;
 }
 
+static void cs5536_warm_reset(struct pci_dev *dev)
+{
+	/*
+	 * 6.6.2.12 Soft Reset (DIVIL_SOFT_RESET)
+	 * writing 1 to the LSB of this MSR causes a hard reset.
+	 */
+	wrmsrl(0x51400017, 1ULL);
+	udelay(50); /* shouldn't get here but be safe and spin a while */
+}
+
 struct device_fixup {
 	unsigned int vendor;
 	unsigned int device;
@@ -29,6 +41,7 @@ struct device_fixup {
 
 static struct device_fixup fixups_table[] = {
 { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
+{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
 };
 
 /*
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-reboot-fixup-for-geode-machines-with-cs5536-boards.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-basic-infrastructure-support-for-amd-geode-class-update.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
