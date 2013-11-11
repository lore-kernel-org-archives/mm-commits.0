From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 11 Nov 2013 10:40:18 -0800
Message-ID: <52812492.aAhkV9A1IsCIVAZb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3KKSkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 13:40:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 10:40:18 -0800


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/omap3-evm.dts             |    3 
 arch/arm/boot/dts/omap4.dtsi                |   21 -----
 drivers/Kconfig                             |    3 
 drivers/mmc/host/mvsdio.c                   |    5 -
 drivers/pci/pci-driver.c                    |    4 -
 drivers/pci/pci-sysfs.c                     |    4 -
 drivers/staging/lustre/lustre/llite/lloop.c |    4 -
 drivers/usb/host/ohci-exynos.c              |    7 -
 drivers/usb/host/ohci-pxa27x.c              |    6 -
 fs/sysfs/dir.c                              |   70 ------------------
 fs/sysfs/symlink.c                          |   29 -------
 include/linux/netdevice.h                   |    6 -
 lib/kobject.c                               |    7 -
 13 files changed, 169 deletions(-)

diff -puN arch/arm/boot/dts/omap3-evm.dts~linux-next-git-rejects arch/arm/boot/dts/omap3-evm.dts
--- a/arch/arm/boot/dts/omap3-evm.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/omap3-evm.dts
@@ -18,7 +18,6 @@
 		device_type = "memory";
 		reg = <0x80000000 0x10000000>; /* 256 MB */
 	};
-<<<<<<< HEAD
 
 	leds {
 		compatible = "gpio-leds";
@@ -70,6 +69,4 @@
 	phy-names = "usb2-phy";
 	mode = <3>;
 	power = <50>;
-=======
->>>>>>> linux-next/akpm-base
 };
diff -puN arch/arm/boot/dts/omap4.dtsi~linux-next-git-rejects arch/arm/boot/dts/omap4.dtsi
--- a/arch/arm/boot/dts/omap4.dtsi~linux-next-git-rejects
+++ a/arch/arm/boot/dts/omap4.dtsi
@@ -686,27 +686,6 @@
 			num-eps = <16>;
 			ram-bits = <12>;
 			ctrl-module = <&omap_control_usbotg>;
-<<<<<<< HEAD
-=======
-		};
-
-		aes: aes@4b501000 {
-			compatible = "ti,omap4-aes";
-			ti,hwmods = "aes";
-			reg = <0x4b501000 0xa0>;
-			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&sdma 111>, <&sdma 110>;
-			dma-names = "tx", "rx";
-		};
-
-		des: des@480a5000 {
-			compatible = "ti,omap4-des";
-			ti,hwmods = "des";
-			reg = <0x480a5000 0xa0>;
-			interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&sdma 117>, <&sdma 116>;
-			dma-names = "tx", "rx";
->>>>>>> linux-next/akpm-base
 		};
 	};
 };
diff -puN drivers/Kconfig~linux-next-git-rejects drivers/Kconfig
--- a/drivers/Kconfig~linux-next-git-rejects
+++ a/drivers/Kconfig
@@ -166,11 +166,8 @@ source "drivers/reset/Kconfig"
 
 source "drivers/fmc/Kconfig"
 
-<<<<<<< HEAD
-=======
 source "drivers/powercap/Kconfig"
 
->>>>>>> linux-next/akpm-base
 source "drivers/phy/Kconfig"
 
 endmenu
