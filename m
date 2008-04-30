From: akpm@linux-foundation.org
Subject: - x86-ptrace-pebs-support-warning-fix.patch removed from -mm tree
Date: Wed, 30 Apr 2008 05:25:42 -0700
Message-ID: <200804301225.m3UCPgBn013350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbYD3M1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 08:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, eranian@googlemail.com, hpa@zytor.com, jason.wessel@windriver.com, juan.villacis@intel.com, markus.t.metzger@intel.com, mingo@elte.hu


The patch titled
     x86-ptrace-pebs-support warning fix
has been removed from the -mm tree.  Its filename was
     x86-ptrace-pebs-support-warning-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-ptrace-pebs-support warning fix
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/process_32.c: In function '__switch_to_xtra':
arch/x86/kernel/process_32.c:566: warning: unused variable 'ds_next'
arch/x86/kernel/process_32.c:566: warning: unused variable 'ds_prev'

Cc: Markus Metzger <markus.t.metzger@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: <juan.villacis@intel.com>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/process_32.c |   37 ++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff -puN arch/x86/kernel/process_32.c~x86-ptrace-pebs-support-warning-fix arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~x86-ptrace-pebs-support-warning-fix
+++ a/arch/x86/kernel/process_32.c
@@ -484,20 +484,13 @@ int set_tsc_mode(unsigned int val)
 	return 0;
 }
 
-static noinline void
-__switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
-		 struct tss_struct *tss)
+#ifdef CONFIG_X86_DS
+static int update_debugctl(struct thread_struct *prev,
+			struct thread_struct *next, unsigned long debugctl)
 {
-	struct thread_struct *prev, *next;
-	unsigned long debugctl;
-	unsigned long ds_prev = 0, ds_next = 0;
+	unsigned long ds_prev = 0;
+	unsigned long ds_next = 0;
 
-	prev = &prev_p->thread;
-	next = &next_p->thread;
-
-	debugctl = prev->debugctlmsr;
-
-#ifdef CONFIG_X86_DS
 	if (prev->ds_ctx)
 		ds_prev = (unsigned long)prev->ds_ctx->ds;
 	if (next->ds_ctx)
@@ -510,8 +503,28 @@ __switch_to_xtra(struct task_struct *pre
 		update_debugctlmsr(0);
 		wrmsr(MSR_IA32_DS_AREA, ds_next, 0);
 	}
+	return debugctl;
+}
+#else
+static int update_debugctl(struct thread_struct *prev,
+			struct thread_struct *next, unsigned long debugctl)
+{
+	return debugctl;
+}
 #endif /* CONFIG_X86_DS */
 
+static noinline void
+__switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
+		 struct tss_struct *tss)
+{
+	struct thread_struct *prev, *next;
+	unsigned long debugctl;
+
+	prev = &prev_p->thread;
+	next = &next_p->thread;
+
+	debugctl = update_debugctl(prev, next, prev->debugctlmsr);
+
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
devpts-factor-out-pty-index-allocation.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
fuse-fix-race-in-llseek.patch
basic-braille-screen-reader-support.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
disable-the-memory-controller-by-default-v3.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
x86-ptrace-pebs-support-warning-fix.patch
git-arm-fixup.patch
cifs-suppress-warning.patch
devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap-checkpatch-fixes.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
tuner_symbol_probe-dont-do-symbol_put-if-symbol_request-failed.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
sched-add-debug-checks-to-idle-functions.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
rename-div64_64-to-div64_u64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

