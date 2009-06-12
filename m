From: akpm@linux-foundation.org
Subject: [merged] pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:32 -0700
Message-ID: <200906121822.n5CIMWEs031256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbZFLSZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:25:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mirq-linux@rere.qmqm.pl, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci-quirks: HP hides SMBus controller in Compaq nx9500 laptops
has been removed from the -mm tree.  Its filename was
     pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-quirks: HP hides SMBus controller in Compaq nx9500 laptops
From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>

I found no references to SMBus in ACPI DSDT disassembly on my laptop
so this should be safe.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/quirks.c~pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops
+++ a/drivers/pci/quirks.c
@@ -1163,6 +1163,7 @@ static void __init asus_hides_smbus_host
 			switch (dev->subsystem_device) {
 			case 0x12bc: /* HP D330L */
 			case 0x12bd: /* HP D530 */
+			case 0x006a: /* HP Compaq nx9500 */
 				asus_hides_smbus = 1;
 			}
 		else if (dev->device == PCI_DEVICE_ID_INTEL_82875_HB)
_

Patches currently in -mm which might be from mirq-linux@rere.qmqm.pl are

linux-next.patch

