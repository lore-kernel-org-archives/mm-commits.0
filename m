Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AF6746E
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 01:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733274585; cv=none; b=Aqu0YqEfQeFGRl4cMX4Ovds+r1mSIwFe6X0G0+JTKP/WhJECDF4TbHY3CoY6Wral6X5uWLAElrmO0iCx/XiGH4IndB22u2k6RbY1MzlD7HXDMch+9Y+/WYnJ/s9smpP1VB8Z86V0dlefi8KWRysIo3HBSA5G0ikL3s5PveGGUZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733274585; c=relaxed/simple;
	bh=nmq8sI8bP2Am4NFQALm6KrZyLnQMZWIz+HPT+nPtUM0=;
	h=Date:To:From:Subject:Message-Id; b=K4IqmFQ50zHKYWlqX1VQTdS4HTHvvYcy7tqd8qx0ToNWAQo4SreZvzyn9cQjCjoyuAxkXhtwnU1+r/HnaPAwrC+xibMdJL4bBg2IzH694lg7+ni1Z/Sb9MeNfje/b2D6UcFRarzugtNHEI6NoeXEOTarFkNBaKeHOR3yqDDayFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TEjg8tD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEjg8tD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283FEC4CEDC;
	Wed,  4 Dec 2024 01:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733274585;
	bh=nmq8sI8bP2Am4NFQALm6KrZyLnQMZWIz+HPT+nPtUM0=;
	h=Date:To:From:Subject:From;
	b=TEjg8tD0pHSoi7lMBL2NryMVmRzgzh6r4GI4UFuVURlKtbvs+pdQLtJw2RS+LB2U7
	 aHJW2RnNwyYwek3sPK1VxKr1r06wKAdKjh+PB8lHhFkT/jXlp1MRow4h7KDXy3KBi8
	 mctSmN5Mr3O7q+RKpYIlEvWHjSkkzj/UpAdKos/s=
Date: Tue, 03 Dec 2024 17:09:44 -0800
To: mm-commits@vger.kernel.org,zhang.yunkai@zte.com.cn,ye.xingchen@zte.com.cn,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yong12@zte.com.cn,tu.qiang35@zte.com.cn,jiang.kun2@zte.com.cn,he.peilin@zte.com.cn,fan.yu9@zte.com.cn,david@redhat.com,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + =utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===.patch added to mm-nonmm-unstable branch
Message-Id: <20241204010945.283FEC4CEDC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: delayacct: add delay max to record delay peak
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     =utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/=utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: delayacct: add delay max to record delay peak
Date: Tue, 3 Dec 2024 16:48:48 +0800 (CST)

Introduce the use cases of delay max, which can help quickly detect
potential abnormal delays in the system and record the types and specific
details of delay spikes.

Problem
========
Delay accounting can track the average delay of processes to show
system workload. However, when a process experiences a significant
delay, maybe a delay spike, which adversely affects performance,
getdelays can only display the average system delay over a period
of time. Yet, average delay is unhelpful for diagnosing delay peak.
It is not even possible to determine which type of delay has spiked,
as this information might be masked by the average delay.

Solution
=========
the 'delay max' can display delay peak since the system's startup,
which can record potential abnormal delays over time, including
the type of delay and the maximum delay. This is helpful for
quickly identifying crash caused by delay.

Use case
=========
bash# ./getdelays -d -p 244
print delayacct stats ON
PID     244

CPU             count     real total  virtual total    delay total  delay average      delay max
                   68      192000000      213676651         705643          0.010ms     0.306381ms
IO              count    delay total  delay average      delay max
                    0              0          0.000ms     0.000000ms
SWAP            count    delay total  delay average      delay max
                    0              0          0.000ms     0.000000ms
RECLAIM         count    delay total  delay average      delay max
                    0              0          0.000ms     0.000000ms
THRASHING       count    delay total  delay average      delay max
                    0              0          0.000ms     0.000000ms
COMPACT         count    delay total  delay average      delay max
                    0              0          0.000ms     0.000000ms
WPCOPY          count    delay total  delay average      delay max
                  235       15648284          0.067ms     0.263842ms
IRQ             count    delay total  delay average      delay max
                    0              0          0.000ms     0.000000ms

