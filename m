Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141CD17C77
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 01:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767058325; cv=none; b=gVYLRavpK4iI9up8EX00joeMFZKI6JUtp7R1azpC1kwuWmgieYKDx9dE8J1284uY6DlLNq5R6oPD3nZDcGS/8aJ0ITSZ8QVg+UIxuI8l6zQC1h0LB8zOPk7cwiPxUOl2OFNXssyfsMqFlAbdkHpysUadCyvClD8q6lyoY+jQcoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767058325; c=relaxed/simple;
	bh=4gYekPcKQTBW4Bbym7rRtJ/vzcFqcRScn1z5XEV62m4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=b/oRRnua91DslhgjxNQtr2Pw5jmY0bqlYQXGxbpNCvyyMRMbTVUcDKqKoA+rQDYPRQkHyKsgXY5FbwRHHpaRJUJe9gv9I/6n1HO/JP/gMk4H7GMjHzc0uzjIGKr0aqpAQ1vVpjmP9aj6apwkXEGvIMp0ktk0TwIj2bY3T8IeaEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=csatFBld; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="csatFBld"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767058320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y471qpYNaZ+Dyu3s6VVvcBiC7r1TKZAuj5Z1lKi1Kf8=;
	b=csatFBldwn2FoPodwO2Ck5F23WEGO77bUS4wjn6a+8JE8CvrcFf18C9YtgG60VtgZ+L8KW
	p6AueB4Ev37iEg3stfsmXKRd6YXEhw9UCgjvMln8c0nfCAdsB2FKpi0wJ2Ark0ua6G3mCD
	zouIGkAy9MO0h7QPoiJMufXI5FIBN6U=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
 viro@zeniv.linux.org.uk, vbabka@suse.cz, tj@kernel.org,
 tglx@linutronix.de, sweettea-kernel@dorminy.me, surenb@google.com,
 sj@kernel.org, shakeel.butt@linux.dev, rppt@kernel.org,
 rostedt@goodmis.org, rientjes@google.com, richard.weiyang@gmail.com,
 paulmck@kernel.org, mjguzik@gmail.com, mhocko@suse.com,
 mhiramat@kernel.org, lorenzo.stoakes@oracle.com, liumartin@google.com,
 linmiaohe@huawei.com, liam.howlett@oracle.com, hannes@cmpxchg.org,
 dennis@kernel.org, david@redhat.com, cl@linux.com,
 christian.koenig@amd.com, broonie@kernel.org, brauner@kernel.org,
 baolin.wang@linux.alibaba.com, aboorvad@linux.ibm.com,
 mathieu.desnoyers@efficios.com
Subject: Re: + mm-implement-precise-oom-killer-task-selection.patch added to
 mm-new branch
In-Reply-To: <20251228222349.36756C4CEFB@smtp.kernel.org> (Andrew Morton's
	message of "Sun, 28 Dec 2025 14:23:48 -0800")
References: <20251228222349.36756C4CEFB@smtp.kernel.org>
Date: Tue, 30 Dec 2025 01:31:31 +0000
Message-ID: <7ia4344ssqks.fsf@castle.c.googlers.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT

Andrew Morton <akpm@linux-foundation.org> writes:

I ran this patchset through AI review and the output is below.
I doubt all its findings are real, but some look real or at least
deserve a bold comment in the code.

# Task
Date: 2025-12-29 23:29:17
Model: gemini-3-pro-preview
Prompts SHA: 192922ae6bf4 ("bpf.md: adjust the documentation about bpf kfunc parameter validation")
Commits to review:
- b7b2e54e5e66 ("tsacct: skip all kernel threads")
- c638fa35f0de ("lib: introduce hierarchical per-cpu counters")
- 6c90884cf3c3 ("mm: fix OOM killer inaccuracy on large many-core systems")
- b886461533a8 ("mm: implement precise OOM killer task selection")


# Commit b7b2e54e5e66 ("tsacct: skip all kernel threads")
No detailed regression report generated.

# Commit c638fa35f0de ("lib: introduce hierarchical per-cpu counters")
commit c638fa35f0de08d4089645381404f0f203307a59
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

lib: introduce hierarchical per-cpu counters

The patch introduces a library for hierarchical per-cpu counters to improve
scalability of RSS tracking. It implements a tree-based propagation of
counter values.

> diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
> new file mode 100644
> index 000000000000..9b7ae7df5530
> --- /dev/null
> +++ b/lib/percpu_counter_tree.c
[ ... ]
> +int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
> +				  unsigned int nr_counters, unsigned int batch_size, gfp_t gfp_flags)
> +{
> +	void __percpu *level0, *level0_iter;
> +	size_t counter_size, items_size = 0;
 > +	void *items_iter;
> +	unsigned int i;
> +	int ret;
> +
> +	counter_size = ALIGN(sizeof(*counters), __alignof__(*counters));
> +	level0 = __alloc_percpu_gfp(nr_counters * counter_size,
> +				    __alignof__(*counters), gfp_flags);

Does `counter_size` allocate `sizeof(struct percpu_counter_tree)` per CPU?
The `level0` pointer is `unsigned int __percpu *`, suggesting only 4 bytes are
needed per CPU. Allocating the full struct size seems to result in significant
per-CPU memory overhead (e.g. ~64 bytes instead of 4).

> +	if (!level0)
> +		return -ENOMEM;
[ ... ]


# Commit 6c90884cf3c3 ("mm: fix OOM killer inaccuracy on large many-core systems")
commit 6c90884cf3c3244fc6ea4f63b4122eb4d2163c61
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

mm: fix OOM killer inaccuracy on large many-core systems

Use hierarchical per-cpu counters for rss tracking to fix the per-mm RSS
tracking which has become too inaccurate for OOM killer purposes on large
many-core systems.

Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
Link: https://lore.kernel.org/lkml/20250704150226.47980-1-mathieu.desnoyers@efficios.com/
Link: https://lkml.kernel.org/r/20251224174638.650551-3-mathieu.desnoyers@efficios.com

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 67865c1d92bc..e2fe66aed267 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2843,38 +2843,56 @@ static inline bool get_user_page_fast_only(unsigned long addr,
>  {
>  	return get_user_pages_fast_only(addr, 1, gup_flags, pagep) == 1;
>  }
> +
> +static inline size_t get_rss_stat_items_size(void)
> +{
> +	return percpu_counter_tree_items_size() * NR_MM_COUNTERS;
> +}
> +
> +static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct mm_struct *mm)
> +{
> +	unsigned long ptr = (unsigned long)mm;
> +
> +	ptr += offsetof(struct mm_struct, flexible_array);
> +	/* Skip cpu_bitmap */
> +	ptr += cpumask_size();
> +	/* Skip mm_cidmask */
> +	ptr += mm_cid_size();
> +	return (struct percpu_counter_tree_level_item *)ptr;
> +}

The `struct percpu_counter_tree_level_item` is defined with
`____cacheline_aligned_in_smp`. `cpumask_size()` and `mm_cid_size()` return
sizes aligned to `sizeof(unsigned long)`, which is typically 8 bytes on 64-bit
architectures.

Does this manual placement guarantee the cacheline alignment required by
`____cacheline_aligned_in_smp`? If `ptr` is not 64-byte aligned, could this
lead to false sharing or other alignment-related issues that the attribute was
intended to prevent?

> +
>  /*
>   * per-process(per-mm_struct) statistics.
>   */
>  static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
>  {
> -	return percpu_counter_read_positive(&mm->rss_stat[member]);
> +	return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
>  }

`percpu_counter_tree_approximate_sum_positive` returns an `int`. The previous
implementation used `percpu_counter_read_positive`, which returns `s64`.

On large memory systems (like the one mentioned in the commit message with >6TB
capacity), is it possible for an RSS counter to exceed 2^31 pages (8TB)? If so,
will this 32-bit `int` return type cause the counter to overflow or wrap unexpectedly?

>  
>  static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
>  {
> -	return percpu_counter_sum_positive(&mm->rss_stat[member]);
> +	return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
>  }
>  
>  void mm_trace_rss_stat(struct mm_struct *mm, int member);
>  
>  static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
>  {
> -	percpu_counter_add(&mm->rss_stat[member], value);
> +	percpu_counter_tree_add(&mm->rss_stat[member], value);
>  
>  	mm_trace_rss_stat(mm, member);
>  }

`add_mm_counter` takes a `long value`, but `percpu_counter_tree_add` takes an
`int inc`.

Is it possible for `value` to exceed the range of an `int` (e.g., during large
batch updates), leading to truncation of the increment?

[ ... ]

> diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
> index 7f93e754da5c..91c81c44f884 100644
> --- a/include/trace/events/kmem.h
> +++ b/include/trace/events/kmem.h
> @@ -442,7 +442,7 @@ TRACE_EVENT(rss_stat,
>  		__entry->mm_id = mm_ptr_to_hash(mm);
>  		__entry->curr = !!(current->mm == mm);
>  		__entry->member = member;
> -		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
> +		__entry->size = (percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member])
>  							    << PAGE_SHIFT);
>  	),

`percpu_counter_tree_approximate_sum_positive` returns an `int`. When shifted
by `PAGE_SHIFT` (typically 12), the result is calculated as a 32-bit integer
before being assigned to `__entry->size` (which is a `long`).

If the counter value exceeds 2^20 (1 million pages, approx 4GB), will this
shift operation cause an integer overflow, resulting in incorrect trace output?

# Commit b886461533a8 ("mm: implement precise OOM killer task selection")
commit b886461533a8bdfe37a9f4b62e606da7c31d886b
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

mm: implement precise OOM killer task selection

This patch implements a 2-pass OOM killer task selection algorithm using per-CPU tree counters. The first pass uses an approximate badness score, and the second pass calculates a precise score only for tasks within the accuracy range of the current best candidate.

Link: https://lkml.kernel.org/r/20251224174638.650551-4-mathieu.desnoyers@efficios.com

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e2fe66aed267..8d9e3239d2cc 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
[ ... ]
>  static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
>  {
> -	return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
> +	return __get_mm_counter(mm, member, true, NULL, NULL);
>  }
>  
> +
>  static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
>  {
> -	return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
> +	return get_mm_counter(mm, member);
>  }

It looks like get_mm_counter_sum() was previously providing a precise sum
using percpu_counter_tree_precise_sum_positive(), but now it aliases to
get_mm_counter() which uses the approximate calculation.

This function is used by task_mem() and task_statm() in fs/proc/task_mmu.c.
Does this change imply that /proc/<pid>/status and /proc/<pid>/statm values
(like VmRSS) are now approximate? If so, is this intended for all users of
these interfaces?

[ ... ]
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 94066316e3ec..14421e29a7da 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
[ ... ]
> @@ -339,9 +353,28 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
>  		goto select;
>  	}
>  
> -	points = oom_badness(task, oc->totalpages);
> -	if (points == LONG_MIN || points < oc->chosen_points)
> -		goto next;
> +	points = oom_badness(task, oc->totalpages, true, &accuracy_under, &accuracy_over);
> +	if (oc->approximate) {
> +		if (points == LONG_MIN || points < oc->chosen_points)
> +			goto next;
> +	} else {
> +		/*
> +		 * Eliminate processes which are below the chosen
> +		 * points accuracy range with an approximation.
> +		 */
> +		if (points == LONG_MIN || (long)(points + accuracy_over + oc->accuracy_under - oc->chosen_points) < 0)
> +			goto next;

The check here seems to use accuracy_over for the current task's points and
oc->accuracy_under for the chosen task's points.

If I understand the bounds correctly from percpu_counter_tree.h:
(precise - under) <= approx <= (precise + over)
So: precise <= approx + under

To skip safely, we want to ensure the maximum possible precise value of the
current task is less than the minimum possible precise value of the chosen
task.

current_max_precise = points + accuracy_under
chosen_min_precise = oc->chosen_points - oc->chosen_accuracy_over

It looks like struct oom_control does not have an accuracy_over field,
and this check uses oc->accuracy_under instead. Without tracking the
"over" error for the chosen task, can we safely calculate its minimum
precise score?

Also, assuming we had the correct values, shouldn't the check be:
(points + accuracy_under) < (oc->chosen_points - oc->accuracy_over)

The current logic appears to compare:
(points + accuracy_over) < (oc->chosen_points - oc->accuracy_under)

Which checks if (current_min_precise < chosen_max_precise), effectively
skipping any task that *might* be worse, rather than only tasks that
*must* be worse. Does this risk skipping valid candidates that have overlapping
error ranges with the chosen task?

> +
> +		if (oc->nr_precise < max_precise_badness_sums) {
[ ... ]


# Summary

| Commit                                                                    | Regressions |
| :------------------------------------------------------------------------ | :---------- |
| b7b2e54e5e66 ("tsacct: skip all kernel threads")                          | 0           |
| c638fa35f0de ("lib: introduce hierarchical per-cpu counters")             | 1           |
| 6c90884cf3c3 ("mm: fix OOM killer inaccuracy on large many-core systems") | 4           |
| b886461533a8 ("mm: implement precise OOM killer task selection")          | 2           |
