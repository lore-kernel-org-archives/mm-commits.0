From: akpm@linux-foundation.org
Subject: - e1000e-fix-drv-load-issues.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:08:16 -0700
Message-ID: <200808082208.m78M8Gwb031232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932428AbYHHWIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: fix drv load issues
has been removed from the -mm tree.  Its filename was
     e1000e-fix-drv-load-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: fix drv load issues
From: Jesse Brandeburg <jesse.brandeburg@intel.com>

A few people seem to have problems maintaining gigabit link and it was
root caused to an interaction between the managability firmware on the
host and the driver, not communicating.

The form of communication they use is the drv_load bit.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN drivers/net/e1000e/netdev.c~e1000e-fix-drv-load-issues drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-fix-drv-load-issues
+++ a/drivers/net/e1000e/netdev.c
@@ -2444,7 +2444,7 @@ void e1000e_reset(struct e1000_adapter *
 	 * For parts with AMT enabled, let the firmware know
 	 * that the network interface is in control
 	 */
-	if ((adapter->flags & FLAG_HAS_AMT) && e1000e_check_mng_mode(hw))
+	if (adapter->flags & FLAG_HAS_AMT)
 		e1000_get_hw_control(adapter);
 
 	ew32(WUC, 0);
@@ -2634,8 +2634,7 @@ static int e1000_open(struct net_device 
 	 * If AMT is enabled, let the firmware know that the network
 	 * interface is now open
 	 */
-	if ((adapter->flags & FLAG_HAS_AMT) &&
-	    e1000e_check_mng_mode(&adapter->hw))
+	if (adapter->flags & FLAG_HAS_AMT)
 		e1000_get_hw_control(adapter);
 
 	/*
@@ -2713,8 +2712,7 @@ static int e1000_close(struct net_device
 	 * If AMT is enabled, let the firmware know that the network
 	 * interface is now closed
 	 */
-	if ((adapter->flags & FLAG_HAS_AMT) &&
-	    e1000e_check_mng_mode(&adapter->hw))
+	if (adapter->flags & FLAG_HAS_AMT)
 		e1000_release_hw_control(adapter);
 
 	return 0;
@@ -4030,7 +4028,7 @@ static int e1000_resume(struct pci_dev *
 	 * is up.  For all other cases, let the f/w know that the h/w is now
 	 * under the control of the driver.
 	 */
-	if (!(adapter->flags & FLAG_HAS_AMT) || !e1000e_check_mng_mode(&adapter->hw))
+	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000_get_hw_control(adapter);
 
 	return 0;
@@ -4149,8 +4147,7 @@ static void e1000_io_resume(struct pci_d
 	 * is up.  For all other cases, let the f/w know that the h/w is now
 	 * under the control of the driver.
 	 */
-	if (!(adapter->flags & FLAG_HAS_AMT) ||
-	    !e1000e_check_mng_mode(&adapter->hw))
+	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000_get_hw_control(adapter);
 
 }
@@ -4505,8 +4502,7 @@ static int __devinit e1000_probe(struct 
 	 * is up.  For all other cases, let the f/w know that the h/w is now
 	 * under the control of the driver.
 	 */
-	if (!(adapter->flags & FLAG_HAS_AMT) ||
-	    !e1000e_check_mng_mode(&adapter->hw))
+	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000_get_hw_control(adapter);
 
 	/* tell the stack to leave us alone until e1000_open() is called */
@@ -4523,19 +4519,19 @@ static int __devinit e1000_probe(struct 
 	return 0;
 
 err_register:
-err_hw_init:
-	e1000_release_hw_control(adapter);
+	if (!(adapter->flags & FLAG_HAS_AMT))
+		e1000_release_hw_control(adapter);
 err_eeprom:
 	if (!e1000_check_reset_block(&adapter->hw))
 		e1000_phy_hw_reset(&adapter->hw);
+err_hw_init:
 
-	if (adapter->hw.flash_address)
-		iounmap(adapter->hw.flash_address);
