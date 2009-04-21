From: akpm@linux-foundation.org
Subject: + drivers-hwmon-coretempc-enable-the-intel-atom.patch added to -mm tree
Date: Tue, 21 Apr 2009 15:47:36 -0700
Message-ID: <200904212247.n3LMla4K021656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbZDUWtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 18:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.riepe@googlemail.com, arjan@infradead.org


The patch titled
     drivers/hwmon/coretemp.c: enable the Intel Atom
has been added to the -mm tree.  Its filename is
     drivers-hwmon-coretempc-enable-the-intel-atom.patch

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
Subject: drivers/hwmon/coretemp.c: enable the Intel Atom
=46rom: Michael Riepe <michael.riepe@googlemail.com>

Enable the coretemp driver on an Intel Atom.

I'm not sure if the readings are correct, however - on my 330, the driv=
er
reports values between 27 and 41 =B0C (with core1 being about 8=B0C hot=
ter
than core0, given the same load).  Maybe the maximum temperature of 100=
 =B0C
is wrong for Atom CPUs.

Michael "Tired" Riepe <michael.riepe@googlemail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/coretemp.c~drivers-hwmon-coretempc-enable-the-i=
ntel-atom drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~drivers-hwmon-coretempc-enable-the-intel=
-atom
+++ a/drivers/hwmon/coretemp.c
@@ -185,7 +185,7 @@ static int __devinit adjust_tjmax(struct
 		}
 	}
=20
-	if (ismobile) {
+	if (ismobile || c->x86_model =3D=3D 0x1c) {
=20
 		err =3D rdmsr_safe_on_cpu(id, 0xee, &eax, &edx);
 		if (err) {
@@ -417,7 +417,7 @@ static int __init coretemp_init(void)
 		if ((c->cpuid_level < 0) || (c->x86 !=3D 0x6) ||
 		    !((c->x86_model =3D=3D 0xe) || (c->x86_model =3D=3D 0xf) ||
 			(c->x86_model =3D=3D 0x16) || (c->x86_model =3D=3D 0x17) ||
-			(c->x86_model =3D=3D 0x1A))) {
+			(c->x86_model =3D=3D 0x1A) || (c->x86_model =3D=3D 0x1c))) {
=20
 			/* supported CPU not found, but report the unknown
 			   family 6 CPU */
_

Patches currently in -mm which might be from michael.riepe@googlemail.c=
om are

drivers-hwmon-coretempc-enable-the-intel-atom.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
