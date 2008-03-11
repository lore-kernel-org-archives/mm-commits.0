From: akpm@linux-foundation.org
Subject: + revert-x86-enhance-debug_rodata-support-for-hotplug-and-kprobes.patch added to -mm tree
Date: Tue, 11 Mar 2008 15:23:03 -0700
Message-ID: <200803112223.m2BMN3BV029680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYCKWYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 18:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andi@firstfloor.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu, pageexec@freemail.hu, tglx@linutronix.de


The patch titled
     revert "x86 - Enhance DEBUG_RODATA support for hotplug and kprobes"
has been added to the -mm tree.  Its filename is
     revert-x86-enhance-debug_rodata-support-for-hotplug-and-kprobes.patch

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
Subject: revert "x86 - Enhance DEBUG_RODATA support for hotplug and kprobes"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 6058550ae95c3700fd9c2f869076d711689eb954
Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date:   Sat Feb 2 15:42:20 2008 -0500

as it caused suspend-to-disk failures on my t61p.

It should never have been merged with such a ridiculously bad changelog
anyway.  It is completely useless and this *greatly* decreases my ability to
work out why the patch is broken.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <pageexec@freemail.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_32.c |   24 ++++++++++++++++--------
 arch/x86/mm/init_64.c |   20 ++++++++++++++++++--
 2 files changed, 34 insertions(+), 10 deletions(-)

diff -puN arch/x86/mm/init_32.c~revert-x86-enhance-debug_rodata-support-for-hotplug-and-kprobes arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~revert-x86-enhance-debug_rodata-support-for-hotplug-and-kprobes
+++ a/arch/x86/mm/init_32.c
@@ -723,17 +723,25 @@ void mark_rodata_ro(void)
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
-	printk(KERN_INFO "Write protecting the kernel text: %luk\n",
-		size >> 10);
+#ifndef CONFIG_KPROBES
+#ifdef CONFIG_HOTPLUG_CPU
+	/* It must still be possible to apply SMP alternatives. */
+	if (num_possible_cpus() <= 1)
+#endif
+	{
+		set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
+		printk(KERN_INFO "Write protecting the kernel text: %luk\n",
+			size >> 10);
 
 #ifdef CONFIG_CPA_DEBUG
-	printk(KERN_INFO "Testing CPA: Reverting %lx-%lx\n",
-		start, start+size);
-	set_pages_rw(virt_to_page(start), size>>PAGE_SHIFT);
+		printk(KERN_INFO "Testing CPA: Reverting %lx-%lx\n",
+			start, start+size);
+		set_pages_rw(virt_to_page(start), size>>PAGE_SHIFT);
 
-	printk(KERN_INFO "Testing CPA: write protecting again\n");
-	set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
+		printk(KERN_INFO "Testing CPA: write protecting again\n");
+		set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
+#endif
+	}
 #endif
 	start += size;
 	size = (unsigned long)__end_rodata - start;
diff -puN arch/x86/mm/init_64.c~revert-x86-enhance-debug_rodata-support-for-hotplug-and-kprobes arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~revert-x86-enhance-debug_rodata-support-for-hotplug-and-kprobes
+++ a/arch/x86/mm/init_64.c
@@ -632,7 +632,24 @@ EXPORT_SYMBOL_GPL(rodata_test_data);
 
 void mark_rodata_ro(void)
 {
-	unsigned long start = PFN_ALIGN(_stext), end = PFN_ALIGN(__end_rodata);
+	unsigned long start = (unsigned long)_stext, end;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	/* It must still be possible to apply SMP alternatives. */
+	if (num_possible_cpus() > 1)
+		start = (unsigned long)_etext;
+#endif
+
+#ifdef CONFIG_KPROBES
+	start = (unsigned long)__start_rodata;
+#endif
+
+	end = (unsigned long)__end_rodata;
+	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
+	end &= PAGE_MASK;
+	if (end <= start)
+		return;
+
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -655,7 +672,6 @@ void mark_rodata_ro(void)
 	set_memory_ro(start, (end-start) >> PAGE_SHIFT);
 #endif
 }
-
 #endif
 
 #ifdef CONFIG_BLK_DEV_INITRD
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
revert-x86-enhance-debug_rodata-support-for-hotplug-and-kprobes.patch
git-kgdb-light.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
git-arm-master.patch
cifs-hack-around-biuld-error.patch
git-powerpc-fix-git-rejects.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
git-hwmon.patch
git-hrt.patch
git-ieee1394.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
git-net.patch
git-net-fix-build-with-config_net=n.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-ocfs2.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
revert-acpi-thermal-fixup.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
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
w1-build-fix.patch

