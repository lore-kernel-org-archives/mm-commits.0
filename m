From: akpm@linux-foundation.org
Subject: - aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:00:57 -0800
Message-ID: <200802080800.m1880cdk013921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbYBHICC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:02:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86
has been removed from the -mm tree.  Its filename was
     aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86
From: Andrew Morton <akpm@linux-foundation.org>

was that really necessary?

Cc: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/a.out-core.h |   38 +++++++++++++++++----------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff -puN include/asm-x86/a.out-core.h~aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86 include/asm-x86/a.out-core.h
--- a/include/asm-x86/a.out-core.h~aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86
+++ a/include/asm-x86/a.out-core.h
@@ -24,40 +24,42 @@
 static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 {
 	int i;
+	unsigned long *debugreg;
 
 /* changed the size calculations - should hopefully work better. lbt */
 	dump->magic = CMAGIC;
 	dump->start_code = 0;
-	dump->start_stack = regs->esp & ~(PAGE_SIZE - 1);
+	dump->start_stack = regs->sp & ~(PAGE_SIZE - 1);
 	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
 	dump->u_dsize = ((unsigned long)
 			 (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
 	dump->u_dsize -= dump->u_tsize;
 	dump->u_ssize = 0;
+	debugreg = &current->thread.debugreg0;
 	for (i = 0; i < 8; i++)
-		dump->u_debugreg[i] = current->thread.debugreg[i];
+		dump->u_debugreg[i] = *debugreg++;
 
 	if (dump->start_stack < TASK_SIZE)
 		dump->u_ssize = ((unsigned long)
 				 (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
 
-	dump->regs.ebx = regs->ebx;
-	dump->regs.ecx = regs->ecx;
-	dump->regs.edx = regs->edx;
-	dump->regs.esi = regs->esi;
-	dump->regs.edi = regs->edi;
-	dump->regs.ebp = regs->ebp;
-	dump->regs.eax = regs->eax;
-	dump->regs.ds = regs->xds;
-	dump->regs.es = regs->xes;
-	dump->regs.fs = regs->xfs;
+	dump->regs.bx = regs->bx;
+	dump->regs.cx = regs->cx;
+	dump->regs.dx = regs->dx;
+	dump->regs.si = regs->si;
+	dump->regs.di = regs->di;
+	dump->regs.bp = regs->bp;
+	dump->regs.ax = regs->ax;
+	dump->regs.ds = regs->ds;
+	dump->regs.es = regs->es;
+	dump->regs.fs = regs->fs;
 	savesegment(gs, dump->regs.gs);
-	dump->regs.orig_eax = regs->orig_eax;
-	dump->regs.eip = regs->eip;
-	dump->regs.cs = regs->xcs;
-	dump->regs.eflags = regs->eflags;
-	dump->regs.esp = regs->esp;
-	dump->regs.ss = regs->xss;
+	dump->regs.orig_ax = regs->orig_ax;
+	dump->regs.ip = regs->ip;
+	dump->regs.cs = regs->cs;
+	dump->regs.flags = regs->flags;
+	dump->regs.sp = regs->sp;
+	dump->regs.ss = regs->ss;
 
 	dump->u_fpvalid = dump_fpu(regs, &dump->i387);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-avr32-fix-git-conflicts.patch
git-cifs.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
revert-git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
memstick-disable-busted-code.patch
git-mmc.patch
typhoon-section-fix.patch
natsemi-section-fix.patch
bnx2x-section-fix.patch
bnx2c-section-fix.patch
via-velocity-section-fix.patch
starfire-secton-fix.patch
pppol2tp-fix-printk-warnings.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-fixup.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
x86-mmconf-enable-mcfg-early.patch
git-xfs-fix-git-conflicts.patch
git-xtensa.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
