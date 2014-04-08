From: akpm@linux-foundation.org
Subject: [merged]
 wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:21:41 -0700
Message-ID: <53446865.LsQ3L7IkI+h+DK0T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbaDHVVm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:21:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, roland@hack.frob.com, mschmidt@redhat.com, lpoetter@redhat.com, jan.kratochvil@redhat.com, oleg@redhat.com

Subject: [merged] wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space.patch removed from -mm tree
To: oleg@redhat.com,jan.kratochvil@redhat.com,lpoetter@redhat.com,mschmidt@redhat.com,roland@hack.frob.com,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:21:41 -0700


The patch titled
     Subject: wait: swap EXIT_ZOMBIE and EXIT_DEAD to hide EXIT_TRACE from user-space
has been removed from the -mm tree.  Its filename was
     wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: wait: swap EXIT_ZOMBIE and EXIT_DEAD to hide EXIT_TRACE from user-space

get_task_state() uses the most significant bit to report the state to
user-space, this means that EXIT_ZOMBIE->EXIT_TRACE->EXIT_DEAD transition
can be noticed via /proc as Z -> X -> Z change.  Note that this was
possible even before EXIT_TRACE was introduced.

This is not really bad but imho it make sense to hide EXIT_TRACE from
user-space completely.  So the patch simply swaps EXIT_ZOMBIE and
EXIT_DEAD, this way EXIT_TRACE will be seen as EXIT_ZOMBIE by user-space.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Lennart Poettering <lpoetter@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c       |    4 ++--
 include/linux/sched.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/array.c~wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space fs/proc/array.c
--- a/fs/proc/array.c~wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space
+++ a/fs/proc/array.c
@@ -138,8 +138,8 @@ static const char * const task_state_arr
 	"D (disk sleep)",	/*   2 */
 	"T (stopped)",		/*   4 */
 	"t (tracing stop)",	/*   8 */
-	"Z (zombie)",		/*  16 */
-	"X (dead)",		/*  32 */
+	"X (dead)",		/*  16 */
+	"Z (zombie)",		/*  32 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
diff -puN include/linux/sched.h~wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space include/linux/sched.h
--- a/include/linux/sched.h~wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space
+++ a/include/linux/sched.h
@@ -210,8 +210,8 @@ print_cfs_rq(struct seq_file *m, int cpu
 #define __TASK_STOPPED		4
 #define __TASK_TRACED		8
 /* in tsk->exit_state */
-#define EXIT_ZOMBIE		16
-#define EXIT_DEAD		32
+#define EXIT_DEAD		16
+#define EXIT_ZOMBIE		32
 #define EXIT_TRACE		(EXIT_ZOMBIE | EXIT_DEAD)
 /* in tsk->state again */
 #define TASK_DEAD		64
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch

