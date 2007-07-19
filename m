From: akpm@linux-foundation.org
Subject: + serial-fix-section-mismatch-vr41xx_siu.patch added to -mm tree
Date: Wed, 18 Jul 2007 19:43:19 -0700
Message-ID: <200707190243.l6J2hJ0g009828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbXGSCnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 22:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org


The patch titled
     serial: fix section mismatch vr41xx_siu
has been added to the -mm tree.  Its filename is
     serial-fix-section-mismatch-vr41xx_siu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: fix section mismatch vr41xx_siu
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Fix section mismatch vr41xx_siu.

WARNING: drivers/built-in.o(.text+0x2ce4c): Section mismatch: reference to .init.text:uart_parse_options (between 'siu_console_setup' and 'siu_request_port')
WARNING: drivers/built-in.o(.text+0x2ce70): Section mismatch: reference to .init.text:uart_set_options (between 'siu_console_setup' and 'siu_request_port')

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/vr41xx_siu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/vr41xx_siu.c~serial-fix-section-mismatch-vr41xx_siu drivers/serial/vr41xx_siu.c
--- a/drivers/serial/vr41xx_siu.c~serial-fix-section-mismatch-vr41xx_siu
+++ a/drivers/serial/vr41xx_siu.c
@@ -782,7 +782,7 @@ static void siu_console_write(struct con
 	siu_write(port, UART_IER, ier);
 }
 
-static int siu_console_setup(struct console *con, char *options)
+static int __init siu_console_setup(struct console *con, char *options)
 {
 	struct uart_port *port;
 	int baud = 9600;
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
git-mips.patch
git-mtd.patch
serial-fix-section-mismatch-vr41xx_siu.patch
serial-fix-vr41xx_siu-interface-select.patch
serial-fix-vr41xx_siu-serial-console-support.patch
