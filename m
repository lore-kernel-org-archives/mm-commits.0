From: akpm@linux-foundation.org
Subject: + oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch added to -mm tree
Date: Mon, 23 Aug 2010 16:16:31 -0700
Message-ID: <201008232316.o7NNGVvA020394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092Ab0HWXQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 19:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, yinghan@google.com


The patch titled
     oom: avoid killing a task if a thread sharing its mm cannot be killed
has been added to the -mm tree.  Its filename is
     oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: avoid killing a task if a thread sharing its mm cannot be killed
From: David Rientjes <rientjes@google.com>

The oom killer's goal is to kill a memory-hogging task so that it may
exit, free its memory, and allow the current context to allocate the
memory that triggered it in the first place.  Thus, killing a task is
pointless if other threads sharing its mm cannot be killed because of its
/proc/pid/oom_adj or /proc/pid/oom_score_adj value.

This patch checks whether any other thread sharing p->mm has an
oom_score_adj of OOM_SCORE_ADJ_MIN.  If so, the thread cannot be killed
and oom_badness(p) returns 0, meaning it's unkillable.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed
+++ a/mm/oom_kill.c
@@ -162,10 +162,11 @@ unsigned int oom_badness(struct task_str
 		return 0;
 
 	/*
-	 * Shortcut check for OOM_SCORE_ADJ_MIN so the entire heuristic doesn't
-	 * need to be executed for something that cannot be killed.
+	 * Shortcut check for a thread sharing p->mm that is OOM_SCORE_ADJ_MIN
+	 * so the entire heuristic doesn't need to be executed for something
+	 * that cannot be killed.
 	 */
-	if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+	if (atomic_read(&p->mm->oom_disable_count)) {
 		task_unlock(p);
 		return 0;
 	}
@@ -675,7 +676,7 @@ void out_of_memory(struct zonelist *zone
 	read_lock(&tasklist_lock);
 	if (sysctl_oom_kill_allocating_task &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
-	    (current->signal->oom_adj != OOM_DISABLE)) {
+	    current->mm && !atomic_read(&current->mm->oom_disable_count)) {
 		/*
 		 * oom_kill_process() needs tasklist_lock held.  If it returns
 		 * non-zero, current could not be killed so we must fallback to
_

Patches currently in -mm which might be from rientjes@google.com are

fs-bio-integrityc-remove-dependency-on-__gfp_nofail.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
jbd-remove-dependency-on-__gfp_nofail.patch

