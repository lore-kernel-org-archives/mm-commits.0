From: akpm@linux-foundation.org
Subject: [patch 08/14] treewide: remove references to the now unnecessary
 DEFINE_PCI_DEVICE_TABLE
Date: Thu, 01 Sep 2016 16:15:01 -0700
Message-ID: <57c8b675.zBzSYEYBZAfJe1wU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbcIAXPC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 19:15:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, apw@canonical.com, bhelgaas@google.com, corbet@lwn.net, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

From: Joe Perches <joe@perches.com>
Subject: treewide: remove references to the now unnecessary DEFINE_PCI_DEVICE_TABLE

It's been eliminated from the sources, remove it from everywhere else.

Link: http://lkml.kernel.org/r/076eff466fd7edb550c25c8b25d76924ca0eba62.1472660229.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/PCI/pci.txt |    1 -
 include/linux/pci.h       |    9 ---------
 scripts/checkpatch.pl     |    9 ---------
 scripts/tags.sh           |    1 -
 4 files changed, 20 deletions(-)

diff -puN Documentation/PCI/pci.txt~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table Documentation/PCI/pci.txt
--- a/Documentation/PCI/pci.txt~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table
+++ a/Documentation/PCI/pci.txt
@@ -124,7 +124,6 @@ initialization with a pointer to a struc
 
 The ID table is an array of struct pci_device_id entries ending with an
 all-zero entry.  Definitions with static const are generally preferred.
-Use of the deprecated macro DEFINE_PCI_DEVICE_TABLE should be avoided.
 
 Each entry consists of:
 
diff -puN include/linux/pci.h~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table include/linux/pci.h
--- a/include/linux/pci.h~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table
+++ a/include/linux/pci.h
@@ -683,15 +683,6 @@ struct pci_driver {
 #define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
 
 /**
- * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
- * @_table: device table name
- *
- * This macro is deprecated and should not be used in new code.
- */
-#define DEFINE_PCI_DEVICE_TABLE(_table) \
-	const struct pci_device_id _table[]
-
-/**
  * PCI_DEVICE - macro used to describe a specific pci device
  * @vend: the 16 bit PCI Vendor ID
  * @dev: the 16 bit PCI Device ID
diff -puN scripts/checkpatch.pl~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~treewide-remove-references-to-the-now-unnecessary-define_pci_device_table
+++ a/scripts/checkpatch.pl
@@ -3570,15 +3570,6 @@ sub process {
 			}
 		}
 
-# check for uses of DEFINE_PCI_DEVICE_TABLE
-		if ($line =~ /\bDEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=/) {
-			if (WARN("DEFINE_PCI_DEVICE_TABLE",
-				 "Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE\n" . $herecurr) &&
-			    $fix) {
-				$fixed[$fixlinenr] =~ s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=\s*/static const struct pci_device_id $1\[\] = /;
-			}
-		}
