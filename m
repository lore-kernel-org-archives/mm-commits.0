From: akpm@linux-foundation.org
Subject: [to-be-updated] acpi-fix-null-bug-for-hid-uid-string.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:36:02 -0700
Message-ID: <200908062336.n76Na2Xk024004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbZHFXhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.m.lin@intel.com, Valdis.Kletnieks@vt.edu, hugh.dickins@tiscali.co.uk, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: fix NULL bug for HID/UID string
has been removed from the -mm tree.  Its filename was
     acpi-fix-null-bug-for-hid-uid-string.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix NULL bug for HID/UID string
From: Lin Ming <ming.m.lin@intel.com>

acpi_device->pnp.hardware_id and unique_id are now allocated pointer. 
If it's NULL, return "\0" for acpi_device_hid and acpi_device_uid. 
Also, free hardware_id and unique_id when acpi_device is going to be
freed.

Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/scan.c     |    4 ++++
 include/acpi/acpi_bus.h |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/scan.c~acpi-fix-null-bug-for-hid-uid-string drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-fix-null-bug-for-hid-uid-string
+++ a/drivers/acpi/scan.c
@@ -309,6 +309,8 @@ static void acpi_device_release(struct d
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
 	kfree(acpi_dev->pnp.cid_list);
+	kfree(acpi_dev->pnp.hardware_id);
+	kfree(acpi_dev->pnp.unique_id);
 	kfree(acpi_dev);
 }
 
@@ -1359,6 +1361,8 @@ end:
 		*child = device;
 	else {
 		kfree(device->pnp.cid_list);
+		kfree(device->pnp.hardware_id);
+		kfree(device->pnp.unique_id);
 		kfree(device);
 	}
 
diff -puN include/acpi/acpi_bus.h~acpi-fix-null-bug-for-hid-uid-string include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-fix-null-bug-for-hid-uid-string
+++ a/include/acpi/acpi_bus.h
@@ -186,8 +186,8 @@ struct acpi_device_pnp {
 
 #define acpi_device_bid(d)	((d)->pnp.bus_id)
 #define acpi_device_adr(d)	((d)->pnp.bus_address)
-#define acpi_device_hid(d)	((d)->pnp.hardware_id)
-#define acpi_device_uid(d)	((d)->pnp.unique_id)
+#define acpi_device_hid(d)	((d)->pnp.hardware_id ? (d)->pnp.hardware_id : "\0")
+#define acpi_device_uid(d)	((d)->pnp.unique_id ? (d)->pnp.unique_id : "\0")
 #define acpi_device_name(d)	((d)->pnp.device_name)
 #define acpi_device_class(d)	((d)->pnp.device_class)
 
_

Patches currently in -mm which might be from ming.m.lin@intel.com are

origin.patch
linux-next.patch
acpi-fix-null-bug-for-hid-uid-string.patch

