From: akpm@linux-foundation.org
Subject: [to-be-updated]
 oom-avoid-killing-init-if-it-assumed-the-oom-killed-threads-mm.patch
 removed from -mm tree
Date: Wed, 25 Sep 2013 12:47:17 -0700
Message-ID: <52433dc5.JrSy0g777HR4FyBH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3IYTrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, ming.liu@windriver.com

Subject: [to-be-updated] oom-avoid-killing-init-if-it-assumed-the-oom-killed-threads-mm.patch removed from -mm tree
To: ming.liu@windriver.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:47:17 -0700


The patch titled
     Subject: oom: avoid killing init if it assumed the oom killed thread's mm
has been removed from the -mm tree.  Its filename was
     oom-avoid-killing-init-if-it-assumed-the-oom-killed-threads-mm.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ming Liu <ming.liu@windriver.com>
Subject: oom: avoid killing init if it assumed the oom killed thread's mm

After selecting a task to kill, the oom killer iterates all processes and
kills all other user threads that share the same mm_struct in different
thread groups.

But in some extreme cases, the selected task happens to be a vfork child
of init process sharing the same mm_struct with it, which causes kernel
panic on init getting killed.  This panic is observed in a busybox shell
that busybox itself is init, when a kthread keeps consuming memory.

Signed-off-by: Ming Liu <ming.liu@windriver.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~oom-avoid-killing-init-if-it-assumed-the-oom-killed-threads-mm mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-killing-init-if-it-assumed-the-oom-killed-threads-mm
+++ a/mm/oom_kill.c
@@ -479,17 +479,17 @@ void oom_kill_process(struct task_struct
 	task_unlock(victim);
 
 	/*
-	 * Kill all user processes sharing victim->mm in other thread groups, if
-	 * any.  They don't get access to memory reserves, though, to avoid
-	 * depletion of all memory.  This prevents mm->mmap_sem livelock when an
-	 * oom killed thread cannot exit because it requires the semaphore and
-	 * its contended by another thread trying to allocate memory itself.
-	 * That thread will now get access to memory reserves since it has a
-	 * pending fatal signal.
+	 * Kill all user processes except init sharing victim->mm in other
+	 * thread groups, if any.  They don't get access to memory reserves,
+	 * though, to avoid depletion of all memory.  This prevents mm->mmap_sem
+	 * livelock when an oom killed thread cannot exit because it requires
+	 * the semaphore and its contended by another thread trying to allocate
+	 * memory itself. That thread will now get access to memory reserves
+	 * since it has a pending fatal signal.
 	 */
 	for_each_process(p)
 		if (p->mm == mm && !same_thread_group(p, victim) &&
-		    !(p->flags & PF_KTHREAD)) {
+		    !(p->flags & PF_KTHREAD) && !is_global_init(p)) {
 			if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 				continue;
 
_

Patches currently in -mm which might be from ming.liu@windriver.com are


