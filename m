From: akpm@linux-foundation.org
Subject: + quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch added to -mm tree
Date: Fri, 11 Jan 2008 16:51:29 -0800
Message-ID: <200801120051.m0C0pTCO006444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762641AbYALAv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 19:51:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pchen@nvidia.com, acurrid@nvidia.com, ak@suse.de, ebiederm@xmission.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     quirks: set 'En' bit of MSI Mapping for devices onHT-based nvidia platform
has been added to the -mm tree.  Its filename is
     quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch

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
Subject: quirks: set 'En' bit of MSI Mapping for devices onHT-based nvidia platform
From: Peer Chen <pchen@nvidia.com>

According to HT spec, to get message interrupt from devices mapped to HT
interrupt message, the 'En' bit of MSI Mapping capability need to be set. 
The patch do this setting in quirks code for the devices on HT-based nvidia
platform.

Signed-off-by: Andy Currid <acurrid@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>
Cc: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   64 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff -puN drivers/pci/quirks.c~quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform
+++ a/drivers/pci/quirks.c
@@ -1775,6 +1775,70 @@ static void __devinit quirk_nvidia_ck804
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_msi_ht_cap);
 
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
+static void __devinit nv_msi_ht_cap_quirk(struct pci_dev *dev) {
+
+	struct pci_dev *host_bridge;
+	int pos, ttl = 48;
+
+	/* HT MSI mapping should be disabled on devices that are below
+	 * a non-Hypertransport host bridge. Locate the host bridge...
+ 	 */
+
+	if ((host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0,0))) == NULL) {
+		printk(KERN_WARNING
+			"PCI: nv_msi_ht_cap_quirk didn't locate host bridge\n");
+		return;
+	}
+
+	if ((pos = pci_find_ht_capability(host_bridge, HT_CAPTYPE_SLAVE)) != 0) {
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
+			printk(KERN_INFO "PCI: Quirk disabling HT MSI mapping on %s\n",
+			       pci_name(dev));
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

quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
