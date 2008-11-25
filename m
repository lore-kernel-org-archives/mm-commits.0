From: akpm@linux-foundation.org
Subject: + resource-allow-mmio-exclusivity-for-device-drivers.patch added to -mm tree
Date: Mon, 24 Nov 2008 16:12:37 -0800
Message-ID: <200811250012.mAP0CbQi016265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbYKYANI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 19:13:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, jbarnes@virtuousgeek.org, willy@linux.intel.com


The patch titled
     resource: allow MMIO exclusivity for device drivers
has been added to the -mm tree.  Its filename is
     resource-allow-mmio-exclusivity-for-device-drivers.patch

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
Subject: resource: allow MMIO exclusivity for device drivers
From: Arjan van de Ven <arjan@linux.intel.com>

Device drivers that use pci_request_regions() (and similar APIs) have a
reasonable expectation that they are the only ones accessing their device.
As part of the e1000e hunt, we were afraid that some userland (X or some
bootsplash stuff) was mapping the MMIO region that the driver thought it
had exclusively via /dev/mem or via various sysfs resource mappings.

This patch adds the option for device drivers to cause their reserved
regions to be added to the "banned from /dev/mem use" list, so now both
kernel memory and device-exclusive MMIO regions are banned.  NOTE: This is
only active when CONFIG_STRICT_DEVMEM is set.

In addition to the config option, a kernel parameter iomem=relaxed is
provided for the cases where developers want to diagnose, in the field,
drivers issues from userspace.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 
 arch/x86/mm/init_32.c               |    2 
 arch/x86/mm/init_64.c               |    2 
 drivers/net/e1000e/netdev.c         |    2 
 drivers/pci/pci-sysfs.c             |    3 
 drivers/pci/pci.c                   |  107 +++++++++++++++++++++++---
 include/linux/ioport.h              |   11 +-
 include/linux/pci.h                 |    3 
 kernel/resource.c                   |   61 ++++++++++++++
 9 files changed, 176 insertions(+), 19 deletions(-)

diff -puN Documentation/kernel-parameters.txt~resource-allow-mmio-exclusivity-for-device-drivers Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~resource-allow-mmio-exclusivity-for-device-drivers
+++ a/Documentation/kernel-parameters.txt
@@ -914,6 +914,10 @@ and is between 256 and 4096 characters. 
 
 	inttest=	[IA64]
 
+	iomem=		Disable strict checking of access to MMIO memory
+		strict	regions from userspace.
+		relaxed
+
 	iommu=		[x86]
 		off
 		force
