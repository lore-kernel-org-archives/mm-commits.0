From: akpm@osdl.org
Subject: - usb-auerswald-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:21 -0800
Message-ID: <200612130656.kBD6uLgP030716@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965047AbWLMG4X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan_952@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     USB AUERSWALD: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     usb-auerswald-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB AUERSWALD: replace kmalloc+memset with kzalloc
From: "Burman Yan" <yan_952@hotmail.com>



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/misc/auerswald.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/usb/misc/auerswald.c~usb-auerswald-replace-kmallocmemset-with-kzalloc drivers/usb/misc/auerswald.c
--- a/drivers/usb/misc/auerswald.c~usb-auerswald-replace-kmallocmemset-with-kzalloc
+++ a/drivers/usb/misc/auerswald.c
@@ -1376,7 +1376,7 @@ static int auerchar_open (struct inode *
 	}
 
 	/* we have access to the device. Now lets allocate memory */
-	ccp = (pauerchar_t) kmalloc(sizeof(auerchar_t), GFP_KERNEL);
+	ccp = kzalloc(sizeof(auerchar_t), GFP_KERNEL);
 	if (ccp == NULL) {
 		err ("out of memory");
 		ret = -ENOMEM;
@@ -1384,7 +1384,6 @@ static int auerchar_open (struct inode *
 	}
 
 	/* Initialize device descriptor */
-	memset( ccp, 0, sizeof(auerchar_t));
 	init_MUTEX( &ccp->mutex);
 	init_MUTEX( &ccp->readmutex);
         auerbuf_init (&ccp->bufctl);
@@ -1912,14 +1911,13 @@ static int auerswald_probe (struct usb_i
 		return -ENODEV;
 
 	/* allocate memory for our device and initialize it */
-	cp = kmalloc (sizeof(auerswald_t), GFP_KERNEL);
+	cp = kzalloc (sizeof(auerswald_t), GFP_KERNEL);
 	if (cp == NULL) {
 		err ("out of memory");
 		goto pfail;
 	}
 
 	/* Initialize device descriptor */
-	memset (cp, 0, sizeof(auerswald_t));
 	init_MUTEX (&cp->mutex);
 	cp->usbdev = usbdev;
 	auerchain_init (&cp->controlchain);
_

Patches currently in -mm which might be from yan_952@hotmail.com are

origin.patch
acpi-replace-kmallocmemset-with-kzalloc.patch
git-mtd.patch
serial-replace-kmallocmemset-with-kzalloc.patch

