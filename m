From: akpm@linux-foundation.org
Subject: + wire-up-dec-serial-drivers-in-kconfig.patch added to -mm tree
Date: Wed, 28 Mar 2007 16:38:37 -0700
Message-ID: <200703282338.l2SNcblH022826@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35761 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934070AbXC1Xlz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:41:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     Wire up DEC serial drivers in Kconfig
has been added to the -mm tree.  Its filename is
     wire-up-dec-serial-drivers-in-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Wire up DEC serial drivers in Kconfig
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+)

diff -puN drivers/char/Kconfig~wire-up-dec-serial-drivers-in-kconfig drivers/char/Kconfig
--- a/drivers/char/Kconfig~wire-up-dec-serial-drivers-in-kconfig
+++ a/drivers/char/Kconfig
@@ -396,6 +396,39 @@ config AU1000_SERIAL_CONSOLE
 	  If you have an Alchemy AU1000 processor (MIPS based) and you want
 	  to use a console on a serial port, say Y.  Otherwise, say N.
 
+config SERIAL_DEC
+	bool "DECstation serial support"
+	depends on MACH_DECSTATION
+	default y
+	help
+	  This selects whether you want to be asked about drivers for
+	  DECstation serial ports.
+
+	  Note that the answer to this question won't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about DECstation serial ports.
+
+config SERIAL_DEC_CONSOLE
+	bool "Support for console on a DECstation serial port"
+	depends on SERIAL_DEC
+	default y
+	help
+	  If you say Y here, it will be possible to use a serial port as the
+	  system console (the system console is the device which receives all
+	  kernel messages and warnings and which allows logins in single user
+	  mode).  Note that the firmware uses ttyS0 as the serial console on
+	  the Maxine and ttyS2 on the others.
+
+	  If unsure, say Y.
+
+config ZS
+	bool "Z85C30 Serial Support"
+	depends on SERIAL_DEC
+	default y
+	help
+	  Documentation on the Zilog 85C350 serial communications controller
+	  is downloadable at <http://www.zilog.com/pdfs/serial/z85c30.pdf>
+
 config A2232
 	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && ZORRO && BROKEN_ON_SMP
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
fix-struct-device-member-name-in-pcmcia-au1000_generic.patch
wire-up-dec-serial-drivers-in-kconfig.patch
git-alsa.patch
git-mips.patch
git-netdev-all.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
x86_64-fix-ia32_binfmtc-build-error.patch
simplify-the-stacktrace-code.patch
serial-allocate-minor-device-numbers-for.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
tgafb-turbochannel-support.patch
