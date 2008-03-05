From: akpm@linux-foundation.org
Subject: + aiptekc-add-support-for-genius-g-pen-560-tablet.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:52:52 -0800
Message-ID: <200803052252.m25MqqVG025492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765413AbYCEWxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:53:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guryanov@dgap.mipt.ru, jkosina@suse.cz


The patch titled
     aiptek.c: add support for Genius G-PEN 560 tablet (fwd)
has been added to the -mm tree.  Its filename is
     aiptekc-add-support-for-genius-g-pen-560-tablet.patch

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
Subject: aiptek.c: add support for Genius G-PEN 560 tablet (fwd)
From: Guryanov Dmitry <guryanov@dgap.mipt.ru>

Now this tablet works with usbhid driver in relative mode only, which is
useless for tablet.  It works well with aiptek.c, so add its support to aiptek
driver.

Signed-off-by: Dmitry Guryanov <guryanov@dgap.mipt.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-quirks.c |    4 ++++
 drivers/input/tablet/Kconfig    |   10 +++++-----
 drivers/input/tablet/aiptek.c   |    2 ++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/hid/usbhid/hid-quirks.c~aiptekc-add-support-for-genius-g-pen-560-tablet drivers/hid/usbhid/hid-quirks.c
--- a/drivers/hid/usbhid/hid-quirks.c~aiptekc-add-support-for-genius-g-pen-560-tablet
+++ a/drivers/hid/usbhid/hid-quirks.c
@@ -405,6 +405,9 @@
 #define USB_VENDOR_ID_YEALINK		0x6993
 #define USB_DEVICE_ID_YEALINK_P1K_P4K_B2K	0xb001
 
+#define USB_VENDOR_ID_KYE		0x0458
+#define USB_DEVICE_ID_KYE_GPEN_560	0x5003
+
 /*
  * Alphabetically sorted blacklist by quirk type.
  */
@@ -703,6 +706,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_HARMONY_63, HID_QUIRK_IGNORE },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_HARMONY_64, HID_QUIRK_IGNORE },
 	{ USB_VENDOR_ID_NATIONAL_SEMICONDUCTOR, USB_DEVICE_ID_N_S_HARMONY, HID_QUIRK_IGNORE },
+	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_GPEN_560, HID_QUIRK_IGNORE },
 
 	{ 0, 0 }
 };
diff -puN drivers/input/tablet/Kconfig~aiptekc-add-support-for-genius-g-pen-560-tablet drivers/input/tablet/Kconfig
--- a/drivers/input/tablet/Kconfig~aiptekc-add-support-for-genius-g-pen-560-tablet
+++ a/drivers/input/tablet/Kconfig
@@ -25,14 +25,14 @@ config TABLET_USB_ACECAD
 	  module will be called acecad.
 
 config TABLET_USB_AIPTEK
-	tristate "Aiptek 6000U/8000U tablet support (USB)"
+	tristate "Aiptek 6000U/8000U and Genius G_PEN tablet support (USB)"
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
-	  Say Y here if you want to use the USB version of the Aiptek 6000U
-	  or Aiptek 8000U tablet.  Make sure to say Y to "Mouse support"
-	  (CONFIG_INPUT_MOUSEDEV) and/or "Event interface support"
-	  (CONFIG_INPUT_EVDEV) as well.
+	  Say Y here if you want to use the USB version of the Aiptek 6000U,
+	  Aiptek 8000U or Genius G-PEN 560 tablet.  Make sure to say Y to
+	  "Mouse support" (CONFIG_INPUT_MOUSEDEV) and/or "Event interface
+	  support" (CONFIG_INPUT_EVDEV) as well.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called aiptek.
diff -puN drivers/input/tablet/aiptek.c~aiptekc-add-support-for-genius-g-pen-560-tablet drivers/input/tablet/aiptek.c
--- a/drivers/input/tablet/aiptek.c~aiptekc-add-support-for-genius-g-pen-560-tablet
+++ a/drivers/input/tablet/aiptek.c
@@ -184,6 +184,7 @@
  */
 
 #define USB_VENDOR_ID_AIPTEK				0x08ca
+#define USB_VENDOR_ID_KYE				0x0458
 #define USB_REQ_GET_REPORT				0x01
 #define USB_REQ_SET_REPORT				0x09
 
@@ -832,6 +833,7 @@ static const struct usb_device_id aiptek
 	{USB_DEVICE(USB_VENDOR_ID_AIPTEK, 0x22)},
 	{USB_DEVICE(USB_VENDOR_ID_AIPTEK, 0x23)},
 	{USB_DEVICE(USB_VENDOR_ID_AIPTEK, 0x24)},
+	{USB_DEVICE(USB_VENDOR_ID_KYE, 0x5003)},
 	{}
 };
 
_

Patches currently in -mm which might be from guryanov@dgap.mipt.ru are

aiptekc-add-support-for-genius-g-pen-560-tablet.patch

