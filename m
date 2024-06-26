Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6C818E77D
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 19:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719429631; cv=none; b=DvI9VlzW9tFRbgat1yJ1ZE5ewujLMGoU88lv3KSQOuGFMyH9EcEfAGiDWSsLPP2watyqOVVTbEYe7KxnP3Put+j7lqgQFIQ1U5E5TkyyR5eiRHDDb/hsH9ae0O7ajC+7rKGpTy3kMqhEYEHyD8RqI3g6Ve9dzFUM6MACCHXN5js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719429631; c=relaxed/simple;
	bh=RqN9ukbTTvUIXUig4VMUAuPav7JL0OFsJimdYsCidvc=;
	h=Date:To:From:Subject:Message-Id; b=Kg3J8t3bNzV1d7cVpvx/Wqww7VW4CRfW0c3sgcjX2yB8GC62YMOk5WHmoCFDX1wp4W94bRR+r3vg/Hbcp4ZsLXknMzsuE1WJPurdIqH3oEu/T7EDyTJn7MxBtrEy3F0rZAgozD267rWqk92i4mwEkD7xfWGZkhpQPX+LFqodPEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hNI8oo6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hNI8oo6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8757EC116B1;
	Wed, 26 Jun 2024 19:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719429630;
	bh=RqN9ukbTTvUIXUig4VMUAuPav7JL0OFsJimdYsCidvc=;
	h=Date:To:From:Subject:From;
	b=hNI8oo6BlbS2m+UXlsRpnovnjjSh3krhdRTV3jWzXDKP6fY5FRSadP9d71Qs5m/FE
	 v2Vd7I4lpCS9BV9cKKSE51IZvKaR+7MjUsUcj2BVWXwKKt9Bhd5zevETd89mODRFrR
	 w7AjyfQQZ37FT1QWkSGYsHODRwHlt3biWa7X3kz8=
Date: Wed, 26 Jun 2024 12:20:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tandersen@netflix.com,mjguzik@gmail.com,mhocko@suse.com,ebiederm@xmission.com,brauner@kernel.org,axboe@kernel.dk,alexjlzheng@tencent.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-mm_update_next_owner-move-for_each_thread-into-try_to_set_owner.patch added to mm-unstable branch
Message-Id: <20240626192030.8757EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: mm_update_next_owner: move for_each_thread() into try_to_set_owner()
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-mm_update_next_owner-move-for_each_thread-into-try_to_set_owner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-mm_update_next_owner-move-for_each_thread-into-try_to_set_owner.patch

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
Subject: memcg: mm_update_next_owner: move for_each_thread() into try_to_set_owner()
Date: Wed, 26 Jun 2024 17:29:30 +0200

mm_update_next_owner() checks the children / real_parent->children to
avoid the "everything else" loop in the likely case, but this won't work
if a child/sibling has a zombie leader with ->mm == NULL.

Move the for_each_thread() logic into try_to_set_owner(), if nothing else
this makes the children/siblings/everything searches more consistent.

Link: https://lkml.kernel.org/r/20240626152930.GA17936@redhat.com
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

 kernel/exit.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/kernel/exit.c~memcg-mm_update_next_owner-move-for_each_thread-into-try_to_set_owner
+++ a/kernel/exit.c
@@ -440,7 +440,7 @@ static void coredump_task_exit(struct ta
 
 #ifdef CONFIG_MEMCG
 /* drops tasklist_lock if succeeds */
-static bool try_to_set_owner(struct task_struct *tsk, struct mm_struct *mm)
+static bool __try_to_set_owner(struct task_struct *tsk, struct mm_struct *mm)
 {
 	bool ret = false;
 
@@ -456,12 +456,28 @@ static bool try_to_set_owner(struct task
 	return ret;
 }
 
+static bool try_to_set_owner(struct task_struct *g, struct mm_struct *mm)
+{
+	struct task_struct *t;
+
+	for_each_thread(g, t) {
+		struct mm_struct *t_mm = READ_ONCE(t->mm);
+		if (t_mm == mm) {
+			if (__try_to_set_owner(t, mm))
+				return true;
+		} else if (t_mm)
+			break;
+	}
+
+	return false;
+}
+
 /*
  * A task is exiting.   If it owned this mm, find a new owner for the mm.
  */
 void mm_update_next_owner(struct mm_struct *mm)
 {
-	struct task_struct *c, *g, *p = current;
+	struct task_struct *g, *p = current;
 
 	/*
 	 * If the exiting or execing task is not the owner, it's
@@ -483,19 +499,17 @@ void mm_update_next_owner(struct mm_stru
 	/*
 	 * Search in the children
 	 */
-	list_for_each_entry(c, &p->children, sibling) {
-		if (c->mm == mm && try_to_set_owner(c, mm))
+	list_for_each_entry(g, &p->children, sibling) {
+		if (try_to_set_owner(g, mm))
 			goto ret;
 	}
-
 	/*
 	 * Search in the siblings
 	 */
-	list_for_each_entry(c, &p->real_parent->children, sibling) {
-		if (c->mm == mm && try_to_set_owner(c, mm))
+	list_for_each_entry(g, &p->real_parent->children, sibling) {
+		if (try_to_set_owner(g, mm))
 			goto ret;
 	}
-
 	/*
 	 * Search through everything else, we should not get here often.
 	 */
@@ -504,14 +518,8 @@ void mm_update_next_owner(struct mm_stru
 			break;
 		if (g->flags & PF_KTHREAD)
 			continue;
-		for_each_thread(g, c) {
-			struct mm_struct *c_mm = READ_ONCE(c->mm);
-			if (c_mm == mm) {
-				if (try_to_set_owner(c, mm))
-					goto ret;
-			} else if (c_mm)
-				break;
-		}
+		if (try_to_set_owner(g, mm))
+			goto ret;
 	}
 	read_unlock(&tasklist_lock);
 	/*
_

Patches currently in -mm which might be from oleg@redhat.com are

memcg-mm_update_next_owner-kill-the-retry-logic.patch
memcg-mm_update_next_owner-move-for_each_thread-into-try_to_set_owner.patch
zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch
coredump-simplify-zap_process.patch

