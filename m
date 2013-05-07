From: akpm@linux-foundation.org
Subject: + idr-print-a-stack-dump-after-ida_remove-warning-fix.patch added to -mm tree
Date: Tue, 07 May 2013 16:34:33 -0700
Message-ID: <20130507233433.CCC0731C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:63381 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab3EGXef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 19:34:35 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so125722ggl.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 16:34:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jdelvare@suse.de, tiwai@suse.de, tj@kernel.org


The patch titled
     Subject: idr-print-a-stack-dump-after-ida_remove-warning-fix
has been added to the -mm tree.  Its filename is
     idr-print-a-stack-dump-after-ida_remove-warning-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: idr-print-a-stack-dump-after-ida_remove-warning-fix

convert the open-coded printk+dump_stack into WARN()

Cc: Jean Delvare <jdelvare@suse.de>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN lib/idr.c~idr-print-a-stack-dump-after-ida_remove-warning-fix lib/idr.c
--- a/lib/idr.c~idr-print-a-stack-dump-after-ida_remove-warning-fix
+++ a/lib/idr.c
@@ -524,9 +524,7 @@ EXPORT_SYMBOL(idr_alloc_cyclic);
 
 static void idr_remove_warning(int id)
 {
-	printk(KERN_WARNING
-		"idr_remove called for id=%d which is not allocated.\n", id);
-	dump_stack();
+	WARN(1, "idr_remove called for id=%d which is not allocated.\n", id);
 }
 
 static void sub_remove(struct idr *idp, int shift, int id)
@@ -1064,9 +1062,7 @@ void ida_remove(struct ida *ida, int id)
 	return;
 
  err:
-	printk(KERN_WARNING
-	       "ida_remove called for id=%d which is not allocated.\n", id);
-	dump_stack();
+	WARN(1, "ida_remove called for id=%d which is not allocated.\n", id);
 }
 EXPORT_SYMBOL(ida_remove);
 
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
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
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
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
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

