From: akpm@linux-foundation.org
Subject: [folded] memcg-fix-oom-killer-under-memcg-fix.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:17:39 -0700
Message-ID: <200904022317.n32NHd5Q010172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755179AbZDBXWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:22:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger


The patch titled
     memcg-fix-oom-killer-under-memcg-fix
has been removed from the -mm tree.  Its filename was
     memcg-fix-oom-killer-under-memcg-fix.patch

This patch was dropped because it was folded into memcg-fix-oom-killer-under-memcg.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-fix-oom-killer-under-memcg-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/oom_kill.c: In function 'dump_tasks':
mm/oom_kill.c:293: warning: passing argument 2 of 'task_in_mem_cgroup' discards qualifiers from pointer target type

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h     |    2 +-
 include/linux/memcontrol.h |    4 ++--
 kernel/cgroup.c            |    2 +-
 mm/memcontrol.c            |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/cgroup.h~memcg-fix-oom-killer-under-memcg-fix include/linux/cgroup.h
--- a/include/linux/cgroup.h~memcg-fix-oom-killer-under-memcg-fix
+++ a/include/linux/cgroup.h
@@ -501,7 +501,7 @@ struct cgroup_subsys_state *css_get_next
 
 /* Returns true if root is ancestor of cg */
 bool css_is_ancestor(struct cgroup_subsys_state *cg,
-		     struct cgroup_subsys_state *root);
+		     const struct cgroup_subsys_state *root);
 
 /* Get id and depth of css */
 unsigned short css_id(struct cgroup_subsys_state *css);
diff -puN include/linux/memcontrol.h~memcg-fix-oom-killer-under-memcg-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-oom-killer-under-memcg-fix
+++ a/include/linux/memcontrol.h
@@ -66,7 +66,7 @@ extern unsigned long mem_cgroup_isolate_
 					struct mem_cgroup *mem_cont,
 					int active, int file);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
-int task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *mem);
+int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
@@ -192,7 +192,7 @@ static inline int mm_match_cgroup(struct
 }
 
 static inline int task_in_mem_cgroup(struct task_struct *task,
-				     struct mem_cgroup *mem)
+				     const struct mem_cgroup *mem)
 {
 	return 1;
 }
diff -puN kernel/cgroup.c~memcg-fix-oom-killer-under-memcg-fix kernel/cgroup.c
--- a/kernel/cgroup.c~memcg-fix-oom-killer-under-memcg-fix
+++ a/kernel/cgroup.c
@@ -3377,7 +3377,7 @@ unsigned short css_depth(struct cgroup_s
 }
 
 bool css_is_ancestor(struct cgroup_subsys_state *child,
-		    struct cgroup_subsys_state *root)
+		    const struct cgroup_subsys_state *root)
 {
 	struct css_id *child_id = rcu_dereference(child->id);
 	struct css_id *root_id = rcu_dereference(root->id);
diff -puN mm/memcontrol.c~memcg-fix-oom-killer-under-memcg-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-oom-killer-under-memcg-fix
+++ a/mm/memcontrol.c
@@ -486,7 +486,7 @@ void mem_cgroup_move_lists(struct page *
 	mem_cgroup_add_lru_list(page, to);
 }
 
-int task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *mem)
+int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
 {
 	int ret;
 	struct mem_cgroup *curr = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
workqueue-add-to_delayed_work-helper-function.patch
simplify-copy_thread.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
max3100-spi-uart-driver-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
kernel-auditscc-fix-warning.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