diff -puN arch/x86/mm/init_32.c~resource-allow-mmio-exclusivity-for-device-drivers arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~resource-allow-mmio-exclusivity-for-device-drivers
+++ a/arch/x86/mm/init_32.c
@@ -331,6 +331,8 @@ int devmem_is_allowed(unsigned long page
 {
 	if (pagenr <= 256)
 		return 1;
+	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
+		return 0;
 	if (!page_is_ram(pagenr))
 		return 1;
 	return 0;
diff -puN arch/x86/mm/init_64.c~resource-allow-mmio-exclusivity-for-device-drivers arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~resource-allow-mmio-exclusivity-for-device-drivers
+++ a/arch/x86/mm/init_64.c
@@ -888,6 +888,8 @@ int devmem_is_allowed(unsigned long page
 {
 	if (pagenr <= 256)
 		return 1;
+	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
+		return 0;
 	if (!page_is_ram(pagenr))
 		return 1;
 	return 0;
diff -puN drivers/net/e1000e/netdev.c~resource-allow-mmio-exclusivity-for-device-drivers drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~resource-allow-mmio-exclusivity-for-device-drivers
+++ a/drivers/net/e1000e/netdev.c
@@ -4808,7 +4808,7 @@ static int __devinit e1000_probe(struct 
 		}
 	}
 
-	err = pci_request_selected_regions(pdev,
+	err = pci_request_selected_regions_exclusive(pdev,
 	                                  pci_select_bars(pdev, IORESOURCE_MEM),
 	                                  e1000e_driver_name);
 	if (err)
diff -puN drivers/pci/pci-sysfs.c~resource-allow-mmio-exclusivity-for-device-drivers drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c~resource-allow-mmio-exclusivity-for-device-drivers
+++ a/drivers/pci/pci-sysfs.c
@@ -620,6 +620,9 @@ pci_mmap_resource(struct kobject *kobj, 
 	vma->vm_pgoff += start >> PAGE_SHIFT;
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
 
+	if (res->flags & IORESOURCE_MEM && iomem_is_exclusive(start))
+		return -EINVAL;
+
 	return pci_mmap_page_range(pdev, vma, mmap_type, write_combine);
 }
 
diff -puN drivers/pci/pci.c~resource-allow-mmio-exclusivity-for-device-drivers drivers/pci/pci.c
--- a/drivers/pci/pci.c~resource-allow-mmio-exclusivity-for-device-drivers
+++ a/drivers/pci/pci.c
@@ -1420,7 +1420,8 @@ void pci_release_region(struct pci_dev *
  *	Returns 0 on success, or %EBUSY on error.  A warning
  *	message is also printed on failure.
  */
-int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
+static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_name,
+									int exclusive)
 {
 	struct pci_devres *dr;
 
@@ -1433,8 +1434,9 @@ int pci_request_region(struct pci_dev *p
 			goto err_out;
 	}
 	else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
-		if (!request_mem_region(pci_resource_start(pdev, bar),
-				        pci_resource_len(pdev, bar), res_name))
+		if (!__request_mem_region(pci_resource_start(pdev, bar),
+					pci_resource_len(pdev, bar), res_name,
+					exclusive))
 			goto err_out;
 	}
 
@@ -1453,6 +1455,47 @@ err_out:
 }
 
 /**
+ *	pci_request_region - Reserved PCI I/O and memory resource
+ *	@pdev: PCI device whose resources are to be reserved
+ *	@bar: BAR to be reserved
+ *	@res_name: Name to be associated with resource.
+ *
+ *	Mark the PCI region associated with PCI device @pdev BR @bar as
+ *	being reserved by owner @res_name.  Do not access any
+ *	address inside the PCI regions unless this call returns
+ *	successfully.
+ *
+ *	Returns 0 on success, or %EBUSY on error.  A warning
+ *	message is also printed on failure.
+ */
+int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
+{
+	return __pci_request_region(pdev, bar, res_name, 0);
+}
+
+/**
+ *	pci_request_region_exclusive - Reserved PCI I/O and memory resource
+ *	@pdev: PCI device whose resources are to be reserved
+ *	@bar: BAR to be reserved
+ *	@res_name: Name to be associated with resource.
+ *
+ *	Mark the PCI region associated with PCI device @pdev BR @bar as
+ *	being reserved by owner @res_name.  Do not access any
+ *	address inside the PCI regions unless this call returns
+ *	successfully.
+ *
+ *	Returns 0 on success, or %EBUSY on error.  A warning
+ *	message is also printed on failure.
+ *
+ *	The key difference that _exclusive makes it that userspace is
+ *	explicitly not allowed to map the resource via /dev/mem or
+ * 	sysfs.
+ */
+int pci_request_region_exclusive(struct pci_dev *pdev, int bar, const char *res_name)
+{
+	return __pci_request_region(pdev, bar, res_name, IORESOURCE_EXCLUSIVE);
+}
+/**
  * pci_release_selected_regions - Release selected PCI I/O and memory resources
  * @pdev: PCI device whose resources were previously reserved
  * @bars: Bitmask of BARs to be released
@@ -1469,20 +1512,14 @@ void pci_release_selected_regions(struct
 			pci_release_region(pdev, i);
 }
 
-/**
- * pci_request_selected_regions - Reserve selected PCI I/O and memory resources
- * @pdev: PCI device whose resources are to be reserved
- * @bars: Bitmask of BARs to be requested
- * @res_name: Name to be associated with resource
- */
-int pci_request_selected_regions(struct pci_dev *pdev, int bars,
-				 const char *res_name)
+int __pci_request_selected_regions(struct pci_dev *pdev, int bars,
+				 const char *res_name, int excl)
 {
 	int i;
 
 	for (i = 0; i < 6; i++)
 		if (bars & (1 << i))
-			if(pci_request_region(pdev, i, res_name))
+			if (__pci_request_region(pdev, i, res_name, excl))
 				goto err_out;
 	return 0;
 
@@ -1494,6 +1531,26 @@ err_out:
 	return -EBUSY;
 }
 
+
+/**
+ * pci_request_selected_regions - Reserve selected PCI I/O and memory resources
+ * @pdev: PCI device whose resources are to be reserved
+ * @bars: Bitmask of BARs to be requested
+ * @res_name: Name to be associated with resource
+ */
+int pci_request_selected_regions(struct pci_dev *pdev, int bars,
+				 const char *res_name)
+{
+	return __pci_request_selected_regions(pdev, bars, res_name, 0);
+}
+
+int pci_request_selected_regions_exclusive(struct pci_dev *pdev,
+				 int bars, const char *res_name)
+{
+	return __pci_request_selected_regions(pdev, bars, res_name,
+			IORESOURCE_EXCLUSIVE);
+}
+
 /**
  *	pci_release_regions - Release reserved PCI I/O and memory resources
  *	@pdev: PCI device whose resources were previously reserved by pci_request_regions
@@ -1527,6 +1584,29 @@ int pci_request_regions(struct pci_dev *
 }
 
 /**
+ *	pci_request_regions_exclusive - Reserved PCI I/O and memory resources
+ *	@pdev: PCI device whose resources are to be reserved
+ *	@res_name: Name to be associated with resource.
+ *
+ *	Mark all PCI regions associated with PCI device @pdev as
+ *	being reserved by owner @res_name.  Do not access any
+ *	address inside the PCI regions unless this call returns
+ *	successfully.
+ *
+ *	pci_request_regions_exclusive() will mark the region so that
+ * 	/dev/mem and the sysfs MMIO access will not be allowed.
+ *
+ *	Returns 0 on success, or %EBUSY on error.  A warning
+ *	message is also printed on failure.
+ */
+int pci_request_regions_exclusive(struct pci_dev *pdev, const char *res_name)
+{
+	return pci_request_selected_regions_exclusive(pdev,
+					((1 << 6) - 1), res_name);
+}
+
+
+/**
  * pci_set_master - enables bus-mastering for device dev
  * @dev: the PCI device to enable
  *
@@ -2174,10 +2254,13 @@ EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
+EXPORT_SYMBOL(pci_request_regions_exclusive);
 EXPORT_SYMBOL(pci_release_region);
 EXPORT_SYMBOL(pci_request_region);
+EXPORT_SYMBOL(pci_request_region_exclusive);
 EXPORT_SYMBOL(pci_release_selected_regions);
 EXPORT_SYMBOL(pci_request_selected_regions);
+EXPORT_SYMBOL(pci_request_selected_regions_exclusive);
 EXPORT_SYMBOL(pci_set_master);
 EXPORT_SYMBOL(pci_set_mwi);
 EXPORT_SYMBOL(pci_try_set_mwi);
diff -puN include/linux/ioport.h~resource-allow-mmio-exclusivity-for-device-drivers include/linux/ioport.h
--- a/include/linux/ioport.h~resource-allow-mmio-exclusivity-for-device-drivers
+++ a/include/linux/ioport.h
@@ -49,6 +49,7 @@ struct resource_list {
 #define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
 #define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
 
+#define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
 #define IORESOURCE_AUTO		0x40000000
@@ -133,13 +134,16 @@ static inline unsigned long resource_typ
 }
 
 /* Convenience shorthand with allocation */
-#define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
-#define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name))
+#define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), 0)
+#define __request_mem_region(start,n,name, excl) __request_region(&iomem_resource, (start), (n), (name), excl)
+#define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
+#define request_mem_region_exclusive(start,n,name) \
+	__request_region(&iomem_resource, (start), (n), (name), IORESOURCE_EXCLUSIVE)
 #define rename_region(region, newname) do { (region)->name = (newname); } while (0)
 
 extern struct resource * __request_region(struct resource *,
 					resource_size_t start,
-					resource_size_t n, const char *name);
+					resource_size_t n, const char *name, int relaxed);
 
 /* Compatibility cruft */
 #define release_region(start,n)	__release_region(&ioport_resource, (start), (n))
@@ -175,6 +179,7 @@ extern struct resource * __devm_request_
 extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
+extern int iomem_is_exclusive(u64 addr);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff -puN include/linux/pci.h~resource-allow-mmio-exclusivity-for-device-drivers include/linux/pci.h
--- a/include/linux/pci.h~resource-allow-mmio-exclusivity-for-device-drivers
+++ a/include/linux/pci.h
@@ -684,10 +684,13 @@ void pci_fixup_irqs(u8 (*)(struct pci_de
 		    int (*)(struct pci_dev *, u8, u8));
 #define HAVE_PCI_REQ_REGIONS	2
 int __must_check pci_request_regions(struct pci_dev *, const char *);
+int __must_check pci_request_regions_exclusive(struct pci_dev *, const char *);
 void pci_release_regions(struct pci_dev *);
 int __must_check pci_request_region(struct pci_dev *, int, const char *);
+int __must_check pci_request_region_exclusive(struct pci_dev *, int, const char *);
 void pci_release_region(struct pci_dev *, int);
 int pci_request_selected_regions(struct pci_dev *, int, const char *);
+int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
diff -puN kernel/resource.c~resource-allow-mmio-exclusivity-for-device-drivers kernel/resource.c
--- a/kernel/resource.c~resource-allow-mmio-exclusivity-for-device-drivers
+++ a/kernel/resource.c
@@ -633,7 +633,7 @@ resource_size_t resource_alignment(struc
  */
 struct resource * __request_region(struct resource *parent,
 				   resource_size_t start, resource_size_t n,
-				   const char *name)
+				   const char *name, int flags)
 {
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
@@ -644,6 +644,7 @@ struct resource * __request_region(struc
 	res->start = start;
 	res->end = start + n - 1;
 	res->flags = IORESOURCE_BUSY;
+	res->flags |= flags;
 
 	write_lock(&resource_lock);
 
@@ -689,7 +690,7 @@ int __check_region(struct resource *pare
 {
 	struct resource * res;
 
-	res = __request_region(parent, start, n, "check-region");
+	res = __request_region(parent, start, n, "check-region", 0);
 	if (!res)
 		return -EBUSY;
 
@@ -786,7 +787,7 @@ struct resource * __devm_request_region(
 	dr->start = start;
 	dr->n = n;
 
-	res = __request_region(parent, start, n, name);
+	res = __request_region(parent, start, n, name, 0);
 	if (res)
 		devres_add(dev, dr);
 	else
@@ -877,3 +878,57 @@ int iomem_map_sanity_check(resource_size
 
 	return err;
 }
+
+#ifdef CONFIG_STRICT_DEVMEM
+static int strict_iomem_checks = 1;
+#else
+static int strict_iomem_checks;
+#endif
+
+/*
+ * check if an address is reserved in the iomem resource tree
+ * returns 1 if reserved, 0 if not reserved.
+ */
+int iomem_is_exclusive(u64 addr)
+{
+	struct resource *p = &iomem_resource;
+	int err = 0;
+	loff_t l;
+	int size = PAGE_SIZE;
+
+	if (!strict_iomem_checks)
+		return 0;
+
+	addr = addr & PAGE_MASK;
+
+	read_lock(&resource_lock);
+	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+		/*
+		 * We can probably skip the resources without
+		 * IORESOURCE_IO attribute?
+		 */
+		if (p->start >= addr + size)
+			break;
+		if (p->end < addr)
+			continue;
+		if (p->flags & IORESOURCE_BUSY &&
+		     p->flags & IORESOURCE_EXCLUSIVE) {
+			err = 1;
+			break;
+		}
+	}
+	read_unlock(&resource_lock);
+
+	return err;
+}
+
+static int __init strict_iomem(char *str)
+{
+	if (strstr(str, "relaxed"))
+		strict_iomem_checks = 0;
+	if (strstr(str, "strict"))
+		strict_iomem_checks = 1;
+	return 1;
+}
+
+__setup("iomem=", strict_iomem);
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
scripts-improve-the-decodecode-script.patch
pci-uninline-pci_ioremap_bar.patch
pci-use-pci_ioremap_bar-in-drivers-misc.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
pci-use-pci_ioremap_bar-in-drivers-video.patch
pci-use-pci_ioremap_bar-in-drivers-edac.patch
oops-increment-the-oops-uuid-every-time-we-oops.patch
scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch
vfs-expand-some-comments-d_path-seq_path.patch
resource-allow-mmio-exclusivity-for-device-drivers.patch

