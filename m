From: akpm@linux-foundation.org
Subject: + serial-fix-vr41xx_siu-serial-console-support.patch added to -mm tree
Date: Wed, 18 Jul 2007 19:43:21 -0700
Message-ID: <200707190243.l6J2hLja009838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbXGSCnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 22:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org


The patch titled
     serial: fix vr41xx_siu serial console support
has been added to the -mm tree.  Its filename is
     serial-fix-vr41xx_siu-serial-console-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: fix vr41xx_siu serial console support
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

The serial console can select only SERIAL_VR41XX=y.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig      |    2 +-
 drivers/serial/vr41xx_siu.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/serial/Kconfig~serial-fix-vr41xx_siu-serial-console-support drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-fix-vr41xx_siu-serial-console-support
+++ a/drivers/serial/Kconfig
@@ -1195,7 +1195,7 @@ config SERIAL_VR41XX
 
 config SERIAL_VR41XX_CONSOLE
 	bool "Enable NEC VR4100 series Serial Interface Unit console"
-	depends on SERIAL_VR41XX
+	depends on SERIAL_VR41XX=y
 	select SERIAL_CORE_CONSOLE
 	help
 	  If you have a NEC VR4100 series processor and you want to use
diff -puN drivers/serial/vr41xx_siu.c~serial-fix-vr41xx_siu-serial-console-support drivers/serial/vr41xx_siu.c
--- a/drivers/serial/vr41xx_siu.c~serial-fix-vr41xx_siu-serial-console-support
+++ a/drivers/serial/vr41xx_siu.c
@@ -65,7 +65,9 @@ static struct uart_port siu_uart_ports[S
 	},
 };
 
+#ifdef CONFIG_SERIAL_VR41XX_CONSOLE
 static uint8_t lsr_break_flag[SIU_PORTS_MAX];
+#endif
 
 #define siu_read(port, offset)		readb((port)->membase + (offset))
 #define siu_write(port, offset, value)	writeb((value), (port)->membase + (offset))
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
git-mips.patch
git-mtd.patch
serial-fix-section-mismatch-vr41xx_siu.patch
serial-fix-vr41xx_siu-interface-select.patch
serial-fix-vr41xx_siu-serial-console-support.patch
