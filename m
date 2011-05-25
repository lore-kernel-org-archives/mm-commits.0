From: akpm@linux-foundation.org
Subject: [folded] lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 17:05:56 -0700
Message-ID: <201105250005.p4P05uUL024449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932271Ab1EYAGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:06:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, imirkin@alum.mit.edu, lars@linbit.com, mm-commits@vger.kernel.org


The patch titled
     lru_cache-use-correct-type-in-sizeof-for-allocation-fix
has been removed from the -mm tree.  Its filename was
     lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch

This patch was dropped because it was folded into lru_cache-use-correct-type-in-sizeof-for-allocation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lru_cache-use-correct-type-in-sizeof-for-allocation-fix
From: Andrew Morton <akpm@linux-foundation.org>

use kcalloc()

Cc: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Lars Ellenberg <lars@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lru_cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/lru_cache.c~lru_cache-use-correct-type-in-sizeof-for-allocation-fix lib/lru_cache.c
--- a/lib/lru_cache.c~lru_cache-use-correct-type-in-sizeof-for-allocation-fix
+++ a/lib/lru_cache.c
@@ -84,7 +84,7 @@ struct lru_cache *lc_create(const char *
 	if (e_count > LC_MAX_ACTIVE)
 		return NULL;
 
-	slot = kzalloc(e_count * sizeof(struct hlist_head), GFP_KERNEL);
+	slot = kcalloc(e_count, sizeof(struct hlist_head), GFP_KERNEL);
 	if (!slot)
 		goto out_fail;
 	element = kzalloc(e_count * sizeof(struct lc_element *), GFP_KERNEL);
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
drivers-leds-leds-lm3530c-add-regulator.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

