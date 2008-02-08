From: akpm@linux-foundation.org
Subject: - char-applicom-use-pci_match_id.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:21 -0800
Message-ID: <200802082020.m18KK2A4011131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762047AbYBHUlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:41:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, dwmw2@infradead.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: applicom, use pci_match_id
has been removed from the -mm tree.  Its filename was
     char-applicom-use-pci_match_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: applicom, use pci_match_id
From: Jiri Slaby <jirislaby@gmail.com>

Instead of testing hardcoded values, use pci_match_id to reference the
pci_device_id table. Sideways, it allows easy new additions to the table.

[akpm@linux-foundation.org: remove wrongly-added semicolon]
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/applicom.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/char/applicom.c~char-applicom-use-pci_match_id drivers/char/applicom.c
--- a/drivers/char/applicom.c~char-applicom-use-pci_match_id
+++ a/drivers/char/applicom.c
@@ -57,7 +57,6 @@
 #define PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN 0x0002
 #define PCI_DEVICE_ID_APPLICOM_PCI2000PFB     0x0003
 #endif
-#define MAX_PCI_DEVICE_NUM 3
 
 static char *applicom_pci_devnames[] = {
 	"PCI board",
@@ -66,12 +65,9 @@ static char *applicom_pci_devnames[] = {
 };
 
 static struct pci_device_id applicom_pci_tbl[] = {
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000PFB,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC) },
+	{ PCI_VDEVICE(APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN) },
+	{ PCI_VDEVICE(APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000PFB) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, applicom_pci_tbl);
@@ -197,10 +193,7 @@ static int __init applicom_init(void)
 
 	while ( (dev = pci_get_class(PCI_CLASS_OTHERS << 16, dev))) {
 
-		if (dev->vendor != PCI_VENDOR_ID_APPLICOM)
-			continue;
-		
-		if (dev->device  > MAX_PCI_DEVICE_NUM || dev->device == 0)
+		if (!pci_match_id(applicom_pci_tbl, dev))
 			continue;
 		
 		if (pci_enable_device(dev))
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
