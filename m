From: akpm@linux-foundation.org
Subject: + drivers-input-misc-winbond-circ-needs-leds_triggers.patch added to -mm tree
Date: Mon, 02 Nov 2009 13:38:32 -0800
Message-ID: <200911022138.nA2LcWV9029062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756700AbZKBVin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 16:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@hardeman.nu, dtor@mail.ru


The patch titled
     drivers/input/misc/winbond-cir.c needs LEDS_TRIGGERS
has been added to the -mm tree.  Its filename is
     drivers-input-misc-winbond-circ-needs-leds_triggers.patch

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
Subject: drivers/input/misc/winbond-cir.c needs LEDS_TRIGGERS
=46rom: David H=E4rdeman <david@hardeman.nu>

drivers/input/misc/winbond-cir.c depends on LEDS_TRIGGERS

Add an appropriate select to drivers/input/misc/Kconfig

Signed-off-by: David H=E4rdeman <david@hardeman.nu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/input/misc/Kconfig~drivers-input-misc-winbond-circ-ne=
eds-leds_triggers drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~drivers-input-misc-winbond-circ-needs-=
leds_triggers
+++ a/drivers/input/misc/Kconfig
@@ -227,6 +227,7 @@ config INPUT_WINBOND_CIR
 	depends on X86 && PNP
 	select NEW_LEDS
 	select LEDS_CLASS
+	select LEDS_TRIGGERS
 	select BITREVERSE
 	help
 	  Say Y here if you want to use the IR remote functionality found
_

Patches currently in -mm which might be from david@hardeman.nu are

origin.patch
acpi-reintroduce-acpi_device_ops-shutdown-method.patch
drivers-input-misc-winbond-circ-needs-leds_triggers.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
