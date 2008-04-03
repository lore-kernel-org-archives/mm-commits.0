From: akpm@linux-foundation.org
Subject: + x86-fix-off-by-one-errors-in-some-pirq-warnings.patch added to -mm tree
Date: Thu, 03 Apr 2008 12:05:18 -0700
Message-ID: <200804031905.m33J5Ila017590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755770AbYDCTFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 15:05:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: B.Steinbrink@gmx.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix off-by-one errors in some pirq warnings
has been added to the -mm tree.  Its filename is
     x86-fix-off-by-one-errors-in-some-pirq-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: x86: fix off-by-one errors in some pirq warnings
=46rom: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>

The conditions for the warnings simply ignored the fact that we later a=
ctually
use the original value minus 1, so the warning triggered even for valid=
 values.

Signed-off-by: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/irq.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86/pci/irq.c~x86-fix-off-by-one-errors-in-some-pirq-war=
nings arch/x86/pci/irq.c
--- a/arch/x86/pci/irq.c~x86-fix-off-by-one-errors-in-some-pirq-warning=
s
+++ a/arch/x86/pci/irq.c
@@ -200,7 +200,7 @@ static int pirq_ali_get(struct pci_dev *
 {
 	static const unsigned char irqmap[16] =3D { 0, 9, 3, 10, 4, 5, 7, 6, =
1, 11, 0, 12, 0, 14, 0, 15 };
=20
-	WARN_ON_ONCE(pirq >=3D 16);
+	WARN_ON_ONCE(pirq > 16);
 	return irqmap[read_config_nybble(router, 0x48, pirq-1)];
 }
=20
@@ -209,7 +209,7 @@ static int pirq_ali_set(struct pci_dev *
 	static const unsigned char irqmap[16] =3D { 0, 8, 0, 2, 4, 5, 7, 6, 0=
, 1, 3, 9, 11, 0, 13, 15 };
 	unsigned int val =3D irqmap[irq];
=20
-	WARN_ON_ONCE(pirq >=3D 16);
+	WARN_ON_ONCE(pirq > 16);
 	if (val) {
 		write_config_nybble(router, 0x48, pirq-1, val);
 		return 1;
@@ -260,7 +260,7 @@ static int pirq_via586_get(struct pci_de
 {
 	static const unsigned int pirqmap[5] =3D { 3, 2, 5, 1, 1 };
=20
-	WARN_ON_ONCE(pirq >=3D 5);
+	WARN_ON_ONCE(pirq > 5);
 	return read_config_nybble(router, 0x55, pirqmap[pirq-1]);
 }
=20
@@ -268,7 +268,7 @@ static int pirq_via586_set(struct pci_de
 {
 	static const unsigned int pirqmap[5] =3D { 3, 2, 5, 1, 1 };
=20
-	WARN_ON_ONCE(pirq >=3D 5);
+	WARN_ON_ONCE(pirq > 5);
 	write_config_nybble(router, 0x55, pirqmap[pirq-1], irq);
 	return 1;
 }
@@ -282,7 +282,7 @@ static int pirq_ite_get(struct pci_dev *
 {
 	static const unsigned char pirqmap[4] =3D { 1, 0, 2, 3 };
=20
-	WARN_ON_ONCE(pirq >=3D 4);
+	WARN_ON_ONCE(pirq > 4);
 	return read_config_nybble(router,0x43, pirqmap[pirq-1]);
 }
=20
@@ -290,7 +290,7 @@ static int pirq_ite_set(struct pci_dev *
 {
 	static const unsigned char pirqmap[4] =3D { 1, 0, 2, 3 };
=20
-	WARN_ON_ONCE(pirq >=3D 4);
+	WARN_ON_ONCE(pirq > 4);
 	write_config_nybble(router, 0x43, pirqmap[pirq-1], irq);
 	return 1;
 }
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are

x86-fix-off-by-one-errors-in-some-pirq-warnings.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
