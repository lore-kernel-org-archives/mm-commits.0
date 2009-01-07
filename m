From: akpm@linux-foundation.org
Subject: - aspm-use-msleep-instead-of-cpu_relax-during-link-retraining.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:21:19 -0800
Message-ID: <200901072221.n07MLJwg020490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762095AbZAGWhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.patterson@hp.com, jbarnes@virtuousgeek.org, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     aspm: use msleep instead of cpu_relax during link retraining
has been removed from the -mm tree.  Its filename was
     aspm-use-msleep-instead-of-cpu_relax-during-link-retraining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aspm: use msleep instead of cpu_relax during link retraining
From: Andrew Patterson <andrew.patterson@hp.com>

The cpu_relax() function can be a noop on certain architectures like IA-64
when CPU threads are disabled, so use msleep instead during link
retraining busy/wait loop.

Introduce define LINK_RETRAIN_TIMEOUT instead of hard-coding timeout in
pcie_aspm_configure_common_clock.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aspm.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/pci/pcie/aspm.c~aspm-use-msleep-instead-of-cpu_relax-during-link-retraining drivers/pci/pcie/aspm.c
--- a/drivers/pci/pcie/aspm.c~aspm-use-msleep-instead-of-cpu_relax-during-link-retraining
+++ a/drivers/pci/pcie/aspm.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
+#include <linux/delay.h>
 #include <linux/pci-aspm.h>
 #include "../pci.h"
 
@@ -70,6 +71,8 @@ static const char *policy_str[] = {
 	[POLICY_POWERSAVE] = "powersave"
 };
 
+#define LINK_RETRAIN_TIMEOUT HZ
+
 static int policy_to_aspm_state(struct pci_dev *pdev)
 {
 	struct pcie_link_state *link_state = pdev->link_state;
@@ -217,16 +220,18 @@ static void pcie_aspm_configure_common_c
 	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
 
 	/* Wait for link training end */
-	/* break out after waiting for 1 second */
+	/* break out after waiting for timeout */
 	start_jiffies = jiffies;
-	while ((jiffies - start_jiffies) < HZ) {
+	for (;;) {
 		pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
 		if (!(reg16 & PCI_EXP_LNKSTA_LT))
 			break;
-		cpu_relax();
+		if ((jiffies - start_jiffies) >= LINK_RETRAIN_TIMEOUT)
+			break;
+		msleep(1);
 	}
 	/* training failed -> recover */
-	if ((jiffies - start_jiffies) >= HZ) {
+	if ((jiffies - start_jiffies) >= LINK_RETRAIN_TIMEOUT) {
 		dev_printk (KERN_ERR, &pdev->dev, "ASPM: Could not configure"
 			    " common clock\n");
 		i = 0;
_

Patches currently in -mm which might be from andrew.patterson@hp.com are

linux-next.patch