Link: https://lkml.kernel.org/r/20241203164848805CS62CQPQWG9GLdQj2_BxS@zte.com.cn
Co-developed-by: Wang Yong <wang.yong12@zte.com.cn>
Signed-off-by: Wang Yong <wang.yong12@zte.com.cn>
Co-developed-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Kun Jiang <jiang.kun2@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Peilin He <he.peilin@zte.com.cn>
Cc: tuqiang <tu.qiang35@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: ye xingchen <ye.xingchen@zte.com.cn>
Cc: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delayacct.h      |    7 +++
 include/linux/sched.h          |    3 +
 include/uapi/linux/taskstats.h |    9 ++++
 kernel/delayacct.c             |   35 +++++++++++++-----
 kernel/sched/stats.h           |    5 ++
 tools/accounting/getdelays.c   |   59 +++++++++++++++++--------------
 6 files changed, 83 insertions(+), 35 deletions(-)

--- a/include/linux/delayacct.h~=utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===
+++ a/include/linux/delayacct.h
@@ -29,25 +29,32 @@ struct task_delay_info {
 	 * XXX_delay contains the accumulated delay time in nanoseconds.
 	 */
 	u64 blkio_start;
+	u64 blkio_delay_max;
 	u64 blkio_delay;	/* wait for sync block io completion */
 	u64 swapin_start;
+	u64 swapin_delay_max;
 	u64 swapin_delay;	/* wait for swapin */
 	u32 blkio_count;	/* total count of the number of sync block */
 				/* io operations performed */
 	u32 swapin_count;	/* total count of swapin */
 
 	u64 freepages_start;
+	u64 freepages_delay_max;
 	u64 freepages_delay;	/* wait for memory reclaim */
 
 	u64 thrashing_start;
+	u64 thrashing_delay_max;
 	u64 thrashing_delay;	/* wait for thrashing page */
 
 	u64 compact_start;
+	u64 compact_delay_max;
 	u64 compact_delay;	/* wait for memory compact */
 
 	u64 wpcopy_start;
+	u64 wpcopy_delay_max;
 	u64 wpcopy_delay;	/* wait for write-protect copy */
 
+	u64 irq_delay_max;
 	u64 irq_delay;	/* wait for IRQ/SOFTIRQ */
 
 	u32 freepages_count;	/* total count of memory reclaim */
--- a/include/linux/sched.h~=utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===
+++ a/include/linux/sched.h
@@ -398,6 +398,9 @@ struct sched_info {
 	/* Time spent waiting on a runqueue: */
 	unsigned long long		run_delay;
 
+	/* Max time spent waiting on a runqueue: */
+	unsigned long long		max_run_delay;
+
 	/* Timestamps: */
 
 	/* When did we last run on a CPU? */
--- a/include/uapi/linux/taskstats.h~=utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===
+++ a/include/uapi/linux/taskstats.h
@@ -72,6 +72,7 @@ struct taskstats {
 	 */
 	__u64	cpu_count __attribute__((aligned(8)));
 	__u64	cpu_delay_total;
+	__u64	cpu_delay_max;
 
 	/* Following four fields atomically updated using task->delays->lock */
 
@@ -80,10 +81,12 @@ struct taskstats {
 	 */
 	__u64	blkio_count;
 	__u64	blkio_delay_total;
+	__u64	blkio_delay_max;
 
 	/* Delay waiting for page fault I/O (swap in only) */
 	__u64	swapin_count;
 	__u64	swapin_delay_total;
+	__u64	swapin_delay_max;
 
 	/* cpu "wall-clock" running time
 	 * On some architectures, value will adjust for cpu time stolen
@@ -166,10 +169,12 @@ struct taskstats {
 	/* Delay waiting for memory reclaim */
 	__u64	freepages_count;
 	__u64	freepages_delay_total;
+	__u64	freepages_delay_max;
 
 	/* Delay waiting for thrashing page */
 	__u64	thrashing_count;
 	__u64	thrashing_delay_total;
+	__u64	thrashing_delay_max;
 
 	/* v10: 64-bit btime to avoid overflow */
 	__u64	ac_btime64;		/* 64-bit begin time */
@@ -177,6 +182,7 @@ struct taskstats {
 	/* v11: Delay waiting for memory compact */
 	__u64	compact_count;
 	__u64	compact_delay_total;
+	__u64	compact_delay_max;
 
 	/* v12 begin */
 	__u32   ac_tgid;	/* thread group ID */
@@ -198,10 +204,13 @@ struct taskstats {
 	/* v13: Delay waiting for write-protect copy */
 	__u64    wpcopy_count;
 	__u64    wpcopy_delay_total;
+	__u64    wpcopy_delay_max;
 
 	/* v14: Delay waiting for IRQ/SOFTIRQ */
 	__u64    irq_count;
 	__u64    irq_delay_total;
+	__u64    irq_delay_max;
+	/* v15: add Delay max */
 };
 
 
--- a/kernel/delayacct.c~=utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===
+++ a/kernel/delayacct.c
@@ -95,7 +95,7 @@ void __delayacct_tsk_init(struct task_st
  * Finish delay accounting for a statistic using its timestamps (@start),
  * accumalator (@total) and @count
  */
-static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total, u32 *count)
+static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total, u32 *count, u64 *max)
 {
 	s64 ns = local_clock() - *start;
 	unsigned long flags;
@@ -104,6 +104,8 @@ static void delayacct_end(raw_spinlock_t
 		raw_spin_lock_irqsave(lock, flags);
 		*total += ns;
 		(*count)++;
+		if (ns > *max)
+			*max = ns;
 		raw_spin_unlock_irqrestore(lock, flags);
 	}
 }
@@ -122,7 +124,8 @@ void __delayacct_blkio_end(struct task_s
 	delayacct_end(&p->delays->lock,
 		      &p->delays->blkio_start,
 		      &p->delays->blkio_delay,
-		      &p->delays->blkio_count);
+		      &p->delays->blkio_count,
+		      &p->delays->blkio_delay_max);
 }
 
 int delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
@@ -153,10 +156,11 @@ int delayacct_add_tsk(struct taskstats *
 
 	d->cpu_count += t1;
 
+	d->cpu_delay_max = tsk->sched_info.max_run_delay;
 	tmp = (s64)d->cpu_delay_total + t2;
 	d->cpu_delay_total = (tmp < (s64)d->cpu_delay_total) ? 0 : tmp;
-
 	tmp = (s64)d->cpu_run_virtual_total + t3;
+
 	d->cpu_run_virtual_total =
 		(tmp < (s64)d->cpu_run_virtual_total) ?	0 : tmp;
 
@@ -164,20 +168,26 @@ int delayacct_add_tsk(struct taskstats *
 		return 0;
 
 	/* zero XXX_total, non-zero XXX_count implies XXX stat overflowed */
-
 	raw_spin_lock_irqsave(&tsk->delays->lock, flags);
+	d->blkio_delay_max = tsk->delays->blkio_delay_max;
 	tmp = d->blkio_delay_total + tsk->delays->blkio_delay;
 	d->blkio_delay_total = (tmp < d->blkio_delay_total) ? 0 : tmp;
+	d->swapin_delay_max = tsk->delays->swapin_delay_max;
 	tmp = d->swapin_delay_total + tsk->delays->swapin_delay;
 	d->swapin_delay_total = (tmp < d->swapin_delay_total) ? 0 : tmp;
+	d->freepages_delay_max = tsk->delays->freepages_delay_max;
 	tmp = d->freepages_delay_total + tsk->delays->freepages_delay;
 	d->freepages_delay_total = (tmp < d->freepages_delay_total) ? 0 : tmp;
+	d->thrashing_delay_max = tsk->delays->thrashing_delay_max;
 	tmp = d->thrashing_delay_total + tsk->delays->thrashing_delay;
 	d->thrashing_delay_total = (tmp < d->thrashing_delay_total) ? 0 : tmp;
+	d->compact_delay_max = tsk->delays->compact_delay_max;
 	tmp = d->compact_delay_total + tsk->delays->compact_delay;
 	d->compact_delay_total = (tmp < d->compact_delay_total) ? 0 : tmp;
+	d->wpcopy_delay_max = tsk->delays->wpcopy_delay_max;
 	tmp = d->wpcopy_delay_total + tsk->delays->wpcopy_delay;
 	d->wpcopy_delay_total = (tmp < d->wpcopy_delay_total) ? 0 : tmp;
+	d->irq_delay_max = tsk->delays->irq_delay_max;
 	tmp = d->irq_delay_total + tsk->delays->irq_delay;
 	d->irq_delay_total = (tmp < d->irq_delay_total) ? 0 : tmp;
 	d->blkio_count += tsk->delays->blkio_count;
@@ -213,7 +223,8 @@ void __delayacct_freepages_end(void)
 	delayacct_end(&current->delays->lock,
 		      &current->delays->freepages_start,
 		      &current->delays->freepages_delay,
-		      &current->delays->freepages_count);
+		      &current->delays->freepages_count,
+		      &current->delays->freepages_delay_max);
 }
 
 void __delayacct_thrashing_start(bool *in_thrashing)
@@ -235,7 +246,8 @@ void __delayacct_thrashing_end(bool *in_
 	delayacct_end(&current->delays->lock,
 		      &current->delays->thrashing_start,
 		      &current->delays->thrashing_delay,
-		      &current->delays->thrashing_count);
+		      &current->delays->thrashing_count,
+		      &current->delays->thrashing_delay_max);
 }
 
 void __delayacct_swapin_start(void)
@@ -248,7 +260,8 @@ void __delayacct_swapin_end(void)
 	delayacct_end(&current->delays->lock,
 		      &current->delays->swapin_start,
 		      &current->delays->swapin_delay,
-		      &current->delays->swapin_count);
+		      &current->delays->swapin_count,
+		      &current->delays->swapin_delay_max);
 }
 
 void __delayacct_compact_start(void)
