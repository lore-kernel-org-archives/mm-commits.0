From: akpm@linux-foundation.org
Subject: + git-wireless-fixup.patch added to -mm tree
Date: Tue, 14 Aug 2007 11:58:50 -0700
Message-ID: <200708141858.l7EIwo14015839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760573AbXHNS66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 14:58:58 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7EIwtUl013048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2007 11:58:56 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-wireless-fixup
has been added to the -mm tree.  Its filename is
     git-wireless-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-wireless-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/Kconfig  |   34 ------------------
 drivers/net/wireless/Makefile |   60 ++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 34 deletions(-)

diff -puN drivers/net/wireless/Kconfig~git-wireless-fixup drivers/net/wireless/Kconfig
--- a/drivers/net/wireless/Kconfig~git-wireless-fixup
+++ a/drivers/net/wireless/Kconfig
@@ -451,40 +451,6 @@ config PCMCIA_ATMEL
 	  Enable support for PCMCIA cards containing the
 	  Atmel at76c502 and at76c504 chips.
 
-config ATMEL
-      tristate "Atmel at76c50x chipset  802.11b support"
-      depends on (PCI || PCMCIA) && WLAN_80211
-      select WIRELESS_EXT
-      select FW_LOADER
-      select CRC32
-       ---help---
-        A driver 802.11b wireless cards based on the Atmel fast-vnet
-        chips. This driver supports standard Linux wireless extensions.
-
-        Many  cards based on this chipset do not have flash memory
-        and need their firmware loaded at start-up. If yours is
-        one of these, you will need to provide a firmware image
-        to be loaded into the card by the driver. The Atmel
-        firmware package can be downloaded from
-        <http://www.thekelleys.org.uk/atmel>
-
-config PCI_ATMEL
-      tristate "Atmel at76c506 PCI cards"
-      depends on ATMEL && PCI
-       ---help---
-        Enable support for PCI and mini-PCI cards containing the
-        Atmel at76c506 chip.
-
-config PCMCIA_ATMEL
-	tristate "Atmel at76c502/at76c504 PCMCIA cards"
-	depends on ATMEL && PCMCIA
-	select WIRELESS_EXT
-	select FW_LOADER
-	select CRC32
-	---help---
-	  Enable support for PCMCIA cards containing the
-	  Atmel at76c502 and at76c504 chips.
-
 config AIRO_CS
 	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
 	depends on PCMCIA && (BROKEN || !M32R) && WLAN_80211
diff -puN drivers/net/wireless/Makefile~git-wireless-fixup drivers/net/wireless/Makefile
--- a/drivers/net/wireless/Makefile~git-wireless-fixup
+++ a/drivers/net/wireless/Makefile
@@ -36,7 +36,9 @@ obj-$(CONFIG_PRISM54)		+= prism54/
 
 obj-$(CONFIG_HOSTAP)		+= hostap/
 obj-$(CONFIG_BCM43XX)		+= bcm43xx/
+obj-$(CONFIG_B43)		+= b43/
 obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
+obj-$(CONFIG_ZD1211RW_MAC80211)	+= zd1211rw-mac80211/
 
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
@@ -47,3 +49,61 @@ obj-$(CONFIG_LIBERTAS)      += libertas/
 
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
+
+obj-$(CONFIG_ADM8211)		+= adm8211.o
+
+obj-$(CONFIG_P54_COMMON)	+= p54common.o
+obj-$(CONFIG_P54_USB)		+= p54usb.o
+obj-$(CONFIG_P54_PCI)		+= p54pci.o
+
+rt2x00lib-objs := rt2x00dev.o rt2x00mac.o rt2x00config.o
+
+ifeq ($(CONFIG_RT2X00_LIB_DEBUGFS),y)
+	rt2x00lib-objs += rt2x00debug.o
+endif
+
+ifeq ($(CONFIG_RT2X00_LIB_RFKILL),y)
+	rt2x00lib-objs += rt2x00rfkill.o
+endif
+
+ifeq ($(CONFIG_RT2X00_LIB_FIRMWARE),y)
+	rt2x00lib-objs += rt2x00firmware.o
+endif
+
+obj-$(CONFIG_RT2X00_LIB)	+= rt2x00lib.o
+obj-$(CONFIG_RT2X00_LIB_PCI)	+= rt2x00pci.o
+obj-$(CONFIG_RT2X00_LIB_USB)	+= rt2x00usb.o
+obj-$(CONFIG_RT2400PCI)		+= rt2400pci.o
+obj-$(CONFIG_RT2500PCI)		+= rt2500pci.o
+obj-$(CONFIG_RT61PCI)		+= rt61pci.o
+obj-$(CONFIG_RT2500USB)		+= rt2500usb.o
+obj-$(CONFIG_RT73USB)		+= rt73usb.o
+
+# NOTE:  We use common code from iwl-base.c to build driver
+# specific binaries based on the #define IWL -- the target
+# setup below creates a specific driver target from iwl-base.c
+#
+# NOTE2: iwl-base-XXXX.o has -D"KBUILD_MODNAME=KBUILD_STR(...)" in order to
+# prevent the following kbuild error:
+# 	include/linux/pci.h:603: error: `KBUILD_MODNAME' undeclared (first \
+#		use in this function)
+#
+# -jpk
+
+obj-$(CONFIG_IWL3945)	+= iwl3945.o
+iwl3945-objs		= iwl-base-3945.o iwl-3945.o iwl-3945-rs.o
+CFLAGS_iwl-3945.o	= -DIWL=3945
+CFLAGS_iwl-3945-rs.o	= -DIWL=3945
+CFLAGS_iwl-base-3945.o	= -DIWL=3945 -D"KBUILD_MODNAME=KBUILD_STR(iwl3945)"
+$(obj)/iwl-base-3945.o: $(src)/iwl-base.c FORCE
+	$(call cmd,force_checksrc)
+	$(call if_changed_rule,cc_o_c)
+
+obj-$(CONFIG_IWL4965)	+= iwl4965.o
+iwl4965-objs		= iwl-base-4965.o iwl-4965.o iwl-4965-rs.o
+CFLAGS_iwl-4965.o	= -DIWL=4965
+CFLAGS_iwl-4965-rs.o	= -DIWL=4965
+CFLAGS_iwl-base-4965.o	= -DIWL=4965 -D"KBUILD_MODNAME=KBUILD_STR(iwl4965)"
+$(obj)/iwl-base-4965.o: $(src)/iwl-base.c FORCE
+	$(call cmd,force_checksrc)
+	$(call if_changed_rule,cc_o_c)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
free_irq-fix-debug_shirq-handling.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dma-up-fix.patch
git-dvb-fixup-2.patch
adbhid-produce-all-capslock-key-events.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
ide-arm-hack.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-ixgbe-build-fix.patch
git-net.patch
git-net-fixup.patch
introduce-strtol_check_range.patch
git-backlight.patch
git-nfsd.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
bsg-declare-request_queue.patch
aacraid-rename-check_reset.patch
scsi-ipsc-warning-fix.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-wireless.patch
git-wireless-fixup.patch
disable-b44-and-bcm43xx.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
git-xfs.patch
git-kgdb-fixup.patch
fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
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
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
w1-build-fix.patch
