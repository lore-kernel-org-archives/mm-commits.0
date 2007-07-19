From: akpm@linux-foundation.org
Subject: + serial-fix-vr41xx_siu-interface-select.patch added to -mm tree
Date: Wed, 18 Jul 2007 19:43:20 -0700
Message-ID: <200707190243.l6J2hKYv009835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbXGSCnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 22:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org


The patch titled
     serial: fix vr41xx_siu interface select
has been added to the -mm tree.  Its filename is
     serial-fix-vr41xx_siu-interface-select.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: fix vr41xx_siu interface select
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

only PORT_VR41XX_SIU can select interface.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/vr41xx_siu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/vr41xx_siu.c~serial-fix-vr41xx_siu-interface-select drivers/serial/vr41xx_siu.c
--- a/drivers/serial/vr41xx_siu.c~serial-fix-vr41xx_siu-interface-select
+++ a/drivers/serial/vr41xx_siu.c
@@ -800,7 +800,8 @@ static int __init siu_console_setup(stru
 		port->membase = ioremap(port->mapbase, siu_port_size(port));
 	}
 
-	vr41xx_select_siu_interface(SIU_INTERFACE_RS232C);
+	if (port->type == PORT_VR41XX_SIU)
+		vr41xx_select_siu_interface(SIU_INTERFACE_RS232C);
 
 	if (options != NULL)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
git-mips.patch
git-mtd.patch
serial-fix-section-mismatch-vr41xx_siu.patch
serial-fix-vr41xx_siu-interface-select.patch
serial-fix-vr41xx_siu-serial-console-support.patch
