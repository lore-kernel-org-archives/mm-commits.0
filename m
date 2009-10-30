From: akpm@linux-foundation.org
Subject: [merged] atmel_serial-fix-bad-build_bug_on-usage.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:50:57 -0700
Message-ID: <200910302050.n9UKoveT011808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757526AbZJ3Uvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haavard.skinnemoen@atmel.com, alan@linux.intel.com, claudio@evidence.eu.com, hskinnemoen@atmel.com, jbeulich@novell.com, nicolas.ferre@atmel.com, u.kleine-koenig@pengutronix.de, mm-co


The patch titled
     atmel_serial: fix bad BUILD_BUG_ON() usage
has been removed from the -mm tree.  Its filename was
     atmel_serial-fix-bad-build_bug_on-usage.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: atmel_serial: fix bad BUILD_BUG_ON() usage
=46rom: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

is_power_of_2() appears not to be constant enough for BUILD_BUG_ON()
after the latest rework, so replace it with an open-coded test.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-bad-build_bug_=
on-usage drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-bad-build_bug_on-u=
sage
+++ a/drivers/serial/atmel_serial.c
@@ -1531,7 +1531,7 @@ static int __devinit atmel_serial_probe(
 	void *data;
 	int ret;
=20
-	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
+	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
=20
 	port =3D &atmel_ports[pdev->id];
 	port->backup_imr =3D 0;
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.c=
om are

origin.patch
linux-next.patch
mmc-atmel-mci-new-mci2-module-support-in-atmel-mci-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
