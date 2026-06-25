Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30B71F2B88
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 03:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782358193; cv=none; b=IST/bIBxs/BxZjLqcg9tflRxlDpXHBZpYSqSj4zA4pLgRTo0XIa2adsFJdJZr1/b5dSauKovSEmDciI/nZscI4S7sOLFZqPtoSrDnUljaORwEga31adOJY3kV8s8/JhIUqbvu0Atmrz8dpokID0xM4L8j/eu9TFrpbxkgpG6Qso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782358193; c=relaxed/simple;
	bh=Hgfo+nwtOkiXYcQJ/K6CgApAzSVhylHkUF+pW2c9gMk=;
	h=Date:To:From:Subject:Message-Id; b=ZidCfmXM7s/8/6FrLpLJnKCGzbi87aPypsFqlokSMsV0K4fH/ArCqxlftWAYv4o2Eqomm2ANMVp6zy/dVtlfxvpxqjDpKzjOaPj5LpzIvYI1qfdymiuGaQSLgReXfga9hwQ+nunwGTSQe5mYErwZIZpbrCU4e700CvjMIdYG4XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y1sEn2GC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y1sEn2GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC631F000E9;
	Thu, 25 Jun 2026 03:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782358192;
	bh=B04230WKtsKnqsR3nHn715EGs1+yrZf0McVuE8ssSR4=;
	h=Date:To:From:Subject;
	b=Y1sEn2GCYQ1/JKCBsOFGTLLp2VrLTp1GU6Ux93q3hdRv0PC7FJoebYOs4gPnG0tVD
	 GVAXS7VAvTCJ9xHX+XJoiy9EFbomPaW4xJNgQJbIsJgo4uaA9EeM5Ox74ZwvSOfBrU
	 HFguXrXgdPV17zU8xym0lrOJ0E8ANBj2hjq15ETI=
Date: Wed, 24 Jun 2026 20:29:51 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,surenb@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mgorman@suse.de,kprateek.nayak@amd.com,juri.lelli@redhat.com,hannes@cmpxchg.org,dietmar.eggemann@arm.com,david@kernel.org,chengming.zhou@linux.dev,bsegall@google.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-psi-skip-irqtime-accounting-when-no-new-irq-time-has-elapsed.patch added to mm-new branch
Message-Id: <20260625032952.2FC631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched/psi: skip irqtime accounting when no new irq time has elapsed
has been added to the -mm mm-new branch.  Its filename is
     sched-psi-skip-irqtime-accounting-when-no-new-irq-time-has-elapsed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-psi-skip-irqtime-accounting-when-no-new-irq-time-has-elapsed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Usama Arif <usama.arif@linux.dev>
Subject: sched/psi: skip irqtime accounting when no new irq time has elapsed
Date: Wed, 17 Jun 2026 10:50:06 -0700

psi_account_irqtime() reads irq_time_read() into a per-rq cumulative
counter and only bails out when the delta vs.  the previously accounted
amount is negative.  A delta of exactly zero is treated as "do the work":
psi_write_begin() is taken, cpu_clock(cpu) is read (which on x86 ends up
in native_sched_clock() / rdtsc) and the cgroup ancestor chain is walked
to add zero to every group's PSI_IRQ_FULL bucket.

The zero-delta case is common in practice -- it fires every time a context
switch crosses a PSI group boundary on a CPU that hasn't serviced an
interrupt between the two switches.

Measured on a 176-thread AMD EPYC 9D64 server running a compute intensive
production workload, instrumented with bpftrace over a 30s window
(irq_time_read() read directly from the per-CPU cpu_irqtime so that delta
== 0 and delta < 0 could be separated):

  @total              17,229,311    (100.0%)
  @ret_curr_swapper    7,864,195    ( 45.6%)  curr->pid == 0
  @ret_samegrp           323,299    (  1.9%)  same cgroup as prev
  @reached_delta       9,041,817    ( 52.5%)
    @delta_positive    6,358,192    ( 36.9%)  real work
    @delta_zero        2,683,625    ( 15.6%)  work wasted (this patch)
    @delta_negative          (0)    (  0.0%)  monotonic clock

So 15.6% of all psi_account_irqtime() calls - and 29.7% of the calls that
get past the early returns - hit the delta == 0 case; delta < 0 did not
occur once in the 30s window.  Under the current code each of those ~89k
calls per second performs the full seqcount write + cpu_clock() read +
cgroup-chain walk just to add 0 to every group's PSI_IRQ_FULL counter.

Extend the early-return to also cover delta == 0.  rq->psi_irq_time does
not need updating in that case (it would store the same value back) and no
PSI bucket would change.  The existing behaviour for delta > 0 is
untouched.

Link: https://lore.kernel.org/20260617175219.2494857-2-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/psi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/psi.c~sched-psi-skip-irqtime-accounting-when-no-new-irq-time-has-elapsed
+++ a/kernel/sched/psi.c
@@ -1023,7 +1023,7 @@ void psi_account_irqtime(struct rq *rq,
 
 	irq = irq_time_read(cpu);
 	delta = (s64)(irq - rq->psi_irq_time);
-	if (delta < 0)
+	if (delta <= 0)
 		return;
 	rq->psi_irq_time = irq;
 
_

Patches currently in -mm which might be from usama.arif@linux.dev are

sched-psi-skip-irqtime-accounting-when-no-new-irq-time-has-elapsed.patch

