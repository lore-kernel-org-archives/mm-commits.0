From: akpm@linux-foundation.org
Subject: [obsolete] revert-ipc-dont-allocate-a-copy-larger-than-max.patch removed from -mm tree
Date: Tue, 07 May 2013 10:43:58 -0700
Message-ID: <20130507174358.EEF965A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:50011 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3EGRoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:44:00 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so84711yen.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:43:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, peter@hurleysoftware.com, skinsbursky@parallels.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "ipc: don't allocate a copy larger than max"
has been removed from the -mm tree.  Its filename was
     revert-ipc-dont-allocate-a-copy-larger-than-max.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "ipc: don't allocate a copy larger than max"

Revert 88b9e456b164.  Dave has confirmed that this was causing oopses
during trinity testing.

Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN ipc/msg.c~revert-ipc-dont-allocate-a-copy-larger-than-max ipc/msg.c
--- a/ipc/msg.c~revert-ipc-dont-allocate-a-copy-larger-than-max
+++ a/ipc/msg.c
@@ -820,17 +820,15 @@ long do_msgrcv(int msqid, void __user *b
 	struct msg_msg *copy = NULL;
 	unsigned long copy_number = 0;
 
-	ns = current->nsproxy->ipc_ns;
-
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
-		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax),
-				    msgflg, &msgtyp, &copy_number);
+		copy = prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);
 	}
 	mode = convert_mode(&msgtyp, msgflg);
+	ns = current->nsproxy->ipc_ns;
 
 	msq = msg_lock_check(ns, msqid);
 	if (IS_ERR(msq)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
mm-vmallocc-add-vfree-comment.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
revert-ipc_schedule_free-can-do-vfree-now.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipc-sysv-shared-memory-limited-to-8tib.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
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
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
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

