From: akpm@linux-foundation.org
Subject: - serial-fix-section-mismatch-vr41xx_siu.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:35 -0700
Message-ID: <200707312357.l6VNvZFh029409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760515AbXHAAQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial: fix section mismatch vr41xx_siu
has been removed from the -mm tree.  Its filename was
     serial-fix-section-mismatch-vr41xx_siu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-mtd.patch
