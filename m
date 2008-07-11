From: akpm@linux-foundation.org
Subject: - nand-flash-fix-timings-for-at91sam9x-evaluation-kits.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:52:05 -0700
Message-ID: <200807112352.m6BNq5fI011103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756632AbYGKXwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: patrice.vilchez@atmel.com, linux@maxim.org.za, mm-commits@vger.kernel.org


The patch titled
     nand flash: fix timings for at91sam9x evaluation kits
has been removed from the -mm tree.  Its filename was
     nand-flash-fix-timings-for-at91sam9x-evaluation-kits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nand flash: fix timings for at91sam9x evaluation kits
From: Patrice Vilchez <patrice.vilchez@atmel.com>

Fix NAND FLASH timings for at91sam9x evaluation kits.

New timings are based on application note
"NAND Flash Support on AT91SAM9 Microcontrollers" available at
http://atmel.com/dyn/resources/prod_documents/doc6255.pdf).

Signed-off-by: Patrice Vilchez <patrice.vilchez@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/at91sam9260_devices.c |    4 ++--
 arch/arm/mach-at91/at91sam9261_devices.c |   12 ++++++------
 arch/arm/mach-at91/at91sam9263_devices.c |    4 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c  |   12 ++++++------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff -puN arch/arm/mach-at91/at91sam9260_devices.c~nand-flash-fix-timings-for-at91sam9x-evaluation-kits arch/arm/mach-at91/at91sam9260_devices.c
--- a/arch/arm/mach-at91/at91sam9260_devices.c~nand-flash-fix-timings-for-at91sam9x-evaluation-kits
+++ a/arch/arm/mach-at91/at91sam9260_devices.c
@@ -321,8 +321,8 @@ void __init at91_add_device_nand(struct 
 	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
 	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(0) | AT91_SMC_NCS_WRSETUP_(0)
-			| AT91_SMC_NRDSETUP_(0) | AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(1) | AT91_SMC_NCS_WRSETUP_(0)
+			| AT91_SMC_NRDSETUP_(1) | AT91_SMC_NCS_RDSETUP_(0));
 
 	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
 			| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
diff -puN arch/arm/mach-at91/at91sam9261_devices.c~nand-flash-fix-timings-for-at91sam9x-evaluation-kits arch/arm/mach-at91/at91sam9261_devices.c
--- a/arch/arm/mach-at91/at91sam9261_devices.c~nand-flash-fix-timings-for-at91sam9x-evaluation-kits
+++ a/arch/arm/mach-at91/at91sam9261_devices.c
@@ -232,19 +232,19 @@ void __init at91_add_device_nand(struct 
 	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
 	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(0) | AT91_SMC_NCS_WRSETUP_(0)
-			| AT91_SMC_NRDSETUP_(0) | AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(1) | AT91_SMC_NCS_WRSETUP_(0)
+			| AT91_SMC_NRDSETUP_(1) | AT91_SMC_NCS_RDSETUP_(0));
 
-	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(2) | AT91_SMC_NCS_WRPULSE_(5)
-			| AT91_SMC_NRDPULSE_(2) | AT91_SMC_NCS_RDPULSE_(5));
+	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
+			| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
 
-	at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(7) | AT91_SMC_NRDCYCLE_(7));
+	at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(5) | AT91_SMC_NRDCYCLE_(5));
 
 	if (data->bus_width_16)
 		mode = AT91_SMC_DBW_16;
 	else
 		mode = AT91_SMC_DBW_8;
-	at91_sys_write(AT91_SMC_MODE(3), mode | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(1));
+	at91_sys_write(AT91_SMC_MODE(3), mode | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(2));
 
 	/* enable pin */
 	if (data->enable_pin)
diff -puN arch/arm/mach-at91/at91sam9263_devices.c~nand-flash-fix-timings-for-at91sam9x-evaluation-kits arch/arm/mach-at91/at91sam9263_devices.c
--- a/arch/arm/mach-at91/at91sam9263_devices.c~nand-flash-fix-timings-for-at91sam9x-evaluation-kits
+++ a/arch/arm/mach-at91/at91sam9263_devices.c
@@ -391,8 +391,8 @@ void __init at91_add_device_nand(struct 
 	at91_sys_write(AT91_MATRIX_EBI0CSA, csa | AT91_MATRIX_EBI0_CS3A_SMC_SMARTMEDIA);
 
 	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(0) | AT91_SMC_NCS_WRSETUP_(0)
-			| AT91_SMC_NRDSETUP_(0) | AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(1) | AT91_SMC_NCS_WRSETUP_(0)
+			| AT91_SMC_NRDSETUP_(1) | AT91_SMC_NCS_RDSETUP_(0));
 
 	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
 			| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
diff -puN arch/arm/mach-at91/at91sam9rl_devices.c~nand-flash-fix-timings-for-at91sam9x-evaluation-kits arch/arm/mach-at91/at91sam9rl_devices.c
--- a/arch/arm/mach-at91/at91sam9rl_devices.c~nand-flash-fix-timings-for-at91sam9x-evaluation-kits
+++ a/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -233,15 +233,15 @@ void __init at91_add_device_nand(struct 
 	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
 	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(0) | AT91_SMC_NCS_WRSETUP_(0)
-			| AT91_SMC_NRDSETUP_(0) | AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(1) | AT91_SMC_NCS_WRSETUP_(0)
+			| AT91_SMC_NRDSETUP_(1) | AT91_SMC_NCS_RDSETUP_(0));
 
-	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(2) | AT91_SMC_NCS_WRPULSE_(5)
-			| AT91_SMC_NRDPULSE_(2) | AT91_SMC_NCS_RDPULSE_(5));
+	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
+			| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
 
-	at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(7) | AT91_SMC_NRDCYCLE_(7));
+	at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(5) | AT91_SMC_NRDCYCLE_(5));
 
-	at91_sys_write(AT91_SMC_MODE(3), AT91_SMC_DBW_8 | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(1));
+	at91_sys_write(AT91_SMC_MODE(3), AT91_SMC_DBW_8 | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(2));
 
 	/* enable pin */
 	if (data->enable_pin)
_

Patches currently in -mm which might be from patrice.vilchez@atmel.com are

linux-next.patch

