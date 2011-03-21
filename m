From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 21 Mar 2011 12:07:17 -0700
Message-ID: <201103211910.p2LJAW2j019811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab1CUTKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 15:10:33 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p2LJAWfN004364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2011 12:10:32 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/usb-musb.c      |    7 -------
 drivers/scsi/libsas/sas_scsi_host.c |    4 ----
 drivers/tty/serial/Makefile         |    5 -----
 fs/super.c                          |    9 ---------
 4 files changed, 25 deletions(-)

diff -puN arch/arm/mach-omap2/usb-musb.c~linux-next-git-rejects arch/arm/mach-omap2/usb-musb.c
--- a/arch/arm/mach-omap2/usb-musb.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap2/usb-musb.c
@@ -132,12 +132,9 @@ void __init usb_musb_init(struct omap_mu
 	musb_plat.mode = board_data->mode;
 	musb_plat.extvbus = board_data->extvbus;
 
-<<<<<<< HEAD
 	if (cpu_is_omap44xx())
 		omap4430_phy_init(dev);
 
-=======
->>>>>>> FETCH_HEAD
 	if (cpu_is_omap3517() || cpu_is_omap3505()) {
 		oh_name = "am35x_otg_hs";
 		name = "musb-am35x";
@@ -167,13 +164,9 @@ void __init usb_musb_init(struct omap_mu
 	dev->dma_mask = &musb_dmamask;
 	dev->coherent_dma_mask = musb_dmamask;
 	put_device(dev);
-<<<<<<< HEAD
-=======
 
 	if (cpu_is_omap44xx())
 		omap4430_phy_init(dev);
-
->>>>>>> FETCH_HEAD
 }
 
 #else
diff -puN drivers/scsi/libsas/sas_scsi_host.c~linux-next-git-rejects drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~linux-next-git-rejects
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -686,10 +686,6 @@ enum blk_eh_timer_return sas_scsi_timed_
 	if (sas_ata_timed_out(cmd, task, &rtn))
 		return rtn;
 
-<<<<<<< HEAD
-=======
-
->>>>>>> FETCH_HEAD
 	if (!task) {
 		cmd->request->timeout /= 2;
 		SAS_DPRINTK("command 0x%p, task 0x%p, gone: %s\n",
diff -puN drivers/tty/serial/Makefile~linux-next-git-rejects drivers/tty/serial/Makefile
--- a/drivers/tty/serial/Makefile~linux-next-git-rejects
+++ a/drivers/tty/serial/Makefile
@@ -92,10 +92,5 @@ obj-$(CONFIG_SERIAL_MRST_MAX3110)	+= mrs
 obj-$(CONFIG_SERIAL_MFD_HSU)	+= mfd.o
 obj-$(CONFIG_SERIAL_IFX6X60)  	+= ifx6x60.o
 obj-$(CONFIG_SERIAL_PCH_UART)	+= pch_uart.o
-<<<<<<< HEAD
-obj-$(CONFIG_SERIAL_MSM_SMD)	+= msm_smd_tty.o
-obj-$(CONFIG_SERIAL_MXS_AUART) += mxs-auart.o
-=======
 obj-$(CONFIG_SERIAL_MXS_AUART) += mxs-auart.o
 obj-$(CONFIG_SERIAL_MSM_SMD)	+= msm_smd_tty.o
->>>>>>> FETCH_HEAD
diff -puN fs/super.c~linux-next-git-rejects fs/super.c
--- a/fs/super.c~linux-next-git-rejects
+++ a/fs/super.c
@@ -937,19 +937,10 @@ mount_fs(struct file_system_type *type, 
 		error = PTR_ERR(root);
 		goto out_free_secdata;
 	}
-<<<<<<< HEAD
 	sb = root->d_sb;
 	BUG_ON(!sb);
 	WARN_ON(!sb->s_bdi);
 	sb->s_flags |= MS_BORN;
-=======
-	mnt->mnt_root = root;
-	mnt->mnt_sb = root->d_sb;
-	BUG_ON(!mnt->mnt_sb);
-	WARN_ON(!mnt->mnt_sb->s_bdi);
-	WARN_ON(mnt->mnt_sb->s_bdi == &default_backing_dev_info);
-	mnt->mnt_sb->s_flags |= MS_BORN;
->>>>>>> FETCH_HEAD
 
 	error = security_sb_kern_mount(sb, flags, secdata);
 	if (error)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
revert-kbuild-reenable-section-mismatch-analysis.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-usb-serial-usb_wwanc-unbork.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

