From: akpm@linux-foundation.org
Subject: + timbuart-use-__devinit-and-__devexit-macros-for-probe-and-remove.patch added to -mm tree
Date: Fri, 09 Jul 2010 12:44:24 -0700
Message-ID: <201007091944.o69JiPsU021919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063Ab0GITpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 15:45:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors@pelagicore.com, greg@kroah.com


The patch titled
     timbuart: use __devinit and __devexit macros for probe and remove
has been added to the -mm tree.  Its filename is
     timbuart-use-__devinit-and-__devexit-macros-for-probe-and-remove.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: timbuart: use __devinit and __devexit macros for probe and rem=
ove
=46rom: Richard R=F6jfors <richard.rojfors@pelagicore.com>

Move the probe and remove functions to the devinit and devexit sections=
=2E

Signed-off-by: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/timbuart.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/serial/timbuart.c~timbuart-use-__devinit-and-__devexi=
t-macros-for-probe-and-remove drivers/serial/timbuart.c
--- a/drivers/serial/timbuart.c~timbuart-use-__devinit-and-__devexit-ma=
cros-for-probe-and-remove
+++ a/drivers/serial/timbuart.c
@@ -423,7 +423,7 @@ static struct uart_driver timbuart_drive
 	.nr =3D 1
 };
=20
-static int timbuart_probe(struct platform_device *dev)
+static int __devinit timbuart_probe(struct platform_device *dev)
 {
 	int err, irq;
 	struct timbuart_port *uart;
@@ -489,7 +489,7 @@ err_mem:
 	return err;
 }
=20
-static int timbuart_remove(struct platform_device *dev)
+static int __devexit timbuart_remove(struct platform_device *dev)
 {
 	struct timbuart_port *uart =3D platform_get_drvdata(dev);
=20
@@ -507,7 +507,7 @@ static struct platform_driver timbuart_p
 		.owner	=3D THIS_MODULE,
 	},
 	.probe		=3D timbuart_probe,
-	.remove		=3D timbuart_remove,
+	.remove		=3D __devexit_p(timbuart_remove),
 };
=20
 /*--------------------------------------------------------------------=
------*/
_

Patches currently in -mm which might be from richard.rojfors@pelagicore=
=2Ecom are

linux-next.patch
timbuart-use-__devinit-and-__devexit-macros-for-probe-and-remove.patch
sdhci-pltfm-switch-to-module-device-table-matching.patch
sdhci-pltfm-reorganize-makefile-entries-to-support-soc-devices.patch
sdhci-pltfm-add-support-for-cns3xxx-soc-devices.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
