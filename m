From: akpm@linux-foundation.org
Subject: + drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:09:13 -0700
Message-ID: <20120724210913.AAF18100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:43502 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2GXVJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:09:14 -0400
Received: by ghbz15 with SMTP id z15so4960ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:09:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, dcb314@hotmail.com, jareguero@telefonica.net, mchehab@infradead.org


The patch titled
     Subject: drivers/media/dvb/dvb-usb/az6007.c: fix incorrect memcpy
has been added to the -mm tree.  Its filename is
     drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/media/dvb/dvb-usb/az6007.c: fix incorrect memcpy

Some parts of the C language are subtle and evil. This is one example.

(akpm: sizeof returns sizeof(u8*) here).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=44041

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/az6007.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/dvb-usb/az6007.c~drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy drivers/media/dvb/dvb-usb/az6007.c
--- a/drivers/media/dvb/dvb-usb/az6007.c~drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy
+++ a/drivers/media/dvb/dvb-usb/az6007.c
@@ -590,7 +590,7 @@ static int az6007_read_mac_addr(struct d
 	int ret;
 
 	ret = az6007_read(d, AZ6007_READ_DATA, 6, 0, st->data, 6);
-	memcpy(mac, st->data, sizeof(mac));
+	memcpy(mac, st->data, 6);
 
 	if (ret > 0)
 		deb_info("%s: mac is %pM\n", __func__, mac);
_
Subject: Subject: drivers/media/dvb/dvb-usb/az6007.c: fix incorrect memcpy

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch
drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-avoid-argv_freenull.patch
drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid.patch

