From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 18 Jan 2013 13:35:15 -0800
Message-ID: <20130118213517.504705A42EC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:40393 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3ARVfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Jan 2013 16:35:20 -0500
Received: by mail-ob0-f202.google.com with SMTP id wd20so1026514obb.5
        for <mm-commits@vger.kernel.org>; Fri, 18 Jan 2013 13:35:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/cio/chsc.c |   29 ----------
 fs/xfs/xfs_buf_item.c   |  106 --------------------------------------
 2 files changed, 135 deletions(-)

diff -puN drivers/s390/cio/chsc.c~linux-next-git-rejects drivers/s390/cio/chsc.c
--- a/drivers/s390/cio/chsc.c~linux-next-git-rejects
+++ a/drivers/s390/cio/chsc.c
@@ -492,32 +492,7 @@ static void chsc_process_event_informati
 		if (chsc(sei))
 			break;
 
-<<<<<<< HEAD
-		if (sei->response.code == 0x0001) {
-			CIO_CRW_EVENT(2, "chsc: sei successful\n");
-
-			/* Check if we might have lost some information. */
-			if (sei->u.nt0_area.flags & 0x40) {
-				CIO_CRW_EVENT(2, "chsc: event overflow\n");
-				css_schedule_eval_all();
-			}
-
-			switch (sei->nt) {
-			case 0:
-				chsc_process_sei_nt0(&sei->u.nt0_area);
-				break;
-			case 2:
-				chsc_process_sei_nt2(&sei->u.nt2_area);
-				break;
-			default:
-				CIO_CRW_EVENT(2, "chsc: unhandled nt=%d\n",
-					      sei->nt);
-				break;
-			}
-		} else {
-=======
 		if (sei->response.code != 0x0001) {
->>>>>>> linux-next/akpm-base
 			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x)\n",
 				      sei->response.code);
 			break;
@@ -559,11 +534,7 @@ static void chsc_process_crw(struct crw 
 		      crw0->erc, crw0->rsid);
 
 	CIO_TRACE_EVENT(2, "prcss");
-<<<<<<< HEAD
-	__chsc_process_crw(sei, CHSC_SEI_NT0 | CHSC_SEI_NT2);
-=======
 	chsc_process_event_information(sei, CHSC_SEI_NT0 | CHSC_SEI_NT2);
->>>>>>> linux-next/akpm-base
 }
 
 void chsc_chp_online(struct chp_id chpid)
diff -puN fs/xfs/xfs_buf_item.c~linux-next-git-rejects fs/xfs/xfs_buf_item.c
--- a/fs/xfs/xfs_buf_item.c~linux-next-git-rejects
+++ a/fs/xfs/xfs_buf_item.c
@@ -37,112 +37,6 @@ static inline struct xfs_buf_log_item *B
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
-<<<<<<< HEAD
-
-#ifdef XFS_TRANS_DEBUG
-/*
- * This function uses an alternate strategy for tracking the bytes
- * that the user requests to be logged.  This can then be used
- * in conjunction with the bli_orig array in the buf log item to
- * catch bugs in our callers' code.
- *
- * We also double check the bits set in xfs_buf_item_log using a
- * simple algorithm to check that every byte is accounted for.
- */
-STATIC void
-xfs_buf_item_log_debug(
-	xfs_buf_log_item_t	*bip,
-	uint			first,
-	uint			last)
-{
-	uint	x;
-	uint	byte;
-	uint	nbytes;
-	uint	chunk_num;
-	uint	word_num;
-	uint	bit_num;
-	uint	bit_set;
-	uint	*wordp;
-
-	ASSERT(bip->bli_logged != NULL);
-	byte = first;
-	nbytes = last - first + 1;
-	bfset(bip->bli_logged, first, nbytes);
-	for (x = 0; x < nbytes; x++) {
-		chunk_num = byte >> XFS_BLF_SHIFT;
-		word_num = chunk_num >> BIT_TO_WORD_SHIFT;
-		bit_num = chunk_num & (NBWORD - 1);
-		wordp = &(bip->__bli_format.blf_data_map[word_num]);
-		bit_set = *wordp & (1 << bit_num);
-		ASSERT(bit_set);
-		byte++;
-	}
-}
-
-/*
- * This function is called when we flush something into a buffer without
- * logging it.  This happens for things like inodes which are logged
- * separately from the buffer.
- */
-void
-xfs_buf_item_flush_log_debug(
-	xfs_buf_t	*bp,
-	uint		first,
-	uint		last)
-{
-	xfs_buf_log_item_t	*bip = bp->b_fspriv;
-	uint			nbytes;
-
-	if (bip == NULL || (bip->bli_item.li_type != XFS_LI_BUF))
-		return;
-
-	ASSERT(bip->bli_logged != NULL);
-	nbytes = last - first + 1;
-	bfset(bip->bli_logged, first, nbytes);
-}
-
-/*
- * This function is called to verify that our callers have logged
- * all the bytes that they changed.
- *
- * It does this by comparing the original copy of the buffer stored in
- * the buf log item's bli_orig array to the current copy of the buffer
- * and ensuring that all bytes which mismatch are set in the bli_logged
- * array of the buf log item.
- */
-STATIC void
-xfs_buf_item_log_check(
-	xfs_buf_log_item_t	*bip)
-{
-	char		*orig;
-	char		*buffer;
-	int		x;
-	xfs_buf_t	*bp;
-
-	ASSERT(bip->bli_orig != NULL);
-	ASSERT(bip->bli_logged != NULL);
-
-	bp = bip->bli_buf;
-	ASSERT(bp->b_length > 0);
-	ASSERT(bp->b_addr != NULL);
-	orig = bip->bli_orig;
-	buffer = bp->b_addr;
-	for (x = 0; x < BBTOB(bp->b_length); x++) {
-		if (orig[x] != buffer[x] && !btst(bip->bli_logged, x)) {
-			xfs_emerg(bp->b_mount,
-				"%s: bip %x buffer %x orig %x index %d",
-				__func__, bip, bp, orig, x);
-			ASSERT(0);
-		}
-	}
-}
-#else
-#define		xfs_buf_item_log_debug(x,y,z)
-#define		xfs_buf_item_log_check(x)
-#endif
-
-=======
->>>>>>> linux-next/akpm-base
 STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
aio-smoosh-struct-kiocb-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

