From: akpm@linux-foundation.org
Subject: + add-support-for-1533-bridge-to-alim1535_wdt.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:13:51 -0700
Message-ID: <200708152113.l7FLDpjt015274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758321AbXHOVOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, wim@iguana.be


The patch titled
     Add support for 1533 bridge to alim1535_wdt
has been added to the -mm tree.  Its filename is
     add-support-for-1533-bridge-to-alim1535_wdt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add support for 1533 bridge to alim1535_wdt
From: Andrey Borzenkov <arvidjaar@mail.ru>

They are apparently pretty close (even lspci combines them). The patch
adds support for 0x1533 bridge in addition to 0x1535.

Tested on Toshiba Portege 4000 with

00:07.0 ISA bridge [0601]: ALi Corporation M1533/M1535 PCI to ISA Bridge
[Aladdin IV/V/V+] [10b9:1533]
00:08.0 Bridge [0680]: ALi Corporation M7101 Power Management Controller
[PMU] [10b9:7101]

with result

[ 2090.906736] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[ 2090.914034] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/watchdog/alim1535_wdt.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/char/watchdog/alim1535_wdt.c~add-support-for-1533-bridge-to-alim1535_wdt drivers/char/watchdog/alim1535_wdt.c
--- a/drivers/char/watchdog/alim1535_wdt.c~add-support-for-1533-bridge-to-alim1535_wdt
+++ a/drivers/char/watchdog/alim1535_wdt.c
@@ -312,6 +312,7 @@ static int ali_notify_sys(struct notifie
  */
 
 static struct pci_device_id ali_pci_tbl[] = {
+	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
 };
@@ -329,9 +330,11 @@ static int __init ali_find_watchdog(void
 	struct pci_dev *pdev;
 	u32 wdog;
 
-	/* Check for a 1535 series bridge */
+	/* Check for a 1533/1535 series bridge */
 	pdev = pci_get_device(PCI_VENDOR_ID_AL, 0x1535, NULL);
-	if(pdev == NULL)
+	if (pdev == NULL)
+		pdev = pci_get_device(PCI_VENDOR_ID_AL, 0x1533, NULL);
+	if (pdev == NULL)
 		return -ENODEV;
 	pci_dev_put(pdev);
 
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

add-support-for-1533-bridge-to-alim1535_wdt.patch
