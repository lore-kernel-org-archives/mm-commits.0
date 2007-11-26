From: akpm@linux-foundation.org
Subject: - pci-get-rid-of-pci_devvendordevice_compatible-fields.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:49:12 -0800
Message-ID: <200711262149.lAQLnC8D024737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755418AbXKZV6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci: get rid of pci_dev::{vendor,device}_compatible fields
has been removed from the -mm tree.  Its filename was
     pci-get-rid-of-pci_devvendordevice_compatible-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci: get rid of pci_dev::{vendor,device}_compatible fields
From: Lennert Buytenhek <buytenh@wantstofly.org>

The vendor_compatible and device_compatible fields in struct pci_dev aren't
used anywhere, and are somewhat pointless.  Assuming that these are
historical artifacts, remove them.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/pci.h~pci-get-rid-of-pci_devvendordevice_compatible-fields include/linux/pci.h
--- a/include/linux/pci.h~pci-get-rid-of-pci_devvendordevice_compatible-fields
+++ a/include/linux/pci.h
@@ -66,7 +66,6 @@ enum pci_mmap_state {
 #define PCI_DMA_FROMDEVICE	2
 #define PCI_DMA_NONE		3
 
-#define DEVICE_COUNT_COMPATIBLE	4
 #define DEVICE_COUNT_RESOURCE	12
 
 typedef int __bitwise pci_power_t;
@@ -167,10 +166,6 @@ struct pci_dev {
 	pci_channel_state_t error_state;	/* current connectivity state */
 	struct	device	dev;		/* Generic device interface */
 
-	/* device is compatible with these IDs */
-	unsigned short vendor_compatible[DEVICE_COUNT_COMPATIBLE];
-	unsigned short device_compatible[DEVICE_COUNT_COMPATIBLE];
-
 	int		cfg_size;	/* Size of configuration space */
 
 	/*
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

git-arm.patch
