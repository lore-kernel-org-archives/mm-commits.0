From: akpm@linux-foundation.org
Subject: + zram-support-req_discard-v4-fix.patch added to -mm tree
Date: Thu, 13 Mar 2014 13:40:42 -0700
Message-ID: <532217ca.sicfyxqhSlx5O7cg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbaCMUkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 16:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org

Subject: + zram-support-req_discard-v4-fix.patch added to -mm tree
To: akpm@linux-foundation.org,iamjoonsoo.kim@lge.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 13:40:42 -0700


The patch titled
     Subject: zram-support-req_discard-v4-fix
has been added to the -mm tree.  Its filename is
     zram-support-req_discard-v4-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-support-req_discard-v4-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-support-req_discard-v4-fix.patch

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
Subject: zram-support-req_discard-v4-fix

tweak comments

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-support-req_discard-v4-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-support-req_discard-v4-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -552,8 +552,8 @@ static int zram_bvec_rw(struct zram *zra
 
 /*
  * zram_bio_discard - handler on discard request
- * @index: physical block index by PAGE_SIZE unit
- * @offset: offset within physical block
+ * @index: physical block index in PAGE_SIZE units
+ * @offset: byte offset within physical block
  */
 static void zram_bio_discard(struct zram *zram, u32 index,
 			     int offset, struct bio *bio)
@@ -561,14 +561,14 @@ static void zram_bio_discard(struct zram
 	size_t n = bio->bi_iter.bi_size;
 
 	/*
-	 * zram manages data by physical block size unit. Because logical block
+	 * zram manages data in physical block size units. Because logical block
 	 * size isn't identical with physical block size on some arch, we
-	 * could get discard request pointing to specific offset within certain
-	 * physical block. Although we can handle this request by reading that
-	 * physiclal block and decompressing and partially zeroing and
-	 * re-compressing and then re-storing it, it isn't reasonable because
-	 * our intention of handling discard request is to save memory.
-	 * So skipping this logical block is approriate here.
+	 * could get a discard request pointing to a specific offset within a
+	 * certain physical block.  Although we can handle this request by
+	 * reading that physiclal block and decompressing and partially zeroing
+	 * and re-compressing and then re-storing it, this isn't reasonable
+	 * because our intent with a discard request is to save memory.  So
+	 * skipping this logical block is appropriate here.
 	 */
 	if (offset) {
 		if (n < offset)
@@ -580,9 +580,8 @@ static void zram_bio_discard(struct zram
 
 	while (n >= PAGE_SIZE) {
 		/*
-		 * discard request can be too large so that the zram can
-		 * be stucked for a long time if we handle the request
-		 * at once. So handle the request by PAGE_SIZE unit at a time.
+		 * Discard request can be large so the lock hold times could be
+		 * lengthy.  So take the lock once per page.
 		 */
 		write_lock(&zram->meta->tb_lock);
 		zram_free_page(zram, index);
@@ -907,9 +906,10 @@ static int create_device(struct zram *zr
 	/*
 	 * zram_bio_discard() will clear all logical blocks if logical block
 	 * size is identical with physical block size(PAGE_SIZE). But if it is
-	 * different, we will skip to discard some parts of logical blocks in
-	 * whole request range which isn't aligned to physical block size.
-	 * So we can't ensure that some discarded logical block is zeroed.
+	 * different, we will skip discarding some parts of logical blocks in
+	 * the part of the request range which isn't aligned to physical block
+	 * size.  So we can't ensure that all discarded logical blocks are
+	 * zeroed.
 	 */
 	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
 		zram->disk->queue->limits.discard_zeroes_data = 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges-fix.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
include-linux-fsh-fix-locks_verify_locked-definition.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

