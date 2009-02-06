From: akpm@linux-foundation.org
Subject: + input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix.patch added to -mm tree
Date: Thu, 05 Feb 2009 16:04:01 -0800
Message-ID: <200902060021.n160L3Y4004295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbZBFAVk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 19:21:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@linux.intel.com, dtor@mail.ru


The patch titled
     input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix
has been added to the -mm tree.  Its filename is
     input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix.patch

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
Subject: input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/input/serio/i8042-x86ia64io.h:458: warning: 'i8042_dmi_reset_table' defined but not used

Fix this my moving both i8042_dmi_nopnp_tablep[] and i8042_dmi_reset_table[]
into a section which requires CONFIG_PNP and CONFIG_X86.  Give their
usage sites the same treatment.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |   79 +++++++++++-------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff -puN drivers/input/serio/i8042-x86ia64io.h~input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -369,26 +369,6 @@ static struct dmi_system_id __initdata i
 	{ }
 };
 
-#ifdef CONFIG_PNP
-static struct dmi_system_id __initdata i8042_dmi_nopnp_table[] = {
-	{
-		.ident = "Intel MBO Desktop D845PESV",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
-		},
-	},
-	{
-		.ident = "MSI Wind U-100",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
-		},
-	},
-	{ }
-};
-#endif
-
 /*
  * Some Wistron based laptops need us to explicitly enable the 'Dritek
  * keyboard extension' to make their extra keys start generating scancodes.
@@ -455,25 +435,6 @@ static struct dmi_system_id __initdata i
 	{ }
 };
 
-static struct dmi_system_id __initdata i8042_dmi_reset_table[] = {
-	{
-		.ident = "MSI Wind U-100",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
-		},
-	},
-	{
-		.ident = "LG Electronics X110",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "X110"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
-		},
-	},
-	{ }
-};
-
-
 #endif /* CONFIG_X86 */
 
 #ifdef CONFIG_PNP
@@ -492,6 +453,44 @@ static int i8042_pnp_aux_irq;
 static char i8042_pnp_kbd_name[32];
 static char i8042_pnp_aux_name[32];
 
+#ifdef CONFIG_X86
+static struct dmi_system_id __initdata i8042_dmi_nopnp_table[] = {
+	{
+		.ident = "Intel MBO Desktop D845PESV",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+		},
+	},
+	{
+		.ident = "MSI Wind U-100",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+		},
+	},
+	{ }
+};
+
+static struct dmi_system_id __initdata i8042_dmi_reset_table[] = {
+	{
+		.ident = "MSI Wind U-100",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+		},
+	},
+	{
+		.ident = "LG Electronics X110",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X110"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
+		},
+	},
+	{ }
+};
+#endif
+
 static int i8042_pnp_kbd_probe(struct pnp_dev *dev, const struct pnp_device_id *did)
 {
 	if (pnp_port_valid(dev, 0) && pnp_port_len(dev, 0) == 1)
@@ -588,12 +587,12 @@ static int __init i8042_pnp_init(void)
 #ifdef CONFIG_X86
 	if (dmi_check_system(i8042_dmi_nopnp_table))
 		i8042_nopnp = 1;
-#endif
 
 	if (dmi_check_system(i8042_dmi_reset_table)) {
 		i8042_reset = 1;
 		i8042_nonfatal = 1;
 	}
+#endif
 
 	if (i8042_nopnp) {
 		printk(KERN_INFO "i8042: PNP detection disabled\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation.patch
sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread-fix.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
revert-x86-prevent-kprobes-from-catching-spurious-page-faults.patch
linux-next.patch
next-remove-localversion.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
arch-powerpc-eliminate-double-sizeof-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-constify-pci_bus_assign_resources.patch
pci-constify-pci_bus_assign_resources-fix.patch
pci-constify-pci_bus_add_devices.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void-fix.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
8250-fix-boot-hang-with-serial-console-when-using-with-serial-over-lan-port-fix.patch
x86-allow-intel_iommu-support-to-be-disabled-by-default-fix.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-uninline-lock_fb_info.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

