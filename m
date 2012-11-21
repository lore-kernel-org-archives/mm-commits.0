From: akpm@linux-foundation.org
Subject: + mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch added to -mm tree
Date: Wed, 21 Nov 2012 14:04:11 -0800
Message-ID: <20121121220412.6060020007C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41918 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030271Ab2KVTxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Nov 2012 14:53:48 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so430632bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Nov 2012 11:53:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jiang.liu@huawei.com, liuj97@gmail.com


The patch titled
     Subject: mm-introduce-new-field-managed_pages-to-struct-zone-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch

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
Subject: mm-introduce-new-field-managed_pages-to-struct-zone-fix

small comment tweaks

Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 ++++----
 mm/page_alloc.c        |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-introduce-new-field-managed_pages-to-struct-zone-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-introduce-new-field-managed_pages-to-struct-zone-fix
+++ a/include/linux/mmzone.h
@@ -451,7 +451,7 @@ struct zone {
 
 	/*
 	 * spanned_pages is the total pages spanned by the zone, including
-	 * holes, which is calcualted as:
+	 * holes, which is calculated as:
 	 * 	spanned_pages = zone_end_pfn - zone_start_pfn;
 	 *
 	 * present_pages is physical pages existing within the zone, which
@@ -469,9 +469,9 @@ struct zone {
 	 * by page allocator and vm scanner to calculate all kinds of watermarks
 	 * and thresholds.
 	 *
-	 * Lock Rules:
+	 * Locking rules:
 	 *
-	 * zone_start_pfn, spanned_pages are protected by span_seqlock.
+	 * zone_start_pfn and spanned_pages are protected by span_seqlock.
 	 * It is a seqlock because it has to be read outside of zone->lock,
 	 * and it is done in the main allocator path.  But, it is written
 	 * quite infrequently.
@@ -480,7 +480,7 @@ struct zone {
 	 * frequently read in proximity to zone->lock.  It's good to
 	 * give them a chance of being in the same cacheline.
 	 *
-	 * Writing access to present_pages and managed_pages at runtime should
+	 * Write access to present_pages and managed_pages at runtime should
 	 * be protected by lock_memory_hotplug()/unlock_memory_hotplug().
 	 * Any reader who can't tolerant drift of present_pages and
 	 * managed_pages should hold memory hotplug lock to get a stable value.
diff -puN mm/page_alloc.c~mm-introduce-new-field-managed_pages-to-struct-zone-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-new-field-managed_pages-to-struct-zone-fix
+++ a/mm/page_alloc.c
@@ -738,7 +738,7 @@ static void __free_pages_ok(struct page 
  * Read access to zone->managed_pages is safe because it's unsigned long,
  * but we still need to serialize writers. Currently all callers of
  * __free_pages_bootmem() except put_page_bootmem() should only be used
- * at boot time. So for shorter boot time, we have shift the burden to
+ * at boot time. So for shorter boot time, we shift the burden to
  * put_page_bootmem() to serialize writers.
  */
 void __meminit __free_pages_bootmem(struct page *page, unsigned int order)
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
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch
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

