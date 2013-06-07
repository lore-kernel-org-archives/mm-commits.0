From: akpm@linux-foundation.org
Subject: + mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
 added to -mm tree
Date: Fri, 07 Jun 2013 13:43:34 -0700
Message-ID: <51b245f6.xPSqbz5srxsm1+SI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab3FGUnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jun 2013 16:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, shli@kernel.org, ngupta@vflare.org, minchan@kernel.org, konrad@darnok.org, hughd@google.com, dan.magenheimer@oracle.com, artem.savkov@gmail.com, akpm@linux-foundation.org

Subject: + mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch added to -mm tree
To: akpm@linux-foundation.org,artem.savkov@gmail.com,dan.magenheimer@oracle.com,hughd@google.com,konrad@darnok.org,minchan@kernel.org,ngupta@vflare.org,shli@kernel.org,sjenning@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 07 Jun 2013 13:43:34 -0700


The patch titled
     Subject: mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix
has been added to the -mm tree.  Its filename is
     mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch

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
Subject: mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix

invert unlikely() test, augment comment, 80-col cleanup

Cc: Artem Savkov <artem.savkov@gmail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   83 +++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff -puN mm/page_io.c~mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix mm/page_io.c
--- a/mm/page_io.c~mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix
+++ a/mm/page_io.c
@@ -81,51 +81,54 @@ void end_swap_bio_read(struct bio *bio,
 				imajor(bio->bi_bdev->bd_inode),
 				iminor(bio->bi_bdev->bd_inode),
 				(unsigned long long)bio->bi_sector);
-	} else {
-		SetPageUptodate(page);
+		goto out;
+	}
+
+	SetPageUptodate(page);
+
+	/*
+	 * There is no guarantee that the page is in swap cache - the software
+	 * suspend code (at least) uses end_swap_bio_read() against a non-
+	 * swapcache page.  So we must check PG_swapcache before proceeding with
+	 * this optimization.
+	 */
+	if (likely(PageSwapCache(page))) {
+		struct swap_info_struct *sis;
+
+		sis = page_swap_info(page);
+		if (sis->flags & SWP_BLKDEV) {
+			/*
+			 * The swap subsystem performs lazy swap slot freeing,
+			 * expecting that the page will be swapped out again.
+			 * So we can avoid an unnecessary write if the page
+			 * isn't redirtied.
+			 * This is good for real swap storage because we can
+			 * reduce unnecessary I/O and enhance wear-leveling
+			 * if an SSD is used as the as swap device.
+			 * But if in-memory swap device (eg zram) is used,
+			 * this causes a duplicated copy between uncompressed
+			 * data in VM-owned memory and compressed data in
+			 * zram-owned memory.  So let's free zram-owned memory
+			 * and make the VM-owned decompressed page *dirty*,
+			 * so the page should be swapped out somewhere again if
+			 * we again wish to reclaim it.
+			 */
+			struct gendisk *disk = sis->bdev->bd_disk;
+			if (disk->fops->swap_slot_free_notify) {
+				swp_entry_t entry;
+				unsigned long offset;
+
+				entry.val = page_private(page);
+				offset = swp_offset(entry);
 
-		/*
-		 * There is no guarantee that the page is in swap cache, so
-		 * we need to check PG_swapcache before proceeding with this
-		 * optimization.
-		 */
-		if (unlikely(PageSwapCache(page))) {
-			struct swap_info_struct *sis;
-
-			sis = page_swap_info(page);
-			if (sis->flags & SWP_BLKDEV) {
-				/*
-				 * The swap subsystem performs lazy swap slot freeing,
-				 * expecting that the page will be swapped out again.
-				 * So we can avoid an unnecessary write if the page
-				 * isn't redirtied.
-				 * This is good for real swap storage because we can
-				 * reduce unnecessary I/O and enhance wear-leveling
-				 * if an SSD is used as the as swap device.
-				 * But if in-memory swap device (eg zram) is used,
-				 * this causes a duplicated copy between uncompressed
-				 * data in VM-owned memory and compressed data in
-				 * zram-owned memory.  So let's free zram-owned memory
-				 * and make the VM-owned decompressed page *dirty*,
-				 * so the page should be swapped out somewhere again if
-				 * we again wish to reclaim it.
-				 */
-				struct gendisk *disk = sis->bdev->bd_disk;
-				if (disk->fops->swap_slot_free_notify) {
-					swp_entry_t entry;
-					unsigned long offset;
-
-					entry.val = page_private(page);
-					offset = swp_offset(entry);
-
-					SetPageDirty(page);
-					disk->fops->swap_slot_free_notify(sis->bdev,
-							offset);
-				}
+				SetPageDirty(page);
+				disk->fops->swap_slot_free_notify(sis->bdev,
+						offset);
 			}
 		}
 	}
 
+out:
 	unlock_page(page);
 	bio_put(bio);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel-fix.patch
drivers-base-cpuc-fix-maxcpus-boot-option-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

