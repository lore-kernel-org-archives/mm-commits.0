From: akpm@linux-foundation.org
Subject: - sdio-fix-module-device-table-definition-for-m68k.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:48 -0800
Message-ID: <200802052226.m15MQThK011628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759822AbYBEW1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:27:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, drzeus@drzeus.cx, geert@linux-m68k.org, marcel@holtmann.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sdio: fix module device table definition for m68k
has been removed from the -mm tree.  Its filename was
     sdio-fix-module-device-table-definition-for-m68k.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
slab-leaks3-default-y.patch
