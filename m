From: akpm@linux-foundation.org
Subject: + pci-pm-introduce-function-pci_wake_from_d3-rev-2.patch added to -mm tree
Date: Thu, 21 Aug 2008 13:35:35 -0700
Message-ID: <200808212035.m7LKZajI024649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbYHUUfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 16:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org


The patch titled
     pc pm: introduce function pci_wake_from_d3
has been added to the -mm tree.  Its filename is
     pci-pm-introduce-function-pci_wake_from_d3-rev-2.patch

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
Subject: pc pm: introduce function pci_wake_from_d3
From: Rafael J. Wysocki <rjw@sisk.pl>

Many device drivers use the following sequence of statements to enable the
device to wake up the system while being in the D3_hot or D3_cold low
power state:

	pci_enable_wake(pdev, PCI_D3hot, 1);
	pci_enable_wake(pdev, PCI_D3cold, 1);

However, the second call is not necessary if the first one succeeds (the
ordering of the statements above doesn't matter here) and it may even be
harmful, because we are not supposed to enable PME# after the wake-up
power has been enabled for the device.

To allow drivers to overcome this problem, introduce function
pci_wake_from_d3() that will enable the device to wake up the system from
any of D3_hot and D3_cold as long as the wake-up from at least one of them
is supported.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c   |   22 ++++++++++++++++++++++
 include/linux/pci.h |    1 +
 2 files changed, 23 insertions(+)

diff -puN drivers/pci/pci.c~pci-pm-introduce-function-pci_wake_from_d3-rev-2 drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-pm-introduce-function-pci_wake_from_d3-rev-2
+++ a/drivers/pci/pci.c
@@ -1127,6 +1127,27 @@ int pci_enable_wake(struct pci_dev *dev,
 }
 
 /**
+ * pci_wake_from_d3 - enable/disable device to wake up from D3_hot or D3_cold
+ * @dev: PCI device to prepare
+ * @enable: True to enable wake-up event generation; false to disable
+ *
+ * Many drivers want the device to wake up the system from D3_hot or D3_cold
+ * and this function allows them to set that up cleanly - pci_enable_wake()
+ * should not be called twice in a row to enable wake-up due to PCI PM vs ACPI
+ * ordering constraints.
+ *
+ * This function only returns error code if the device is not capable of
+ * generating PME# from both D3_hot and D3_cold, and the platform is unable to
+ * enable wake-up power for it.
+ */
+int pci_wake_from_d3(struct pci_dev *dev, bool enable)
+{
+	return pci_pme_capable(dev, PCI_D3cold) ?
+			pci_enable_wake(dev, PCI_D3cold, enable) :
+			pci_enable_wake(dev, PCI_D3hot, enable);
+}
+
+/**
  * pci_target_state - find an appropriate low power state for a given PCI dev
  * @dev: PCI device
  *
@@ -1943,6 +1964,7 @@ EXPORT_SYMBOL(pci_restore_state);
 EXPORT_SYMBOL(pci_pme_capable);
 EXPORT_SYMBOL(pci_pme_active);
 EXPORT_SYMBOL(pci_enable_wake);
+EXPORT_SYMBOL(pci_wake_from_d3);
 EXPORT_SYMBOL(pci_target_state);
 EXPORT_SYMBOL(pci_prepare_to_sleep);
 EXPORT_SYMBOL(pci_back_from_sleep);
diff -puN include/linux/pci.h~pci-pm-introduce-function-pci_wake_from_d3-rev-2 include/linux/pci.h
--- a/include/linux/pci.h~pci-pm-introduce-function-pci_wake_from_d3-rev-2
+++ a/include/linux/pci.h
@@ -642,6 +642,7 @@ pci_power_t pci_choose_state(struct pci_
 bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
 void pci_pme_active(struct pci_dev *dev, bool enable);
 int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable);
+int pci_wake_from_d3(struct pci_dev *dev, bool enable);
 pci_power_t pci_target_state(struct pci_dev *dev);
 int pci_prepare_to_sleep(struct pci_dev *dev);
 int pci_back_from_sleep(struct pci_dev *dev);
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
skty2-adapt-to-the-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
pci-pm-introduce-function-pci_wake_from_d3-rev-2.patch
forcedeth-fix-kexec-regression.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
shrink_slab-handle-bad-shrinkers.patch

