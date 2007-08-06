From: akpm@linux-foundation.org
Subject: - at91-include-atmel_lcdch-in-at91sam92613_devicesc.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:54:02 -0700
Message-ID: <200708060754.l767s2YU016401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758944AbXHFH4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.altenberg@linutronix.de, hskinnemoen@atmel.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     AT91: include atmel_lcdc.h in at91sam926{1,3}_devices.c
has been removed from the -mm tree.  Its filename was
     at91-include-atmel_lcdch-in-at91sam92613_devicesc.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: AT91: include atmel_lcdc.h in at91sam926{1,3}_devices.c
=46rom: Jan Altenberg <jan.altenberg@linutronix.de>

Current git doesn't compile for CONFIG_ARCH_AT91SAM926{1,3} and and
CONFIG_FB_ATMEL enabled, due to a missing inclusion of atmel_lcdc.h:

/home/jan/kernel/git/linux-2.6/arch/arm/mach-at91/at91sam9263_devices.c=
: In function =E2=80=98at91_add_device_lcdc=E2=80=99:
/home/jan/kernel/git/linux-2.6/arch/arm/mach-at91/at91sam9263_devices.c=
:688: error: dereferencing pointer to incomplete type
/home/jan/kernel/git/linux-2.6/arch/arm/mach-at91/at91sam9263_devices.c=
:688: error: =E2=80=98lcdc_data=E2=80=99 has an incomplete type

This error should also have occured in the past, because atmel_lcdc.h
has never been included.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/at91sam9261_devices.c |    2 ++
 arch/arm/mach-at91/at91sam9263_devices.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN arch/arm/mach-at91/at91sam9261_devices.c~at91-include-atmel_l=
cdch-in-at91sam92613_devicesc arch/arm/mach-at91/at91sam9261_devices.c
--- a/arch/arm/mach-at91/at91sam9261_devices.c~at91-include-atmel_lcdch=
-in-at91sam92613_devicesc
+++ a/arch/arm/mach-at91/at91sam9261_devices.c
@@ -15,6 +15,8 @@
=20
 #include <linux/platform_device.h>
=20
+#include <video/atmel_lcdc.h>
+
 #include <asm/arch/board.h>
 #include <asm/arch/gpio.h>
 #include <asm/arch/at91sam9261.h>
diff -puN arch/arm/mach-at91/at91sam9263_devices.c~at91-include-atmel_l=
cdch-in-at91sam92613_devicesc arch/arm/mach-at91/at91sam9263_devices.c
--- a/arch/arm/mach-at91/at91sam9263_devices.c~at91-include-atmel_lcdch=
-in-at91sam92613_devicesc
+++ a/arch/arm/mach-at91/at91sam9263_devices.c
@@ -14,6 +14,8 @@
=20
 #include <linux/platform_device.h>
=20
+#include <video/atmel_lcdc.h>
+
 #include <asm/arch/board.h>
 #include <asm/arch/gpio.h>
 #include <asm/arch/at91sam9263.h>
_

Patches currently in -mm which might be from jan.altenberg@linutronix.d=
e are

git-arm-master.patch
remove-get_perm_addr-from-ucc_geth_ethtoolc.patch
