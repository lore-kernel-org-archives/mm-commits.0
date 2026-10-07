Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150C2401486
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 06:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791355150; cv=none; b=hn4+3hcGeQsBERZsWMAhXiu21qvvQwt4Iy3PcI8TKuHnQPqLh8j2Rzk0qzOJ7iiDh2nu0Txk44uQNlZ6TvSjEOeO5+h8tnP1EkLYDoXbIK4yiCC2NozkOfWMpLuuvxevuI/8xf0wrklftNq6EgtKLECnqgkP/DLaM1b+FMrVDsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791355150; c=relaxed/simple;
	bh=Gp34dwErX+hxu8YB99WB6yAWgQ3ugOVfWNaN+KEmfQk=;
	h=Date:From:To:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=StopLds0Rwlv8jiruoQlUOStxlwn3whBWlKdJpbZfiAVBdFw+0kZ7oY1LpzOoE23auePLUbGwL0f6HLdS8XKGvGYDDJzP6GXL+VxVYdk8nEBuGGfLD+LG1XGrL194sijaR4ACqdc/FAzpV7PRFwKfHWQS033bXGWFG2pCr+odL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=hYdK7AXH; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=QmPdj/QD; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="hYdK7AXH";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="QmPdj/QD"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1791355143; bh=5Fb9Sfi0sgVn/UpJ9VcC9iw
	HJHoyxg09/+mBGM/HHhU=; b=hYdK7AXHI6AzpM6p6a8UXyqNPDzlYkZm6w+V7lle/m1qhOtagU
	mMR2hAbLBvNRLMP/hjtpcEyrQevGjLDab6A8LVfkI/jFJTphMTDzEMNTAW8bPb/2xe4542y0YSR
	4m2UP7WX4qXdunMBI+pXJ48/yL7pqe3km4J8k3TiO+fpXw7DjWGnYI1SiCL6GhSjVpt2mvhQmtr
	ZxvW5WXHfIBU2mqz1xuytELcDVdHClT6aZjny4OErw1ROiKS//FwLwfqPjWTHWdZJ1VaelsQbQY
	DBg5TW3Hwkkko/GZ9XdkB307FfzEjZ3lYVhISencDUG67lExRG/otBvi3eDlKSW23bQ==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1791355143; bh=5Fb9Sfi0sgVn/UpJ9VcC9iw
	HJHoyxg09/+mBGM/HHhU=; b=QmPdj/QDRQCG+DMPECdYdolG2ppQasHtYCg7fn9sBlV6x9CjTo
	ojelL3dvrBTesVWZ3Mn0WQ2qFW1v5cFyilDw==;
Date: Wed, 07 Oct 2026 07:39:03 +0100
From: Bradley Morgan <brads@mainlining.org>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 oleg@redhat.com, bsingharora@gmail.com, akpm@linux-foundation.org
Subject: =?US-ASCII?Q?Re=3A_=5Bto-be-updated=5D_taskstats-copy-signal-stats-under?=
 =?US-ASCII?Q?-siglock-in-taskstats=5Fexit=2Epatch_removed_from_-mm_tree?=
In-Reply-To: <20261007012108.780B01F0089B@smtp.kernel.org>
References: <20261007012108.780B01F0089B@smtp.kernel.org>
Message-ID: <CB0B268A-5D7E-4FDE-A706-1A7AD877EA93@mainlining.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 7 October 2026 02:21:08 BST, Andrew Morton <akpm@linux-foundation.org>
wrote:
>
>The quilt patch titled
>     Subject: taskstats: copy signal->stats under siglock in taskstats_exit
>has been removed from the -mm tree.  Its filename was
>     taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch
>
>This patch was dropped because an updated version will be issued


Any reason? I didn't get let known about this! :)

