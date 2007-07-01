From: akpm@linux-foundation.org
Subject: + smsc-ircc2-bypass-pnp-detection-until-we-get-the-quirks-worked-out.patch added to -mm tree
Date: Sun, 01 Jul 2007 11:37:20 -0700
Message-ID: <200707011837.l61IbKbX031738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbXGASiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 1 Jul 2007 14:38:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, arvidjaar@mail.ru, davem@davemloft.net, jeff@garzik.org, michal.k.k.piotrowski@gmail.com, samuel@sortiz.org


The patch titled
     smsc-ircc2: bypass PNP detection until we get the quirks worked out
has been added to the -mm tree.  Its filename is
     smsc-ircc2-bypass-pnp-detection-until-we-get-the-quirks-worked-out.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
smsc-ircc2-bypass-pnp-detection-until-we-get-the-quirks-worked-out.patch
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
