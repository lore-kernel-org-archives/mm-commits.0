From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 31 Mar 2009 11:54:07 -0700
Message-ID: <200903311854.n2VIs7b5031181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980AbZCaSym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 14:54:42 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2VIs7Nf023536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2009 11:54:40 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/topology.h |   14 --------------
 drivers/oprofile/buffer_sync.c  |   17 -----------------
 kernel/kthread.c                |   14 --------------
 3 files changed, 45 deletions(-)

diff -puN arch/x86/include/asm/topology.h~linux-next-git-rejects arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~linux-next-git-rejects
+++ a/arch/x86/include/asm/topology.h
@@ -172,19 +172,9 @@ static inline int early_cpu_to_node(int 
 	return 0;
 }
 
-<<<<<<< HEAD:arch/x86/include/asm/topology.h
-static inline const cpumask_t *cpumask_of_node(int node)
-{
-	return &cpu_online_map;
-}
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return cpu_online_map;
-=======
 static inline const struct cpumask *cpumask_of_node(int node)
 {
 	return cpu_online_mask;
->>>>>>> FETCH_HEAD:arch/x86/include/asm/topology.h
 }
 
 static inline void setup_node_to_cpumask_map(void) { }
@@ -193,10 +183,6 @@ static inline void setup_node_to_cpumask
 
 #include <asm-generic/topology.h>
 
-<<<<<<< HEAD:arch/x86/include/asm/topology.h
-extern cpumask_t cpu_coregroup_map(int cpu);
-=======
->>>>>>> FETCH_HEAD:arch/x86/include/asm/topology.h
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
diff -puN drivers/oprofile/buffer_sync.c~linux-next-git-rejects drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~linux-next-git-rejects
+++ a/drivers/oprofile/buffer_sync.c
@@ -571,23 +571,6 @@ void sync_buffer(int cpu)
 	mutex_unlock(&buffer_mutex);
 }
 
-<<<<<<< HEAD:drivers/oprofile/buffer_sync.c
-int __init buffer_sync_init(void)
-{
-	if (!alloc_cpumask_var(&marked_cpus, GFP_KERNEL))
-		return -ENOMEM;
-
-	cpumask_clear(marked_cpus);
-		return 0;
-}
-
-void buffer_sync_cleanup(void)
-{
-	free_cpumask_var(marked_cpus);
-}
-
-=======
->>>>>>> FETCH_HEAD:drivers/oprofile/buffer_sync.c
 /* The function can be used to add a buffer worth of data directly to
  * the kernel buffer. The buffer is assumed to be a circular buffer.
  * Take the entries from index start and end at index end, wrapping
diff -puN kernel/kthread.c~linux-next-git-rejects kernel/kthread.c
--- a/kernel/kthread.c~linux-next-git-rejects
+++ a/kernel/kthread.c
@@ -101,20 +101,6 @@ static void create_kthread(struct kthrea
 		create->result = ERR_PTR(pid);
 	else
 		wait_for_completion(&create->started);
-<<<<<<< HEAD:kernel/kthread.c
-		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid_ns(pid, &init_pid_ns);
-		read_unlock(&tasklist_lock);
-		/*
-		 * root may have changed our (kthreadd's) priority or CPU mask.
-		 * The kernel thread should not inherit these properties.
-		 */
-		sched_setscheduler(create->result, SCHED_NORMAL, &param);
-		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, cpu_all_mask);
-	}
-=======
->>>>>>> FETCH_HEAD:kernel/kthread.c
 	complete(&create->done);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
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
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
isicom-isicom-kref-leak-fix-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
ubd-stop-defintining-major_nr-checkpatch-fixes.patch
simplify-copy_thread-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
cirrusfb-fix-clock-doubling-fix.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

