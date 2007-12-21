From: akpm@linux-foundation.org
Subject: - usb-storage-initializersc-fix-signedness-difference.patch removed from -mm tree
Date: Fri, 21 Dec 2007 14:08:54 -0800
Message-ID: <200712212208.lBLM8sic001738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756312AbXLUWJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 17:09:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb/storage/initializers.c: fix signedness difference
has been removed from the -mm tree.  Its filename was
     usb-storage-initializersc-fix-signedness-difference.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: usb/storage/initializers.c: fix signedness difference
=46rom: Marcin =C5=9Alusarz <marcin.slusarz@gmail.com>

=46ix 2 sparse warnings:

drivers/usb/storage/initializers.c:83:26: warning: incorrect type in ar=
gument 5 (different signedness)
drivers/usb/storage/initializers.c:83:26:    expected unsigned int *act=
_len
drivers/usb/storage/initializers.c:83:26:    got int *<noident>
drivers/usb/storage/initializers.c:89:26: warning: incorrect type in ar=
gument 5 (different signedness)
drivers/usb/storage/initializers.c:89:26:    expected unsigned int *act=
_len
drivers/usb/storage/initializers.c:89:26:    got int *<noident>

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
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fi=
xes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
