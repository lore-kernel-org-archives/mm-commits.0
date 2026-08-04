Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E865439DBCD
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 20:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785876843; cv=none; b=FhQPzBKd5BnFYcD0e+1+8YQYon4u9vdkF6CKwGF3Ua2mb+shu01KE4fc0u7lqq4KV5skRntHRUqlpJVUmYzWuaKcFWGXgK4GJkQbX7NpTOezYDWGHBAr/aqy3xnPPX9LRkMwvCwAX7szrv23fRTfrHnxWEcGb8dsfOb+3tPgSQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785876843; c=relaxed/simple;
	bh=nzYLNJ9by6byl81waKdSeRGc6ywBL63/5yjg+U2jkaU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=eriupbN8k/eRD9oO7Jv9TBfBHZAW6QZFJ6iN3r7S/+R8M9/MEvRI6RDIEgfGYLsW0RRq3so4ibEFwmUSTdcP2thkTYCRdN4tLY+Eqo28UT8cA0OKR5COEPbL3RsOfvmEE3bxld/vXORj5atprd/lZ/jvCQh8xVHyFFtRhrI1RGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=aicQh66Y; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="aicQh66Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1785876837;
	bh=jFyCzro9wPuL3RVgWSc2DOlV8DF4vBIgDMMnziU8aPU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=aicQh66Ysz/uIs5RDzlqlDkQ/G/Pj2GtzD6GLLsLumf1ZXTM7HnrGmmCKrQDeNiiN
	 v1NNz4Mi4sfM2ZCPUZjbfJ7gS8jLw/Q8rjafH8EDz/B41gMdio2nk27bci60ZFV66z
	 Enu5tv6NscQeEE1inf2DZIGPxF+7mnxXhpp9h+eM=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4hF5PK19cyz12MZ;
	Tue, 04 Aug 2026 20:53:57 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4hF5PJ5B3Pz12Lx;
	Tue, 04 Aug 2026 20:53:56 +0000 (UTC)
Date: Tue, 04 Aug 2026 21:53:56 +0100
From: Bradley Morgan <include@grrlz.net>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: mm-commits@vger.kernel.org, bsingharora@gmail.com
Subject: =?US-ASCII?Q?Re=3A_+_taskstats-copy-signal-stats-under-siglock-in-t?=
 =?US-ASCII?Q?askstats=5Fexit=2Epatch_added_to_mm-nonmm-unstable_branch?=
In-Reply-To: <anJN-w0et3CXG64B@redhat.com>
References: <20260804200407.E858F1F000E9@smtp.kernel.org> <anJN-w0et3CXG64B@redhat.com>
Message-ID: <5727577F-39B4-43AF-8E6B-003E9A980A12@grrlz.net>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 4 August 2026 21:39:23 BST, Oleg Nesterov <oleg@redhat.com> wrote:
>On 08/04, Andrew Morton wrote:
>>
>> From: Bradley Morgan <include@grrlz.net>
>> Subject: taskstats: copy signal->stats under siglock in taskstats_exit
>
>...
>
>> ---
>a/kernel/taskstats.c~taskstats-copy-signal-stats-under-siglock-in-taskstats_exit
>> +++ a/kernel/taskstats.c
>> @@ -590,6 +590,7 @@ void taskstats_exit(struct task_struct *
>>  	struct sk_buff *rep_skb;
>>  	size_t size;
>>  	int is_thread_group;
>> +	unsigned long flags;
>>  
>>  	if (!family_registered)
>>  		return;
>> @@ -635,7 +636,10 @@ void taskstats_exit(struct task_struct *
>>  	if (!stats)
>>  		goto err;
>>  
>> +	/* This was racy before, copy the stats under siglock. */
>> +	spin_lock_irqsave(&tsk->sighand->siglock, flags);
>
>Why _irqsave? The only caller is do_exit(), and it obviously runs with
>irqs enabled?
>
>Oleg.
>
>


Thanks for the review, how's this?

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

Thanks!
