From: akpm@linux-foundation.org
Subject: + revert-m68k-convert-to-asm-generic-hardirqh.patch added to -mm tree
Date: Wed, 30 Sep 2009 12:34:20 -0700
Message-ID: <200909301934.n8UJYKTV009323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZI3TfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 15:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, hch@lst.de


The patch titled
     revert "m68k: convert to asm-generic/hardirq.h"
has been added to the -mm tree.  Its filename is
     revert-m68k-convert-to-asm-generic-hardirqh.patch

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
Subject: revert "m68k: convert to asm-generic/hardirq.h"
From: Andrew Morton <akpm@linux-foundation.org>

Revert 45d80eea87c9f8292d2d33173d6866c0ec57238a ("m68k: convert to
asm-generic/hardirq.h") - it fails to compile due to an inclusion tangle:

In file included from include/linux/irq.h:12,
                 from include/asm-generic/hardirq.h:6,
                 from /usr/src/devel/arch/m68k/include/asm/hardirq_mm.h:6,
                 from /usr/src/devel/arch/m68k/include/asm/hardirq.h:4,
                 from include/linux/hardirq.h:10,
                 from /usr/src/devel/arch/m68k/include/asm/system_mm.h:69,
                 from /usr/src/devel/arch/m68k/include/asm/system.h:4,
                 from include/linux/list.h:7,
                 from include/linux/preempt.h:11,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/m68k/kernel/asm-offsets.c:14:
include/linux/smp.h:17: error: field 'list' has incomplete type

Cc: Christoph Hellwig <hch@lst.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/hardirq_mm.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN arch/m68k/include/asm/hardirq_mm.h~revert-m68k-convert-to-asm-generic-hardirqh arch/m68k/include/asm/hardirq_mm.h
--- a/arch/m68k/include/asm/hardirq_mm.h~revert-m68k-convert-to-asm-generic-hardirqh
+++ a/arch/m68k/include/asm/hardirq_mm.h
@@ -1,8 +1,16 @@
 #ifndef __M68K_HARDIRQ_H
 #define __M68K_HARDIRQ_H
 
-#define HARDIRQ_BITS	8
+#include <linux/threads.h>
+#include <linux/cache.h>
+
+/* entry.S is sensitive to the offsets of these fields */
+typedef struct {
+	unsigned int __softirq_pending;
+} ____cacheline_aligned irq_cpustat_t;
 
-#include <asm-generic/hardirq.h>
+#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+
+#define HARDIRQ_BITS	8
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-input-inputc-fix-config_pm=n-warning.patch
revert-m68k-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
ar9170-fix-bug-in-iq-auto-calibration-value-calculation.patch
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

