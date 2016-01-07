From: akpm@linux-foundation.org
Subject: [merged] sched-check-tgid-in-is_global_init.patch removed from
 -mm tree
Date: Thu, 07 Jan 2016 14:17:10 -0800
Message-ID: <568ee3e6.3ii2yfUZ8fLMCHsG%akpm__29525.9093902589$1452205042$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbcAGWRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 17:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, oleg@redhat.com, rgb@redhat.com, serge.hallyn@canonical.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched: check tgid in is_global_init
has been removed from the -mm tree.  Its filename was
     sched-check-tgid-in-is_global_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: sched: check tgid in is_global_init

Global init can have sub-threads, so ->pid check is not reliable enough
for is_global_init(), we need to check tgid instead.  This has been
spotted by Oleg and a fix was proposed by Richard a long time ago (see the
link below).

Oleg wrote:
:Because is_global_init() is only true for the main thread of /sbin/init.
:
:Just look at oom_unkillable_task(). It tries to not kill init. But, say,
:select_bad_process() can happily find a sub-thread of is_global_init()
:and still kill it.

I recently hit the problem in question; re-sending the patch (to the best
of my knowledge it has never been submitted) with updated function
comment.  Credit goes to Oleg and Richard.

Link: https://www.redhat.com/archives/linux-audit/2013-December/msg00086.html
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~sched-check-tgid-in-is_global_init include/linux/sched.h
--- a/include/linux/sched.h~sched-check-tgid-in-is_global_init
+++ a/include/linux/sched.h
@@ -2013,7 +2013,8 @@ static inline int pid_alive(const struct
 }
 
 /**
- * is_global_init - check if a task structure is init
+ * is_global_init - check if a task structure is init. Since init
+ * is free to have sub-threads we need to check tgid.
  * @tsk: Task structure to be checked.
  *
  * Check if a task structure is the first user space task the kernel created.
@@ -2022,7 +2023,7 @@ static inline int pid_alive(const struct
  */
 static inline int is_global_init(struct task_struct *tsk)
 {
-	return tsk->pid == 1;
+	return task_tgid_nr(tsk) == 1;
 }
 
 extern struct pid *cad_pid;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-zcomp-use-gfp_noio-to-allocate-streams.patch
zram-zcomp-do-not-zero-out-zcomp-private-pages.patch
printk-change-recursion_bug-type-to-bool.patch

