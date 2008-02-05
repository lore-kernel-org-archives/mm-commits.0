From: akpm@linux-foundation.org
Subject: + nmi-hacks.patch added to -mm tree
Date: Tue, 05 Feb 2008 01:38:02 -0800
Message-ID: <200802050937.m159bhAX014288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbYBEJhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 04:37:48 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m159bhvV026518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 5 Feb 2008 01:37:45 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     a
has been added to the -mm tree.  Its filename is
     nmi-hacks.patch

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
Subject: a
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/traps_32.c |    6 ++
 drivers/char/vt.c          |    2 
 kernel/printk.c            |   83 ++++++++++++++++++++++++-----------
 3 files changed, 65 insertions(+), 26 deletions(-)

diff -puN kernel/printk.c~nmi-hacks kernel/printk.c
--- a/kernel/printk.c~nmi-hacks
+++ a/kernel/printk.c
@@ -36,6 +36,8 @@
 
 #include <asm/uaccess.h>
 
+int nmi_hit;
+
 /*
  * Architectures can override it:
  */
@@ -147,7 +149,8 @@ static int __init log_buf_len_setup(char
 			goto out;
 		}
 
-		spin_lock_irqsave(&logbuf_lock, flags);
+		if (!nmi_hit)
+			spin_lock_irqsave(&logbuf_lock, flags);
 		log_buf_len = size;
 		log_buf = new_log_buf;
 
@@ -161,7 +164,8 @@ static int __init log_buf_len_setup(char
 		log_start -= offset;
 		con_start -= offset;
 		log_end -= offset;
-		spin_unlock_irqrestore(&logbuf_lock, flags);
+		if (!nmi_hit)
+			spin_unlock_irqrestore(&logbuf_lock, flags);
 
 		printk(KERN_NOTICE "log_buf_len: %d\n", log_buf_len);
 	}
@@ -243,7 +247,8 @@ int log_buf_copy(char *dest, int idx, in
 	bool took_lock = false;
 
 	if (!oops_in_progress) {
-		spin_lock_irq(&logbuf_lock);
+		if (!nmi_hit)
+			spin_lock_irq(&logbuf_lock);
 		took_lock = true;
 	}
 
@@ -260,7 +265,8 @@ int log_buf_copy(char *dest, int idx, in
 	}
 
 	if (took_lock)
-		spin_unlock_irq(&logbuf_lock);
+		if (!nmi_hit)
+			spin_unlock_irq(&logbuf_lock);
 
 	return ret;
 }
@@ -325,18 +331,22 @@ int do_syslog(int type, char __user *buf
 		if (error)
 			goto out;
 		i = 0;
-		spin_lock_irq(&logbuf_lock);
+		if (!nmi_hit)
+			spin_lock_irq(&logbuf_lock);
 		while (!error && (log_start != log_end) && i < len) {
 			c = LOG_BUF(log_start);
 			log_start++;
-			spin_unlock_irq(&logbuf_lock);
+			if (!nmi_hit)
+				spin_unlock_irq(&logbuf_lock);
 			error = __put_user(c,buf);
 			buf++;
 			i++;
 			cond_resched();
-			spin_lock_irq(&logbuf_lock);
+			if (!nmi_hit)
+				spin_lock_irq(&logbuf_lock);
 		}
-		spin_unlock_irq(&logbuf_lock);
+		if (!nmi_hit)
+			spin_unlock_irq(&logbuf_lock);
 		if (!error)
 			error = i;
 		break;
@@ -357,7 +367,8 @@ int do_syslog(int type, char __user *buf
 		count = len;
 		if (count > log_buf_len)
 			count = log_buf_len;
-		spin_lock_irq(&logbuf_lock);
+		if (!nmi_hit)
+			spin_lock_irq(&logbuf_lock);
 		if (count > logged_chars)
 			count = logged_chars;
 		if (do_clear)
@@ -374,12 +385,14 @@ int do_syslog(int type, char __user *buf
 			if (j + log_buf_len < log_end)
 				break;
 			c = LOG_BUF(j);
-			spin_unlock_irq(&logbuf_lock);
+			if (!nmi_hit)
+				spin_unlock_irq(&logbuf_lock);
 			error = __put_user(c,&buf[count-1-i]);
 			cond_resched();
-			spin_lock_irq(&logbuf_lock);
+			if (!nmi_hit)										spin_lock_irq(&logbuf_lock);
 		}
-		spin_unlock_irq(&logbuf_lock);
+		if (!nmi_hit)
+			spin_unlock_irq(&logbuf_lock);
 		if (error)
 			break;
 		error = i;
@@ -433,6 +446,9 @@ asmlinkage long sys_syslog(int type, cha
 	return do_syslog(type, buf, len);
 }
 
+extern void vt_console_print(struct console *co, const char *b, unsigned count);
+
+
 /*
  * Call the console drivers on a range of log_buf
  */
@@ -443,8 +459,13 @@ static void __call_console_drivers(unsig
 	for (con = console_drivers; con; con = con->next) {
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
-				(con->flags & CON_ANYTIME)))
-			con->write(con, &LOG_BUF(start), end - start);
+				(con->flags & CON_ANYTIME))) {
+			if (nmi_hit)
+				vt_console_print(con, &LOG_BUF(start),
+						end - start);
+			else
+				con->write(con, &LOG_BUF(start), end - start);
+		}
 	}
 }
 
