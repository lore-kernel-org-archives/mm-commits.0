From: akpm@linux-foundation.org
Subject: + parisc-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:46 -0700
Message-ID: <200804152356.m3FNukhg022572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756089AbYDOX5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:57:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, grundler@parisc-linux.org, kyle@parisc-linux.org, matthew@wil.cx


The patch titled
     parisc: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     parisc-use-non-racy-method-for-proc-entries-creation.patch

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

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

