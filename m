From: akpm@linux-foundation.org
Subject: + procfs-disable-per-task-stack-usage-on-nommu.patch added to -mm tree
Date: Thu, 24 Sep 2009 01:30:45 -0700
Message-ID: <200909240830.n8O8UjNb010146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266AbZIXIdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 04:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com, geert@linux-m68k.org, gerg@snapgear.com, lethal@linux-sh.org, michal.simek@petalogix.com, stefani@seibold.net


The patch titled
     procfs: disable per-task stack usage on NOMMU
has been added to the -mm tree.  Its filename is
     procfs-disable-per-task-stack-usage-on-nommu.patch

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
Subject: procfs: disable per-task stack usage on NOMMU
From: Andrew Morton <akpm@linux-foundation.org>

It needs walk_page_range().

Reported-by: Michal Simek <michal.simek@petalogix.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    7 +++++++
 mm/Makefile     |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/proc/array.c~procfs-disable-per-task-stack-usage-on-nommu fs/proc/array.c
--- a/fs/proc/array.c~procfs-disable-per-task-stack-usage-on-nommu
+++ a/fs/proc/array.c
@@ -322,6 +322,8 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
+#ifdef CONFIG_MMU
+
 struct stack_stats {
 	struct vm_area_struct *vma;
 	unsigned long	startpage;
@@ -402,6 +404,11 @@ static inline void task_show_stack_usage
 		mmput(mm);
 	}
 }
+#else
+static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
+{
+}
+#endif		/* CONFIG_MMU */
 
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
diff -puN mm/Makefile~procfs-disable-per-task-stack-usage-on-nommu mm/Makefile
--- a/mm/Makefile~procfs-disable-per-task-stack-usage-on-nommu
+++ a/mm/Makefile
@@ -5,14 +5,14 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o
+			   vmalloc.o pagewalk.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o mmu_context.o \
-			   pagewalk.o $(mmu-y)
+			   $(mmu-y)
 obj-y += init-mm.o
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memcg-improve-resource-counter-scalability.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
elf-clean-up-fill_note_info.patch
drivers-usb-serial-sierrac-fix-config_pm=n-build.patch
procfs-disable-per-task-stack-usage-on-nommu.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
drivers-md-dm-log-userspace-basec-fix-warning.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-linux-credh-fix-build.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-optimize-touch_time-too.patch
fs-improve-remountro-vs-buffercache-coherency.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
hugetlb_file_setup-use-c-not-cpp.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

