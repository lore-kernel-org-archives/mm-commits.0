From: akpm@linux-foundation.org
Subject: [merged]
 wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str.patch removed from -mm tree
Date: Tue, 27 May 2014 13:22:21 -0700
Message-ID: <5384f3fd.6RWhmmCWuqksOy9P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaE0UWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 16:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, yamato@redhat.com

Subject: [merged] wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str.patch removed from -mm tree
To: yamato@redhat.com,oleg@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 13:22:21 -0700


The patch titled
     Subject: wait: swap EXIT_ZOMBIE(Z) and EXIT_DEAD(X) chars in TASK_STATE_TO_CHAR_STR
has been removed from the -mm tree.  Its filename was
     wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masatake YAMATO <yamato@redhat.com>
Subject: wait: swap EXIT_ZOMBIE(Z) and EXIT_DEAD(X) chars in TASK_STATE_TO_CHAR_STR

In ad86622b478eaafdc ("wait: swap EXIT_ZOMBIE and EXIT_DEAD to hide
EXIT_TRACE from user-space") the order of task state definitions were
changed: EXIT_DEAD and EXIT_ZOMBIE were swapped.  Though the charterers
for the states in TASK_STATE_TO_CHAR_STR string were not updated.  This
patch synchronizes the string to the order of definitions.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sched.h~wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str include/linux/sched.h
--- a/include/linux/sched.h~wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str
+++ a/include/linux/sched.h
@@ -220,7 +220,7 @@ print_cfs_rq(struct seq_file *m, int cpu
 #define TASK_PARKED		512
 #define TASK_STATE_MAX		1024
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKWP"
+#define TASK_STATE_TO_CHAR_STR "RSDTtXZxKWP"
 
 extern char ___assert_task_state[1 - 2*!!(
 		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
_

Patches currently in -mm which might be from yamato@redhat.com are