@@ -460,6 +481,7 @@ static int __init ignore_loglevel_setup(
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
 
+
 /*
  * Write out chars from start to end - 1 inclusive
  */
@@ -670,7 +692,8 @@ asmlinkage int vprintk(const char *fmt, 
 	}
 
 	lockdep_off();
-	spin_lock(&logbuf_lock);
+	if (!nmi_hit)
+		spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
 	if (printk_recursion_bug) {
@@ -746,7 +769,8 @@ asmlinkage int vprintk(const char *fmt, 
 		 */
 		console_locked = 1;
 		printk_cpu = UINT_MAX;
-		spin_unlock(&logbuf_lock);
+		if (!nmi_hit)
+			spin_unlock(&logbuf_lock);
 
 		/*
 		 * Console drivers may assume that per-cpu resources have
@@ -771,7 +795,8 @@ asmlinkage int vprintk(const char *fmt, 
 		 * console drivers with the output which we just produced.
 		 */
 		printk_cpu = UINT_MAX;
-		spin_unlock(&logbuf_lock);
+		if (!nmi_hit)
+			spin_unlock(&logbuf_lock);
 		lockdep_on();
 out_restore_irqs:
 		raw_local_irq_restore(flags);
@@ -994,20 +1019,23 @@ void release_console_sem(void)
 	console_may_schedule = 0;
 
 	for ( ; ; ) {
-		spin_lock_irqsave(&logbuf_lock, flags);
+		if (!nmi_hit)
+			spin_lock_irqsave(&logbuf_lock, flags);
 		wake_klogd |= log_start - log_end;
 		if (con_start == log_end)
 			break;			/* Nothing to print */
 		_con_start = con_start;
 		_log_end = log_end;
 		con_start = log_end;		/* Flush */
-		spin_unlock(&logbuf_lock);
+		if (!nmi_hit)
+			spin_unlock(&logbuf_lock);
 		call_console_drivers(_con_start, _log_end);
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
 	up(&console_sem);
-	spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (!nmi_hit)
+		spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (wake_klogd)
 		wake_up_klogd();
 }
@@ -1196,9 +1224,11 @@ void register_console(struct console *co
 		 * release_console_sem() will print out the buffered messages
 		 * for us.
 		 */
-		spin_lock_irqsave(&logbuf_lock, flags);
+		if (!nmi_hit)
+			spin_lock_irqsave(&logbuf_lock, flags);
 		con_start = log_start;
-		spin_unlock_irqrestore(&logbuf_lock, flags);
+		if (!nmi_hit)
+			spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
 }
@@ -1281,7 +1311,8 @@ int __printk_ratelimit(int ratelimit_jif
 	unsigned long flags;
 	unsigned long now = jiffies;
 
-	spin_lock_irqsave(&ratelimit_lock, flags);
+	if (!nmi_hit)
+		spin_lock_irqsave(&ratelimit_lock, flags);
 	toks += now - last_msg;
 	last_msg = now;
 	if (toks > (ratelimit_burst * ratelimit_jiffies))
@@ -1291,13 +1322,15 @@ int __printk_ratelimit(int ratelimit_jif
 
 		missed = 0;
 		toks -= ratelimit_jiffies;
-		spin_unlock_irqrestore(&ratelimit_lock, flags);
+		if (!nmi_hit)
+			spin_unlock_irqrestore(&ratelimit_lock, flags);
 		if (lost)
 			printk(KERN_WARNING "printk: %d messages suppressed.\n", lost);
 		return 1;
 	}
 	missed++;
-	spin_unlock_irqrestore(&ratelimit_lock, flags);
+	if (!nmi_hit)
+		spin_unlock_irqrestore(&ratelimit_lock, flags);
 	return 0;
 }
 EXPORT_SYMBOL(__printk_ratelimit);
diff -puN drivers/char/vt.c~nmi-hacks drivers/char/vt.c
--- a/drivers/char/vt.c~nmi-hacks
+++ a/drivers/char/vt.c
@@ -2396,7 +2396,7 @@ struct tty_driver *console_driver;
  * The console must be locked when we get here.
  */
 
-static void vt_console_print(struct console *co, const char *b, unsigned count)
+void vt_console_print(struct console *co, const char *b, unsigned count)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
 	unsigned char c;
diff -puN arch/x86/kernel/nmi_32.c~nmi-hacks arch/x86/kernel/nmi_32.c
diff -puN arch/x86/kernel/traps_32.c~nmi-hacks arch/x86/kernel/traps_32.c
--- a/arch/x86/kernel/traps_32.c~nmi-hacks
+++ a/arch/x86/kernel/traps_32.c
@@ -71,6 +71,8 @@ asmlinkage int system_call(void);
 /* Do we ignore FPU interrupts ? */
 char ignore_fpu_irq = 0;
 
+extern int nmi_hit;
+
 /*
  * The IDT has to be page-aligned to simplify the Pentium
  * F0 0F bug workaround.. We have a special link segment
@@ -431,6 +433,8 @@ void die(const char * str, struct pt_reg
 	};
 	unsigned long flags;
 
+	nmi_hit = 1;
+
 	oops_enter();
 
 	if (die.lock_owner != raw_smp_processor_id()) {
@@ -729,6 +733,8 @@ static DEFINE_SPINLOCK(nmi_print_lock);
 
 void __kprobes die_nmi(struct pt_regs *regs, const char *msg)
 {
+	nmi_hit = 1;
+
 	if (notify_die(DIE_NMIWATCHDOG, msg, regs, 0, 2, SIGINT) ==
 	    NOTIFY_STOP)
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kvm-i386-fix.patch
drivers-net-wireless-b43-mainc-needs-ioh.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
timerfd-v3-new-timerfd-api.patch
include-asm-powerpc-nvramh-needs-listh.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
bufferhead-revert-constructor-removal.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
maps4-rework-task_size-macros.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
page-allocator-clean-up-pcp-draining-functions.patch
add-mm-argument-to-pte-pmd-pud-pgd_free.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-remove-fastcall-from-mm.patch
page-migraton-handle-orphaned-pages.patch
revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
dio-array_size-cleanup.patch
uml-get-rid-of-asmlinkage.patch
uml-improve-detection-of-host-cmov.patch
uml-further-bugsc-tidying.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
acpi-backlight-reset-brightness-on-resume.patch
git-agpgart.patch
git-agpgart-fix.patch
git-audit-printk-warning-fix.patch
cifs-fix-warning.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-drm-fix.patch
drm-convert-from-nopage-to-fault.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
revert-git-hrt.patch
git-ia64.patch
i8042-non-x86-build-fix.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
ata-drivers-ata-sata_mvc-needs-dmapoolh.patch
drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
memstick-disable-busted-code.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-maps-physmapc-fix-compile-remove-ifdef.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
bluetooth-uninlining.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
scsi-fix-isa-pcmcia-compile-problem.patch
scsi-aic94xx-cleanups.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-v9fs-fix-git-conflicts.patch
9p-fix-p9_printfcall-export.patch
git-watchdog.patch
git-watchdog-fixup.patch
b43-fix-build-with-config_ssb_pcihost=n.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-fix-git-conflicts.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
x86-mmconf-enable-mcfg-early.patch
git-xtensa.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
md-change-interate_mddev-to-for_each_mddev-fix.patch
md-change-iterate_rdev-to-rdev_for_each-fix.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file-fix.patch
memcontrol-move-mm_cgroup-to-header-file-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
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
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
page-owner-tracking-leak-detector-broken-on-s390.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
nmi-hacks.patch
