From: akpm@linux-foundation.org
Subject: +
 wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str.patch added to -mm tree
Date: Thu, 22 May 2014 10:21:51 -0700
Message-ID: <537e322f.6MQCktrjuA1+lN0d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaEVRVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 13:21:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, yamato@redhat.com

Subject: + wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str.patch added to -mm tree
To: yamato@redhat.com,oleg@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 10:21:51 -0700


The patch titled
     Subject: wait: swap EXIT_ZOMBIE(Z) and EXIT_DEAD(X) chars in TASK_STATE_TO_CHAR_STR
has been added to the -mm tree.  Its filename is
     wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

wait-swap-exit_zombiez-and-exit_deadx-chars-in-task_state_to_char_str.patch

