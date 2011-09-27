From: akpm@google.com
Subject: [wrecked] pci-dmar-update-dmar-units-devices-list-during-hotplug.patch removed from -mm tree
Date: Tue, 27 Sep 2011 12:08:57 -0700
Message-ID: <201109271908.p8RJ8wM3029613@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:19937 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1I0TJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 15:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, dan.j.williams@intel.com, dwmw2@infradead.org, jbarnes@virtuousgeek.org, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pci, dmar: update dmar units devices list during hotplug
has been removed from the -mm tree.  Its filename was
     pci-dmar-update-dmar-units-devices-list-during-hotplug.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: pci, dmar: update dmar units devices list during hotplug

When do pci remove/rescan on system that have more iommus, got

[  894.089745] Set context mapping for c4:00.0
[  894.110890] mpt2sas3: Allocated physical memory: size(4293 kB)
[  894.112556] mpt2sas3: Current Controller Queue Depth(1883), Max Controller Queue Depth(2144)
[  894.127278] mpt2sas3: Scatter Gather Elements per IO(128)
[  894.361295] DRHD: handling fault status reg 2
[  894.364053] DMAR:[DMA Read] Request device [c4:00.0] fault addr fffbe000
[  894.364056] DMAR:[fault reason 02] Present bit in context entry is cl

it turns out when remove/rescan, pci dev will be freed and will get
another new dev.  but drhd units still keep old one...  so
dmar_find_matched_drhd_unit will return wrong drhd and iommu for the
device that is not on first iommu.

So need to update devices in drhd_units during pci remove/rescan.

Could save domain/bus/device/function aside in the list and according that
info restore new dev to drhd_units later.  Then
dmar_find_matched_drdh_unit and device_to_iommu could return right drhd
and iommu.

Add remove_dev_from_drhd/restore_dev_to_drhd functions to do the real
work.  call them in device ADD_DEVICE and UNBOUND_DRIVER

Need to do the samething to atsr.  (expose dmar_atsr_units and add
atsru->segment)

After patch, will right iommu for the new dev and will not get DMAR error
any more.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/iommu/dmar.c        |    7 -
 drivers/iommu/intel-iommu.c |  177 +++++++++++++++++++++++++++++++++-
 include/linux/dmar.h        |    5 
 3 files changed, 180 insertions(+), 9 deletions(-)

diff -puN drivers/iommu/dmar.c~pci-dmar-update-dmar-units-devices-list-during-hotplug drivers/iommu/dmar.c
--- a/drivers/iommu/dmar.c~pci-dmar-update-dmar-units-devices-list-during-hotplug
+++ a/drivers/iommu/dmar.c
@@ -263,7 +263,7 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rm
 	return ret;
 }
 
