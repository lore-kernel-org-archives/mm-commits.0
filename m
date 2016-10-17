From: akpm@linux-foundation.org
Subject: [withdrawn]
 hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix.patch removed from -mm tree
Date: Mon, 17 Oct 2016 14:35:20 -0700
Message-ID: <58054418.roL0//7fjNgKIK/0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56983 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965204AbcJQVfV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2016 17:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jsiddle@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix
has been removed from the -mm tree.  Its filename was
     hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix.patch

This patch was dropped because it was withdrawn

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
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

