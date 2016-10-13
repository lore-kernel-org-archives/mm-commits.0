From: akpm@linux-foundation.org
Subject: +
 hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix.patch added to -mm tree
Date: Wed, 12 Oct 2016 17:11:29 -0700
Message-ID: <57fed131.79+bAri7HipPDWPp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933211AbcJMAMp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 20:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jsiddle@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix
has been added to the -mm tree.  Its filename is
     hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix.patch

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
Subject: hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix

handle -2, -3, ... as per the documentation

Cc: John Siddle <jsiddle@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/hung_task.c~hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix kernel/hung_task.c
--- a/kernel/hung_task.c~hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix
+++ a/kernel/hung_task.c
@@ -106,7 +106,7 @@ static void check_hung_task(struct task_
 	 * complain:
 	 */
 	if (sysctl_hung_task_warnings) {
-		if (sysctl_hung_task_warnings > 0)
+		if (sysctl_hung_task_warnings != -1)
 			sysctl_hung_task_warnings--;
 		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
 			t->comm, t->pid, timeout);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix.patch
hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

