From: akpm@linux-foundation.org
Subject: [folded-merged] aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 07 May 2013 12:42:30 -0700
Message-ID: <20130507194230.8B6505A419E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:39813 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3EGTmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:42:31 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so99967ggl.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:42:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch

This patch was dropped because it was folded into aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes

WARNING: line over 80 characters
#97: FILE: fs/aio.c:775:
+		long avail = (head <= info->tail ? info->tail : info->nr) - head;

WARNING: line over 80 characters
#106: FILE: fs/aio.c:784:
+			      ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));

WARNING: line over 80 characters
#113: FILE: fs/aio.c:791:
+		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * avail);

total: 0 errors, 3 warnings, 288 lines checked

./patches/aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/aio.c~aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes fs/aio.c
--- a/fs/aio.c~aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes
+++ a/fs/aio.c
@@ -773,23 +773,25 @@ static long aio_read_events_ring(struct
 		goto out;
 
 	while (ret < nr) {
-		long avail = (head <= info->tail ? info->tail : info->nr) - head;
+		long avail;
 		struct io_event *ev;
 		struct page *page;
 
+		avail = (head <= info->tail ? info->tail : info->nr) - head;
 		if (head == info->tail)
 			break;
 
 		avail = min(avail, nr - ret);
 		avail = min_t(long, avail, AIO_EVENTS_PER_PAGE -
-			      ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
+			    ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
 
 		pos = head + AIO_EVENTS_OFFSET;
 		page = info->ring_pages[pos / AIO_EVENTS_PER_PAGE];
 		pos %= AIO_EVENTS_PER_PAGE;
 
 		ev = kmap(page);
-		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * avail);
+		copy_ret = copy_to_user(event + ret, ev + pos,
+					sizeof(*ev) * avail);
 		kunmap(page);
 
 		if (unlikely(copy_ret)) {
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
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
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

