Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D7410A35
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141629; cv=none; b=ffylofkpC2B6Fzs3olSaaYi850DPGqP6gu6O6FImA7LDq8HnKszGZS/50D9ky+urvlcJnGFDLm0siVix9fR9U5U8q5f4ShkWNk+5coeiQ0xnZ1Skyvy+oOFPAfd/mNEu4vrJYoRphXCi0Mnbgmr+j2zAxrpfFgHuWVkx1VCraFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141629; c=relaxed/simple;
	bh=U93oqY76px14Z+ILnT6pFlmfCNcYJKcuG6qO9Bn0JnE=;
	h=Date:To:From:Subject:Message-Id; b=H5HYFETvucoxqJF580cDkvtwq8KMfE4BSzQV6p1hcqrjsx7lW8unbkCz2t/ByTrFxepSLieLe8N62rJePDIUOwvfJ/14VtRCwrTJc8Lptl54HDBPLXNpTsmYmyAMm/Pj6aDhIho+mSeQ6OFpEN2yLHDWdq+JvN4VawnEYH62RTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x8WSSxh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x8WSSxh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B97C4AF0A;
	Fri,  5 Jul 2024 01:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141629;
	bh=U93oqY76px14Z+ILnT6pFlmfCNcYJKcuG6qO9Bn0JnE=;
	h=Date:To:From:Subject:From;
	b=x8WSSxh3vx+7D1zSXZ1eRdvp7ZzqS97l4EW4UrzhZrd7m5QG+6SNkTlv5LAC6Unv6
	 dBU1AEG4VWvvC6PS/J2VSFdReKhcoHmjw1b5CEEr1mnjGDLOWVvTp/gaMd1LXs9D1T
	 0WhMlVi1ymnh5ImNWv3dYOqIsodgyjtSUPWLiGr0=
Date: Thu, 04 Jul 2024 18:07:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tandersen@netflix.com,mjguzik@gmail.com,mhocko@suse.com,ebiederm@xmission.com,brauner@kernel.org,axboe@kernel.dk,alexjlzheng@tencent.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-mm_update_next_owner-kill-the-retry-logic.patch removed from -mm tree
Message-Id: <20240705010709.84B97C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: mm_update_next_owner: kill the "retry" logic
has been removed from the -mm tree.  Its filename was
     memcg-mm_update_next_owner-kill-the-retry-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: memcg: mm_update_next_owner: kill the "retry" logic
Date: Wed, 26 Jun 2024 17:29:24 +0200

Add the new helper, try_to_set_owner(), which tries to update mm->owner
once we see c->mm == mm.  This way mm_update_next_owner() doesn't need to
restart the list_for_each_entry/for_each_process loops from the very
beginning if it races with exit/exec, it can just continue.

Unlike the current code, try_to_set_owner() re-checks tsk->mm == mm before
it drops tasklist_lock, so it doesn't need get/put_task_struct().

Link: https://lkml.kernel.org/r/20240626152924.GA17933@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jinliang Zheng <alexjlzheng@tencent.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tycho Andersen <tandersen@netflix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   57 ++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

--- a/kernel/exit.c~memcg-mm_update_next_owner-kill-the-retry-logic
+++ a/kernel/exit.c
@@ -439,6 +439,23 @@ static void coredump_task_exit(struct ta
 }
 
 #ifdef CONFIG_MEMCG
+/* drops tasklist_lock if succeeds */
+static bool try_to_set_owner(struct task_struct *tsk, struct mm_struct *mm)
+{
+	bool ret = false;
+
+	task_lock(tsk);
+	if (likely(tsk->mm == mm)) {
+		/* tsk can't pass exit_mm/exec_mmap and exit */
+		read_unlock(&tasklist_lock);
+		WRITE_ONCE(mm->owner, tsk);
+		lru_gen_migrate_mm(mm);
+		ret = true;
+	}
+	task_unlock(tsk);
+	return ret;
+}
+
 /*
  * A task is exiting.   If it owned this mm, find a new owner for the mm.
  */
@@ -446,7 +463,6 @@ void mm_update_next_owner(struct mm_stru
 {
 	struct task_struct *c, *g, *p = current;
 
-retry:
 	/*
 	 * If the exiting or execing task is not the owner, it's
 	 * someone else's problem.
@@ -468,16 +484,16 @@ retry:
 	 * Search in the children
 	 */
 	list_for_each_entry(c, &p->children, sibling) {
-		if (c->mm == mm)
-			goto assign_new_owner;
+		if (c->mm == mm && try_to_set_owner(c, mm))
+			goto ret;
 	}
 
 	/*
 	 * Search in the siblings
 	 */
 	list_for_each_entry(c, &p->real_parent->children, sibling) {
-		if (c->mm == mm)
-			goto assign_new_owner;
+		if (c->mm == mm && try_to_set_owner(c, mm))
+			goto ret;
 	}
 
 	/*
@@ -489,9 +505,11 @@ retry:
 		if (g->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(g, c) {
-			if (c->mm == mm)
-				goto assign_new_owner;
-			if (c->mm)
+			struct mm_struct *c_mm = READ_ONCE(c->mm);
+			if (c_mm == mm) {
+				if (try_to_set_owner(c, mm))
+					goto ret;
+			} else if (c_mm)
 				break;
 		}
 	}
@@ -502,30 +520,9 @@ retry:
 	 * ptrace or page migration (get_task_mm()).  Mark owner as NULL.
 	 */
 	WRITE_ONCE(mm->owner, NULL);
+ ret:
 	return;
 
-assign_new_owner:
-	BUG_ON(c == p);
-	get_task_struct(c);
-	/*
-	 * The task_lock protects c->mm from changing.
-	 * We always want mm->owner->mm == mm
-	 */
-	task_lock(c);
-	/*
-	 * Delay read_unlock() till we have the task_lock()
-	 * to ensure that c does not slip away underneath us
-	 */
-	read_unlock(&tasklist_lock);
-	if (c->mm != mm) {
-		task_unlock(c);
-		put_task_struct(c);
-		goto retry;
-	}
-	WRITE_ONCE(mm->owner, c);
-	lru_gen_migrate_mm(mm);
-	task_unlock(c);
-	put_task_struct(c);
 }
 #endif /* CONFIG_MEMCG */
 
_

Patches currently in -mm which might be from oleg@redhat.com are

zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch
coredump-simplify-zap_process.patch

