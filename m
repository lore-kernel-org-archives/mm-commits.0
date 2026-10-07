Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD2C3CF047
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791393594; cv=none; b=ryiTNCUvar3YBEuVsrGW3bQpxYDB/42OX533zbbrhjJCO2W73NwJ8Cso1qjmv5c3k94BHcdpHw6oqG/PPYxv+o2utUix3D2BsLKoQ4BDX8bYmShPcrIq5Smzq7/MoGDd7/axhWa2GHvkVy/W990yCZkkBkxPZFp5NnD7K0eqJUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791393594; c=relaxed/simple;
	bh=G+PP4b6E65UudTRooaVGPx2BWmg2gEFtrJRhzOjSNNs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=sqoUKrtRbR5aSWzjH6wirQdQ71+v/+1/dUBkSgk5fcWr+EkXraHSkJsrEo4Q6QUL2dFe+zM+A+XN35TvvF1HkoHVkTmsLRIX3xSb/cRtx+qnt0W+7QrI82CAg1YAdcGXFz4PnzhEHPpoI92EnJcuo0W0mbZykX2MB5qZkfHmV/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=XkXwsiwp; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=BmaKrWha; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="XkXwsiwp";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="BmaKrWha"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1791393589; bh=nRdE7DQD7MeXKFfGJn4IsDt
	m8IaUBW9ws38n09wNn+A=; b=XkXwsiwpII6/r0NrqCRSXsozZmX77svyaV8DFBYIQ2d7l040v1
	0Br161kgNt7nUYSae9hsInYF58F2Q0iQvKC/xWyoGdxE0FFI8A6Hj+3TQyIwPBy1JzL5PH72lKg
	KPidPafnHtAImipMh6HW/vFM+O0+kZ5kkyH4zJJPk8u6KGgwEkQFeYKqjWglcF5c7pogc3s/HVY
	iT9EYDieiW2A6XzAyBoONi20t3+5h7p+2++9PGn/IBtjDV86FnHw0fPzKRsCi1E61rLCJQf6LDi
	1pwCItjRH0ku8sOgE5OzTw8uT3/vn9r6kEfJwBj4OxlLb93ynlBIvxKpIpNEZXnh+JA==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1791393589; bh=nRdE7DQD7MeXKFfGJn4IsDt
	m8IaUBW9ws38n09wNn+A=; b=BmaKrWhayo5UYhMh4tfjtYmQS6r9Me2N7azwi9cKr3Wcn65Xmu
	34uiZoWCRR0L+cUNfKAfxry0K42+nnYtT6Bg==;
Date: Wed, 07 Oct 2026 18:19:50 +0100
From: Bradley Morgan <brads@mainlining.org>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mm-commits@vger.kernel.org, oleg@redhat.com, bsingharora@gmail.com
Subject: =?US-ASCII?Q?Re=3A_=5Bto-be-updated=5D_taskstats-copy-signal-stats-under?=
 =?US-ASCII?Q?-siglock-in-taskstats=5Fexit=2Epatch_removed_from_-mm_tree?=
