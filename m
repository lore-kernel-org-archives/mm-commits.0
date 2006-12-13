From: akpm@osdl.org
Subject: - pci-introduce-pci_find_present.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:09 -0800
Message-ID: <200612130656.kBD6u9cd030701@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57918 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965040AbWLMG4S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci: Introduce pci_find_present
has been removed from the -mm tree.  Its filename was
     pci-introduce-pci_find_present.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci: Introduce pci_find_present
From: Alan Cox <alan@redhat.com>

This works like pci_dev_present but instead of returning boolean returns
the matching pci_device_id entry.  This makes it much more useful.  Code
bloat is basically nil as the old boolean function is rewritten in terms of
the new one.

This will be used by the updated VIA PCI quirks for one

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/search.c |   39 ++++++++++++++++++++++-----------------
 include/linux/pci.h  |    2 ++
 2 files changed, 24 insertions(+), 17 deletions(-)

diff -puN drivers/pci/search.c~pci-introduce-pci_find_present drivers/pci/search.c
--- a/drivers/pci/search.c~pci-introduce-pci_find_present
+++ a/drivers/pci/search.c
@@ -413,6 +413,24 @@ exit:
 	return dev;
 }
 
+const struct pci_device_id *pci_find_present(const struct pci_device_id *ids)
+{
+	struct pci_dev *dev;
+	struct pci_device_id * found = NULL;
+
+	WARN_ON(in_interrupt());
+	down_read(&pci_bus_sem);
+	while (ids->vendor || ids->subvendor || ids->class_mask) {
+		list_for_each_entry(dev, &pci_devices, global_list) {
+			if ((found = pci_match_one_device(ids, dev)) != NULL)
+				break;
+		}
+		ids++;
+	}
+	up_read(&pci_bus_sem);
+	return found;
+}
+
 /**
  * pci_dev_present - Returns 1 if device matching the device list is present, 0 if not.
  * @ids: A pointer to a null terminated list of struct pci_device_id structures
@@ -424,27 +442,14 @@ exit:
  * find devices that are usually built into a system, or for a general hint as
  * to if another device happens to be present at this specific moment in time.
  */
+
 int pci_dev_present(const struct pci_device_id *ids)
 {
-	struct pci_dev *dev;
-	int found = 0;
-
-	WARN_ON(in_interrupt());
-	down_read(&pci_bus_sem);
-	while (ids->vendor || ids->subvendor || ids->class_mask) {
-		list_for_each_entry(dev, &pci_devices, global_list) {
-			if (pci_match_one_device(ids, dev)) {
-				found = 1;
-				goto exit;
-			}
-		}
-		ids++;
-	}
-exit:
-	up_read(&pci_bus_sem);
-	return found;
+	return pci_find_present(ids) == NULL ? 0 : 1;
 }
+
 EXPORT_SYMBOL(pci_dev_present);
+EXPORT_SYMBOL(pci_find_present);
 
 EXPORT_SYMBOL(pci_find_device);
 EXPORT_SYMBOL(pci_find_device_reverse);
diff -puN include/linux/pci.h~pci-introduce-pci_find_present include/linux/pci.h
--- a/include/linux/pci.h~pci-introduce-pci_find_present
+++ a/include/linux/pci.h
@@ -481,6 +481,7 @@ struct pci_dev *pci_get_slot (struct pci
 struct pci_dev *pci_get_bus_and_slot (unsigned int bus, unsigned int devfn);
 struct pci_dev *pci_get_class (unsigned int class, struct pci_dev *from);
 int pci_dev_present(const struct pci_device_id *ids);
+const struct pci_device_id *pci_find_present(const struct pci_device_id *ids);
 
 int pci_bus_read_config_byte (struct pci_bus *bus, unsigned int devfn, int where, u8 *val);
 int pci_bus_read_config_word (struct pci_bus *bus, unsigned int devfn, int where, u16 *val);
@@ -694,6 +695,7 @@ static inline struct pci_dev *pci_get_cl
 { return NULL; }
 
 #define pci_dev_present(ids)	(0)
+#define pci_find_present(ids)	(NULL)
 #define pci_dev_put(dev)	do { } while (0)
 
 static inline void pci_set_master(struct pci_dev *dev) { }
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
cciss-remove-calls-to-pci_disable_device.patch
cciss-remove-calls-to-pci_disable_device-fix.patch
tty-switch-to-ktermios-nozomi-fix.patch
git-libata-all.patch
pci-move-pci_vdevice-from-libata-to-core.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
pci_module_init-convertion-in-tmscsimc.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
tty_ioc-balance-tty_ldisc_ref.patch

