Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA843C1A
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 01:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336070; cv=none; b=qq+6OpwARLxqioA9Iss2cl4yminm6BXMycVMN3mhoKOuAd8N5gfosvn6XR+kbbaYbjY7ajQcIlwm1TS7CGEXAWpXHZGTrhl+7mKXn/mztz8nFQtyM43sluPp7KSaRHff3dTD3hepT0j9+UaHY4m0ZXF2FLY9F82aFuQhx9Q2Ol4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336070; c=relaxed/simple;
	bh=wI1GF6qX0J7ejjQcpYIO74wsYB+7S+eKMtYeC/YTerI=;
	h=Date:To:From:Subject:Message-Id; b=cvLgdhTgza2JiD2LGqjjBdWGEmiVHNWxAUCG1/6W0agUjsu8hoLTBDmTGGDwnjkE8emP+9i/EL3os9brzQX4jOAWOeFNEyIhrXGsCcPrp9D1Ao5JWNIW6/djTB5aUCn1lLEw5m6AzmGUdFnQop/g/6Mdcnk7Hujl3dcl7StN6No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QuUL/3SZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QuUL/3SZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780B01F0089B;
	Wed,  7 Oct 2026 01:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791336068;
	bh=lr7Avoqh5ZC6/AoEJFEr6KIXcdD4hzD+l4NLW4i3alo=;
	h=Date:To:From:Subject;
	b=QuUL/3SZ2XDxTMle8ep/tSKAHDIGVUKY+eD1ZXX08VbNIog4JnEtxdX5OQaqDHIzY
	 rYiC1xZrw85Qxn1HkM1op7Bq8KaTxHP8MR8igPa27ignnfPWwfTB3H0R/Jbo/vXra1
	 q/294tuuRVXOi0F/HPxsGEHek/M1glpZh2u6pqEA=
Date: Tue, 06 Oct 2026 18:21:08 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,bsingharora@gmail.com,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch removed from -mm tree
Message-Id: <20261007012108.780B01F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: copy signal->stats under siglock in taskstats_exit
has been removed from the -mm tree.  Its filename was
     taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Bradley Morgan <brads@mainlining.org>
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
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
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

Patches currently in -mm which might be from brads@mainlining.org are

mailmap-update-email-address-for-bradley-morgan.patch
taskstats-drop-the-unused-cpu_dont_care-enum-member.patch
panic-fix-redirect-cpu-race-in-panic_try_force_cpu.patch
panic-flatten-nmi_panic-control-flow.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
panic-restore-variable-arguments-to-nmi_panic.patch
panic-allow-force_cpu-redirect-from-an-nmi.patch
panic-kill-the-buffer-unavailable-redirect-fallback.patch
watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

