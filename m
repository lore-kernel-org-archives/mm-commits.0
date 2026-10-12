Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41133B3C15
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 18:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791830993; cv=none; b=ksPj1tRByKDdTz35FOwVKXMvt7jUINBRds2r161/BJVq92zOSJOpevWOVdOvgClZQi5C5r29GATVrQ8CqL6lbKDTWUupXUllsqlHSYnAjuWsnWzYoj9/IV7coFE0TPmzndaaykpBbomnhxJqSN5y8sqXdpSCTzPv9zqSPI4l/DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791830993; c=relaxed/simple;
	bh=lQO1G1gzqDXw8Ul0gaoKuhqj3EgFBfJsB9N8BSDJpZk=;
	h=Date:To:From:Subject:Message-Id; b=KFKpl3UShq/N82t8ThPc6ndqv6Q+KYozxV7JZ1VrzD4B8WxKKg2PuttE/qXYZE9sxxiM5ZwaNqI4DmeJAJ5EKVS4zyXTQldJv7kHysrt/T7Wkqi0om5YrXp7atTz1p6bpz6bYhu92Eifnn4bly9uKOBujPvU68o/BWeIALOtDrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D/DBaLkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D/DBaLkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC6B1F008A1;
	Mon, 12 Oct 2026 18:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791830992;
	bh=qYb6xPVs4ZaNB7LvVco5Q7pOcaMiHJpCM9Chwj/3oZc=;
	h=Date:To:From:Subject;
	b=D/DBaLkRmrDqudi6w3vm6ZXfKcABsWFHnt39z7xkEkhL2aw4i6ZQInW+xlEG3GocQ
	 9ca5oLa5IzQXLs+JWUXI2s0NR9ZEPLp3vF6QHE4KmO+SfAW7GYOVJXMbsHj1DNhU9z
	 orlaqVVjwH6Uy5uwvY00qriaOQES8ApilhcEkfW4=
Date: Mon, 12 Oct 2026 11:49:51 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,brauner@kernel.org,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] exit-fix-lost-update-race-on-the-child_subreaper-bitfields.patch removed from -mm tree
Message-Id: <20261012184952.2FC6B1F008A1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: exit: fix lost-update race on the child_subreaper bitfields
has been removed from the -mm tree.  Its filename was
     exit-fix-lost-update-race-on-the-child_subreaper-bitfields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: exit: fix lost-update race on the child_subreaper bitfields
Date: Sun, 11 Oct 2026 08:34:39 -0400

is_child_subreaper, has_child_subreaper, autoreap and, with
CONFIG_POSIX_TIMERS=y, timer_create_restore_ids are 1-bit fields that
share one memory location in struct signal_struct.  A store to any of
them is a read-modify-write of the whole word, and three of the stores
run without a common lock:

  - PR_SET_CHILD_SUBREAPER writes me->signal->is_child_subreaper with
    no lock held.

  - propagate_has_child_subreaper(), run by walk_process_tree() from
    the same prctl in an ancestor, writes p->signal->has_child_subreaper
    of every descendant p under read_lock(&tasklist_lock), which does
    not exclude the other writers.

  - PR_TIMER_CREATE_RESTORE_IDS writes
    current->signal->timer_create_restore_ids with no lock held.

When a process calls prctl(PR_SET_CHILD_SUBREAPER, 1) while an
ancestor's PR_SET_CHILD_SUBREAPER walk visits it, or while another
thread of the same process calls prctl(PR_TIMER_CREATE_RESTORE_IDS),
the read-modify-write sequences interleave and one of the bits is
silently lost:

  - If has_child_subreaper is lost, the process's orphaned descendants
    are reparented straight to init when it exits: find_new_reaper()
    tests father->signal->has_child_subreaper first and never looks for
    the ancestor subreaper.  The service manager that registered as the
    subreaper never gets SIGCHLD for them and cannot wait() on them.

  - If is_child_subreaper is lost, the prctl returned 0 but the process
    is not a subreaper: orphans of its descendants skip it and are
    reparented to the next subreaper up or to init.
    PR_GET_CHILD_SUBREAPER reads back 0.

  - If timer_create_restore_ids is lost, the prctl returned 0 but
    timer_create() does not restore the requested timer ids (or keeps
    restoring them after _OFF), and _GET reads back the old value.

Documentation/memory-barriers.txt requires all fields of one bitfield
to be protected by one lock for exactly this reason.  No lock is taken
or documented for these flags, and the prctls need no privilege, so any
process can hit the race against its own ancestors or descendants, or
between two of its own threads.

Make is_child_subreaper and has_child_subreaper separate bool members.
Each store then has its own memory location and no read-modify-write
of a neighbour.  The readers and their locking are unchanged.

autoreap stays a bit-field and so shares a memory location only with
timer_create_restore_ids.  That pair is race-free: autoreap is stored
exactly once, in copy_process() before the new signal_struct is
reachable by any other task, and timer_create_restore_ids is only
stored to the signal_struct of an already running process.

Link: https://lore.kernel.org/20261011123440.768054-1-nickolai@csail.mit.edu
Fixes: 749860ce2427 ("prctl: propagate has_child_subreaper flag to every descendant")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Assisted-by: LLM
Cc: Christian Brauner <brauner@kernel.org>
---

 include/linux/sched/signal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/sched/signal.h~exit-fix-lost-update-race-on-the-child_subreaper-bitfields
+++ a/include/linux/sched/signal.h
@@ -130,8 +130,8 @@ struct signal_struct {
 	 * process will inherit a flag if they should look for a
 	 * child_subreaper process at exit.
 	 */
-	unsigned int		is_child_subreaper:1;
-	unsigned int		has_child_subreaper:1;
+	bool			is_child_subreaper;
+	bool			has_child_subreaper;
 	unsigned int		autoreap:1;
 
 #ifdef CONFIG_POSIX_TIMERS
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are


