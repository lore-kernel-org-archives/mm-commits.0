From: akpm@linux-foundation.org
Subject: [withdrawn] mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled-fix.patch removed from -mm tree
Date: Wed, 21 Nov 2012 13:30:31 -0800
Message-ID: <20121121213032.41ABD2004A1@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:40000 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2KVTLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Nov 2012 14:11:52 -0500
Received: by mail-wi0-f202.google.com with SMTP id cb5so81932wib.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Nov 2012 11:11:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.magenheimer@oracle.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, rientjes@google.com, semenzato@google.com, sonnyrao@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled-fix

fix early-return retval, tidy a few things

Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sonny Rao <sonnyrao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled-fix
+++ a/mm/vmscan.c
@@ -2209,7 +2209,7 @@ static bool pfmemalloc_watermark_ok(pg_d
  * depleted. kswapd will continue to make progress and wake the processes
  * when the low watermark is reached.
  *
- * Returns true if a fatal signal was delivered during throttling. If this
+ * Returns true if a fatal signal was received during throttling.  If this
  * happens, the page allocator should not consider triggering the OOM killer.
  */
 static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
@@ -2223,24 +2223,24 @@ static bool throttle_direct_reclaim(gfp_
 	 * Kernel threads should not be throttled as they may be indirectly
 	 * responsible for cleaning pages necessary for reclaim to make forward
 	 * progress. kjournald for example may enter direct reclaim while
-	 * committing a transaction where throttling it could forcing other
+	 * committing a transaction where throttling it could force other
 	 * processes to block on log_wait_commit().
 	 */
 	if (current->flags & PF_KTHREAD)
-		goto out;
+		return false;
 
 	/*
 	 * If a fatal signal is pending, this process should not throttle.
 	 * It should return quickly so it can exit and free its memory
 	 */
 	if (fatal_signal_pending(current))
-		goto out;
+		return true;
 
 	/* Check if the pfmemalloc reserves are ok */
 	first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
 	pgdat = zone->zone_pgdat;
 	if (pfmemalloc_watermark_ok(pgdat))
-		goto out;
+		return false;
 
 	/* Account for the throttling */
 	count_vm_event(PGSCAN_DIRECT_THROTTLE);
@@ -2255,21 +2255,14 @@ static bool throttle_direct_reclaim(gfp_
 	 */
 	if (!(gfp_mask & __GFP_FS)) {
 		wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
-			pfmemalloc_watermark_ok(pgdat), HZ);
-
-		goto check_pending;
+					pfmemalloc_watermark_ok(pgdat), HZ);
+	} else {
+		/* Throttle until kswapd wakes the process */
+		wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
+				    pfmemalloc_watermark_ok(pgdat));
 	}
 
-	/* Throttle until kswapd wakes the process */
-	wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
-		pfmemalloc_watermark_ok(pgdat));
-
-check_pending:
-	if (fatal_signal_pending(current))
-		return true;
-
-out:
-	return false;
+	return fatal_signal_pending(current);
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
@@ -2292,7 +2285,7 @@ unsigned long try_to_free_pages(struct z
 	};
 
 	/*
-	 * Do not enter reclaim if fatal signal was delivered while throttled.
+	 * Do not enter reclaim if a fatal signal was received while throttled.
 	 * 1 is returned so that the page allocator does not OOM kill at this
 	 * point.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-export-a-function-to-get-vm-committed-memory.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes.patch
irq-tsk-comm-is-an-array.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

