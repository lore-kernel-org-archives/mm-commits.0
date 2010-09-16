From: akpm@linux-foundation.org
Subject: + oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch added to -mm tree
Date: Thu, 16 Sep 2010 15:50:29 -0700
Message-ID: <201009162250.o8GMoTb4018492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640Ab0IPWuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 18:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, yinghan@google.com


The patch titled
     oom: use old_mm for oom_disable_count in exec
has been added to the -mm tree.  Its filename is
     oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch

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
Subject: oom: use old_mm for oom_disable_count in exec
From: David Rientjes <rientjes@google.com>

active_mm in the exec() path can be for an unrelated thread, so the
oom_disable_count logic should use old_mm instead.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec fs/exec.c
--- a/fs/exec.c~oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec
+++ a/fs/exec.c
@@ -760,8 +760,8 @@ static int exec_mmap(struct mm_struct *m
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
-	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
-		atomic_dec(&active_mm->oom_disable_count);
+	if (old_mm && tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+		atomic_dec(&old_mm->oom_disable_count);
 		atomic_inc(&tsk->mm->oom_disable_count);
 	}
 	task_unlock(tsk);
_

Patches currently in -mm which might be from rientjes@google.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
linux-next.patch
oom-filter-unkillable-tasks-from-tasklist-dump.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-mempolicy-check-return-code-of-check_range.patch
jbd-remove-dependency-on-__gfp_nofail.patch

