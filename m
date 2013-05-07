From: akpm@linux-foundation.org
Subject: [folded-merged] generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 07 May 2013 12:42:53 -0700
Message-ID: <20130507194253.BBD535A419E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:39152 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3EGTmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:42:54 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so100035qec.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:42:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: generic-dynamic-per-cpu-refcounting-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch

This patch was dropped because it was folded into generic-dynamic-per-cpu-refcounting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: generic-dynamic-per-cpu-refcounting-checkpatch-fixes

WARNING: line over 80 characters
#401: FILE: lib/percpu-refcount.c:215:
+			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);

total: 0 errors, 1 warnings, 365 lines checked

./patches/generic-dynamic-per-cpu-refcounting.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-refcount.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-checkpatch-fixes lib/percpu-refcount.c
--- a/lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-checkpatch-fixes
+++ a/lib/percpu-refcount.c
@@ -212,7 +212,8 @@ int percpu_ref_kill(struct percpu_ref *r
 		synchronize_rcu();
 
 		for_each_possible_cpu(cpu)
-			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);
+			count += *per_cpu_ptr((unsigned __percpu *)pcpu_count,
+					      cpu);
 
 		pr_debug("global %lli pcpu %i",
 			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
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

