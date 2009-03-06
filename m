From: akpm@linux-foundation.org
Subject: + pcie-aer-during-disable-check-subordinate-before-walking.patch added to -mm tree
Date: Fri, 06 Mar 2009 13:57:49 -0800
Message-ID: <200903062157.n26Lvn4D003371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbZCFV55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 16:57:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, andrew.patterson@hp.com, matthew@wil.cx, rjw@sisk.pl


The patch titled
     PCIe: AER: during disable, check subordinate before walking
has been added to the -mm tree.  Its filename is
     pcie-aer-during-disable-check-subordinate-before-walking.patch

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
Subject: PCIe: AER: during disable, check subordinate before walking
From: Alex Chiang <achiang@hp.com>

Commit 47a8b0cc (Enable PCIe AER only after checking firmware
support) wants to walk the PCI bus in the remove path to disable
AER, and calls pci_walk_bus for downstream bridges.

Unfortunately, in the remove path, we remove devices and bridges in a
depth-first manner, starting with the furthest downstream bridge and
working our way backwards.

The furthest downstream bridges will not have a dev->subordinate, and we
hit a NULL deref in pci_walk_bus.

Check for dev->subordinate first before attempting to walk the PCI
hierarchy below us.

Acked-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv_core.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/pci/pcie/aer/aerdrv_core.c~pcie-aer-during-disable-check-subordinate-before-walking drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~pcie-aer-during-disable-check-subordinate-before-walking
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -133,6 +133,9 @@ static void set_downstream_devices_error
 						   bool enable)
 {
 	set_device_error_reporting(dev, &enable);
+
+	if (!dev->subordinate)
+		return;
 	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
 }
 
_

Patches currently in -mm which might be from achiang@hp.com are

linux-next.patch
pcie-aer-during-disable-check-subordinate-before-walking.patch