-static LIST_HEAD(dmar_atsr_units);
+LIST_HEAD(dmar_atsr_units);
 
 static int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 {
@@ -277,6 +277,7 @@ static int __init dmar_parse_one_atsr(st
 
 	atsru->hdr = hdr;
 	atsru->include_all = atsr->flags & 0x1;
+	atsru->segment = atsr->segment;
 
 	list_add(&atsru->list, &dmar_atsr_units);
 
@@ -308,14 +309,12 @@ int dmar_find_matched_atsr_unit(struct p
 {
 	int i;
 	struct pci_bus *bus;
-	struct acpi_dmar_atsr *atsr;
 	struct dmar_atsr_unit *atsru;
 
 	dev = pci_physfn(dev);
 
 	list_for_each_entry(atsru, &dmar_atsr_units, list) {
-		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
-		if (atsr->segment == pci_domain_nr(dev->bus))
+		if (atsru->segment == pci_domain_nr(dev->bus))
 			goto found;
 	}
 
diff -puN drivers/iommu/intel-iommu.c~pci-dmar-update-dmar-units-devices-list-during-hotplug drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~pci-dmar-update-dmar-units-devices-list-during-hotplug
+++ a/drivers/iommu/intel-iommu.c
@@ -633,6 +633,157 @@ static struct intel_iommu *device_to_iom
 	return NULL;
 }
 
+#ifdef CONFIG_HOTPLUG
+struct dev_dmaru {
+	struct list_head list;
+	void *dmaru;
+	int index;
+	int segment;
+	unsigned char bus;
+	unsigned int devfn;
+};
+
+static int
+save_dev_dmaru(int segment, unsigned char bus, unsigned int devfn,
+		 void *dmaru, int index, struct list_head *lh)
+{
+	struct dev_dmaru *m;
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
+
+	m->segment = segment;
+	m->bus     = bus;
+	m->devfn   = devfn;
+	m->dmaru   = dmaru;
+	m->index   = index;
+
+	list_add(&m->list, lh);
+
+	return 0;
+}
+
+static void
+*get_dev_dmaru(int segment, unsigned char bus, unsigned int devfn,
+		int *index, struct list_head *lh)
+{
+	struct dev_dmaru *m;
+	void *dmaru = NULL;
+
+	list_for_each_entry(m, lh, list) {
+		if (m->segment == segment &&
+		    m->bus == bus && m->devfn == devfn) {
+			*index = m->index;
+			dmaru  = m->dmaru;
+			list_del(&m->list);
+			kfree(m);
+			break;
+		}
+	}
+
+	return dmaru;
+}
+
+static LIST_HEAD(saved_dev_drhd_list);
+
+static void remove_dev_from_drhd(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd = NULL;
+	int segment = pci_domain_nr(dev->bus);
+	int i;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		if (segment != drhd->segment)
+			continue;
+
+		for (i = 0; i < drhd->devices_cnt; i++) {
+			if (drhd->devices[i] == dev) {
+				/* save it at first if it is in drhd */
+				save_dev_dmaru(segment, dev->bus->number,
+						dev->devfn, drhd, i,
+						&saved_dev_drhd_list);
+				/* always remove it */
+				drhd->devices[i] = NULL;
+				return;
+			}
+		}
+	}
+}
+
+static void restore_dev_to_drhd(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd = NULL;
+	int i;
+
+	/* find the stored drhd */
+	drhd = get_dev_dmaru(pci_domain_nr(dev->bus), dev->bus->number,
+				 dev->devfn, &i, &saved_dev_drhd_list);
+	/* restore that into drhd */
+	if (drhd)
+		drhd->devices[i] = dev;
+}
+#else
+static void remove_dev_from_drhd(struct pci_dev *dev)
+{
+}
+
+static void restore_dev_to_drhd(struct pci_dev *dev)
+{
+}
+#endif
+
+#if defined(CONFIG_DMAR) && defined(CONFIG_HOTPLUG)
+static LIST_HEAD(saved_dev_atsr_list);
+
+static void remove_dev_from_atsr(struct pci_dev *dev)
+{
+	struct dmar_atsr_unit *atsr = NULL;
+	int segment = pci_domain_nr(dev->bus);
+	int i;
+
+	for_each_atsr_unit(atsr) {
+		if (segment != atsr->segment)
+			continue;
+
+		for (i = 0; i < atsr->devices_cnt; i++) {
+			if (atsr->devices[i] == dev) {
+				/* save it at first if it is in drhd */
+				save_dev_dmaru(segment, dev->bus->number,
+						dev->devfn, atsr, i,
+						&saved_dev_atsr_list);
+				/* always remove it */
+				atsr->devices[i] = NULL;
+				return;
+			}
+		}
+	}
+}
+
+static void restore_dev_to_atsr(struct pci_dev *dev)
+{
+	struct dmar_atsr_unit *atsr = NULL;
+	int i;
+
+	/* find the stored atsr */
+	atsr = get_dev_dmaru(pci_domain_nr(dev->bus), dev->bus->number,
+				 dev->devfn, &i, &saved_dev_atsr_list);
+	/* restore that into atsr */
+	if (atsr)
+		atsr->devices[i] = dev;
+}
+#else
+static void remove_dev_from_atsr(struct pci_dev *dev)
+{
+}
+
+static void restore_dev_to_atsr(struct pci_dev *dev)
+{
+}
+#endif
+
 static void domain_flush_cache(struct dmar_domain *domain,
 			       void *addr, int size)
 {
@@ -3403,20 +3554,36 @@ static int device_notifier(struct notifi
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
 
-	if (iommu_no_mapping(dev))
+	if (unlikely(dev->bus != &pci_bus_type))
 		return 0;
 
-	domain = find_domain(pdev);
-	if (!domain)
-		return 0;
+	switch (action) {
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		if (iommu_no_mapping(dev))
+			goto out;
+
+		if (iommu_pass_through)
+			goto out;
+
+		domain = find_domain(pdev);
+		if (!domain)
+			goto out;
 
-	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
 		domain_remove_one_dev_info(domain, pdev);
 
 		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
 		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
 		    list_empty(&domain->devices))
 			domain_exit(domain);
+out:
+		remove_dev_from_drhd(pdev);
+		remove_dev_from_atsr(pdev);
+
+		break;
+	case BUS_NOTIFY_ADD_DEVICE:
+		restore_dev_to_drhd(pdev);
+		restore_dev_to_atsr(pdev);
+		break;
 	}
 
 	return 0;
diff -puN include/linux/dmar.h~pci-dmar-update-dmar-units-devices-list-during-hotplug include/linux/dmar.h
--- a/include/linux/dmar.h~pci-dmar-update-dmar-units-devices-list-during-hotplug
+++ a/include/linux/dmar.h
@@ -219,14 +219,19 @@ struct dmar_rmrr_unit {
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
 
+extern struct list_head dmar_atsr_units;
 struct dmar_atsr_unit {
 	struct list_head list;		/* list of ATSR units */
 	struct acpi_dmar_header *hdr;	/* ACPI header */
 	struct pci_dev **devices;	/* target devices */
 	int devices_cnt;		/* target device count */
+	u16	segment;		/* PCI domain		*/
 	u8 include_all:1;		/* include all ports */
 };
 
+#define for_each_atsr_unit(atsr) \
+	list_for_each_entry(atsr, &dmar_atsr_units, list)
+
 extern int intel_iommu_init(void);
 #else /* !CONFIG_DMAR: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
memblock-add-memblock_start_of_dram.patch
memblock-add-no_bootmem-config-symbol.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

