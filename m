From: akpm@linux-foundation.org
Subject: - parisc-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:31 -0700
Message-ID: <200804300547.m3U5lVqe029712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758647AbYD3FsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:48:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, grundler@parisc-linux.org, kyle@parisc-linux.org, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     parisc: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     parisc-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/ccio-dma.c  |   14 +++++---------
 drivers/parisc/sba_iommu.c |   14 +++++---------
 2 files changed, 10 insertions(+), 18 deletions(-)

diff -puN drivers/parisc/ccio-dma.c~parisc-use-non-racy-method-for-proc-entries-creation drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~parisc-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/parisc/ccio-dma.c
@@ -1551,8 +1551,7 @@ static int __init ccio_probe(struct pari
 {
 	int i;
 	struct ioc *ioc, **ioc_p = &ioc_list;
-	struct proc_dir_entry *info_entry, *bitmap_entry;
-	
+
 	ioc = kzalloc(sizeof(struct ioc), GFP_KERNEL);
 	if (ioc == NULL) {
 		printk(KERN_ERR MODULE_NAME ": memory allocation failure\n");
@@ -1580,13 +1579,10 @@ static int __init ccio_probe(struct pari
 	HBA_DATA(dev->dev.platform_data)->iommu = ioc;
 	
 	if (ioc_count == 0) {
-		info_entry = create_proc_entry(MODULE_NAME, 0, proc_runway_root);
-		if (info_entry)
-			info_entry->proc_fops = &ccio_proc_info_fops;
-
-		bitmap_entry = create_proc_entry(MODULE_NAME"-bitmap", 0, proc_runway_root);
-		if (bitmap_entry)
-			bitmap_entry->proc_fops = &ccio_proc_bitmap_fops;
+		proc_create(MODULE_NAME, 0, proc_runway_root,
+			    &ccio_proc_info_fops);
+		proc_create(MODULE_NAME"-bitmap", 0, proc_runway_root,
+			    &ccio_proc_bitmap_fops);
 	}
 
 	ioc_count++;
diff -puN drivers/parisc/sba_iommu.c~parisc-use-non-racy-method-for-proc-entries-creation drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~parisc-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/parisc/sba_iommu.c
@@ -1895,7 +1895,9 @@ sba_driver_callback(struct parisc_device
 	int i;
 	char *version;
 	void __iomem *sba_addr = ioremap_nocache(dev->hpa.start, SBA_FUNC_SIZE);
-	struct proc_dir_entry *info_entry, *bitmap_entry, *root;
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *root;
+#endif
 
 	sba_dump_ranges(sba_addr);
 
@@ -1973,14 +1975,8 @@ sba_driver_callback(struct parisc_device
 		break;
 	}
 
-	info_entry = create_proc_entry("sba_iommu", 0, root);
-	bitmap_entry = create_proc_entry("sba_iommu-bitmap", 0, root);
-
-	if (info_entry)
-		info_entry->proc_fops = &sba_proc_fops;
-
-	if (bitmap_entry)
-		bitmap_entry->proc_fops = &sba_proc_bitmap_fops;
+	proc_create("sba_iommu", 0, root, &sba_proc_fops);
+	proc_create("sba_iommu-bitmap", 0, root, &sba_proc_bitmap_fops);
 #endif
 
 	parisc_vmerge_boundary = IOVP_SIZE;
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch
net-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch
atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch
vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch
cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch
netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

