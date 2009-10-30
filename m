From: akpm@linux-foundation.org
Subject: + alpha-move-thread_size-definition-outside-ifndef-assembly.patch added to -mm tree
Date: Fri, 30 Oct 2009 15:13:32 -0700
Message-ID: <200910302236.n9UMao6j000865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932140AbZJ3WhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 18:37:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, geofft@ksplice.com, ink@jurassic.park.msu.ru, rth@twiddle.net, sam@ravnborg.org, tabbott@ksplice.com, torvalds@linux-foundation.org


The patch titled
     alpha: move THREAD_SIZE definition outside #ifndef ASSEMBLY
has been added to the -mm tree.  Its filename is
     alpha-move-thread_size-definition-outside-ifndef-assembly.patch

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

 arch/alpha/include/asm/thread_info.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
alpha-move-thread_size-definition-outside-ifndef-assembly.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-mtd-maps-gpio-addr-flashc-needs-config_generic_gpio.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
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

