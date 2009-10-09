From: akpm@linux-foundation.org
Subject: + errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch added to -mm tree
Date: Fri, 09 Oct 2009 00:31:55 -0700
Message-ID: <200910090754.n997shQ0011086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbZJIHz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 03:55:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ext-phil.2.carmody@nokia.com


The patch titled
     errh-add-helper-function-to-simplify-pointer-error-checking-fix
has been added to the -mm tree.  Its filename is
     errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch

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
Subject: errh-add-helper-function-to-simplify-pointer-error-checking-fix
From: Andrew Morton <akpm@linux-foundation.org>

/usr/src/devel/arch/x86/Makefile:82: stack protector enabled but no compiler support
/usr/src/devel/arch/x86/Makefile:82: stack protector enabled but no compiler support
In file included from crypto/api.c:18:
include/linux/err.h: In function 'IS_ERR_OR_NULL':
include/linux/err.h:39: error: 'NULL' undeclared (first use in this function)
include/linux/err.h:39: error: (Each undeclared identifier is reported only once
include/linux/err.h:39: error: for each function it appears in.)

Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/err.h~errh-add-helper-function-to-simplify-pointer-error-checking-fix include/linux/err.h
--- a/include/linux/err.h~errh-add-helper-function-to-simplify-pointer-error-checking-fix
+++ a/include/linux/err.h
@@ -36,7 +36,7 @@ static inline long IS_ERR(const void *pt
 
 static inline long IS_ERR_OR_NULL(const void *ptr)
 {
-	return (ptr == NULL) || IS_ERR_VALUE((unsigned long)ptr);
+	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings.patch
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
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
munmap-dont-check-sysctl_max_mapcount-fix.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
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

