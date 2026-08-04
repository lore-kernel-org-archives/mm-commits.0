Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B7343FD11
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 20:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785873849; cv=none; b=R1Vd4rf+7OM8pb8Uwek/2irlLZ1h1NCY041Pp5pAGpOaxU0a2KZ3YlEIHVETGeRMJ4E4hVoWy7+f0ojeWLKAG+FTY9/bhpvrOJx5m0mm9/uX2fJan0GAh6V8MNucDuUV595gDK2oi/U+Bk+4qTpc5xXejUjXCKYoRjOz+Mij2VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785873849; c=relaxed/simple;
	bh=TnV1tEBX7ZUDi9lfWpHACZwbefGFbRe+a3JA0qneEb8=;
	h=Date:To:From:Subject:Message-Id; b=HO8S5CvT27pZ2qvoNjVGvdmuYofkp9zJ2InLWwTcJfjU1G9OPN44E2UifRr5NDUi4e2tODzLOPswY0bO2u8X8gwstcDU1C92CEie02YQ899enH+WYpjYdx7JxGH9VaZItbbpw4lpinw4CxBq/cSPvHSe3kpM0CwCkHxMsTGEzw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s/UyjLYZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s/UyjLYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E858F1F000E9;
	Tue,  4 Aug 2026 20:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785873848;
	bh=yVvs5WRZ/IloNsw7iPHFqVHq8t1Wgu3AD3aixHknvfo=;
	h=Date:To:From:Subject;
	b=s/UyjLYZqibqfXM/I0UxSV+E3xGlJnrf3vqZqU0MJorKVDoqyL/zKfjNNXBB2RmQ9
	 9/ovxBJSUh1as3LE6edcUA4rkUdAlezV/pvtfeAQsaJvDQCuoW3ffBpFVreeqLHCUa
	 MpwNUOVkRyxyRlzVr2D8VAJw9Velf3BdIZQazWfk=
Date: Tue, 04 Aug 2026 13:04:07 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,bsingharora@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch added to mm-nonmm-unstable branch
Message-Id: <20260804200407.E858F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: copy signal->stats under siglock in taskstats_exit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: taskstats: copy signal->stats under siglock in taskstats_exit
Date: Tue, 4 Aug 2026 09:34:00 +0000

taskstats_exit() copies tsk->signal->stats into the exit reply without
taking any lock.  Every other writer of this struct holds sighand->siglock
before touching it, and this copy does not.

The copy happens on the last thread of a thread group that exits. 
group_dead being 1 only says that every thread has dropped signal->live,
it does not say how far the other threads got in do_exit().  One of them
can still be inside fill_tgid_exit() adding its counters to the struct
while the last thread copies it out, so the copy can read the struct in
the middle of an update.

The commit that added the copy assumed no locking was needed because the
group was dead:

	/* No locking needed for tsk->signal->stats since
	   group is dead */

but at that point the other threads have not necessarily finished
their exit path.

cpu0 (thread A, not last)        cpu1 (thread B, last)
===========================      ==============================
atomic_dec(&signal->live)        atomic_dec(&signal->live) -> 0
group_dead = 0                   group_dead = 1
...                              taskstats_exit(tsk, 1)
taskstats_exit(tsk, 0)           fill_tgid_exit(tsk) [siglock]
fill_tgid_exit(tsk)              memcpy(stats, signal->stats)
  spin_lock(siglock)               reads ac_utime (new)
  stats->ac_utime += x             reads ac_stime (old)
  stats->ac_stime += y             torn snapshot -> netlink
  spin_unlock(siglock)

The listeners receive a partially updated tgid snapshot, with some fields
from before the concurrent update and some from after.  There is no crash
or splat, which is likely why this went unnoticed since 2006.  A userspace
model of the same shape, writer under a lock and a lockless memcpy reader,
produces millions of torn reads in a few seconds.

Take siglock around the copy like every other access does.  sighand is
still alive here because taskstats_exit() runs before exit_notify(), and
fill_tgid_exit() already takes this same lock earlier in this function.

Link: https://lore.kernel.org/20260804093400.3922-1-include@grrlz.net
Fixes: ad4ecbcba728 ("[PATCH] delay accounting taskstats interface send tgid once")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/taskstats.c~taskstats-copy-signal-stats-under-siglock-in-taskstats_exit
+++ a/kernel/taskstats.c
@@ -590,6 +590,7 @@ void taskstats_exit(struct task_struct *
 	struct sk_buff *rep_skb;
 	size_t size;
 	int is_thread_group;
+	unsigned long flags;
 
 	if (!family_registered)
 		return;
@@ -635,7 +636,10 @@ void taskstats_exit(struct task_struct *
 	if (!stats)
 		goto err;
 
+	/* This was racy before, copy the stats under siglock. */
+	spin_lock_irqsave(&tsk->sighand->siglock, flags);
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
+	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 	stats->version = TASKSTATS_VERSION;
 
 send:
_

Patches currently in -mm which might be from include@grrlz.net are

taskstats-drop-the-dead-null-attribute-check-in-parse.patch
taskstats-fold-the-two-cpumask-handlers-into-one.patch
taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch

