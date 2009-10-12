From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 12 Oct 2009 14:03:37 -0700
Message-ID: <200910122103.n9CL3bJj026587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758152AbZJLVEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 17:04:46 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n9CL3d1K026305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2009 14:03:40 -0700
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

 drivers/ata/ahci.c  |   52 ------------------------------------------
 fs/ecryptfs/Kconfig |    4 ---
 2 files changed, 56 deletions(-)

diff -puN drivers/ata/ahci.c~linux-next-git-rejects drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~linux-next-git-rejects
+++ a/drivers/ata/ahci.c
@@ -2884,58 +2884,6 @@ static bool ahci_broken_online(struct pc
 	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
 }
 
-<<<<<<< HEAD:drivers/ata/ahci.c
-#ifdef CONFIG_ATA_ACPI
-static void ahci_gtf_filter_workaround(struct ata_host *host)
-{
-	static const struct dmi_system_id sysids[] = {
-		/*
-		 * Aspire 3810T issues a bunch of SATA enable commands
-		 * via _GTF including an invalid one and one which is
-		 * rejected by the device.  Among the successful ones
-		 * is FPDMA non-zero offset enable which when enabled
-		 * only on the drive side leads to NCQ command
-		 * failures.  Filter it out.
-		 */
-		{
-			.ident = "Aspire 3810T",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3810T"),
-			},
-			.driver_data = (void *)ATA_ACPI_FILTER_FPDMA_OFFSET,
-		},
-		{ }
-	};
-	const struct dmi_system_id *dmi = dmi_first_match(sysids);
-	unsigned int filter;
-	int i;
-
-	if (!dmi)
-		return;
-
-	filter = (unsigned long)dmi->driver_data;
-	dev_printk(KERN_INFO, host->dev,
-		   "applying extra ACPI _GTF filter 0x%x for %s\n",
-		   filter, dmi->ident);
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-		struct ata_link *link;
-		struct ata_device *dev;
-
-		ata_for_each_link(link, ap, EDGE)
-			ata_for_each_dev(dev, link, ALL)
-				dev->gtf_filter |= filter;
-	}
-}
-#else
-static inline void ahci_gtf_filter_workaround(struct ata_host *host)
-{}
-#endif
-
-=======
->>>>>>> FETCH_HEAD:drivers/ata/ahci.c
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
diff -puN fs/ecryptfs/Kconfig~linux-next-git-rejects fs/ecryptfs/Kconfig
--- a/fs/ecryptfs/Kconfig~linux-next-git-rejects
+++ a/fs/ecryptfs/Kconfig
@@ -1,10 +1,6 @@
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-<<<<<<< HEAD:fs/ecryptfs/Kconfig
-	depends on EXPERIMENTAL && KEYS && CRYPTO
-=======
 	depends on EXPERIMENTAL && KEYS && NET && CRYPTO
->>>>>>> FETCH_HEAD:fs/ecryptfs/Kconfig
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	select CRYPTO_MD5
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
munmap-dont-check-sysctl_max_mapcount-fix.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

