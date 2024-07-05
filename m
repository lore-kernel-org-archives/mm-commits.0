Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9799D2FE
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141630; cv=none; b=aEJbriGuLACJlzqjRnqAasCWMOTQA8usfgiSZgNY1wI6EirWB7gRYwNCl2UzaynzAIR0Den36uf6bAV3krrc8Q7W9b5UT6iXDt9iVOfcKitvsr2v/2+eHt7KhWWGBFwANH92+m6WB2ZGkK6pC8Qk+jW2Gh7RkdvarwM7hCkh2ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141630; c=relaxed/simple;
	bh=jmqJ2HDchArLs4YlaPNAqZvP14GhyJQ3jiIo52CUvWc=;
	h=Date:To:From:Subject:Message-Id; b=M5dM9zgszldHoAumtlg11EZtiRxTXLoDqHAIp2toOvSrH2TiV8tPKDnzYudOjInnOOy8d6vqpB+0O+q2GetUYqI9EedP55gVPagJV9CFm069w0ej4QRr6d2YZxlxv2zMatT16MdCDjLcQv2ONQz3uAgqNf6sv6cOinJsDxS+pIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YaoHVZqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YaoHVZqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2BCC3277B;
	Fri,  5 Jul 2024 01:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141630;
	bh=jmqJ2HDchArLs4YlaPNAqZvP14GhyJQ3jiIo52CUvWc=;
	h=Date:To:From:Subject:From;
	b=YaoHVZqjhEz4HGdf5RL30hYDdzqu3kL/SFXQfAJVia+x5ATEVAB9V6rtBJjc3UBNs
	 /f+ZvnnQlUNqb+i7KHxSYtuXi9bB+KF0c8sWgoCaPxAlz3vl2TmEGHPnHIDEEHzgvl
	 +P+uTdkAG4cfgj91xSRb54wrBz7VYPvveB/JV0FA=
Date: Thu, 04 Jul 2024 18:07:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tandersen@netflix.com,mjguzik@gmail.com,mhocko@suse.com,ebiederm@xmission.com,brauner@kernel.org,axboe@kernel.dk,alexjlzheng@tencent.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-mm_update_next_owner-move-for_each_thread-into-try_to_set_owner.patch removed from -mm tree
Message-Id: <20240705010710.9E2BCC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: mm_update_next_owner: move for_each_thread() into try_to_set_owner()
has been removed from the -mm tree.  Its filename was
     memcg-mm_update_next_owner-move-for_each_thread-into-try_to_set_owner.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch
coredump-simplify-zap_process.patch

