From: akpm@linux-foundation.org
Subject: - git-wireless-fixup.patch removed from -mm tree
Date: Mon, 17 Sep 2007 03:19:55 -0700
Message-ID: <200709171019.l8HAJtLA007623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbXIQKUB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Sep 2007 06:20:01 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8HAJt3R022431
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2007 03:19:57 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-wireless-fixup
has been removed from the -mm tree.  Its filename was
     git-wireless-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-wireless-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                   |    9 +--------
 drivers/net/b44.c             |    4 ----
 drivers/net/wireless/Kconfig  |    6 ------
 drivers/net/wireless/Makefile |    3 ---
 scripts/mod/file2alias.c      |    4 ++++
 5 files changed, 5 insertions(+), 21 deletions(-)

diff -puN scripts/mod/file2alias.c~git-wireless-fixup scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~git-wireless-fixup
+++ a/scripts/mod/file2alias.c
@@ -623,6 +623,10 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct sdio_device_id), "sdio",
 			 do_sdio_entry, mod);
+	else if (sym_is(symname, "__mod_ssb_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct ssb_device_id), "ssb",
+			 do_ssb_entry, mod);
 }
 
 /* Now add out buffered information to the generated C source */
diff -puN MAINTAINERS~git-wireless-fixup MAINTAINERS
--- a/MAINTAINERS~git-wireless-fixup
+++ a/MAINTAINERS
@@ -284,7 +284,6 @@ M:	corentin.labbe@geomatys.fr
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 
-<<<<<<< HEAD/MAINTAINERS
 ADM8211 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
@@ -293,7 +292,6 @@ W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 
-=======
 ADM8211 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
@@ -302,7 +300,6 @@ W:	http://aluminum.sourmilk.net/adm8211/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 
->>>>>>> /MAINTAINERS
 ADT746X FAN DRIVER
 P:	Colin Leroy
 M:	colin@colino.net
@@ -2111,9 +2108,6 @@ L:	http://lists.sourceforge.net/mailman/
 W:	http://ipw2200.sourceforge.net
 S:	Supported
 
-<<<<<<< HEAD/MAINTAINERS
-IOC3 ETHERNET DRIVER
-=======
 INTEL WIRELESS WIFI LINK (iwlwifi)
 P:	Zhu Yi
 M:	yi.zhu@intel.com
@@ -2124,8 +2118,7 @@ W:	http://intellinuxwireless.org
 T:	git git://intellinuxwireless.org/repos/iwlwifi
 S:	Supported
 
-IOC3 DRIVER
->>>>>>> /MAINTAINERS
+IOC3 ETHERNET DRIVER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-mips@linux-mips.org
diff -puN drivers/net/b44.c~git-wireless-fixup drivers/net/b44.c
--- a/drivers/net/b44.c~git-wireless-fixup
+++ a/drivers/net/b44.c
@@ -2101,12 +2101,8 @@ static int __devinit b44_init_one(struct
 		goto out;
 	}
 
-<<<<<<< HEAD/drivers/net/b44.c
-	SET_NETDEV_DEV(dev,&pdev->dev);
-=======
 	SET_MODULE_OWNER(dev);
 	SET_NETDEV_DEV(dev, sdev->dev);
->>>>>>> /drivers/net/b44.c
 
 	/* No interesting netdevice features in this card... */
 	dev->features |= 0;
diff -puN drivers/net/wireless/Kconfig~git-wireless-fixup drivers/net/wireless/Kconfig
--- a/drivers/net/wireless/Kconfig~git-wireless-fixup
+++ a/drivers/net/wireless/Kconfig
@@ -381,8 +381,6 @@ config PCI_HERMES
 	  common.  Some of the built-in wireless adaptors in laptops are of
 	  this variety.
 
-<<<<<<< HEAD/drivers/net/wireless/Kconfig
-=======
 config ATMEL
       tristate "Atmel at76c50x chipset  802.11b support"
       depends on (PCI || PCMCIA) && WLAN_80211
@@ -415,7 +413,6 @@ config USB_ATMEL
 	  Enable support for USB Wireless devices using Atmel at76c503,
 	  at76c505 or at76c505a chips.
 
->>>>>>> /drivers/net/wireless/Kconfig
 config PCMCIA_HERMES
 	tristate "Hermes PCMCIA card support"
 	depends on PCMCIA && HERMES
@@ -585,7 +582,6 @@ config RTL8187
 
 	  Thanks to Realtek for their support!
 
-<<<<<<< HEAD/drivers/net/wireless/Kconfig
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
@@ -613,7 +609,6 @@ config ADM8211
 
 	  Thanks to Infineon-ADMtek for their support of this driver.
 
-=======
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on PCI && WLAN_80211 && MAC80211 && EXPERIMENTAL
@@ -796,7 +791,6 @@ config IWL3945
 	  say M here and read <file:Documentation/modules.txt>.  The module
 	  will be called iwl3945.ko.
 
->>>>>>> /drivers/net/wireless/Kconfig
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/bcm43xx/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
diff -puN drivers/net/wireless/Makefile~git-wireless-fixup drivers/net/wireless/Makefile
--- a/drivers/net/wireless/Makefile~git-wireless-fixup
+++ a/drivers/net/wireless/Makefile
@@ -52,10 +52,8 @@ obj-$(CONFIG_LIBERTAS)      += libertas/
 
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
-<<<<<<< HEAD/drivers/net/wireless/Makefile
 
 obj-$(CONFIG_ADM8211)	+= adm8211.o
-=======
 
 obj-$(CONFIG_ADM8211)		+= adm8211.o
 
@@ -96,4 +94,3 @@ CFLAGS_iwl-base-4965.o	= -DIWL=4965 -D"K
 $(obj)/iwl-base-4965.o: $(src)/iwl-base.c FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
->>>>>>> /drivers/net/wireless/Makefile
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
atyfb-force-29mhz-xtal-on-g3-powerbooks.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
alsa-procfs-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
fix-gregkh-driver-sysfs-spit-a-warning-to-users-when-they-try-to-create-a-duplicate-sysfs-file.patch
fix-gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-jg-misc-fix.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
git-mips-fixup.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-net.patch
git-net-fixup.patch
nit-net-skge-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
net-atm-lecc-printk-warning-fix.patch
git-net-broke-ipg-add-ip1000a-driver-to-kernel-tree.patch
git-backlight.patch
git-backlight-build-fix.patch
git-backlight-dependency-fix.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-nfsd-fixup.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-misc-arcmsr-build-fix.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-block-fix-u14-34f.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
git-net-vs-git-wireless.patch
git-net-vs-git-wireless-2.patch
net-add-ath5k-wireless-driver-fix.patch
git-net-vs-git-wireless-3.patch
git-net-broke-git-wireless.patch
iwl3945-is-bust.patch
more-wireless-borkage.patch
more-wireless-borkage-2.patch
more-wireless-borkage-3.patch
net-hack-hack.patch
p54pci-terminate-pci-table.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
i386-and-x86_64-randomize-brk-fix.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs.patch
modpost-detect-unterminated-device-id-lists-fix.patch
pvrusb2-hdw-terminate-usb-device-id-table-differently.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
