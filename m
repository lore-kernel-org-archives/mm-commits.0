From: akpm@linux-foundation.org
Subject: - ssb-add-ssb_pcihost_set_power_state-function.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:49:55 -0800
Message-ID: <200801290149.m0T1ntsN027532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756353AbYA2CAM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 21:00:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mboton@gmail.com, linville@tuxdriver.com, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     ssb: add 'ssb_pcihost_set_power_state' function
has been removed from the -mm tree.  Its filename was
     ssb-add-ssb_pcihost_set_power_state-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ssb: add 'ssb_pcihost_set_power_state' function
From: Miguel Boton <mboton@gmail.com>

Add the 'ssb_pcihost_set_power_state' function.

This function allows us to set the power state of a PCI device (for example
b44 ethernet device).

Signed-off-by: Miguel Boton <mboton@gmail.com>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ssb/ssb.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/ssb/ssb.h~ssb-add-ssb_pcihost_set_power_state-function include/linux/ssb/ssb.h
--- a/include/linux/ssb/ssb.h~ssb-add-ssb_pcihost_set_power_state-function
+++ a/include/linux/ssb/ssb.h
@@ -349,6 +349,13 @@ static inline void ssb_pcihost_unregiste
 {
 	pci_unregister_driver(driver);
 }
+
+static inline
+void ssb_pcihost_set_power_state(struct ssb_device *sdev, pci_power_t state)
+{
+	if (sdev->bus->bustype == SSB_BUSTYPE_PCI)
+		pci_set_power_state(sdev->bus->host_pci, state);
+}
 #endif /* CONFIG_SSB_PCIHOST */
 
 
_

Patches currently in -mm which might be from mboton@gmail.com are

acpi-remove-duplicated-warning-message.patch
git-alsa.patch
memstick-initial-commit-for-sony-memorystick-support-fix.patch
git-net.patch
git-x86.patch
