From: akpm@linux-foundation.org
Subject: + rework-fix-is_single_threaded.patch added to -mm tree
Date: Wed, 15 Apr 2009 16:32:49 -0700
Message-ID: <200904152332.n3FNWn4g006366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756080AbZDOXf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 19:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, jmorris@namei.org, roland@redhat.com


The patch titled
     rework/fix is_single_threaded()
has been added to the -mm tree.  Its filename is
     rework-fix-is_single_threaded.patch

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
Subject: rework/fix is_single_threaded()
From: Oleg Nesterov <oleg@redhat.com>

- Fix the comment, is_single_threaded(p) actually means that nobody shares
  ->mm with p.

  I think this helper should be renamed, and it should not have arguments.
  With or without this patch it must not be used unless p == current,
  otherwise we can't safely use p->signal or p->mm.

- "if (atomic_read(&p->signal->count) != 1)" is not right when we have a
  zombie group leader, use signal->live instead.

- Add PF_KTHREAD check to skip kernel threads which may borrow p->mm,
  otherwise we can return the wrong "false".

- Use for_each_process() instead of do_each_thread(), all threads must use
  the same ->mm.

- Use down_write(mm->mmap_sem) + rcu_read_lock() instead of tasklist_lock
  to iterate over the process list. If there is another CLONE_VM process
  it can't pass exit_mm() which takes the same mm->mmap_sem. We can miss
  a freshly forked CLONE_VM task, but this doesn't matter because we must
  see its parent and return false.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/is_single_threaded.c |   62 +++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff -puN lib/is_single_threaded.c~rework-fix-is_single_threaded lib/is_single_threaded.c
--- a/lib/is_single_threaded.c~rework-fix-is_single_threaded
+++ a/lib/is_single_threaded.c
@@ -12,34 +12,44 @@
 
 #include <linux/sched.h>
 
-/**
- * is_single_threaded - Determine if a thread group is single-threaded or not
- * @p: A task in the thread group in question
- *
- * This returns true if the thread group to which a task belongs is single
- * threaded, false if it is not.
+/*
+ * Returns true if the task does not share ->mm with another thread/process.
  */
-bool is_single_threaded(struct task_struct *p)
+bool is_single_threaded(struct task_struct *task)
 {
-	struct task_struct *g, *t;
-	struct mm_struct *mm = p->mm;
-
-	if (atomic_read(&p->signal->count) != 1)
-		goto no;
-
-	if (atomic_read(&p->mm->mm_users) != 1) {
-		read_lock(&tasklist_lock);
-		do_each_thread(g, t) {
-			if (t->mm == mm && t != p)
-				goto no_unlock;
-		} while_each_thread(g, t);
-		read_unlock(&tasklist_lock);
+	struct mm_struct *mm = task->mm;
+	struct task_struct *p, *t;
+	bool ret;
+
+	might_sleep();
+
+	if (atomic_read(&task->signal->live) != 1)
+		return false;
+
+	if (atomic_read(&mm->mm_users) == 1)
+		return true;
+
+	ret = false;
+	down_write(&mm->mmap_sem);
+	rcu_read_lock();
+	for_each_process(p) {
+		if (unlikely(p->flags & PF_KTHREAD))
+			continue;
+		if (unlikely(p == task->group_leader))
+			continue;
+
+		t = p;
+		do {
+			if (unlikely(t->mm == mm))
+				goto found;
+			if (likely(t->mm))
+				break;
+		} while_each_thread(p, t);
 	}
+	ret = true;
+found:
+	rcu_read_unlock();
+	up_write(&mm->mmap_sem);
 
-	return true;
