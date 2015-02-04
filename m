From: akpm@linux-foundation.org
Subject: + kernelh-remove-ancient-__function__-hack-fix.patch added to -mm tree
Date: Wed, 04 Feb 2015 14:35:45 -0800
Message-ID: <54d29ec1.58Ygo9WyCmp2wc9V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161137AbbBDWfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:35:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, lenb@kernel.org, linux@rasmusvillemoes.dk, mina86@mina86.com, rjw@rjwysocki.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kernelh-remove-ancient-__function__-hack-fix
has been added to the -mm tree.  Its filename is
     kernelh-remove-ancient-__function__-hack-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-remove-ancient-__function__-hack-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-remove-ancient-__function__-hack-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernelh-remove-ancient-__function__-hack-fix

convert remaining __FUNCTION__ references

Cc: Joe Perches <joe@perches.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hpet.c                       |    2 +-
 arch/x86/kernel/rtc.c                        |    4 ++--
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |    2 +-
 drivers/acpi/acpica/utdebug.c                |    4 ++--
 drivers/block/xen-blkfront.c                 |    2 +-
 include/acpi/acoutput.h                      |    6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/hpet.c~kernelh-remove-ancient-__function__-hack-fix arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~kernelh-remove-ancient-__function__-hack-fix
+++ a/arch/x86/kernel/hpet.c
@@ -168,7 +168,7 @@ static void _hpet_print_config(const cha
 #define hpet_print_config()					\
 do {								\
 	if (hpet_verbose)					\
-		_hpet_print_config(__FUNCTION__, __LINE__);	\
+		_hpet_print_config(__func__, __LINE__);	\
 } while (0)
 
 /*
diff -puN arch/x86/kernel/rtc.c~kernelh-remove-ancient-__function__-hack-fix arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~kernelh-remove-ancient-__function__-hack-fix
+++ a/arch/x86/kernel/rtc.c
@@ -49,11 +49,11 @@ int mach_set_rtc_mmss(const struct times
 		retval = set_rtc_time(&tm);
 		if (retval)
 			printk(KERN_ERR "%s: RTC write failed with error %d\n",
-			       __FUNCTION__, retval);
+			       __func__, retval);
 	} else {
 		printk(KERN_ERR
 		       "%s: Invalid RTC value: write of %lx to RTC failed\n",
-			__FUNCTION__, nowtime);
+			__func__, nowtime);
 		retval = -EINVAL;
 	}
 	return retval;
diff -puN arch/x86/platform/intel-mid/intel_mid_vrtc.c~kernelh-remove-ancient-__function__-hack-fix arch/x86/platform/intel-mid/intel_mid_vrtc.c
--- a/arch/x86/platform/intel-mid/intel_mid_vrtc.c~kernelh-remove-ancient-__function__-hack-fix
+++ a/arch/x86/platform/intel-mid/intel_mid_vrtc.c
@@ -110,7 +110,7 @@ int vrtc_set_mmss(const struct timespec
 		spin_unlock_irqrestore(&rtc_lock, flags);
 	} else {
 		pr_err("%s: Invalid vRTC value: write of %lx to vRTC failed\n",
-			__FUNCTION__, now->tv_sec);
+			__func__, now->tv_sec);
 		retval = -EINVAL;
 	}
 	return retval;
diff -puN drivers/acpi/acpica/utdebug.c~kernelh-remove-ancient-__function__-hack-fix drivers/acpi/acpica/utdebug.c
--- a/drivers/acpi/acpica/utdebug.c~kernelh-remove-ancient-__function__-hack-fix
+++ a/drivers/acpi/acpica/utdebug.c
@@ -111,8 +111,8 @@ void acpi_ut_track_stack_ptr(void)
  * RETURN:      Updated pointer to the function name
  *
  * DESCRIPTION: Remove the "Acpi" prefix from the function name, if present.
- *              This allows compiler macros such as __FUNCTION__ to be used
- *              with no change to the debug output.
+ *              This allows compiler macros such as __func__ to be used with no
+ *              change to the debug output.
  *
  ******************************************************************************/
 
diff -puN drivers/block/xen-blkfront.c~kernelh-remove-ancient-__function__-hack-fix drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c~kernelh-remove-ancient-__function__-hack-fix
+++ a/drivers/block/xen-blkfront.c
@@ -1391,7 +1391,7 @@ static int blkfront_probe(struct xenbus_
 			if (major != XENVBD_MAJOR) {
 				printk(KERN_INFO
 						"%s: HVM does not support vbd %d as xen block device\n",
-						__FUNCTION__, vdevice);
+						__func__, vdevice);
 				return -ENODEV;
 			}
 		}
diff -puN include/acpi/acoutput.h~kernelh-remove-ancient-__function__-hack-fix include/acpi/acoutput.h
--- a/include/acpi/acoutput.h~kernelh-remove-ancient-__function__-hack-fix
+++ a/include/acpi/acoutput.h
@@ -240,7 +240,7 @@
 /*
  * If ACPI_GET_FUNCTION_NAME was not defined in the compiler-dependent header,
  * define it now. This is the case where there the compiler does not support
- * a __FUNCTION__ macro or equivalent.
+ * a __func__ macro or equivalent.
  */
 #ifndef ACPI_GET_FUNCTION_NAME
 #define ACPI_GET_FUNCTION_NAME          _acpi_function_name
@@ -249,12 +249,12 @@
  * The Name parameter should be the procedure name as a quoted string.
  * The function name is also used by the function exit macros below.
  * Note: (const char) is used to be compatible with the debug interfaces
- * and macros such as __FUNCTION__.
+ * and macros such as __func__.
  */
 #define ACPI_FUNCTION_NAME(name)        static const char _acpi_function_name[] = #name;
 
 #else
-/* Compiler supports __FUNCTION__ (or equivalent) -- Ignore this macro */
+/* Compiler supports __func__ (or equivalent) -- Ignore this macro */
 
 #define ACPI_FUNCTION_NAME(name)
 #endif				/* ACPI_GET_FUNCTION_NAME */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-rework-reset-and-destroy-path-fix.patch
zram-rework-reset-and-destroy-path-fix-2-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes.patch
kernelh-remove-ancient-__function__-hack-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
module_device_table-fix-some-callsites.patch
kasan-enable-instrumentation-of-global-variables-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
samples-seccomp-improve-label-helper-fix.patch
linux-next.patch
linux-next-rejects.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

