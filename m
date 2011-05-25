From: akpm@linux-foundation.org
Subject: [folded] printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 24 May 2011 17:04:27 -0700
Message-ID: <201105250004.p4P04RJY024352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933002Ab1EYAE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch

This patch was dropped because it was folded into printk-allocate-kernel-log-buffer-earlier-v2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: else should follow close brace '}'
#147: FILE: kernel/printk.c:206:
 	}
+	else

total: 1 errors, 0 warnings, 141 lines checked

./patches/printk-allocate-kernel-log-buffer-earlier-v2.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes kernel/printk.c
--- a/kernel/printk.c~printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes
+++ a/kernel/printk.c
@@ -202,9 +202,9 @@ void __init setup_log_buf(int early)
 		if (mem == MEMBLOCK_ERROR)
 			return;
 		new_log_buf = __va(mem);
-	}
-	else
+	} else {
 		new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
+	}
 
 	if (unlikely(!new_log_buf)) {
 		pr_err("log_buf_len: %ld bytes not available\n",
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
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