diff -puN drivers/mmc/host/mvsdio.c~linux-next-git-rejects drivers/mmc/host/mvsdio.c
--- a/drivers/mmc/host/mvsdio.c~linux-next-git-rejects
+++ a/drivers/mmc/host/mvsdio.c
@@ -847,11 +847,6 @@ MODULE_DEVICE_TABLE(of, mvsdio_dt_ids);
 static struct platform_driver mvsd_driver = {
 	.probe		= mvsd_probe,
 	.remove		= mvsd_remove,
-<<<<<<< HEAD
-	.suspend	= mvsd_suspend,
-	.resume		= mvsd_resume,
-=======
->>>>>>> linux-next/akpm-base
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.of_match_table = mvsdio_dt_ids,
diff -puN drivers/pci/pci-driver.c~linux-next-git-rejects drivers/pci/pci-driver.c
--- a/drivers/pci/pci-driver.c~linux-next-git-rejects
+++ a/drivers/pci/pci-driver.c
@@ -1318,11 +1318,7 @@ struct bus_type pci_bus_type = {
 	.probe		= pci_device_probe,
 	.remove		= pci_device_remove,
 	.shutdown	= pci_device_shutdown,
-<<<<<<< HEAD
-	.dev_attrs	= pci_dev_attrs,
-=======
 	.dev_groups	= pci_dev_groups,
->>>>>>> linux-next/akpm-base
 	.bus_groups	= pci_bus_groups,
 	.drv_groups	= pci_drv_groups,
 	.pm		= PCI_PM_OPS_PTR,
diff -puN drivers/pci/pci-sysfs.c~linux-next-git-rejects drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c~linux-next-git-rejects
+++ a/drivers/pci/pci-sysfs.c
@@ -313,11 +313,7 @@ static ssize_t bus_rescan_store(struct b
 }
 static BUS_ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, bus_rescan_store);
 
-<<<<<<< HEAD
 struct attribute *pci_bus_attrs[] = {
-=======
-static struct attribute *pci_bus_attrs[] = {
->>>>>>> linux-next/akpm-base
 	&bus_attr_rescan.attr,
 	NULL,
 };
diff -puN drivers/staging/lustre/lustre/llite/lloop.c~linux-next-git-rejects drivers/staging/lustre/lustre/llite/lloop.c
--- a/drivers/staging/lustre/lustre/llite/lloop.c~linux-next-git-rejects
+++ a/drivers/staging/lustre/lustre/llite/lloop.c
@@ -369,11 +369,7 @@ static void loop_make_request(struct req
 	loop_add_bio(lo, old_bio);
 	return;
 err:
-<<<<<<< HEAD
-	cfs_bio_io_error(old_bio, old_bio->bi_size);
-=======
 	cfs_bio_io_error(old_bio, old_bio->bi_iter.bi_size);
->>>>>>> linux-next/akpm-base
 }
 
 
diff -puN drivers/usb/host/ohci-exynos.c~linux-next-git-rejects drivers/usb/host/ohci-exynos.c
--- a/drivers/usb/host/ohci-exynos.c~linux-next-git-rejects
+++ a/drivers/usb/host/ohci-exynos.c
@@ -71,16 +71,9 @@ static int exynos_ohci_probe(struct plat
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we move to full device tree support this will vanish off.
 	 */
-<<<<<<< HEAD
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-=======
 	err = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
 		return err;
->>>>>>> linux-next/akpm-base
 
 	hcd = usb_create_hcd(&exynos_ohci_hc_driver,
 				&pdev->dev, dev_name(&pdev->dev));
diff -puN drivers/usb/host/ohci-pxa27x.c~linux-next-git-rejects drivers/usb/host/ohci-pxa27x.c
--- a/drivers/usb/host/ohci-pxa27x.c~linux-next-git-rejects
+++ a/drivers/usb/host/ohci-pxa27x.c
@@ -113,15 +113,9 @@
 #define PXA_UHC_MAX_PORTNUM    3
 
 static const char hcd_name[] = "ohci-pxa27x";
-<<<<<<< HEAD
 
 static struct hc_driver __read_mostly ohci_pxa27x_hc_driver;
 
-=======
-
-static struct hc_driver __read_mostly ohci_pxa27x_hc_driver;
-
->>>>>>> linux-next/akpm-base
 struct pxa27x_ohci {
 	struct clk	*clk;
 	void __iomem	*mmio_base;
diff -puN fs/sysfs/dir.c~linux-next-git-rejects fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~linux-next-git-rejects
+++ a/fs/sysfs/dir.c
@@ -135,8 +135,6 @@ static void sysfs_unlink_sibling(struct
 		sd->s_parent->s_dir.subdirs--;
 
 	rb_erase(&sd->s_rb, &sd->s_parent->s_dir.children);
-<<<<<<< HEAD
-=======
 
 	/*
 	 * Either all or none of the children have tags.  Clearing HAS_NS
@@ -144,7 +142,6 @@ static void sysfs_unlink_sibling(struct
 	 */
 	if (RB_EMPTY_ROOT(&sd->s_parent->s_dir.children))
 		sd->s_parent->s_flags &= ~SYSFS_FLAG_HAS_NS;
->>>>>>> linux-next/akpm-base
 }
 
 /**
@@ -428,16 +425,6 @@ int __sysfs_add_one(struct sysfs_addrm_c
 	struct sysfs_inode_attrs *ps_iattr;
 	int ret;
 
-<<<<<<< HEAD
-	if (!!sysfs_ns_type(parent_sd) != !!sd->s_ns) {
-		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
-			sysfs_ns_type(parent_sd) ? "required" : "invalid",
-			parent_sd->s_name, sd->s_name);
-		return -EINVAL;
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	sd->s_hash = sysfs_name_hash(sd->s_name, sd->s_ns);
 	sd->s_parent = sysfs_get(parent_sd);
 
@@ -617,16 +604,6 @@ struct sysfs_dirent *sysfs_find_dirent(s
 	struct rb_node *node = parent_sd->s_dir.children.rb_node;
 	unsigned int hash;
 
-<<<<<<< HEAD
-	if (!!sysfs_ns_type(parent_sd) != !!ns) {
-		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
-			sysfs_ns_type(parent_sd) ? "required" : "invalid",
-			parent_sd->s_name, name);
-		return NULL;
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	hash = sysfs_name_hash(name, ns);
 	while (node) {
 		struct sysfs_dirent *sd;
@@ -675,10 +652,6 @@ struct sysfs_dirent *sysfs_get_dirent_ns
 EXPORT_SYMBOL_GPL(sysfs_get_dirent_ns);
 
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
-<<<<<<< HEAD
-		      enum kobj_ns_type type,
-=======
->>>>>>> linux-next/akpm-base
 		      const char *name, const void *ns,
 		      struct sysfs_dirent **p_sd)
 {
@@ -711,37 +684,7 @@ static int create_dir(struct kobject *ko
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd)
 {
-<<<<<<< HEAD
-	return create_dir(kobj, kobj->sd,
-			  KOBJ_NS_TYPE_NONE, name, NULL, p_sd);
-}
-
-/**
- *	sysfs_read_ns_type: return associated ns_type
- *	@kobj: the kobject being queried
- *
- *	Each kobject can be tagged with exactly one namespace type
- *	(i.e. network or user).  Return the ns_type associated with
- *	this object if any
- */
-static enum kobj_ns_type sysfs_read_ns_type(struct kobject *kobj)
-{
-	const struct kobj_ns_type_operations *ops;
-	enum kobj_ns_type type;
-
-	ops = kobj_child_ns_ops(kobj);
-	if (!ops)
-		return KOBJ_NS_TYPE_NONE;
-
-	type = ops->type;
-	BUG_ON(type <= KOBJ_NS_TYPE_NONE);
-	BUG_ON(type >= KOBJ_NS_TYPES);
-	BUG_ON(!kobj_ns_type_registered(type));
-
-	return type;
-=======
 	return create_dir(kobj, kobj->sd, name, NULL, p_sd);
->>>>>>> linux-next/akpm-base
 }
 
 /**
@@ -764,13 +707,7 @@ int sysfs_create_dir_ns(struct kobject *
 	if (!parent_sd)
 		return -ENOENT;
 
-<<<<<<< HEAD
-	type = sysfs_read_ns_type(kobj);
-
-	error = create_dir(kobj, parent_sd, type, kobject_name(kobj), ns, &sd);
-=======
 	error = create_dir(kobj, parent_sd, kobject_name(kobj), ns, &sd);
->>>>>>> linux-next/akpm-base
 	if (!error)
 		kobj->sd = sd;
 	return error;
@@ -881,17 +818,10 @@ static void __sysfs_remove(struct sysfs_
 			   struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *pos, *next;
-<<<<<<< HEAD
-
-	if (!sd)
-		return;
-
-=======
 
 	if (!sd)
 		return;
 
->>>>>>> linux-next/akpm-base
 	pr_debug("sysfs %s: removing\n", sd->s_name);
 
 	next = NULL;
diff -puN fs/sysfs/symlink.c~linux-next-git-rejects fs/sysfs/symlink.c
--- a/fs/sysfs/symlink.c~linux-next-git-rejects
+++ a/fs/sysfs/symlink.c
@@ -51,40 +51,15 @@ static int sysfs_do_create_link_sd(struc
 	if (!sd)
 		goto out_put;
 
-<<<<<<< HEAD
-	ns_type = sysfs_ns_type(parent_sd);
-	if (ns_type)
-		sd->s_ns = target_sd->s_ns;
-=======
 	sd->s_ns = target_sd->s_ns;
->>>>>>> linux-next/akpm-base
 	sd->s_symlink.target_sd = target_sd;
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt);
-<<<<<<< HEAD
-	/* Symlinks must be between directories with the same ns_type */
-	if (!ns_type ||
-	    (ns_type == sysfs_ns_type(sd->s_symlink.target_sd->s_parent))) {
-		if (warn)
-			error = sysfs_add_one(&acxt, sd, parent_sd);
-		else
-			error = __sysfs_add_one(&acxt, sd, parent_sd);
-	} else {
-		error = -EINVAL;
-		WARN(1, KERN_WARNING
-			"sysfs: symlink across ns_types %s/%s -> %s/%s\n",
-			parent_sd->s_name,
-			sd->s_name,
-			sd->s_symlink.target_sd->s_parent->s_name,
-			sd->s_symlink.target_sd->s_name);
-	}
-=======
 	if (warn)
 		error = sysfs_add_one(&acxt, sd, parent_sd);
 	else
 		error = __sysfs_add_one(&acxt, sd, parent_sd);
->>>>>>> linux-next/akpm-base
 	sysfs_addrm_finish(&acxt);
 
 	if (error)
@@ -174,11 +149,7 @@ void sysfs_delete_link(struct kobject *k
 	 * sysfs_remove_dir() for details.
 	 */
 	spin_lock(&sysfs_symlink_target_lock);
-<<<<<<< HEAD
-	if (targ->sd && sysfs_ns_type(kobj->sd))
-=======
 	if (targ->sd)
->>>>>>> linux-next/akpm-base
 		ns = targ->sd->s_ns;
 	spin_unlock(&sysfs_symlink_target_lock);
 	sysfs_hash_and_remove(kobj->sd, name, ns);
diff -puN include/linux/netdevice.h~linux-next-git-rejects include/linux/netdevice.h
--- a/include/linux/netdevice.h~linux-next-git-rejects
+++ a/include/linux/netdevice.h
@@ -2896,15 +2896,9 @@ int __init dev_proc_init(void);
 #define dev_proc_init() 0
 #endif
 
-<<<<<<< HEAD
-extern int netdev_class_create_file_ns(struct class_attribute *class_attr,
-				       const void *ns);
-extern void netdev_class_remove_file_ns(struct class_attribute *class_attr,
-=======
 int netdev_class_create_file_ns(struct class_attribute *class_attr,
 				       const void *ns);
 void netdev_class_remove_file_ns(struct class_attribute *class_attr,
->>>>>>> linux-next/akpm-base
 					const void *ns);
 
 static inline int netdev_class_create_file(struct class_attribute *class_attr)
diff -puN lib/kobject.c~linux-next-git-rejects lib/kobject.c
--- a/lib/kobject.c~linux-next-git-rejects
+++ a/lib/kobject.c
@@ -30,21 +30,14 @@
 const void *kobject_namespace(struct kobject *kobj)
 {
 	const struct kobj_ns_type_operations *ns_ops = kobj_ns_ops(kobj);
-<<<<<<< HEAD
-=======
 	const void *ns;
->>>>>>> linux-next/akpm-base
 
 	if (!ns_ops || ns_ops->type == KOBJ_NS_TYPE_NONE)
 		return NULL;
 
-<<<<<<< HEAD
-	return kobj->ktype->namespace(kobj);
-=======
 	ns = kobj->ktype->namespace(kobj);
 	WARN_ON(!ns);	/* @kobj in a namespace is required to have !NULL tag */
 	return ns;
->>>>>>> linux-next/akpm-base
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-remove-unrelated-header-files-and-export-symbol-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-factor-commit-limit-calculation-fix.patch
mm-factor-commit-limit-calculation-fix-fix.patch
mm-factor-commit-limit-calculation-fix-fix-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch
linux-next.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

