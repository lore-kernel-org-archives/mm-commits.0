From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-storage-realtek_crc-fix-build.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:06 -0700
Message-ID: <20130507174607.0A5E531C284@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:56882 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab3EGRqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:08 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so84935yen.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, joe@perches.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/usb/storage/realtek_cr.c: fix build
has been removed from the -mm tree.  Its filename was
     drivers-usb-storage-realtek_crc-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/usb/storage/realtek_cr.c: fix build

Remove unused local `us', which broke the build.  Also nuke an unneeded
cast.

Repairs 191648d03d20 ("usb: storage: Convert US_DEBUGP to usb_stor_dbg").

Cc: Joe Perches <joe@perches.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/realtek_cr.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/usb/storage/realtek_cr.c~drivers-usb-storage-realtek_crc-fix-build drivers/usb/storage/realtek_cr.c
--- a/drivers/usb/storage/realtek_cr.c~drivers-usb-storage-realtek_crc-fix-build
+++ a/drivers/usb/storage/realtek_cr.c
@@ -933,14 +933,11 @@ static int realtek_cr_autosuspend_setup(
 
 static void realtek_cr_destructor(void *extra)
 {
-	struct rts51x_chip *chip = (struct rts51x_chip *)extra;
-	struct us_data *us;
+	struct rts51x_chip *chip = extra;
 
 	if (!chip)
 		return;
 
-	us = chip->us;
-
 #ifdef CONFIG_REALTEK_AUTOPM
 	if (ss_en) {
 		del_timer(&chip->rts51x_suspend_timer);
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

