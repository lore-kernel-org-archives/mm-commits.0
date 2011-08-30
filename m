From: akpm@linux-foundation.org
Subject: + dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:47:24 -0700
Message-ID: <201108302347.p7UNlPiJ026199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab1H3Xr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:47:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com


The patch titled
     dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch

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
Subject: dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#85: FILE: fs/direct-io.c:71:
+^Iint pages_in_io;^I^I/* approximate total IO pages */^I$

ERROR: trailing whitespace
#95: FILE: fs/direct-io.c:81:
+^Idio_submit_t *submit_io;^I/* IO submition function */^I$

ERROR: trailing whitespace
#103: FILE: fs/direct-io.c:87:
+^I$

ERROR: trailing whitespace
#162: FILE: fs/direct-io.c:143:
+^Istruct page *pages[DIO_PAGES];^I/* page buffer */^I$

WARNING: line over 80 characters
#171: FILE: fs/direct-io.c:193:
+static inline unsigned dio_pages_present(struct dio *dio, struct dio_submit *sdio)

ERROR: trailing whitespace
#394: FILE: fs/direct-io.c:630:
+static int dio_new_bio(struct dio *dio, struct dio_submit *sdio, $

ERROR: space prohibited after that open parenthesis '('
#525: FILE: fs/direct-io.c:773:
+	if (	(sdio->cur_page == page) &&

ERROR: trailing whitespace
#612: FILE: fs/direct-io.c:866:
+^Iif (submit_page_section(dio, sdio, page, 0, this_chunk_bytes, $

WARNING: line over 80 characters
#696: FILE: fs/direct-io.c:954:
+					sdio->next_block_for_io += dio_remainder;

WARNING: line over 80 characters
#748: FILE: fs/direct-io.c:1010:
+			ret = submit_page_section(dio, sdio, page, offset_in_page,

WARNING: line over 80 characters
#765: FILE: fs/direct-io.c:1022:
+			BUG_ON(sdio->block_in_file > sdio->final_block_in_request);

total: 7 errors, 4 warnings, 817 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/direct-io.c~dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes fs/direct-io.c
--- a/fs/direct-io.c~dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes
+++ a/fs/direct-io.c
@@ -68,7 +68,7 @@ struct dio_submit {
 	unsigned start_zero_done;	/* flag: sub-blocksize zeroing has
 					   been performed at the start of a
 					   write */
-	int pages_in_io;		/* approximate total IO pages */	
+	int pages_in_io;		/* approximate total IO pages */
 	size_t	size;			/* total request size (doesn't change)*/
 	sector_t block_in_file;		/* Current offset into the underlying
 					   file in dio_block units. */
@@ -78,13 +78,13 @@ struct dio_submit {
 	int boundary;			/* prev block is at a boundary */
 	int reap_counter;		/* rate limit reaping */
 	get_block_t *get_block;		/* block mapping function */
-	dio_submit_t *submit_io;	/* IO submition function */	
+	dio_submit_t *submit_io;	/* IO submition function */
 
 	loff_t logical_offset_in_bio;	/* current first logical block in bio */
 	sector_t final_block_in_bio;	/* current final block in bio + 1 */
 	sector_t next_block_for_io;	/* next block to be put under IO,
 					   in dio_blocks units */
-	
+
 	/*
 	 * Deferred addition of a page to the dio.  These variables are
 	 * private to dio_send_cur_page(), submit_page_section() and
@@ -140,7 +140,7 @@ struct dio {
 	 * allocation time.  Don't add new fields after pages[] unless you
 	 * wish that they not be zeroed.
 	 */
-	struct page *pages[DIO_PAGES];	/* page buffer */	
+	struct page *pages[DIO_PAGES];	/* page buffer */
 };
 
 static void __inode_dio_wait(struct inode *inode)
@@ -627,7 +627,7 @@ static int get_more_blocks(struct dio *d
 /*
  * There is no bio.  Make one now.
  */
-static int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
+static int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
 		       sector_t start_sector)
 {
 	sector_t sector;
@@ -770,7 +770,7 @@ submit_page_section(struct dio *dio, str
 	/*
 	 * Can we just grow the current page's presence in the dio?
 	 */
-	if (	(sdio->cur_page == page) &&
+	if ((sdio->cur_page == page) &&
 		(sdio->cur_page_offset + sdio->cur_page_len == offset) &&
 		(sdio->cur_page_block +
 			(sdio->cur_page_len >> sdio->blkbits) == blocknr)) {
@@ -863,7 +863,7 @@ static void dio_zero_block(struct dio *d
 	this_chunk_bytes = this_chunk_blocks << sdio->blkbits;
 
 	page = ZERO_PAGE(0);
-	if (submit_page_section(dio, sdio, page, 0, this_chunk_bytes, 
+	if (submit_page_section(dio, sdio, page, 0, this_chunk_bytes,
 				sdio->next_block_for_io))
 		return;
 
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
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

