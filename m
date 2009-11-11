From: akpm@linux-foundation.org
Subject: + cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch added to -mm tree
Date: Tue, 10 Nov 2009 16:41:02 -0800
Message-ID: <200911110041.nAB0f2fP013390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681AbZKKAmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 19:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, cjb@laptop.org, johnstul@us.ibm.com, jordan@cosmicpenguin.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     cs5535: move the DIVIL MSR definition into linux/cs5535.h
has been added to the -mm tree.  Its filename is
     cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch

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

linux-next.patch
drm-kill-some-unused-drm_proc-macros-from-drmph.patch
drm-kill-more-unused-drm-macros.patch
drm-replace-drm_copy-macro-w-a-function.patch
drm-check-return-values-in-drm_version.patch
cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs5535-gpio-request-function-mask-names-added.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch
cs5535-move-vsa2-checks-into-linux-cs5535h.patch
cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch
cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch

