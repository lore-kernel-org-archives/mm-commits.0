From: akpm@linux-foundation.org
Subject: + pci-get-rid-of-pci_devvendordevice_compatible-fields.patch added to -mm tree
Date: Thu, 01 Nov 2007 13:22:22 -0700
Message-ID: <20071101202222.63AB3432BDC@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:41984 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbXKAUWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 16:22:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, greg@kroah.com


The patch titled
     pci: get rid of pci_dev::{vendor,device}_compatible fields
has been added to the -mm tree.  Its filename is
     pci-get-rid-of-pci_devvendordevice_compatible-fields.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-hwmon.patch
pci-get-rid-of-pci_devvendordevice_compatible-fields.patch
