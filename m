From: akpm@linux-foundation.org
Subject: [folded] printk-allocate-kernel-log-buffer-earlier-v2-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 17:04:29 -0700
Message-ID: <201105250004.p4P04TZL024355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932939Ab1EYAFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, steiner@sgi.com, tglx@linutronix.de, travis@sgi.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     printk-allocate-kernel-log-buffer-earlier-v2-fix
has been removed from the -mm tree.  Its filename was
     printk-allocate-kernel-log-buffer-earlier-v2-fix.patch

This patch was dropped because it was folded into printk-allocate-kernel-log-buffer-earlier-v2.patch

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
 1 file changed, 5 insertions(+), 2 deletions(-)

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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mmu_gather-rework.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
nommu-add-page-alignment-to-mmap.patch
alpha-hook-up-gpiolib-support.patch
cris-convert-old-cpumask-api-into-new-one.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch
printk-allocate-kernel-log-buffer-earlier-v2.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

