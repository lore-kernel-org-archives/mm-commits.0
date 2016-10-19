From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak-ensure-that-the-task-stack-is-not-freed-during-scanning.patch
 added to -mm tree
Date: Wed, 19 Oct 2016 11:33:37 -0700
Message-ID: <5807bc81.s57HK6JMAhzpck2P%akpm__18050.9887556129$1476902047$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941873AbcJSSdi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 14:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, caiqian@redhat.com, hillf.zj@alibaba-inc.com, luto@kernel.org, mhocko@suse.com, oleg@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: ensure that the task stack is not freed during scanning
has been added to the -mm tree.  Its filename is
     mm-kmemleak-ensure-that-the-task-stack-is-not-freed-during-scanning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-ensure-that-the-task-stack-is-not-freed-during-scanning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-ensure-that-the-task-stack-is-not-freed-during-scanning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>	[4.8.x]
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

mm-kmemleak-ensure-that-the-task-stack-is-not-freed-during-scanning.patch

