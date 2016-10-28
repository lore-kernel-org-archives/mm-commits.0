From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmemleak-ensure-that-the-task-stack-is-not-freed-during-scanning.patch
 removed from -mm tree
Date: Fri, 28 Oct 2016 11:30:39 -0700
Message-ID: <5813994f.PJmeh0Z2Dt5M9bGZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030229AbcJ1Sak (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:30:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, caiqian@redhat.com, hillf.zj@alibaba-inc.com, luto@kernel.org, mhocko@suse.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: ensure that the task stack is not freed during scanning
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-ensure-that-the-task-stack-is-not-freed-during-scanning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: ensure that the task stack is not freed during scanning

Commit 68f24b08ee89 ("sched/core: Free the stack early if
CONFIG_THREAD_INFO_IN_TASK") may cause the task->stack to be freed
during kmemleak_scan() execution, leading to either a NULL pointer
fault (if task->stack is NULL) or kmemleak accessing already freed
memory. This patch uses the new try_get_task_stack() API to ensure that
the task stack is not freed during kmemleak stack scanning.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=173901.

Fixes: 68f24b08ee89 ("sched/core: Free the stack early if CONFIG_THREAD_INFO_IN_TASK")
Link: http://lkml.kernel.org/r/1476266223-14325-1-git-send-email-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: CAI Qian <caiqian@redhat.com>
Tested-by: CAI Qian <caiqian@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-ensure-that-the-task-stack-is-not-freed-during-scanning mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-ensure-that-the-task-stack-is-not-freed-during-scanning
+++ a/mm/kmemleak.c
@@ -1453,8 +1453,11 @@ static void kmemleak_scan(void)
 
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			scan_block(task_stack_page(p), task_stack_page(p) +
-				   THREAD_SIZE, NULL);
+			void *stack = try_get_task_stack(p);
+			if (stack) {
+				scan_block(stack, stack + THREAD_SIZE, NULL);
+				put_task_stack(p);
+			}
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 	}
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


