From: akpm@linux-foundation.org
Subject: [folded-merged] block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch removed from -mm tree
Date: Mon, 18 Mar 2013 13:36:28 -0700
Message-ID: <20130318203628.963235A4638@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:57876 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3CRUga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:36:30 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so617082vea.2
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:36:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koverstreet@google.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into block-aio-batch-completion-for-bios-kiocbs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix

fix tracepoint in batch_complete()

Cc: Kent Overstreet <koverstreet@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/bio.c~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix fs/bio.c
--- a/fs/bio.c~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix
+++ a/fs/bio.c
@@ -1426,6 +1426,8 @@ void bio_endio_batch(struct bio *bio, in
 	if (error)
 		bio->bi_error = error;
 
+	trace_block_bio_complete(bio, error);
+
 	if (batch)
 		bio_list_add(&batch->bio, bio);
 	else
@@ -1441,8 +1443,6 @@ void batch_complete(struct batch_complet
 	while ((bio = bio_list_pop(&batch->bio)))
 		__bio_endio(bio, batch);
 
-	trace_block_bio_complete(bio, error);
-
 	batch_complete_aio(batch);
 }
 EXPORT_SYMBOL(batch_complete);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting-fix.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
aio-kiocb_cancel.patch
wait-add-wait_event_hrtimeout.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

