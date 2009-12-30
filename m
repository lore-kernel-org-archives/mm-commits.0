From: akpm@linux-foundation.org
Subject: + hwmon-coretemp-fix-tjmax-for-atom-n450-d410-d510-cpus.patch added to -mm tree
Date: Wed, 30 Dec 2009 15:41:49 -0800
Message-ID: <200912302341.nBUNfnvT008697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbZL3XmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 18:42:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.y.wang@linux.intel.com, huaxu.wan@intel.com, khali@linux-fr.org, yong.y.wang@intel.com


The patch titled
     hwmon/coretemp: fix TjMax for Atom N450/D410/D510 CPUs
has been added to the -mm tree.  Its filename is
     hwmon-coretemp-fix-tjmax-for-atom-n450-d410-d510-cpus.patch

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
Subject: hwmon/coretemp: fix TjMax for Atom N450/D410/D510 CPUs
From: Yong Wang <yong.y.wang@linux.intel.com>

The max junction temperature of Atom N450/D410/D510 CPUs is 100 degrees
Celsius.  Since these CPUs are always coupled with Intel NM10 chipset in
one package, the best way to verify whether an Atom CPU is N450/D410/D510
is to check the host bridge device.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Acked-by: Huaxu Wan <huaxu.wan@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-fix-tjmax-for-atom-n450-d410-d510-cpus drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-fix-tjmax-for-atom-n450-d410-d510-cpus
+++ a/drivers/hwmon/coretemp.c
@@ -33,6 +33,7 @@
 #include <linux/list.h>
 #include <linux/platform_device.h>
 #include <linux/cpu.h>
+#include <linux/pci.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
 
@@ -161,6 +162,7 @@ static int __devinit adjust_tjmax(struct
 	int usemsr_ee = 1;
 	int err;
 	u32 eax, edx;
+	struct pci_dev *host_bridge;
 
 	/* Early chips have no MSR for TjMax */
 
@@ -168,11 +170,21 @@ static int __devinit adjust_tjmax(struct
 		usemsr_ee = 0;
 	}
 
-	/* Atoms seems to have TjMax at 90C */
+	/* Atoms CPUs */
 
 	if (c->x86_model == 0x1c) {
 		usemsr_ee = 0;
-		tjmax = 90000;
+
+		host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
+
+		if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL
+		    && (host_bridge->device == 0xa000	/* NM10 based nettop */
+		    || host_bridge->device == 0xa010))	/* NM10 based netbook */
+			tjmax = 100000;
+		else
+			tjmax = 90000;
+
+		pci_dev_put(host_bridge);
 	}
 
 	if ((c->x86_model > 0xe) && (usemsr_ee)) {
_

Patches currently in -mm which might be from yong.y.wang@linux.intel.com are

hwmon-coretemp-fix-tjmax-for-atom-n450-d410-d510-cpus.patch

