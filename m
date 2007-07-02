From: akpm@linux-foundation.org
Subject: - smsc-ircc2-bypass-pnp-detection-until-we-get-the-quirks-worked-out.patch removed from -mm tree
Date: Mon, 02 Jul 2007 13:16:39 -0700
Message-ID: <200707022016.l62KGdSf004797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427AbXGBURo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jul 2007 16:17:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, arvidjaar@mail.ru, davem@davemloft.net, jeff@garzik.org, michal.k.k.piotrowski@gmail.com, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     smsc-ircc2: bypass PNP detection until we get the quirks worked out
has been removed from the -mm tree.  Its filename was
     smsc-ircc2-bypass-pnp-detection-until-we-get-the-quirks-worked-out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smsc-ircc2: bypass PNP detection until we get the quirks worked out
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Don't use PNP detection by default yet.  We have some PNP and BIOS issues
to work out first.

Sample problem on a Toshiba Portege 4000: the SMCf010 device is handed off
disabled.  We assign I/O ports originally assigned to the SMCf010 to a
PCMCIA device instead.  We enable the SMCf010, configuring it to use
disjoint ports, but _SRS doesn't work correctly, so the device doesn't
work.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/smsc-ircc2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/irda/smsc-ircc2.c~smsc-ircc2-bypass-pnp-detection-until-we-get-the-quirks-worked-out drivers/net/irda/smsc-ircc2.c
--- a/drivers/net/irda/smsc-ircc2.c~smsc-ircc2-bypass-pnp-detection-until-we-get-the-quirks-worked-out
+++ a/drivers/net/irda/smsc-ircc2.c
@@ -79,7 +79,7 @@ MODULE_AUTHOR("Daniele Peri <peri@csai.u
 MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
 MODULE_LICENSE("GPL");
 
-static int smsc_nopnp;
+static int smsc_nopnp = 1;
 module_param_named(nopnp, smsc_nopnp, bool, 0);
 MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-assert-dtr-for-serial-console-devices.patch
console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
x86-initial-fixmap-support.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
move-free-pages-between-lists-on-steal.patch
use-menuconfig-objects-pnp.patch
