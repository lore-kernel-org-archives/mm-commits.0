From: akpm@linux-foundation.org
Subject: [merged] drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:55:15 -0700
Message-ID: <20120731185516.247D75C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:65159 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab2GaSzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:55:18 -0400
Received: by eekd4 with SMTP id d4so295688eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:55:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, dcb314@hotmail.com, jareguero@telefonica.net, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/dvb/dvb-usb/az6007.c: fix incorrect memcpy
has been removed from the -mm tree.  Its filename was
     drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch

