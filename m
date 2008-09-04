From: akpm@linux-foundation.org
Subject: + pci-hotplug-fakephp-fix-deadlock-again.patch added to -mm tree
Date: Thu, 04 Sep 2008 13:07:43 -0700
Message-ID: <200809042007.m84K7haj028368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbYIDUIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 16:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx, yu.zhao@intel.com


The patch titled
     PCI Hotplug: fakephp: fix deadlock... again
has been added to the -mm tree.  Its filename is
     pci-hotplug-fakephp-fix-deadlock-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI Hotplug: fakephp: fix deadlock... again
From: Alex Chiang <achiang@hp.com>

Commit fe99740cac117f208707488c03f3789cf4904957 (construct one
fakephp slot per PCI slot) introduced a regression, causing a
deadlock when removing a PCI device.

We also never actually removed the device from the PCI core.

So we:

	- remove the device from the PCI core
	- do not directly call remove_slot() to prevent deadlock

Yu Zhao reported and diagnosed this defect.

Signed-off-by: Alex Chiang <achiang@hp.com>
Acked-by: Yu Zhao <yu.zhao@intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/fakephp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pci/hotplug/fakephp.c~pci-hotplug-fakephp-fix-deadlock-again drivers/pci/hotplug/fakephp.c
--- a/drivers/pci/hotplug/fakephp.c~pci-hotplug-fakephp-fix-deadlock-again
+++ a/drivers/pci/hotplug/fakephp.c
@@ -320,15 +320,15 @@ static int disable_slot(struct hotplug_s
 			return -ENODEV;
 		}
 
+		/* remove the device from the pci core */
+		pci_remove_bus_device(dev);
+
 		/* queue work item to blow away this sysfs entry and other
 		 * parts.
 		 */
 		INIT_WORK(&dslot->remove_work, remove_slot_worker);
 		queue_work(dummyphp_wq, &dslot->remove_work);
 
-		/* blow away this sysfs entry and other parts. */
-		remove_slot(dslot);
