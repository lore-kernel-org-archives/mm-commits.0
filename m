From: akpm@linux-foundation.org
Subject: [folded-merged] hugetlbfs-fix-mmap-failure-in-unaligned-size-request-fix.patch removed from -mm tree
Date: Tue, 07 May 2013 12:39:27 -0700
Message-ID: <20130507193927.C87BC5A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39225 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3EGTj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:39:29 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so99723vbe.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:39:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, iceman_dvd@yahoo.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, steven.truelove@utoronto.ca, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs-fix-mmap-failure-in-unaligned-size-request-fix
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-mmap-failure-in-unaligned-size-request-fix.patch

This patch was dropped because it was folded into hugetlbfs-fix-mmap-failure-in-unaligned-size-request.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlbfs-fix-mmap-failure-in-unaligned-size-request-fix

Fix warning when CONFIG_HUGETLB_PAGE=n

mm/mmap.c: In function 'SYSC_mmap_pgoff':
mm/mmap.c:1370: warning: unused variable 'hs'

Cc: <iceman_dvd@yahoo.com>
Cc: <stable@vger.kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steven Truelove <steven.truelove@utoronto.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~hugetlbfs-fix-mmap-failure-in-unaligned-size-request-fix mm/mmap.c
--- a/mm/mmap.c~hugetlbfs-fix-mmap-failure-in-unaligned-size-request-fix
+++ a/mm/mmap.c
@@ -1367,9 +1367,9 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
-		struct hstate *hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT)
-						& MAP_HUGE_MASK);
-		len = ALIGN(len, huge_page_size(hs));
+
+		len = ALIGN(len, huge_page_size(hstate_sizelog(
+			(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK)));
 		/*
 		 * VM_NORESERVE is used because the reservations will be
 		 * taken when vm_ops->mmap() is called
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
hugetlbfs-fix-mmap-failure-in-unaligned-size-request.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32.patch
mm-vmallocc-add-vfree-comment.patch
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

