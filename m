From: akpm@linux-foundation.org
Subject: + rwsem-fix-rwsem_is_locked-bugs-fix.patch added to -mm tree
Date: Thu, 15 Oct 2009 16:46:20 -0700
Message-ID: <200910152346.n9FNkKvL010288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935606AbZJOXrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 19:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, amwang@redhat.com, behlendorf1@llnl.gov, bwoodard@llnl.gov, dhowells@redhat.com


The patch titled
     rwsem-fix-rwsem_is_locked-bugs-fix
has been added to the -mm tree.  Its filename is
     rwsem-fix-rwsem_is_locked-bugs-fix.patch

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
Subject: rwsem-fix-rwsem_is_locked-bugs-fix
From: Andrew Morton <akpm@linux-foundation.org>

simplify

Cc: Amerigo Wang <amwang@redhat.com>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: David Howells <dhowells@redhat.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/rwsem-spinlock.h~rwsem-fix-rwsem_is_locked-bugs-fix include/linux/rwsem-spinlock.h
--- a/include/linux/rwsem-spinlock.h~rwsem-fix-rwsem_is_locked-bugs-fix
+++ a/include/linux/rwsem-spinlock.h
@@ -68,9 +68,7 @@ extern int __down_write_trylock(struct r
 extern void __up_read(struct rw_semaphore *sem);
 extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
-extern int __rwsem_is_locked(struct rw_semaphore *sem);
-
-#define rwsem_is_locked(sem) __rwsem_is_locked(sem)
+extern int rwsem_is_locked(struct rw_semaphore *sem);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff -puN lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bugs-fix lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bugs-fix
+++ a/lib/rwsem-spinlock.c
@@ -17,7 +17,7 @@ struct rwsem_waiter {
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
 };
 
-int __rwsem_is_locked(struct rw_semaphore *sem)
+int rwsem_is_locked(struct rw_semaphore *sem)
 {
 	int ret = 1;
 	unsigned long flags;
@@ -28,7 +28,7 @@ int __rwsem_is_locked(struct rw_semaphor
 	}
 	return ret;
 }
-EXPORT_SYMBOL(__rwsem_is_locked);
+EXPORT_SYMBOL(rwsem_is_locked);
 
 /*
  * initialise the semaphore
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
8250_pci-add-ibm-saturn-serial-card-fix.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
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

