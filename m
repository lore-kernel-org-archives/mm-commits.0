From: akpm@linux-foundation.org
Subject: - quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:35 -0800
Message-ID: <200802232022.m1NKMZHR013437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763451AbYBWU3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pchen@nvidia.com, acurrid@nvidia.com, ak@suse.de, ebiederm@xmission.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     quirks: set 'En' bit of MSI Mapping for devices onHT-based nvidia platform
has been removed from the -mm tree.  Its filename was
     quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quirks: set 'En' bit of MSI Mapping for devices onHT-based nvidia platform
From: Peer Chen <pchen@nvidia.com>

According to HT spec, to get message interrupt from devices mapped to HT
interrupt message, the 'En' bit of MSI Mapping capability need to be set. 
The patch do this setting in quirks code for the devices on HT-based nvidia
platform.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Andy Currid <acurrid@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>
Cc: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   68 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff -puN drivers/pci/quirks.c~quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform
+++ a/drivers/pci/quirks.c
@@ -1840,6 +1840,74 @@ static void __devinit nv_msi_ht_cap_quir
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk);
 
+/*
+ *  Force enable MSI mapping capability on HT bridges  */
+static inline void ht_enable_msi_mapping(struct pci_dev *dev)
+{
+	int pos, ttl = 48;
+
+	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
+	while (pos && ttl--) {
+		u8 flags;
+
+		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
+			printk(KERN_INFO "PCI: Enabling HT MSI Mapping on %s\n",
+						dev->dev.bus_id);
+
+			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
+					      flags | HT_MSI_FLAGS_ENABLE);
+		}
+		pos = pci_find_next_ht_capability(dev, pos,
+						  HT_CAPTYPE_MSI_MAPPING);
+	}
+}
+
+static void __devinit nv_msi_ht_cap_quirk(struct pci_dev *dev)
+{
+
+	struct pci_dev *host_bridge;
+	int pos, ttl = 48;
+
+	/*
+	 * HT MSI mapping should be disabled on devices that are below
+	 * a non-Hypertransport host bridge. Locate the host bridge...
+	 */
+
+	host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	if (host_bridge == NULL) {
+		printk(KERN_WARNING
+			"PCI: nv_msi_ht_cap_quirk didn't locate host bridge\n");
+		return;
+	}
+
+	pos = pci_find_ht_capability(host_bridge, HT_CAPTYPE_SLAVE);
+	if (pos != 0) {
+		/* Host bridge is to HT */
+		ht_enable_msi_mapping(dev);
+		return;
+	}
+
+	/* Host bridge is not to HT, disable HT MSI mapping on this device */
+
+	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
+	while (pos && ttl--) {
+		u8 flags;
+
+		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
+			printk(KERN_INFO "PCI: Quirk disabling HT MSI mapping "
+					"on %s\n", pci_name(dev));
+
+			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
+					      flags & ~HT_MSI_FLAGS_ENABLE);
+		}
+		pos = pci_find_next_ht_capability(dev, pos,
+						  HT_CAPTYPE_MSI_MAPPING);
+	}
+}
+
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+							nv_msi_ht_cap_quirk);
+
 static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
 	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
_

Patches currently in -mm which might be from pchen@nvidia.com are

origin.patch
