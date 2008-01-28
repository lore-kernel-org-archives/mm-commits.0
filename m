From: akpm@linux-foundation.org
Subject: + smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:28:39 -0800
Message-ID: <200801280529.m0S5TXkc013993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYA1FaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:30:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wim@iguana.be, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, khali@linux-fr.org, lenb@kernel.org


The patch titled
     SMBIOS/DMI: add type 41 = Onboard Devices Extended Information
has been added to the -mm tree.  Its filename is
     smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SMBIOS/DMI: add type 41 = Onboard Devices Extended Information
From: Wim Van Sebroeck <wim@iguana.be>

From version 2.6 of the SMBIOS standard, type 10 (On Board Devices
Information) becomes obsolete.  The reason for this is that no further
fields can be added to this structure without adversely affecting existing
software's ability to properly parse the data.

Therefore type 41 (Onboard Devices Extended Information) was added.
The structure is as follows:

struct smbios_type_41 {
	u8 type;
	u8 length;
	u16 handle;
	u8 reference_designation_string;
	u8 device_type;		/* same device type as in type 10 */
	u8 device_type_instance;
	u16 segment_group_number;
	u8 bus_number;
	u8 device_function_number;
};

For more info: http://www.dmtf.org/standards/smbios

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   25 +++++++++++++++++++++++++
 include/linux/dmi.h         |    5 ++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff -puN drivers/firmware/dmi_scan.c~smbios-dmi-add-type-41-=-onboard-devices-extended-information drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~smbios-dmi-add-type-41-=-onboard-devices-extended-information
+++ a/drivers/firmware/dmi_scan.c
@@ -250,6 +250,28 @@ static void __init dmi_save_ipmi_device(
 	list_add(&dev->list, &dmi_devices);
 }
 
+static void __init dmi_save_extended_devices(const struct dmi_header *dm)
+{
+	const u8 *d = (u8*) dm + 5;
+	struct dmi_device *dev;
+
+	/* Skip disabled device */
+	if ((*d & 0x80) == 0)
+		return;
+
+	dev = dmi_alloc(sizeof(*dev));
+	if (!dev) {
+		printk(KERN_ERR "dmi_save_extended_devices: out of memory.\n");
+		return;
+	}
+
+	dev->type = *d-- & 0x7f;
+	dev->name = dmi_string(dm, *d);
+	dev->device_data = NULL;
+
+	list_add(&dev->list, &dmi_devices);
+}
+
 /*
  *	Process a DMI table entry. Right now all we care about are the BIOS
  *	and machine entries. For 2.5 we should pull the smbus controller info
@@ -292,6 +314,9 @@ static void __init dmi_decode(const stru
 		break;
 	case 38:	/* IPMI Device Information */
 		dmi_save_ipmi_device(dm);
+		break;
+	case 41:	/* Onboard Devices Extended Information */
+		dmi_save_extended_devices(dm);
 	}
 }
 
diff -puN include/linux/dmi.h~smbios-dmi-add-type-41-=-onboard-devices-extended-information include/linux/dmi.h
--- a/include/linux/dmi.h~smbios-dmi-add-type-41-=-onboard-devices-extended-information
+++ a/include/linux/dmi.h
@@ -35,8 +35,11 @@ enum dmi_device_type {
 	DMI_DEV_TYPE_ETHERNET,
 	DMI_DEV_TYPE_TOKENRING,
 	DMI_DEV_TYPE_SOUND,
+	DMI_DEV_TYPE_PATA,
+	DMI_DEV_TYPE_SATA,
+	DMI_DEV_TYPE_SAS,
 	DMI_DEV_TYPE_IPMI = -1,
-	DMI_DEV_TYPE_OEM_STRING = -2
+	DMI_DEV_TYPE_OEM_STRING = -2,
 };
 
 struct dmi_header {
_

Patches currently in -mm which might be from wim@iguana.be are

origin.patch
git-watchdog.patch
git-watchdog-fixup.patch
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
