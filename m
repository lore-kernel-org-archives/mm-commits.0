From: akpm@linux-foundation.org
Subject: + usb-yurex-recognize-generalkeys-wireless-presenter-as-generic-hid.patch added to -mm tree
Date: Thu, 20 Jan 2011 14:57:32 -0800
Message-ID: <201101202257.p0KMvWDU007513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825Ab1ATW56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 17:57:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomoki.sekiyama@gmail.com, gregkh@suse.de, maciej.rutecki@gmail.com, rjw@sisk.pl, thomas@archlinux.org


The patch titled
     USB: yurex: recognize GeneralKeys wireless presenter as generic HI=
D
has been added to the -mm tree.  Its filename is
     usb-yurex-recognize-generalkeys-wireless-presenter-as-generic-hid.=
patch

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
Subject: USB: yurex: recognize GeneralKeys wireless presenter as generi=
c HID
=46rom: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

Unfortunately, the device seems to have the same Vendor ID and Product =
ID
as YUREX leg-shakes sensors, and the commit 6bc235a2e2 ("USB: add drive=
r
for Meywa-Denki & Kayac YUREX") added the ID to hid_ignore_list.

I believe that we can distinguish YUREX and the Wireless Presenter by
device type.  The patch below makes the driver ignore only YUREX
(bInterfaceProtocol=3D=3D0), and recognize Wireless Presenter
(bInterfaceProtocol is keyboard or mouse) as generic HID.  (I don't hav=
e
the Wireless Presenter, so not yet ested.)

** YUREX lsusb information:
Bus 002 Device 007: ID 0c45:1010 Microdia
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x0c45 Microdia
   idProduct          0x1010
   bcdDevice            0.03
   iManufacturer           1 JESS
   iProduct                2 YUREX
   iSerial                 3 10000269
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           34
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      0 None
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      31
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
Device Status:     0x0002
   (Bus Powered)
   Remote Wakeup Enabled

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=3D26922

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Cc: Greg KH <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Reported-by: Thomas B=E4chler <thomas@archlinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-core.c        |    6 +++++-
 drivers/hid/usbhid/hid-core.c |    2 ++
 include/linux/hid.h           |    3 ++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/hid/hid-core.c~usb-yurex-recognize-generalkeys-wirele=
ss-presenter-as-generic-hid drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~usb-yurex-recognize-generalkeys-wireless-p=
resenter-as-generic-hid
+++ a/drivers/hid/hid-core.c
@@ -1710,7 +1710,6 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GTCO, USB_DEVICE_ID_GTCO_1006) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GTCO, USB_DEVICE_ID_GTCO_1007) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IMATION, USB_DEVICE_ID_DISC_STAKKA) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_JESS_YUREX) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KBGEAR, USB_DEVICE_ID_KBGEAR_JAMSTUDIO=
) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KWORLD, USB_DEVICE_ID_KWORLD_RADIO_FM7=
00) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_GPEN_560) },
@@ -1830,6 +1829,11 @@ static bool hid_ignore(struct hid_device
 		    hdev->product <=3D USB_DEVICE_ID_HANWANG_TABLET_LAST)
 			return true;
 		break;
+	case USB_VENDOR_ID_JESS:
+		if (hdev->product =3D=3D USB_DEVICE_ID_JESS_YUREX &&
+				hdev->type =3D=3D HID_TYPE_USBNONE)
+			return true;
+	break;
 	}
=20
 	if (hdev->type =3D=3D HID_TYPE_USBMOUSE &&
diff -puN drivers/hid/usbhid/hid-core.c~usb-yurex-recognize-generalkeys=
-wireless-presenter-as-generic-hid drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c~usb-yurex-recognize-generalkeys-wir=
eless-presenter-as-generic-hid
+++ a/drivers/hid/usbhid/hid-core.c
@@ -1156,6 +1156,8 @@ static int usbhid_probe(struct usb_inter
 	if (intf->cur_altsetting->desc.bInterfaceProtocol =3D=3D
 			USB_INTERFACE_PROTOCOL_MOUSE)
 		hid->type =3D HID_TYPE_USBMOUSE;
+	else if (intf->cur_altsetting->desc.bInterfaceProtocol =3D=3D 0)
+		hid->type =3D HID_TYPE_USBNONE;
=20
 	if (dev->manufacturer)
 		strlcpy(hid->name, dev->manufacturer, sizeof(hid->name));
diff -puN include/linux/hid.h~usb-yurex-recognize-generalkeys-wireless-=
presenter-as-generic-hid include/linux/hid.h
--- a/include/linux/hid.h~usb-yurex-recognize-generalkeys-wireless-pres=
enter-as-generic-hid
+++ a/include/linux/hid.h
@@ -453,7 +453,8 @@ struct hid_input {
=20
 enum hid_type {
 	HID_TYPE_OTHER =3D 0,
-	HID_TYPE_USBMOUSE
+	HID_TYPE_USBMOUSE,
+	HID_TYPE_USBNONE =3D -1,
 };
=20
 struct hid_driver;
_

Patches currently in -mm which might be from tomoki.sekiyama@gmail.com =
are

usb-yurex-recognize-generalkeys-wireless-presenter-as-generic-hid.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
