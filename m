From: akpm@linux-foundation.org
Subject: + dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:49:44 -0700
Message-ID: <201108302349.p7UNniBH026318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab1H3XuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com


The patch titled
     dio-inline-the-complete-submission-path-v2-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch

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
Subject: dio-inline-the-complete-submission-path-v2-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

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
 
@@ -631,7 +629,7 @@ static int get_more_blocks(struct dio *d
 /*
  * There is no bio.  Make one now.
  */
-static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
+static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
 		       sector_t start_sector, struct buffer_head *map_bh)
 {
 	sector_t sector;
@@ -690,7 +688,7 @@ static inline int dio_bio_add_page(struc
  * dio, and for dropping the refcount which came from that presence.
  */
 static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
-	  		    	    struct buffer_head *map_bh)
+				    struct buffer_head *map_bh)
 {
 	int ret = 0;
 
@@ -1213,10 +1211,10 @@ direct_io_worker(int rw, struct kiocb *i
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

headers_check-is-broken.patch
samples-hidraw-is-busted.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
block-document-blk-plug-fix.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

