From: akpm@linux-foundation.org
Subject: - itco_wdt-ich9do-support.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:33 -0700
Message-ID: <200805270728.m4R7SXZX014949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756073AbYE0H3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nix.or.die@googlemail.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     iTCO_wdt: ICH9DO support
has been removed from the -mm tree.  Its filename was
     itco_wdt-ich9do-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iTCO_wdt: ICH9DO support
From: Gabriel C <nix.or.die@googlemail.com>

Add the Intel ICH9DO controller ID's for the iTCO_wdt kernel driver and bump
the driver version.

Tested on an P5E-VM DO ASUS motherboard.

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/iTCO_wdt.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/watchdog/iTCO_wdt.c~itco_wdt-ich9do-support drivers/watchdog/iTCO_wdt.c
--- a/drivers/watchdog/iTCO_wdt.c~itco_wdt-ich9do-support
+++ a/drivers/watchdog/iTCO_wdt.c
@@ -44,6 +44,7 @@
  *	82801IB  (ICH9)      : document number 316972-001, 316973-001,
  *	82801IR  (ICH9R)     : document number 316972-001, 316973-001,
  *	82801IH  (ICH9DH)    : document number 316972-001, 316973-001,
+ *	82801IO  (ICH9DO)    : document number 316972-001, 316973-006,
  *	6300ESB  (6300ESB)   : document number 300641-003, 300884-010,
  *	631xESB  (631xESB)   : document number 313082-001, 313075-005,
  *	632xESB  (632xESB)   : document number 313082-001, 313075-005
@@ -55,8 +56,8 @@
 
 /* Module and version information */
 #define DRV_NAME        "iTCO_wdt"
-#define DRV_VERSION     "1.10"
-#define DRV_RELDATE     "17-Aug-2007"
+#define DRV_VERSION     "1.11"
+#define DRV_RELDATE     "30-Apr-2008"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -104,6 +105,7 @@ enum iTCO_chipsets {
 	TCO_ICH9,	/* ICH9 */
 	TCO_ICH9R,	/* ICH9R */
 	TCO_ICH9DH,	/* ICH9DH */
+	TCO_ICH9DO,     /* ICH9DO */
 	TCO_631XESB,	/* 631xESB/632xESB */
 };
 
@@ -136,6 +138,7 @@ static struct {
 	{"ICH9", 2},
 	{"ICH9R", 2},
 	{"ICH9DH", 2},
+	{"ICH9DO", 2},
 	{"631xESB/632xESB", 2},
 	{NULL, 0}
 };
@@ -181,6 +184,7 @@ static struct pci_device_id iTCO_wdt_pci
 	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9   )},
 	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R  )},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,           TCO_ICH9DO )},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

linux-next.patch

