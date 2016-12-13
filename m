From: akpm@linux-foundation.org
Subject: [patch 100/123] hung_task: decrement sysctl_hung_task_warnings
 only if it is positive
Date: Mon, 12 Dec 2016 16:45:35 -0800
Message-ID: <584f44af.l3CZlh4tUdnTSimq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41826 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932578AbcLMApg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, jsiddle@redhat.com

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
