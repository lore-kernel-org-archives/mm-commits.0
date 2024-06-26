Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8059D149C57
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 19:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719429629; cv=none; b=sHccDY3rW9KObtpPXKbLMHteit9mdFPROfGazFIi7dXfh6FiohWTxgkt9bz9qnalQt9FGIiUuhEQzSxBUtgh/e0+665+cD/tCQQfProq49caKjQKJHppaA8nSSXSah6FA/U4Mqq92MJYVdOvB8o8ggkxNL5WeiPaghcFL92R1HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719429629; c=relaxed/simple;
	bh=uiIlSBbTc0zsEAPOPIKcgd1ugf4GqU9bYyK/6O294vg=;
	h=Date:To:From:Subject:Message-Id; b=Sa1bfnRoWv7OJor7XezGtYPpzm+Xmkmt+HWulmk3wFx4GOHu/ZQ+xY4xBzsRmw6L8wiIP52Hze/wbItt+iEG5BwNJEbxAdwFAY9L2T3Bcemdw99Pv4PvVzW2aL8aoyetVnP6lzT6qnzEhYwvUwKI/eWneLJZ+JdLcymmvwD9wmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hAORKhZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hAORKhZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31F9C116B1;
	Wed, 26 Jun 2024 19:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719429629;
	bh=uiIlSBbTc0zsEAPOPIKcgd1ugf4GqU9bYyK/6O294vg=;
	h=Date:To:From:Subject:From;
	b=hAORKhZpQTFKbHSU1N+Z5aMw4yNCAsPIzeNLVZq0G649WI/NjDEob5tDzIUazJm+C
	 GzIWvWCoVi/AtF442WG0ptf1ZEqXcPrCkO71lPCiZ9e3wICF6lTcYqf+eLCoBuT0Hc
	 BGJ1s0VfuNikJX2mESx2e3/TwTcL43oGSUsSrfjM=
Date: Wed, 26 Jun 2024 12:20:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tandersen@netflix.com,mjguzik@gmail.com,mhocko@suse.com,ebiederm@xmission.com,brauner@kernel.org,axboe@kernel.dk,alexjlzheng@tencent.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-mm_update_next_owner-kill-the-retry-logic.patch added to mm-unstable branch
Message-Id: <20240626192028.D31F9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: mm_update_next_owner: kill the "retry" logic
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-mm_update_next_owner-kill-the-retry-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-mm_update_next_owner-kill-the-retry-logic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jinliang Zheng <alexjlzheng@tencent.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
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

memcg-mm_update_next_owner-kill-the-retry-logic.patch
memcg-mm_update_next_owner-move-for_each_thread-into-try_to_set_owner.patch
zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch
coredump-simplify-zap_process.patch

