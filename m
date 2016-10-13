From: akpm@linux-foundation.org
Subject: +
 hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch
 added to -mm tree
Date: Wed, 12 Oct 2016 17:11:27 -0700
Message-ID: <57fed12f.D9iyWkq5lNuH23BT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41413 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932966AbcJMAMp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 20:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, jsiddle@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hung_task: decrement sysctl_hung_task_warnings only if it is positive
has been added to the -mm tree.  Its filename is
     hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: hung_task: decrement sysctl_hung_task_warnings only if it is positive

Since sysctl_hung_task_warnings == -1 is allowed (infinite warnings),
48a6d64edadbd40f ("hung_task: allow hung_task_panic when
hung_task_warnings is 0") should decrement it only when it is not -1.

This prevents the kernel from ceasing warnings after the first 4294967295 ;)

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: John Siddle <jsiddle@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/hung_task.c~hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive kernel/hung_task.c
--- a/kernel/hung_task.c~hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive
+++ a/kernel/hung_task.c
@@ -106,7 +106,8 @@ static void check_hung_task(struct task_
 	 * complain:
 	 */
 	if (sysctl_hung_task_warnings) {
-		sysctl_hung_task_warnings--;
+		if (sysctl_hung_task_warnings > 0)
+			sysctl_hung_task_warnings--;
 		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
 			t->comm, t->pid, timeout);
 		pr_err("      %s %s %.*s\n",
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mm-remove-extra-newline-from-allocation-stall-warning.patch
hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch

