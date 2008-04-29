From: akpm@linux-foundation.org
Subject: - sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:17:31 -0700
Message-ID: <200804290517.m3T5HV3C002610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbYD2FSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lwoodman@redhat.com, mingo@elte.hu, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch

This patch was dropped because it was folded into sysrq-add-show-backtrace-on-all-cpus-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: printk() should include KERN_ facility level
#53: FILE: drivers/char/sysrq.c:210:
+	printk("CPU%d:\n", smp_processor_id());

WARNING: printk() should include KERN_ facility level
#67: FILE: drivers/char/sysrq.c:224:
+		printk("CPU%d:\n", smp_processor_id());

total: 0 errors, 2 warnings, 63 lines checked

./patches/sysrq-add-show-backtrace-on-all-cpus-function.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: <lwoodman@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/sysrq.c~sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes
+++ a/drivers/char/sysrq.c
@@ -207,7 +207,7 @@ static void showacpu(void *dummy)
 		return;
 
 	spin_lock_irqsave(&show_lock, flags);
-	printk("CPU%d:\n", smp_processor_id());
+	printk(KERN_INFO "CPU%d:\n", smp_processor_id());
 	show_stack(NULL, NULL);
 	spin_unlock_irqrestore(&show_lock, flags);
 }
@@ -221,7 +221,7 @@ static void sysrq_handle_showallcpus(int
 {
 	struct pt_regs *regs = get_irq_regs();
 	if (regs) {
-		printk("CPU%d:\n", smp_processor_id());
+		printk(KERN_INFO "CPU%d:\n", smp_processor_id());
 		show_regs(regs);
 	}
 	schedule_work(&sysrq_showallcpus);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-dev-kmem-a-config-option.patch
misc-phantom-add-compat-ioctl.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch
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
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