@@ -261,7 +274,8 @@ void __delayacct_compact_end(void)
 	delayacct_end(&current->delays->lock,
 		      &current->delays->compact_start,
 		      &current->delays->compact_delay,
-		      &current->delays->compact_count);
+		      &current->delays->compact_count,
+		      &current->delays->compact_delay_max);
 }
 
 void __delayacct_wpcopy_start(void)
@@ -274,7 +288,8 @@ void __delayacct_wpcopy_end(void)
 	delayacct_end(&current->delays->lock,
 		      &current->delays->wpcopy_start,
 		      &current->delays->wpcopy_delay,
-		      &current->delays->wpcopy_count);
+		      &current->delays->wpcopy_count,
+		      &current->delays->wpcopy_delay_max);
 }
 
 void __delayacct_irq(struct task_struct *task, u32 delta)
@@ -284,6 +299,8 @@ void __delayacct_irq(struct task_struct
 	raw_spin_lock_irqsave(&task->delays->lock, flags);
 	task->delays->irq_delay += delta;
 	task->delays->irq_count++;
+	if (delta > task->delays->irq_delay_max)
+		task->delays->irq_delay_max = delta;
 	raw_spin_unlock_irqrestore(&task->delays->lock, flags);
 }
 
--- a/kernel/sched/stats.h~=utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===
+++ a/kernel/sched/stats.h
@@ -244,7 +244,8 @@ static inline void sched_info_dequeue(st
 	delta = rq_clock(rq) - t->sched_info.last_queued;
 	t->sched_info.last_queued = 0;
 	t->sched_info.run_delay += delta;
-
+	if (delta > t->sched_info.max_run_delay)
+		t->sched_info.max_run_delay = delta;
 	rq_sched_info_dequeue(rq, delta);
 }
 
