From: akpm@linux-foundation.org
Subject: + usb-storage-initializersc-fix-signedness-difference.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:35:37 -0800
Message-ID: <200712182335.lBINZgrN027663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbXLRXfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:35:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, greg@kroah.com


The patch titled
     usb/storage/initializers.c: fix signedness difference
has been added to the -mm tree.  Its filename is
     usb-storage-initializersc-fix-signedness-difference.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: usb/storage/initializers.c: fix signedness difference
=46rom: Marcin =C5=9Alusarz <marcin.slusarz@gmail.com>

usb/storage/initializers.c: fix signedness difference

Signed-off-by: Marcin =C5=9Alusarz <marcin.slusarz@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/initializers.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/usb/storage/initializers.c~usb-storage-initializersc-=
fix-signedness-difference drivers/usb/storage/initializers.c
--- a/drivers/usb/storage/initializers.c~usb-storage-initializersc-fix-=
signedness-difference
+++ a/drivers/usb/storage/initializers.c
@@ -66,7 +66,8 @@ int usb_stor_ucr61s2b_init(struct us_dat
 {
 	struct bulk_cb_wrap *bcb =3D (struct bulk_cb_wrap*) us->iobuf;
 	struct bulk_cs_wrap *bcs =3D (struct bulk_cs_wrap*) us->iobuf;
-	int res, partial;
+	int res;
+	unsigned int partial;
 	static char init_string[] =3D "\xec\x0a\x06\x00$PCCHIPS";
=20
 	US_DEBUGP("Sending UCR-61S2B initialization packet...\n");
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com a=
re

git-alsa.patch
usb-storage-initializersc-fix-signedness-difference.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
