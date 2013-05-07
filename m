From: akpm@linux-foundation.org
Subject: [folded-merged] aio-kill-ki_retry-fix.patch removed from -mm tree
Date: Tue, 07 May 2013 12:43:48 -0700
Message-ID: <20130507194349.15A375A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47619 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3EGTnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:43:50 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so100216vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:43:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koverstreet@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: aio-kill-ki_retry-fix
has been removed from the -mm tree.  Its filename was
     aio-kill-ki_retry-fix.patch

This patch was dropped because it was folded into aio-kill-ki_retry.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: aio-kill-ki_retry-fix

fix file_start_write/file_end_write tests

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~aio-kill-ki_retry-fix fs/aio.c
--- a/fs/aio.c~aio-kill-ki_retry-fix
+++ a/fs/aio.c
@@ -1021,7 +1021,7 @@ static ssize_t aio_rw_vect_retry(struct
 	if (iocb->ki_pos < 0)
 		return -EINVAL;
 
-	if (opcode == IOCB_CMD_PWRITEV)
+	if (rw == WRITE)
 		file_start_write(file);
 	do {
 		ret = rw_op(iocb, &iocb->ki_iovec[iocb->ki_cur_seg],
@@ -1035,7 +1035,7 @@ static ssize_t aio_rw_vect_retry(struct
 	} while (ret > 0 && iocb->ki_left > 0 &&
 		 (rw == WRITE ||
 		  (!S_ISFIFO(inode->i_mode) && !S_ISSOCK(inode->i_mode))));
-	if (opcode == IOCB_CMD_PWRITEV)
+	if (rw == WRITE)
 		file_end_write(file);
 
 	/* This means we must have transferred all that we could */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
hugetlbfs-fix-mmap-failure-in-unaligned-size-request.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32.patch
mm-vmallocc-add-vfree-comment.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-4.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