In-Reply-To: <20261007101242.050caf151539d660e8bdc100@linux-foundation.org>
References: <20261007012108.780B01F0089B@smtp.kernel.org> <CB0B268A-5D7E-4FDE-A706-1A7AD877EA93@mainlining.org> <20261007101242.050caf151539d660e8bdc100@linux-foundation.org>
Message-ID: <A2B94D8E-F026-406E-B346-9200FA081EB0@mainlining.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 7 October 2026 18:12:42 BST, Andrew Morton <akpm@linux-foundation.org>
wrote:
>On Wed, 07 Oct 2026 07:39:03 +0100 Bradley Morgan <brads@mainlining.org>
>wrote:
>
>> On 7 October 2026 02:21:08 BST, Andrew Morton
><akpm@linux-foundation.org>
>> wrote:
>> >
>> >The quilt patch titled
>> >     Subject: taskstats: copy signal->stats under siglock in
>taskstats_exit
>> >has been removed from the -mm tree.  Its filename was
>> >     taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch
>> >
>> >This patch was dropped because an updated version will be issued
>> 
>> 
>> Any reason? I didn't get let known about this! :)
>
>That's what happens when you change email addresses :(
>
>
>
>Begin forwarded message:
>
>Date: Tue, 6 Oct 2026 18:20:53 -0700
>From: Andrew Morton <akpm@linux-foundation.org>
>To: Bradley Morgan <include@grrlz.net>
>Subject: Re: [PATCH] taskstats: copy signal->stats under siglock in taskstats_exit
>
>
>On Tue,  4 Aug 2026 09:34:00 +0000 Bradley Morgan <include@grrlz.net>
>wrote:
>
>> taskstats_exit() copies tsk->signal->stats into the exit reply
>> without taking any lock. Every other writer of this struct holds
>> sighand->siglock before touching it, and this copy does not.
>> 
>> The copy happens on the last thread of a thread group that exits.
>> group_dead being 1 only says that every thread has dropped
>> signal->live, it does not say how far the other threads got in
>> do_exit(). One of them can still be inside fill_tgid_exit() adding
>> its counters to the struct while the last thread copies it out, so
>> the copy can read the struct in the middle of an update.
>
>I managed to lose the v2 of this.  Please resend sometime?  Add
>a cc:oleg while in there.
>
>Thanks.
>
From 137b873cce7721384c9d24f4c0864bb002c8d039 Mon Sep 17 00:00:00 2001
From: Bradley Morgan <include@grrlz.net>
Date: Tue, 4 Aug 2026 09:34:00 +0000
Subject: [PATCH v2] taskstats: copy signal->stats under siglock in
 taskstats_exit

taskstats_exit() copies tsk->signal->stats into the exit reply
without taking any lock. Every other writer of this struct holds
sighand->siglock before touching it, and this copy does not.

The copy happens on the last thread of a thread group that exits.
group_dead being 1 only says that every thread has dropped
signal->live, it does not say how far the other threads got in
do_exit(). One of them can still be inside fill_tgid_exit() adding
its counters to the struct while the last thread copies it out, so
the copy can read the struct in the middle of an update.

The commit that added the copy assumed no locking was needed because
the group was dead:

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

The listeners receive a partially updated tgid snapshot, with some
fields from before the concurrent update and some from after. There
is no crash or splat, which is likely why this went unnoticed since
2006. A userspace model of the same shape, writer under a lock and
a lockless memcpy reader, produces millions of torn reads in a few
seconds.

Take siglock around the copy like every other access does. sighand
is still alive here because taskstats_exit() runs before
exit_notify(), and fill_tgid_exit() already takes this same lock
earlier in this function.

Fixes: ad4ecbcba728 ("[PATCH] delay accounting taskstats interface send tgid once")
Signed-off-by: Bradley Morgan <include@grrlz.net>

The only caller is do_exit(), which runs with irqs enabled, and
fill_tgid_exit() already takes the same lock with spin_lock_irq().
Use that instead of spin_lock_irqsave(). (Oleg)

---
Changes since V1:
- spin_lock_irq() instead of spin_lock_irqsave() (Oleg)
---
 kernel/taskstats.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index f31df72f0e9d..300fa06ac84a 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -635,7 +635,10 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	if (!stats)
 		goto err;
 
+	/* This was racy before, copy the stats under siglock. */
+	spin_lock_irq(&tsk->sighand->siglock);
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
+	spin_unlock_irq(&tsk->sighand->siglock);
 	stats->version = TASKSTATS_VERSION;
 
 send:
-- 
2.47.3


https://lore.kernel.org/all/5727577F-39B4-43AF-8E6B-003E9A980A12@grrlz.net/
--- Thanks!
"I'm not a very positive person" - Linus torvalds
