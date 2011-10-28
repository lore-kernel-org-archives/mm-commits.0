From: akpm@linux-foundation.org
Subject: [merged] dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 28 Oct 2011 15:10:53 -0700
Message-ID: <201110282210.p9SMArUj000780@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:6997 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab1J1WK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dio-inline-the-complete-submission-path-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dio-inline-the-complete-submission-path-v2-checkpatch-fixes

WARNING: line over 80 characters
#46: FILE: fs/direct-io.c:248:
+static inline struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)

ERROR: inline keyword should sit between storage class and type
#55: FILE: fs/direct-io.c:379:
+static void inline

ERROR: trailing whitespace
#91: FILE: fs/direct-io.c:634:
+static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio, $

ERROR: code indent should use tabs where possible
#111: FILE: fs/direct-io.c:693:
+^I  ^I^I    ^I    struct buffer_head *map_bh)$

WARNING: please, no space before tabs
#111: FILE: fs/direct-io.c:693:
+^I  ^I^I    ^I    struct buffer_head *map_bh)$

WARNING: line over 80 characters
#129: FILE: fs/direct-io.c:845:
+static inline void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end,

ERROR: trailing whitespace
#146: FILE: fs/direct-io.c:1216:
+ * $

ERROR: trailing whitespace
#149: FILE: fs/direct-io.c:1219:
+ * individual fields and will generate much worse code. $

total: 5 errors, 3 warnings, 109 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/dio-inline-the-complete-submission-path-v2.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/direct-io.c~dio-inline-the-complete-submission-path-v2-checkpatch-fixes fs/direct-io.c
--- a/fs/direct-io.c~dio-inline-the-complete-submission-path-v2-checkpatch-fixes
+++ a/fs/direct-io.c
@@ -376,10 +376,8 @@ void dio_end_io(struct bio *bio, int err
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
-static void inline
-dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
-	      struct block_device *bdev,
-	      sector_t first_sector, int nr_vecs)
+static inline void dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
+	      	struct block_device *bdev, sector_t first_sector, int nr_vecs)
 {
 	struct bio *bio;
 
@@ -627,7 +625,7 @@ static int get_more_blocks(struct dio *d
 /*
  * There is no bio.  Make one now.
  */
-static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
+static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
 		       sector_t start_sector, struct buffer_head *map_bh)
 {
 	sector_t sector;
@@ -686,7 +684,7 @@ static inline int dio_bio_add_page(struc
  * dio, and for dropping the refcount which came from that presence.
  */
 static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
-	  		    	    struct buffer_head *map_bh)
+				    struct buffer_head *map_bh)
 {
 	int ret = 0;
 
@@ -1209,10 +1207,10 @@ direct_io_worker(int rw, struct kiocb *i
  * expected that filesystem provide exclusion between new direct I/O
  * and truncates.  For DIO_LOCKING filesystems this is done by i_mutex,
  * but other filesystems need to take care of this on their own.
- * 
+ *
  * NOTE: if you pass "sdio" to anything by pointer make sure that function
  * is always inlined. Otherwise gcc is unable to split the structure into
- * individual fields and will generate much worse code. 
+ * individual fields and will generate much worse code.
  * This is important for the whole file.
  */
 ssize_t
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
sysctl-add-support-for-poll-fix.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

