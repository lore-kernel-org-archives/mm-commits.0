From: akpm@linux-foundation.org
Subject: - usb-ehci-tolerates-some-buggy-devices.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:09 -0800
Message-ID: <200802232023.m1NKN9gD013491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763504AbYBWU3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, andy@smile.org.ua, dbrownell@users.sourceforge.net, greg@kroah.com, sgosne@sequans.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: ehci tolerates some buggy devices
has been removed from the -mm tree.  Its filename was
     usb-ehci-tolerates-some-buggy-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: ehci tolerates some buggy devices
From: David Brownell <david-b@pacbell.net>

This teaches EHCI how to to work around bugs in certain high speed devices,
by accomodating "bulk" packets that exceed the 512 byte constant value
required by the USB 2.0 specification.  (Have a look at section 5.8.3,
paragraphs 1 and 3.)

It also makes the descriptor parsing code warn when it encounters such
bugs.  (We've had reports of maybe two or three such devices, all pretty
recent.)

Such devices are nonconformant.  The proper fix is have the vendors of
those devices do the simple, obvious, and correct thing ...  which will let
them be used with USB hosts that don't have workarounds for this particular
vendor bug.  But unless/until they do, we can at least have one of the high
speed HCDs work with such buggy devices.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andy Shevchenko <andy@smile.org.ua>
Cc: Gosne Stephane <sgosne@sequans.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/config.c |   17 +++++++++++++++++
 drivers/usb/host/ehci-q.c |   16 +++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff -puN drivers/usb/core/config.c~usb-ehci-tolerates-some-buggy-devices drivers/usb/core/config.c
--- a/drivers/usb/core/config.c~usb-ehci-tolerates-some-buggy-devices
+++ a/drivers/usb/core/config.c
@@ -145,6 +145,23 @@ static int usb_parse_endpoint(struct dev
 			endpoint->desc.wMaxPacketSize = cpu_to_le16(8);
 	}
 
+	/*
+	 * Some buggy high speed devices have bulk endpoints using
+	 * maxpacket sizes other than 512.  High speed HCDs may not
+	 * be able to handle that particular bug, so let's warn...
+	 */
+	if (to_usb_device(ddev)->speed == USB_SPEED_HIGH
+			&& usb_endpoint_xfer_bulk(d)) {
+		unsigned maxp;
+
+		maxp = le16_to_cpu(endpoint->desc.wMaxPacketSize) & 0x07ff;
+		if (maxp != 512)
+			dev_warn(ddev, "config %d interface %d altsetting %d "
+				"bulk endpoint 0x%X has invalid maxpacket %d\n",
+				cfgno, inum, asnum, d->bEndpointAddress,
+				maxp);
+	}
+
 	/* Skip over any Class Specific or Vendor Specific descriptors;
 	 * find the next endpoint or interface descriptor */
 	endpoint->extra = buffer;
diff -puN drivers/usb/host/ehci-q.c~usb-ehci-tolerates-some-buggy-devices drivers/usb/host/ehci-q.c
--- a/drivers/usb/host/ehci-q.c~usb-ehci-tolerates-some-buggy-devices
+++ a/drivers/usb/host/ehci-q.c
@@ -657,6 +657,14 @@ qh_make (
 	type = usb_pipetype (urb->pipe);
 	maxp = usb_maxpacket (urb->dev, urb->pipe, !is_input);
 
+	/* 1024 byte maxpacket is a hardware ceiling.  High bandwidth
+	 * acts like up to 3KB, but is built from smaller packets.
+	 */
+	if (max_packet(maxp) > 1024) {
+		ehci_dbg(ehci, "bogus qh maxpacket %d\n", max_packet(maxp));
+		goto done;
+	}
+
 	/* Compute interrupt scheduling parameters just once, and save.
 	 * - allowing for high bandwidth, how many nsec/uframe are used?
 	 * - split transactions need a second CSPLIT uframe; same question
@@ -757,7 +765,13 @@ qh_make (
 			info2 |= (EHCI_TUNE_MULT_HS << 30);
 		} else if (type == PIPE_BULK) {
 			info1 |= (EHCI_TUNE_RL_HS << 28);
-			info1 |= 512 << 16;	/* usb2 fixed maxpacket */
+			/* The USB spec says that high speed bulk endpoints
+			 * always use 512 byte maxpacket.  But some device
+			 * vendors decided to ignore that, and MSFT is happy
+			 * to help them do so.  So now people expect to use
+			 * such nonconformant devices with Linux too; sigh.
+			 */
+			info1 |= max_packet(maxp) << 16;
 			info2 |= (EHCI_TUNE_MULT_HS << 30);
 		} else {		/* PIPE_INTERRUPT */
 			info1 |= max_packet (maxp) << 16;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
atmel_spi-fix-clock-polarity.patch
git-acpi.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
git-avr32.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
rtc-cmos-display-hpet-emulation-mode.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
