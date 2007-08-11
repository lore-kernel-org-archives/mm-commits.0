From: akpm@linux-foundation.org
Subject: - nikon-d50-is-an-unusual-device.patch removed from -mm tree
Date: Sat, 11 Aug 2007 09:49:09 -0700
Message-ID: <200708111649.l7BGn9aH016965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbXHKQuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 11 Aug 2007 12:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: niam.niam@gmail.com, caglar@pardus.org.tr, greg@kroah.com, oliver@neukum.org, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     NIKON D50 is an unusual device
has been removed from the -mm tree.  Its filename was
     nikon-d50-is-an-unusual-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NIKON D50 is an unusual device
From: Milinevsky Dmitry <niam.niam@gmail.com>

This short patch allows NIKON D50 to be mounted as UMS[unusual device]
on Linux niam 2.6.22-rc7-cfs-v18 #2 PREEMPT Tue Jul 3 22:35:53 EEST
2007 i686 Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel
GNU/Linux,
some previous kernels...

lsusb -v
Bus 001 Device 006: ID 04b0:0409 Nikon Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x04b0 Nikon Corp.
  idProduct          0x0409
  bcdDevice            1.00
  iManufacturer           1 NIKON
  iProduct                2 NIKON DSC D50
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered

Signed-off-by: Milinevsky Dmitry <niam.niam@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <caglar@pardus.org.tr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN drivers/usb/storage/unusual_devs.h~nikon-d50-is-an-unusual-device drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~nikon-d50-is-an-unusual-device
+++ a/drivers/usb/storage/unusual_devs.h
@@ -327,6 +327,13 @@ UNUSUAL_DEV(  0x04b0, 0x0409, 0x0100, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
+/* Reported by Milinevsky Dmitry <niam.niam@gmail.com> */
+UNUSUAL_DEV(  0x04b0, 0x0409, 0x0100, 0x0100,
+		"NIKON",
+		"NIKON DSC D50",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* Reported by Andreas Bockhold <andreas@bockionline.de> */
 UNUSUAL_DEV(  0x04b0, 0x0405, 0x0100, 0x0100,
 		"NIKON",
_

Patches currently in -mm which might be from niam.niam@gmail.com are

nikon-d50-is-an-unusual-device.patch
