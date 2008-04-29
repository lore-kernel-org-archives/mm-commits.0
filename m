From: akpm@linux-foundation.org
Subject: - sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:17:34 -0700
Message-ID: <200804290517.m3T5HYQF002613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468AbYD2FSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:18:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lwoodman@redhat.com, mingo@elte.hu, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup
has been removed from the -mm tree.  Its filename was
     sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch

This patch was dropped because it was folded into sysrq-add-show-backtrace-on-all-cpus-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

be conventional about code layout.

Cc: <lwoodman@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/sysrq.c~sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup
+++ a/drivers/char/sysrq.c
@@ -198,6 +198,7 @@ static struct sysrq_key_op sysrq_showloc
 
 #ifdef CONFIG_SMP
 static DEFINE_SPINLOCK(show_lock);
+
 static void showacpu(void *dummy)
 {
 	unsigned long flags;
@@ -211,10 +212,12 @@ static void showacpu(void *dummy)
 	show_stack(NULL, NULL);
 	spin_unlock_irqrestore(&show_lock, flags);
 }
+
 static void sysrq_showregs_othercpus(struct work_struct *dummy)
 {
 	smp_call_function(showacpu, NULL, 0, 0);
 }
+
 static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
 
 static void sysrq_handle_showallcpus(int key, struct tty_struct *tty)
@@ -226,6 +229,7 @@ static void sysrq_handle_showallcpus(int
 	}
 	schedule_work(&sysrq_showallcpus);
 }
+
 static struct sysrq_key_op sysrq_showallcpus_op = {
 	.handler	= sysrq_handle_showallcpus,
 	.help_msg	= "aLlcpus",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-dev-kmem-a-config-option.patch
misc-phantom-add-compat-ioctl.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
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

