From: akpm@linux-foundation.org
Subject: [merged] cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:56:31 -0800
Message-ID: <200912152156.nBFLuVwC015646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761288AbZLOV52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:57:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@collabora.co.uk, cjb@laptop.org, johnstul@us.ibm.com, jordan@cosmicpenguin.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     cs5535: move the DIVIL MSR definition into linux/cs5535.h
has been removed from the -mm tree.  Its filename was
     cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs5535: move the DIVIL MSR definition into linux/cs5535.h
From: Andres Salomon <dilinger@collabora.co.uk>

The only thing that uses this is the reboot_fixups code.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/geode.h       |    2 --
 arch/x86/kernel/reboot_fixups_32.c |    2 +-
 include/linux/cs5535.h             |    2 ++
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/geode.h~cs5535-move-the-divil-msr-definition-into-linux-cs5535h arch/x86/include/asm/geode.h
--- a/arch/x86/include/asm/geode.h~cs5535-move-the-divil-msr-definition-into-linux-cs5535h
+++ a/arch/x86/include/asm/geode.h
@@ -45,8 +45,6 @@ extern int geode_get_dev_base(unsigned i
 #define MSR_LBAR_ACPI		0x5140000E
 #define MSR_LBAR_PMS		0x5140000F
 
-#define MSR_DIVIL_SOFT_RESET	0x51400017
-
 #define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
 
 #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
diff -puN arch/x86/kernel/reboot_fixups_32.c~cs5535-move-the-divil-msr-definition-into-linux-cs5535h arch/x86/kernel/reboot_fixups_32.c
--- a/arch/x86/kernel/reboot_fixups_32.c~cs5535-move-the-divil-msr-definition-into-linux-cs5535h
+++ a/arch/x86/kernel/reboot_fixups_32.c
@@ -12,7 +12,7 @@
 #include <linux/interrupt.h>
 #include <asm/reboot_fixups.h>
 #include <asm/msr.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 static void cs5530a_warm_reset(struct pci_dev *dev)
 {
diff -puN include/linux/cs5535.h~cs5535-move-the-divil-msr-definition-into-linux-cs5535h include/linux/cs5535.h
--- a/include/linux/cs5535.h~cs5535-move-the-divil-msr-definition-into-linux-cs5535h
+++ a/include/linux/cs5535.h
@@ -18,6 +18,8 @@
 #define MSR_LBAR_ACPI		0x5140000E
 #define MSR_LBAR_PMS		0x5140000F
 
+#define MSR_DIVIL_SOFT_RESET	0x51400017
+
 #define MSR_PIC_YSEL_LOW	0x51400020
 #define MSR_PIC_YSEL_HIGH	0x51400021
 #define MSR_PIC_ZSEL_LOW	0x51400022
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

origin.patch
lxfb-add-copyright-license-info.patch

