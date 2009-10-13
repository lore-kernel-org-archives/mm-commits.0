From: akpm@linux-foundation.org
Subject: + atmel_serial-fix-bad-build_bug_on-usage.patch added to -mm tree
Date: Tue, 13 Oct 2009 16:51:11 -0700
Message-ID: <200910132351.n9DNpBG4020445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761693AbZJMX5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 19:57:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com, alan@linux.intel.com, claudio@evidence.eu.com, hskinnemoen@atmel.com, jbeulich@novell.com, nicolas.ferre@atmel.com, u.kleine-koenig@pengutronix.de


The patch titled
     atmel_serial: fix bad BUILD_BUG_ON() usage
has been added to the -mm tree.  Its filename is
     atmel_serial-fix-bad-build_bug_on-usage.patch

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

linux-next.patch
atmel_serial-fix-bad-build_bug_on-usage.patch
mmc-atmel-mci-new-mci2-module-support-in-atmel-mci-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
