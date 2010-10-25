From: akpm@linux-foundation.org
Subject: + drivers-char-mxserc-fix-compilation-warning-in-mxserc.patch added to -mm tree
Date: Mon, 25 Oct 2010 14:11:56 -0700
Message-ID: <201010252111.o9PLBuNu016614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab0JYVL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 17:11:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, jirislaby@gmail.com


The patch titled
     drivers/char/mxser.c: fix compilation warning in mxser.c
has been added to the -mm tree.  Its filename is
     drivers-char-mxserc-fix-compilation-warning-in-mxserc.patch

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
Subject: drivers/char/mxser.c: fix compilation warning in mxser.c
=46rom: Rakib Mullick <rakib.mullick@gmail.com>

Both mxser_disable_must_enchance_mode() and mxser_get_must_hardware_id(=
)
called from function CheckIsMoxaMust(), when CONFIG_PCI=3Dy.  So mark b=
oth
the functions under CONFIG_PCI.

We were warned by the following warning.

drivers/char/mxser.c:306: warning: =91mxser_disable_must_enchance_mode=92
defined but not used
drivers/char/mxser.c:391: warning: =91mxser_get_must_hardware_id=92
defined but not used

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/mxser.c~drivers-char-mxserc-fix-compilation-warn=
ing-in-mxserc drivers/char/mxser.c
--- a/drivers/char/mxser.c~drivers-char-mxserc-fix-compilation-warning-=
in-mxserc
+++ a/drivers/char/mxser.c
@@ -303,6 +303,7 @@ static void mxser_enable_must_enchance_m
 	outb(oldlcr, baseio + UART_LCR);
 }
=20
+#ifdef	CONFIG_PCI
 static void mxser_disable_must_enchance_mode(unsigned long baseio)
 {
 	u8 oldlcr;
@@ -317,6 +318,7 @@ static void mxser_disable_must_enchance_
 	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
 	outb(oldlcr, baseio + UART_LCR);
 }
+#endif
=20
 static void mxser_set_must_xon1_value(unsigned long baseio, u8 value)
 {
@@ -388,6 +390,7 @@ static void mxser_set_must_enum_value(un
 	outb(oldlcr, baseio + UART_LCR);
 }
=20
+#ifdef CONFIG_PCI
 static void mxser_get_must_hardware_id(unsigned long baseio, u8 *pId)
 {
 	u8 oldlcr;
@@ -404,6 +407,7 @@ static void mxser_get_must_hardware_id(u
 	*pId =3D inb(baseio + MOXA_MUST_HWID_REGISTER);
 	outb(oldlcr, baseio + UART_LCR);
 }
+#endif
=20
 static void SET_MOXA_MUST_NO_SOFTWARE_FLOW_CONTROL(unsigned long basei=
o)
 {
_

Patches currently in -mm which might be from rakib.mullick@gmail.com ar=
e

linux-next.patch
kernel-stop_machinec-fix-unused-variable-warning.patch
drivers-char-mxserc-fix-compilation-warning-in-mxserc.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
