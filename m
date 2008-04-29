From: akpm@linux-foundation.org
Subject: + pci-export-resource_wc-in-pci-sysfs.patch added to -mm tree
Date: Tue, 29 Apr 2008 15:24:56 -0700
Message-ID: <200804292224.m3TMOuCS013197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761467AbYD2WZW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 18:25:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, jbarnes@virtuousgeek.org, mingo@elte.hu, suresh.b.siddha@intel.com


The patch titled
     PCI: export resource_wc in pci sysfs
has been added to the -mm tree.  Its filename is
     pci-export-resource_wc-in-pci-sysfs.patch

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
Subject: PCI: export resource_wc in pci sysfs
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

For the ranges with IORESOURCE_PREFETCH, export a new resource_wc interface in
pci /sysfs along with resource (which is uncached).

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/sysfs-pci.txt |    1 
 drivers/pci/pci-sysfs.c                 |   82 ++++++++++++++++------
 include/linux/pci.h                     |    1 
 3 files changed, 63 insertions(+), 21 deletions(-)

diff -puN Documentation/filesystems/sysfs-pci.txt~pci-export-resource_wc-in-pci-sysfs Documentation/filesystems/sysfs-pci.txt
--- a/Documentation/filesystems/sysfs-pci.txt~pci-export-resource_wc-in-pci-sysfs
+++ a/Documentation/filesystems/sysfs-pci.txt
@@ -36,6 +36,7 @@ files, each with their own function.
        local_cpus	   nearby CPU mask (cpumask, ro)
        resource		   PCI resource host addresses (ascii, ro)
        resource0..N	   PCI resource N, if present (binary, mmap)
+       resource0_wc..N_wc  PCI WC map resource N, if prefetchable (binary, mmap)
        rom		   PCI ROM resource, if present (binary, ro)
        subsystem_device	   PCI subsystem device (ascii, ro)
        subsystem_vendor	   PCI subsystem vendor (ascii, ro)
diff -puN drivers/pci/pci-sysfs.c~pci-export-resource_wc-in-pci-sysfs drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c~pci-export-resource_wc-in-pci-sysfs
+++ a/drivers/pci/pci-sysfs.c
@@ -489,13 +489,14 @@ pci_mmap_legacy_mem(struct kobject *kobj
  * @kobj: kobject for mapping
  * @attr: struct bin_attribute for the file being mapped
  * @vma: struct vm_area_struct passed into the mmap
+ * @write_combine: 1 for write_combine mapping
  *
  * Use the regular PCI mapping routines to map a PCI resource into userspace.
  * FIXME: write combining?  maybe automatic for prefetchable regions?
  */
 static int
 pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
-		  struct vm_area_struct *vma)
+		  struct vm_area_struct *vma, int write_combine)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
 						       struct device, kobj));
@@ -518,7 +519,21 @@ pci_mmap_resource(struct kobject *kobj, 
 	vma->vm_pgoff += start >> PAGE_SHIFT;
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
 
-	return pci_mmap_page_range(pdev, vma, mmap_type, 0);
+	return pci_mmap_page_range(pdev, vma, mmap_type, write_combine);
+}
+
+static int
+pci_mmap_resource_uc(struct kobject *kobj, struct bin_attribute *attr,
+		     struct vm_area_struct *vma)
+{
+	return pci_mmap_resource(kobj, attr, vma, 0);
+}
+
+static int
+pci_mmap_resource_wc(struct kobject *kobj, struct bin_attribute *attr,
+		     struct vm_area_struct *vma)
+{
+	return pci_mmap_resource(kobj, attr, vma, 1);
 }
 
 /**
@@ -541,9 +556,46 @@ pci_remove_resource_files(struct pci_dev
 			sysfs_remove_bin_file(&pdev->dev.kobj, res_attr);
 			kfree(res_attr);
 		}
+
+		res_attr = pdev->res_attr_wc[i];
+		if (res_attr) {
+			sysfs_remove_bin_file(&pdev->dev.kobj, res_attr);
+			kfree(res_attr);
+		}
 	}
 }
 
+static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
+{
+	/* allocate attribute structure, piggyback attribute name */
+	int name_len = write_combine ? 13 : 10;
+	struct bin_attribute *res_attr;
+	int retval;
+
+	res_attr = kzalloc(sizeof(*res_attr) + name_len, GFP_ATOMIC);
+	if (res_attr) {
+		char *res_attr_name = (char *)(res_attr + 1);
+
+		if (write_combine) {
+			pdev->res_attr_wc[num] = res_attr;
+			sprintf(res_attr_name, "resource%d_wc", num);
+			res_attr->mmap = pci_mmap_resource_wc;
+		} else {
+			pdev->res_attr[num] = res_attr;
+			sprintf(res_attr_name, "resource%d", num);
+			res_attr->mmap = pci_mmap_resource_uc;
+		}
+		res_attr->attr.name = res_attr_name;
+		res_attr->attr.mode = S_IRUSR | S_IWUSR;
+		res_attr->size = pci_resource_len(pdev, num);
+		res_attr->private = &pdev->resource[num];
+		retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
+	} else
+		retval = -ENOMEM;
+
+	return retval;
+}
+
 /**
  * pci_create_resource_files - create resource files in sysfs for @dev
  * @dev: dev in question
@@ -557,31 +609,19 @@ static int pci_create_resource_files(str
 
 	/* Expose the PCI resources from this device as files */
 	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
-		struct bin_attribute *res_attr;
 
 		/* skip empty resources */
 		if (!pci_resource_len(pdev, i))
 			continue;
 
-		/* allocate attribute structure, piggyback attribute name */
-		res_attr = kzalloc(sizeof(*res_attr) + 10, GFP_ATOMIC);
-		if (res_attr) {
-			char *res_attr_name = (char *)(res_attr + 1);
+		retval = pci_create_attr(pdev, i, 0);
+		/* for prefetchable resources, create a WC mappable file */
+		if (!retval && pdev->resource[i].flags & IORESOURCE_PREFETCH)
+			retval = pci_create_attr(pdev, i, 1);
 
-			pdev->res_attr[i] = res_attr;
-			sprintf(res_attr_name, "resource%d", i);
-			res_attr->attr.name = res_attr_name;
-			res_attr->attr.mode = S_IRUSR | S_IWUSR;
-			res_attr->size = pci_resource_len(pdev, i);
-			res_attr->mmap = pci_mmap_resource;
-			res_attr->private = &pdev->resource[i];
-			retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
-			if (retval) {
-				pci_remove_resource_files(pdev);
-				return retval;
-			}
-		} else {
-			return -ENOMEM;
+		if (retval) {
+			pci_remove_resource_files(pdev);
+			return retval;
 		}
 	}
 	return 0;
diff -puN include/linux/pci.h~pci-export-resource_wc-in-pci-sysfs include/linux/pci.h
--- a/include/linux/pci.h~pci-export-resource_wc-in-pci-sysfs
+++ a/include/linux/pci.h
@@ -215,6 +215,7 @@ struct pci_dev {
 	struct bin_attribute *rom_attr; /* attribute descriptor for sysfs ROM entry */
 	int rom_attr_enabled;		/* has display of the rom attribute been enabled? */
 	struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for resources */
+	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
 #endif
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
pci-export-resource_wc-in-pci-sysfs.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
git-acpi.patch
git-cpufreq.patch
cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch
sched-add-debug-checks-to-idle-functions.patch

