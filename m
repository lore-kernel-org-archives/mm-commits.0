From: akpm@linux-foundation.org
Subject: + pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops.patch added to -mm tree
Date: Tue, 30 Dec 2008 13:14:24 -0800
Message-ID: <200812302114.mBULEOAG026888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbYL3VO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 16:14:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mirq-linux@rere.qmqm.pl, jbarnes@virtuousgeek.org


The patch titled
     pci-quirks: HP hides SMBus controller in Compaq nx9500 laptops
has been added to the -mm tree.  Its filename is
     pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1098,6 +1098,7 @@ static void __init asus_hides_smbus_host
 			switch (dev->subsystem_device) {
 			case 0x12bc: /* HP D330L */
 			case 0x12bd: /* HP D530 */
+			case 0x006a: /* HP Compaq nx9500 */
 				asus_hides_smbus = 1;
 			}
 		else if (dev->device == PCI_DEVICE_ID_INTEL_82875_HB)
_

Patches currently in -mm which might be from mirq-linux@rere.qmqm.pl are

pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes.patch
pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops.patch

