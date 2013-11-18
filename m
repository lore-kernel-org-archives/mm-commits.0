From: akpm@linux-foundation.org
Subject: + block-blk-mq-cpuc-use-hotcpu_notifier.patch added to -mm tree
Date: Mon, 18 Nov 2013 12:00:18 -0800
Message-ID: <528a71d2.LlQZRoQinDgmKJ74%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3KRUAT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 15:00:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, akpm@linux-foundation.org

Subject: + block-blk-mq-cpuc-use-hotcpu_notifier.patch added to -mm tree
To: akpm@linux-foundation.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 12:00:18 -0800


The patch titled
     Subject: block/blk-mq-cpu.c: use hotcpu_notifier()
has been added to the -mm tree.  Its filename is
     block-blk-mq-cpuc-use-hotcpu_notifier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-blk-mq-cpuc-use-hotcpu_notifier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-blk-mq-cpuc-use-hotcpu_notifier.patch

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
Subject: block/blk-mq-cpu.c: use hotcpu_notifier()

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-mq-cpu.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN block/blk-mq-cpu.c~block-blk-mq-cpuc-use-hotcpu_notifier block/blk-mq-cpu.c
--- a/block/blk-mq-cpu.c~block-blk-mq-cpuc-use-hotcpu_notifier
+++ a/block/blk-mq-cpu.c
@@ -28,10 +28,6 @@ static int blk_mq_main_cpu_notify(struct
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata blk_mq_main_cpu_notifier = {
-	.notifier_call	= blk_mq_main_cpu_notify,
-};
-
 void blk_mq_register_cpu_notifier(struct blk_mq_cpu_notifier *notifier)
 {
 	BUG_ON(!notifier->notify);
@@ -58,5 +54,5 @@ void blk_mq_init_cpu_notifier(struct blk
 
 void __init blk_mq_cpu_init(void)
 {
-	register_hotcpu_notifier(&blk_mq_main_cpu_notifier);
+	hotcpu_notifier(blk_mq_main_cpu_notify, 0);
 }
diff -puN block/blk-mq.c~block-blk-mq-cpuc-use-hotcpu_notifier block/blk-mq.c
diff -puN block/blk-mq.h~block-blk-mq-cpuc-use-hotcpu_notifier block/blk-mq.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

