From: akpm@linux-foundation.org
Subject: + sdio-fix-module-device-table-definition-for-m68k.patch added to -mm tree
Date: Thu, 29 Nov 2007 13:19:52 -0800
Message-ID: <200711292119.lATLJqXx007878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40072 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756974AbXK2VVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 16:21:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, drzeus@drzeus.cx, geert@linux-m68k.org, marcel@holtmann.org, sam@ravnborg.org


The patch titled
     sdio: fix module device table definition for m68k
has been added to the -mm tree.  Its filename is
     sdio-fix-module-device-table-definition-for-m68k.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sdio: fix module device table definition for m68k
From: Al Viro <viro@ftp.linux.org.uk>

FATAL: drivers/bluetooth/btsdio: sizeof(struct sdio_device_id)=12 is not a modulo of the size of section __mod_sdio_device_table=30.
Fix definition of struct sdio_device_id in mod_devicetable.h

m68k has 16bit alignment for unsigned long.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
CC: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mod_devicetable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/mod_devicetable.h~sdio-fix-module-device-table-definition-for-m68k include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~sdio-fix-module-device-table-definition-for-m68k
+++ a/include/linux/mod_devicetable.h
@@ -343,7 +343,8 @@ struct sdio_device_id {
 	__u8	class;			/* Standard interface or SDIO_ANY_ID */
 	__u16	vendor;			/* Vendor or SDIO_ANY_ID */
 	__u16	device;			/* Device ID or SDIO_ANY_ID */
-	kernel_ulong_t driver_data;	/* Data private to the driver */
+	kernel_ulong_t driver_data	/* Data private to the driver */
+		__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
 /* SSB core, see drivers/ssb/ */
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

sdio-fix-module-device-table-definition-for-m68k.patch
slab-leaks3-default-y.patch
