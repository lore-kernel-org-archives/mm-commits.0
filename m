From: akpm@linux-foundation.org
Subject: + printk-allocate-kernel-log-buffer-earlier-v2-fix.patch added to -mm tree
Date: Wed, 27 Apr 2011 15:52:45 -0700
Message-ID: <201104272328.p3RNSmEi010654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291Ab1D0Xee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Apr 2011 19:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, steiner@sgi.com, tglx@linutronix.de, travis@sgi.com, yhlu.kernel@gmail.com


The patch titled
     printk-allocate-kernel-log-buffer-earlier-v2-fix
has been added to the -mm tree.  Its filename is
     printk-allocate-kernel-log-buffer-earlier-v2-fix.patch

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
Subject: printk-allocate-kernel-log-buffer-earlier-v2-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix CONFIG_PRINTK=n build

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    7 +++++--
 printk.c               |    0 
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/setup.c~printk-allocate-kernel-log-buffer-earlier-v2-fix arch/x86/kernel/setup.c
diff -puN include/linux/printk.h~printk-allocate-kernel-log-buffer-earlier-v2-fix include/linux/printk.h
--- a/include/linux/printk.h~printk-allocate-kernel-log-buffer-earlier-v2-fix
+++ a/include/linux/printk.h
@@ -91,8 +91,6 @@ int no_printk(const char *fmt, ...)
 extern asmlinkage __attribute__ ((format (printf, 1, 2)))
 void early_printk(const char *fmt, ...);
 
-void __init setup_log_buf(int early);
-
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
 
@@ -117,6 +115,7 @@ extern int dmesg_restrict;
 extern int kptr_restrict;
 
 void log_buf_kexec_setup(void);
+void __init setup_log_buf(int early);
 #else
 static inline __attribute__ ((format (printf, 1, 0)))
 int vprintk(const char *s, va_list args)
@@ -141,6 +140,10 @@ static inline bool printk_timed_ratelimi
 static inline void log_buf_kexec_setup(void)
 {
 }
+
+static inline void setup_log_buf(int early)
+{
+}
 #endif
 
 extern void dump_stack(void) __cold;
diff -puN init/main.c~printk-allocate-kernel-log-buffer-earlier-v2-fix init/main.c
diff -puN kernel/printk.c~printk-allocate-kernel-log-buffer-earlier-v2-fix kernel/printk.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vfs-avoid-large-kmallocs-for-the-fdtable.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-usb-misc-usbtestc-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