>
>------------------------------------------------------
>From: Bradley Morgan <brads@mainlining.org>
>Subject: taskstats: copy signal->stats under siglock in taskstats_exit
>Date: Tue, 4 Aug 2026 09:34:00 +0000
>
>taskstats_exit() copies tsk->signal->stats into the exit reply without
>taking any lock.  Every other writer of this struct holds sighand->siglock
>before touching it, and this copy does not.
>
>The copy happens on the last thread of a thread group that exits. 
>group_dead being 1 only says that every thread has dropped signal->live,
>it does not say how far the other threads got in do_exit().  One of them
>can still be inside fill_tgid_exit() adding its counters to the struct
>while the last thread copies it out, so the copy can read the struct in
>the middle of an update.
>
>The commit that added the copy assumed no locking was needed because the
>group was dead:
>
>	/* No locking needed for tsk->signal->stats since
>	   group is dead */
>
>but at that point the other threads have not necessarily finished
>their exit path.
>
>cpu0 (thread A, not last)        cpu1 (thread B, last)
>===========================      ==============================
>atomic_dec(&signal->live)        atomic_dec(&signal->live) -> 0
>group_dead = 0                   group_dead = 1
>...                              taskstats_exit(tsk, 1)
>taskstats_exit(tsk, 0)           fill_tgid_exit(tsk) [siglock]
>fill_tgid_exit(tsk)              memcpy(stats, signal->stats)
>  spin_lock(siglock)               reads ac_utime (new)
>  stats->ac_utime += x             reads ac_stime (old)
>  stats->ac_stime += y             torn snapshot -> netlink
>  spin_unlock(siglock)
>
>The listeners receive a partially updated tgid snapshot, with some fields
>from before the concurrent update and some from after.  There is no crash
>or splat, which is likely why this went unnoticed since 2006.  A userspace
>model of the same shape, writer under a lock and a lockless memcpy reader,
>produces millions of torn reads in a few seconds.
>
>Take siglock around the copy like every other access does.  sighand is
>still alive here because taskstats_exit() runs before exit_notify(), and
>fill_tgid_exit() already takes this same lock earlier in this function.
>
>Link: https://lore.kernel.org/20260804093400.3922-1-include@grrlz.net
>Fixes: ad4ecbcba728 ("[PATCH] delay accounting taskstats interface send tgid once")
>Signed-off-by: Bradley Morgan <brads@mainlining.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Acked-by: Oleg Nesterov <oleg@redhat.com>
>Cc: Balbir Singh <bsingharora@gmail.com>
>---
>
> kernel/taskstats.c |    4 ++++
> 1 file changed, 4 insertions(+)
>
>--- a/kernel/taskstats.c~taskstats-copy-signal-stats-under-siglock-in-taskstats_exit
>+++ a/kernel/taskstats.c
>@@ -590,6 +590,7 @@ void taskstats_exit(struct task_struct *
> 	struct sk_buff *rep_skb;
> 	size_t size;
> 	int is_thread_group;
>+	unsigned long flags;
> 
> 	if (!family_registered)
> 		return;
>@@ -635,7 +636,10 @@ void taskstats_exit(struct task_struct *
> 	if (!stats)
> 		goto err;
> 
>+	/* This was racy before, copy the stats under siglock. */
>+	spin_lock_irqsave(&tsk->sighand->siglock, flags);
> 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
>+	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
> 	stats->version = TASKSTATS_VERSION;
> 
> send:
>_
>
>Patches currently in -mm which might be from brads@mainlining.org are
>
>mailmap-update-email-address-for-bradley-morgan.patch
>taskstats-drop-the-unused-cpu_dont_care-enum-member.patch
>panic-fix-redirect-cpu-race-in-panic_try_force_cpu.patch
>panic-flatten-nmi_panic-control-flow.patch
>panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
>panic-restore-variable-arguments-to-nmi_panic.patch
>panic-allow-force_cpu-redirect-from-an-nmi.patch
>panic-kill-the-buffer-unavailable-redirect-fallback.patch
>watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch
>

--- Thanks!
"I'm not a very positive person" - Linus torvalds
