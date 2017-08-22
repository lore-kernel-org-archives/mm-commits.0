From: akpm@linux-foundation.org
Subject: +
 block-make-i-o-timeout-failure-injection-support-again-task-independent.patch added to -mm tree
Date: Tue, 22 Aug 2017 15:16:18 -0700
Message-ID: <599cad32.5/1O46qK6BPGGsQX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51120 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbdHVWQT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 18:16:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@wdc.com, akinobu.mita@gmail.com, axboe@kernel.dk, dvyukov@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block: make I/O timeout failure injection support again task-independent
has been added to the -mm tree.  Its filename is
     block-make-i-o-timeout-failure-injection-support-again-task-independent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-make-i-o-timeout-failure-injection-support-again-task-independent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-make-i-o-timeout-failure-injection-support-again-task-independent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: block: make I/O timeout failure injection support again task-independent

e41d58185f14 made all faults that are triggered from task context,
including I/O timeouts, dependent on the failure injection settings for
that task.  Make it again possible to inject I/O timeout failures
independent of task context.  An example for a fault injection for which
this patch makes a difference (from a VM booted with the 'threadirqs'
command line parameter):

FAULT_INJECTION: forcing a failure. name fail_io_timeout, interval 1, probability 100, space 0, times 1
CPU: 6 PID: 1253 Comm: irq/36-skd0-msi Not tainted 4.13.0-rc2-dbg+ #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1.fc26 04/01/2014
Call Trace:
 dump_stack+0x8e/0xcd
 should_fail+0x154/0x160
 blk_should_fake_timeout+0x27/0x30
 blk_mq_complete_request+0x11/0x30
 skd_end_request+0x32/0xc0 [skd]
 skd_isr_completion_posted.isra.30+0x14a/0x400 [skd]
 skd_comp_q+0x40/0xb0 [skd]
 irq_forced_thread_fn+0x2a/0x70
 irq_thread+0x144/0x1a0
 kthread+0x125/0x140
 ret_from_fork+0x2a/0x40

Link: http://lkml.kernel.org/r/20170822165236.12275-3-bart.vanassche@wdc.com
Fixes: commit e41d58185f14 ("fault-inject: support systematic fault injection")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-timeout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-timeout.c~block-make-i-o-timeout-failure-injection-support-again-task-independent block/blk-timeout.c
--- a/block/blk-timeout.c~block-make-i-o-timeout-failure-injection-support-again-task-independent
+++ a/block/blk-timeout.c
@@ -11,7 +11,7 @@
 
 #ifdef CONFIG_FAIL_IO_TIMEOUT
 
-static DECLARE_FAULT_ATTR(fail_io_timeout);
+static DECLARE_GLOBAL_FAULT_ATTR(fail_io_timeout);
 
 static int __init setup_fail_io_timeout(char *str)
 {
_

Patches currently in -mm which might be from bart.vanassche@wdc.com are

fault-inject-restore-support-for-task-independent-fault-injection.patch
block-make-i-o-timeout-failure-injection-support-again-task-independent.patch

