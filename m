From: akpm@linux-foundation.org
Subject: [merged]
 hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:27:06 -0800
Message-ID: <58519d0a.BIJ0ReZqYZok+DT2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45636 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756686AbcLNT1H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:27:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, jsiddle@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hung_task: decrement sysctl_hung_task_warnings only if it is positive
has been removed from the -mm tree.  Its filename was
     hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

sysctl-add-kern_cont-to-deprecated_sysctl_warning.patch

