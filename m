From: akpm@linux-foundation.org
Subject: + revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch added to -mm tree
Date: Fri, 28 Mar 2008 16:48:47 -0700
Message-ID: <200803282348.m2SNmleP016847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756710AbYC1X51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 19:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bjorn.helgaas@hp.com, davem@davemloft.net, greg@kroah.com, m.kozlowski@tuxland.pl


The patch titled
     revert gregkh-pci-pci-x86-use-generic-pci_enable_resources
has been added to the -mm tree.  Its filename is
     revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch

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
Subject: revert gregkh-pci-pci-x86-use-generic-pci_enable_resources
From: Andrew Morton <akpm@linux-foundation.org>

On Fri, 28 Mar 2008 16:10:11 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Date: Fri, 28 Mar 2008 23:52:10 +0100
> 
> > 	The gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch which
> > replaces arch-specific code with generic pci_enable_resources() makes my sparc64
> > box unable to boot (that's what quilt bisection says). At first I see these messages:
> 
> Yes, that generic code won't work because of the NULL
> r->parent check.
> 
> Alpha, ARM, V32, FRV, IA64, MIPS, MN10300, PARISC, PPC,
> SH, V850, X86, and Xtensa are all likely to run into
> problems because of this change.
> 
> The only platform that did the check as a test of r->parent
> being NULL is Powerpc.
> 
> The rest either didn't check (like sparc64), or tested it by going:
> 
> 	if (!r->start && r->end)
> 
> So the amount of potential breakage from this change is enormous.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/common.c |    2 +-
 arch/x86/pci/i386.c   |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/pci/pci.h    |    1 +
 3 files changed, 40 insertions(+), 1 deletion(-)

diff -puN arch/x86/pci/common.c~revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources arch/x86/pci/common.c
--- a/arch/x86/pci/common.c~revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources
+++ a/arch/x86/pci/common.c
@@ -466,7 +466,7 @@ int pcibios_enable_device(struct pci_dev
 {
 	int err;
 
-	if ((err = pci_enable_resources(dev, mask)) < 0)
+	if ((err = pcibios_enable_resources(dev, mask)) < 0)
 		return err;
 
 	if (!dev->msi_enabled)
diff -puN arch/x86/pci/i386.c~revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources arch/x86/pci/i386.c
--- a/arch/x86/pci/i386.c~revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources
+++ a/arch/x86/pci/i386.c
@@ -238,6 +238,44 @@ void __init pcibios_resource_survey(void
  */
 fs_initcall(pcibios_assign_resources);
 
+int pcibios_enable_resources(struct pci_dev *dev, int mask)
+{
+	u16 cmd, old_cmd;
+	int idx;
+	struct resource *r;
+
+	pci_read_config_word(dev, PCI_COMMAND, &cmd);
+	old_cmd = cmd;
+	for (idx = 0; idx < PCI_NUM_RESOURCES; idx++) {
+		/* Only set up the requested stuff */
+		if (!(mask & (1 << idx)))
+			continue;
+
+		r = &dev->resource[idx];
+		if (!(r->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
+			continue;
+		if ((idx == PCI_ROM_RESOURCE) &&
+				(!(r->flags & IORESOURCE_ROM_ENABLE)))
+			continue;
+		if (!r->start && r->end) {
+			printk(KERN_ERR "PCI: Device %s not available "
+				"because of resource %d collisions\n",
+				pci_name(dev), idx);
+			return -EINVAL;
+		}
+		if (r->flags & IORESOURCE_IO)
+			cmd |= PCI_COMMAND_IO;
+		if (r->flags & IORESOURCE_MEM)
+			cmd |= PCI_COMMAND_MEMORY;
+	}
+	if (cmd != old_cmd) {
+		printk("PCI: Enabling device %s (%04x -> %04x)\n",
+			pci_name(dev), old_cmd, cmd);
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+	}
+	return 0;
+}
+
 /*
  *  If we set up a device for bus mastering, we need to check the latency
  *  timer as certain crappy BIOSes forget to set it properly.
diff -puN arch/x86/pci/pci.h~revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources arch/x86/pci/pci.h
--- a/arch/x86/pci/pci.h~revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources
+++ a/arch/x86/pci/pci.h
@@ -42,6 +42,7 @@ enum pci_bf_sort_state {
 extern unsigned int pcibios_max_latency;
 
 void pcibios_resource_survey(void);
+int pcibios_enable_resources(struct pci_dev *, int);
 
 /* pci-pc.c */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-drm-drivers-char-drm-ati_pcigartc-fix-printk-warning.patch
net-9p-trans_fdc-p9_trans_fd_init-module_init-functions-should-return-0-on-success.patch
blackfin-video-driver-update-the-bf52x-ezkit-video-framebuffer-driver-according-to-lkml-review-fix.patch
memstick-suppress-uninitialized-var-warning.patch
alpha-get_current-dont-add-zero-to-current_thread_info-task.patch
x86-kmap_atomic-debugging-only-run-debug_kmap_atomic_prot-for-highmem-pages.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
git-x86-fix-printk-warning.patch
i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
git-kgdb-light.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
pm-remove-destroy_suspended_device-checkpatch-fixes.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-kvm-fixup.patch
git-kvm-vs-git-s390.patch
git-leds.patch
git-libata-fix-config_pci=n-build.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
git-async-tx.patch
git-net.patch
net-mac80211-debugfs_netdevc-use-of-bool-triggers-a-gcc-bug.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
net-ehea-port_lock-semaphore-to-mutex-fix.patch
tulip-tulip_read_eeprom-fixes-for-bug-4420-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-gregkh-pci-pci-alpha-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ia64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-powerpc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
git-s390-git-rejects.patch
git-sh.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
scsi-add-iscsi-ibft-support-fix.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-fixup.patch
git-xtensa.patch
git-semaphore-git-rejects.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-allocate-section_map-for-sparse_init-update-fix.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
clocksource-introduce-clock_monotonic_raw-fix-checkpatch-fixes.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch
w1-build-fix.patch

