From: akpm@linux-foundation.org
Subject: +
 hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
 added to -mm tree
Date: Fri, 09 Sep 2016 13:14:04 -0700
Message-ID: <57d3180c.Kz8mJIuSNbYvWSet%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50038 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753520AbcIIUOF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2016 16:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jsiddle@redhat.com, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix
has been added to the -mm tree.  Its filename is
     hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch

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
Subject: hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix

fix off-by-one

Cc: John Siddle <jsiddle@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/hung_task.c~hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix kernel/hung_task.c
--- a/kernel/hung_task.c~hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix
+++ a/kernel/hung_task.c
@@ -101,14 +101,12 @@ static void check_hung_task(struct task_
 	if (!sysctl_hung_task_warnings && !sysctl_hung_task_panic)
 		return;
 
-	if (sysctl_hung_task_warnings > 0)
-		sysctl_hung_task_warnings--;
-
 	/*
 	 * Ok, the task did not get scheduled for more than 2 minutes,
 	 * complain:
 	 */
 	if (sysctl_hung_task_warnings) {
+		sysctl_hung_task_warnings--;
 		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
 			t->comm, t->pid, timeout);
 		pr_err("      %s %s %.*s\n",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

