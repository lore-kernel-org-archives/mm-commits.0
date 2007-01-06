From: akpm@osdl.org
Subject: - pci-prevent-down_read-when-pci_devices-is-empty-fix.patch removed from -mm tree
Date: Fri, 05 Jan 2007 16:11:25 -0800
Message-ID: <200701060011.l060BqJW011216@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44636 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbXAFALx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 19:11:53 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l060BqWi014568
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 5 Jan 2007 16:11:53 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, mm-commits@vger.kernel.org


The patch titled
     pci-prevent-down_read-when-pci_devices-is-empty-fix
has been removed from the -mm tree.  Its filename was
     pci-prevent-down_read-when-pci_devices-is-empty-fix.patch

This patch was dropped because it was folded into pci-prevent-down_read-when-pci_devices-is-empty.patch

------------------------------------------------------
Subject: pci-prevent-down_read-when-pci_devices-is-empty-fix
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/search.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/pci/search.c~pci-prevent-down_read-when-pci_devices-is-empty-fix drivers/pci/search.c
--- a/drivers/pci/search.c~pci-prevent-down_read-when-pci_devices-is-empty-fix
+++ a/drivers/pci/search.c
@@ -200,8 +200,9 @@ static struct pci_dev * pci_find_subsys(
 	 * can cause some machines to crash.  So here we detect and flag that
 	 * situation and bail out early.
 	 */
-	if(unlikely(list_empty(&pci_devices))) {
-		printk(KERN_INFO "pci_find_subsys() called while pci_devices is still empty\n");
+	if (unlikely(list_empty(&pci_devices))) {
+		printk(KERN_INFO "pci_find_subsys() called while pci_devices "
+				"is still empty\n");
 		return NULL;
 	}
 	down_read(&pci_bus_sem);
@@ -270,14 +271,16 @@ pci_get_subsys(unsigned int vendor, unsi
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
 	/*
 	 * pci_get_subsys() can potentially be called by drivers super-early
 	 * in boot.  But the down_read() will enable local interrupts, which
 	 * can cause some machines to crash.  So here we detect and flag that
 	 * situation and bail out early.
 	 */
-	if(unlikely(list_empty(&pci_devices))) {
-		printk(KERN_NOTICE "pci_get_subsys() called while pci_devices is still empty\n");
+	if (unlikely(list_empty(&pci_devices))) {
+		printk(KERN_NOTICE "pci_get_subsys() called while pci_devices "
+				"is still empty\n");
 		return NULL;
 	}
 	down_read(&pci_bus_sem);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch
pci-prevent-down_read-when-pci_devices-is-empty.patch
pci-prevent-down_read-when-pci_devices-is-empty-fix.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
ip2-warning-fix.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
shrink_all_memory-fix-lru_pages-handling.patch
