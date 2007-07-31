From: akpm@linux-foundation.org
Subject: - serial-fix-vr41xx_siu-interface-select.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:37 -0700
Message-ID: <200707312357.l6VNvb6s029412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759724AbXHAAQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial: fix vr41xx_siu interface select
has been removed from the -mm tree.  Its filename was
     serial-fix-vr41xx_siu-interface-select.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-mtd.patch
