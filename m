From: akpm@linux-foundation.org
Subject: + char-isicom-enable-disable-pci-device.patch added to -mm tree
Date: Thu, 10 Jul 2008 16:37:29 -0700
Message-ID: <200807102343.m6ANh4u5020868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142AbYGJXnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jul 2008 19:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, prabhatg@cdotd.ernet.in


The patch titled
     char: isicom, enable/disable pci device
has been added to the -mm tree.  Its filename is
     char-isicom-enable-disable-pci-device.patch

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
Subject: char: isicom, enable/disable pci device
From: Jiri Slaby <jirislaby@gmail.com>

Don't forget to enable and disable PCI devices.  The device might be unusable
without that.

Might fix http://bugzilla.kernel.org/show_bug.cgi?id=11067

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Prabhat Gupta <prabhatg@cdotd.ernet.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/char/isicom.c~char-isicom-enable-disable-pci-device drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-enable-disable-pci-device
+++ a/drivers/char/isicom.c
@@ -1736,6 +1736,12 @@ static int __devinit isicom_probe(struct
 	if (card_count >= BOARD_COUNT)
 		goto err;
 
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		dev_err(&pdev->dev, "failed to enable\n");
+		goto err;
+	}
+
 	dev_info(&pdev->dev, "ISI PCI Card(Device ID 0x%x)\n", ent->device);
 
 	/* allot the first empty slot in the array */
@@ -1790,6 +1796,7 @@ errunrr:
 errdec:
 	board->base = 0;
 	card_count--;
+	pci_disable_device(pdev);
 err:
 	return retval;
 }
@@ -1806,6 +1813,7 @@ static void __devexit isicom_remove(stru
 	pci_release_region(pdev, 3);
 	board->base = 0;
 	card_count--;
+	pci_disable_device(pdev);
 }
 
 static int __init isicom_init(void)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
char-isicom-enable-disable-pci-device.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

