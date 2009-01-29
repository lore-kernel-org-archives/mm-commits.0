From: akpm@linux-foundation.org
Subject: + cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch added to -mm tree
Date: Thu, 29 Jan 2009 01:45:14 -0800
Message-ID: <200901290945.n0T9jECY012662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166AbZA2JpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 04:45:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux-foundation.org, menage@google.com, miaox@cn.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2
has been added to the -mm tree.  Its filename is
     cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch

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
Subject: cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    9 +++++++++
 init/main.c            |    2 +-
 kernel/kthread.c       |    4 +++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff -puN include/linux/cpuset.h~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2 include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2
+++ a/include/linux/cpuset.h
@@ -79,6 +79,11 @@ extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
+static inline void set_mems_allowed(nodemask_t nodemask)
+{
+	current->mems_allowed = nodemask;
+}
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init(void) { return 0; }
@@ -163,6 +168,10 @@ static inline void cpuset_print_task_mem
 {
 }
 
+static inline void set_mems_allowed(nodemask_t nodemask)
+{
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff -puN init/main.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2 init/main.c
--- a/init/main.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2
+++ a/init/main.c
@@ -873,7 +873,7 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
-	current->mems_allowed = node_possible_map;
+	set_mems_allowed(node_possible_map);
 
 	cad_pid = task_pid(current);
 
diff -puN kernel/kthread.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2 kernel/kthread.c
--- a/kernel/kthread.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2
+++ a/kernel/kthread.c
@@ -13,6 +13,8 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/cpuset.h>
+
 #include <trace/sched.h>
 
 #define KTHREAD_NICE_LEVEL (-5)
@@ -242,7 +244,7 @@ int kthreadd(void *unused)
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
 	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
 
-	current->mems_allowed = node_possible_map;
+	set_mems_allowed(node_possible_map);
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
 	for (;;) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
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
w1-build-fix.patch