@@ -266,6 +267,8 @@ static void sched_info_arrive(struct rq
 	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;
+	if (delta > t->sched_info.max_run_delay)
+		t->sched_info.max_run_delay = delta;
 
 	rq_sched_info_arrive(rq, delta);
 }
--- a/tools/accounting/getdelays.c~=utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===
+++ a/tools/accounting/getdelays.c
@@ -192,60 +192,69 @@ static int get_family_id(int sd)
 }
 
 #define average_ms(t, c) (t / 1000000ULL / (c ? c : 1))
+#define delay_max_ms(t) (t / 1000000ULL)
 
 static void print_delayacct(struct taskstats *t)
 {
-	printf("\n\nCPU   %15s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15llu%15llu%15.3fms\n"
-	       "IO    %15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms\n"
-	       "SWAP  %15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms\n"
-	       "RECLAIM  %12s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms\n"
-	       "THRASHING%12s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms\n"
-	       "COMPACT  %12s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms\n"
-	       "WPCOPY   %12s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms\n"
-	       "IRQ   %15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms\n",
+	printf("\n\nCPU   %15s%15s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15llu%15llu%15.3fms%13.6fms\n"
+	       "IO    %15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms\n"
+	       "SWAP  %15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms\n"
+	       "RECLAIM  %12s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms\n"
+	       "THRASHING%12s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms\n"
+	       "COMPACT  %12s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms\n"
+	       "WPCOPY   %12s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms\n"
+	       "IRQ   %15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms\n",
 	       "count", "real total", "virtual total",
-	       "delay total", "delay average",
+	       "delay total", "delay average", "delay max",
 	       (unsigned long long)t->cpu_count,
 	       (unsigned long long)t->cpu_run_real_total,
 	       (unsigned long long)t->cpu_run_virtual_total,
 	       (unsigned long long)t->cpu_delay_total,
 	       average_ms((double)t->cpu_delay_total, t->cpu_count),
-	       "count", "delay total", "delay average",
+		   delay_max_ms((double)t->cpu_delay_max),
+	       "count", "delay total", "delay average", "delay max",
 	       (unsigned long long)t->blkio_count,
 	       (unsigned long long)t->blkio_delay_total,
 	       average_ms((double)t->blkio_delay_total, t->blkio_count),
-	       "count", "delay total", "delay average",
+		   delay_max_ms((double)t->blkio_delay_max),
+	       "count", "delay total", "delay average", "delay max",
 	       (unsigned long long)t->swapin_count,
 	       (unsigned long long)t->swapin_delay_total,
 	       average_ms((double)t->swapin_delay_total, t->swapin_count),
-	       "count", "delay total", "delay average",
+		   delay_max_ms((double)t->swapin_delay_max),
+	       "count", "delay total", "delay average", "delay max",
 	       (unsigned long long)t->freepages_count,
 	       (unsigned long long)t->freepages_delay_total,
 	       average_ms((double)t->freepages_delay_total, t->freepages_count),
-	       "count", "delay total", "delay average",
+		   delay_max_ms((double)t->freepages_delay_max),
+	       "count", "delay total", "delay average", "delay max",
 	       (unsigned long long)t->thrashing_count,
 	       (unsigned long long)t->thrashing_delay_total,
 	       average_ms((double)t->thrashing_delay_total, t->thrashing_count),
-	       "count", "delay total", "delay average",
+		   delay_max_ms((double)t->thrashing_delay_max),
+	       "count", "delay total", "delay average", "delay max",
 	       (unsigned long long)t->compact_count,
 	       (unsigned long long)t->compact_delay_total,
 	       average_ms((double)t->compact_delay_total, t->compact_count),
-	       "count", "delay total", "delay average",
+		   delay_max_ms((double)t->compact_delay_max),
+	       "count", "delay total", "delay average", "delay max",
 	       (unsigned long long)t->wpcopy_count,
 	       (unsigned long long)t->wpcopy_delay_total,
 	       average_ms((double)t->wpcopy_delay_total, t->wpcopy_count),
-	       "count", "delay total", "delay average",
+		   delay_max_ms((double)t->wpcopy_delay_max),
+	       "count", "delay total", "delay average", "delay max",
 	       (unsigned long long)t->irq_count,
 	       (unsigned long long)t->irq_delay_total,
-	       average_ms((double)t->irq_delay_total, t->irq_count));
+	       average_ms((double)t->irq_delay_total, t->irq_count),
+		   delay_max_ms((double)t->irq_delay_max));
 }
 
 static void task_context_switch_counts(struct taskstats *t)
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

=utf-8bw1bbveniigxpbnv4ig5lehrdigrlbgf5ywnjddogywrkigrlbgf5ig1hecb0bybyzwnvcmqgzgvsyxkgcgvhaw===.patch

