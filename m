From: akpm@linux-foundation.org
Subject: [folded-merged] mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch removed from -mm tree
Date: Tue, 09 Apr 2013 13:56:23 -0700
Message-ID: <20130409205624.586A831C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:63613 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762739Ab3DIU40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 16:56:26 -0400
Received: by mail-oa0-f73.google.com with SMTP id o6so1871967oag.4
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 13:56:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adrian.hunter@intel.com, axboe@kernel.dk, darrick.wong@oracle.com, dedekind1@gmail.com, jack@suse.cz, luto@amacapital.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix
has been removed from the -mm tree.  Its filename was
     mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch

This patch was dropped because it was folded into mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix

rename _submit_bh()'s `flags' to `bio_flags', delobotomize the _submit_bh declaration

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    4 ++--
 include/linux/buffer_head.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/buffer.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix fs/buffer.c
--- a/fs/buffer.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix
+++ a/fs/buffer.c
@@ -2949,7 +2949,7 @@ static void guard_bh_eod(int rw, struct
 	}
 }
 
-int _submit_bh(int rw, struct buffer_head * bh, unsigned long flags)
+int _submit_bh(int rw, struct buffer_head * bh, unsigned long bio_flags)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -2983,7 +2983,7 @@ int _submit_bh(int rw, struct buffer_hea
 
 	bio->bi_end_io = end_bio_bh_io_sync;
 	bio->bi_private = bh;
-	bio->bi_flags |= flags;
+	bio->bi_flags |= bio_flags;
 
 	/* Take care of bh's that straddle the end of the device */
 	guard_bh_eod(rw, bio, bh);
diff -puN include/linux/buffer_head.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix
+++ a/include/linux/buffer_head.h
@@ -181,7 +181,7 @@ void ll_rw_block(int, int, struct buffer
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, int rw);
 void write_dirty_buffer(struct buffer_head *bh, int rw);
-int _submit_bh(int, struct buffer_head *, unsigned long);
+int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags);
 int submit_bh(int, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
mips-define-kvm_user_mem_slots.patch
auditsc-use-kzalloc-instead-of-kmallocmemset-fix.patch
drivers-video-implement-a-simple-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
misc-generic-on-chip-sram-allocation-driver-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-mainc-convert-to-pr_foo.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

