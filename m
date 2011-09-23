From: akpm@google.com
Subject: + drivers-block-mtip32xx-mtip32xxc-fix-warning.patch added to -mm tree
Date: Fri, 23 Sep 2011 15:43:08 -0700
Message-ID: <201109232243.p8NMh9Xq011768@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:4201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1IWWnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2011 18:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, asamymuthupa@micron.com, jaxboe@fusionio.com, sbradshaw@micron.com


The patch titled
     drivers/block/mtip32xx/mtip32xx.c: fix warning
has been added to the -mm tree.  Its filename is
     drivers-block-mtip32xx-mtip32xxc-fix-warning.patch

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
From: Andrew Morton <akpm@linux-foundation.org>

make_request_fn was changed in linux-next.

Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mtip32xx/mtip32xx.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/block/mtip32xx/mtip32xx.c~drivers-block-mtip32xx-mtip32xxc-fix-warning drivers/block/mtip32xx/mtip32xx.c
--- a/drivers/block/mtip32xx/mtip32xx.c~drivers-block-mtip32xx-mtip32xxc-fix-warning
+++ a/drivers/block/mtip32xx/mtip32xx.c
@@ -2977,7 +2977,7 @@ static const struct block_device_operati
  * return value
  *	0
  */
-static int mtip_make_request(struct request_queue *queue, struct bio *bio)
+static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct driver_data *dd = queue->queuedata;
 	struct scatterlist *sg;
@@ -2988,12 +2988,12 @@ static int mtip_make_request(struct requ
 	if (unlikely(!bio_has_data(bio))) {
 		blk_queue_flush(queue, 0);
 		bio_endio(bio, 0);
-		return 0;
+		return;
 	}
 
 	if (unlikely(atomic_read(&dd->eh_active))) {
 		bio_endio(bio, -EBUSY);
-		return 0;
+		return;
 	}
 
 	sg = mtip_hw_get_scatterlist(dd, &tag);
@@ -3005,7 +3005,7 @@ static int mtip_make_request(struct requ
 				"Maximum number of SGL entries exceeded");
 			bio_io_error(bio);
 			mtip_hw_release_scatterlist(dd, tag);
-			return 0;
+			return;
 		}
 
 		/* Create the scatter list for this bio. */
@@ -3029,8 +3029,6 @@ static int mtip_make_request(struct requ
 	} else {
 		bio_io_error(bio);
 	}
-
-	return 0;
 }
 
 /*
_
Subject: drivers/block/mtip32xx/mtip32xx.c: fix warning

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
drivers-block-mtip32xx-mtip32xxc-fix-warning.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

