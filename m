From: akpm@linux-foundation.org
Subject: [folded] tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:24:04 -0700
Message-ID: <200909212124.n8LLO4dC009264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbZIUVZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:25:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lwoodman@redhat.com, macli@brc.ubc.ca, mel@csn.ul.ie, mingo@elte.hu, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix
has been removed from the -mm tree.  Its filename was
     tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch

This patch was dropped because it was folded into tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/page_alloc.c: In function 'free_pages_bulk':
mm/page_alloc.c:549: error: implicit declaration of function 'trace_mm_page_pcpu_drain'
mm/page_alloc.c: In function '__rmqueue_fallback':
mm/page_alloc.c:879: error: implicit declaration of function 'trace_mm_page_alloc_extfrag'
mm/page_alloc.c: In function '__rmqueue':
mm/page_alloc.c:915: error: implicit declaration of function 'trace_mm_page_alloc_zone_locked'
mm/page_alloc.c: In function 'free_hot_page':
mm/page_alloc.c:1106: error: implicit declaration of function 'trace_mm_page_free_direct'
mm/page_alloc.c: In function '__alloc_pages_nodemask':
mm/page_alloc.c:1951: error: implicit declaration of function 'trace_mm_page_alloc'
mm/page_alloc.c: In function '__pagevec_free':
mm/page_alloc.c:1987: error: implicit declaration of function 'trace_mm_pagevec_free'


Cc: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix mm/page_alloc.c
--- a/mm/page_alloc.c~tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix
+++ a/mm/page_alloc.c
@@ -48,6 +48,7 @@
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
+#include <trace/events/kmem.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch
drivers-mfd-ab3100-corec-fiw-warning-and-powerpc-build-error.patch
mm-make-swap-token-dummies-static-inlines.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
revert-proc-kcore-work-around-a-bug.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp-checkpatch-fixes.patch
mm-zero_page-without-pte_special-mips-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-convert-to-use-arch_gettimeoffset-fix.patch
cpuidle-fix-the-menu-governor-to-boost-io-performance.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
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

