From: akpm@linux-foundation.org
Subject: [merged] alpha-move-thread_size-definition-outside-ifndef-assembly.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:29 -0800
Message-ID: <200911131926.nADJQTww028357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932184AbZKMT0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:26:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geofft@ksplice.com, ink@jurassic.park.msu.ru, rth@twiddle.net, sam@ravnborg.org, tabbott@ksplice.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     alpha: move THREAD_SIZE definition outside #ifndef ASSEMBLY
has been removed from the -mm tree.  Its filename was
     alpha-move-thread_size-definition-outside-ifndef-assembly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: move THREAD_SIZE definition outside #ifndef ASSEMBLY
From: Andrew Morton <akpm@linux-foundation.org>

arch/alpha/kernel/vmlinux.lds.S uses it:

arch/alpha/kernel/vmlinux.lds:241: undefined symbol `THREAD_SIZE' referenced in expression

Seems to have been caused by

commit 9d93f00580243cc059510d9d6ac4d2f5e97e5b83
Author:     Geoffrey Thomas <geofft@ksplice.com>
AuthorDate: Thu Sep 24 10:36:26 2009 -0400
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Thu Sep 24 17:16:22 2009 -0700

    alpha: Clean up linker script using new linker script macros.
    
    Note that .data.page_aligned and .data.cacheline_aligned are now after
    _data; it was probably a bug that they were before it.
    
    Also, some explicit ALIGN(8)'s between various initcall sections were
    removed; this should be harmless as the implicit alignment of
    initcall_t was already 8.
    


Cc: Geoffrey Thomas <geofft@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/alpha/include/asm/thread_info.h~alpha-move-thread_size-definition-outside-ifndef-assembly arch/alpha/include/asm/thread_info.h
--- a/arch/alpha/include/asm/thread_info.h~alpha-move-thread_size-definition-outside-ifndef-assembly
+++ a/arch/alpha/include/asm/thread_info.h
@@ -50,12 +50,12 @@ struct thread_info {
 register struct thread_info *__current_thread_info __asm__("$8");
 #define current_thread_info()  __current_thread_info
 
+#endif /* __ASSEMBLY__ */
+
 /* Thread information allocation.  */
 #define THREAD_SIZE_ORDER 1
 #define THREAD_SIZE (2*PAGE_SIZE)
 
-#endif /* __ASSEMBLY__ */
-
 #define PREEMPT_ACTIVE		0x40000000
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops-fix.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
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

