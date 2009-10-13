From: akpm@linux-foundation.org
Subject: + serial-atmel_serial-fix-another-fallout-of-the-change-to-build_bug_on.patch added to -mm tree
Date: Tue, 13 Oct 2009 10:13:44 -0700
Message-ID: <200910131713.n9DHDiCx002468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbZJMRTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 13:19:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, alan@linux.intel.com, hskinnemoen@atmel.com, jbeulich@novell.com


The patch titled
     serial/atmel_serial: fix fallout from the change to BUILD_BUG_ON
has been added to the -mm tree.  Its filename is
     serial-atmel_serial-fix-another-fallout-of-the-change-to-build_bug=
_on.patch

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
Subject: serial/atmel_serial: fix fallout from the change to BUILD_BUG_=
ON
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Commit 8c87df457cb5 ("BUILD_BUG_ON(): fix it and a couple of bogus uses=
 of
it") fixed BUILD_BUG_ON with the result that some expressions (e.g.  "n=
ot
really constant" ones) result in a build failure.

Some of these were fixed in 8c87df457cb5, but not serial/atmel_serial.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/serial/atmel_serial.c~serial-atmel_serial-fix-another=
-fallout-of-the-change-to-build_bug_on drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~serial-atmel_serial-fix-another-fal=
lout-of-the-change-to-build_bug_on
+++ a/drivers/serial/atmel_serial.c
@@ -1531,7 +1531,7 @@ static int __devinit atmel_serial_probe(
 	void *data;
 	int ret;
=20
-	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
+	MAYBE_BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
=20
 	port =3D &atmel_ports[pdev->id];
 	port->backup_imr =3D 0;
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
mmc-at91_mci-dont-include-asm-mach-mmch.patch
serial-atmel_serial-fix-another-fallout-of-the-change-to-build_bug_on.p=
atch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
