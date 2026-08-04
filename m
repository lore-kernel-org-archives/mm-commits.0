Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC943EDE59;
	Tue,  4 Aug 2026 04:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816363; cv=none; b=d3MEDzJKqZTJlLZUMIeDFKGAiraFozd0N99b/qrJo+kSsCS/FzBYsFHmmJJPcF0U9hmcTUjagaUkxAbPNG8THGl0jCvDgZ/B1flLLC6B2eR38pqhuBm1OTmk/MQUr2n/2IveqMhc85dYbhS/Wusc9NeHZsi3usTueQLyfSJncqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816363; c=relaxed/simple;
	bh=as3HznrUyETCsy/Ql2xTC5SHaY0G1hqeE7qqiwiJ7EE=;
	h=Date:To:From:Subject:Message-Id; b=Zl0MWxP4BFd6grm0LIscbzeoh0t3sXYU8dot8zAi+3fMUgsFTwfzGcKxImrTLwSjcLUYgD/o5LsuvouSUUAHK1mO7rSbNuhBQsDPPBazKDMciwGb5K7iOgF7angRoZz6ne8iLBm56QA0/GwzFopAgmBB1+4BR839oBsiw4zPLRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xoMhKAUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xoMhKAUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E306B1F00A3A;
	Tue,  4 Aug 2026 04:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816362;
	bh=9Bv/w6WjPic0lsZbw/A663PTzLUonZfLSbYr8gq/FkY=;
	h=Date:To:From:Subject;
	b=xoMhKAUZfGmE7gID8YUPY7Xv7+4EKXFhqt7QI4IA6lmFPbAoxLtQIkSp5eVXEsPTM
	 WehVp0aZ/hD3ajEkZDjvlqVYdoQc8qEMW0J53e1UehgzCjADjxlS2Whk11FOZn0BB0
	 rbluu77lyT5R0gzh38aU6xb/ugYD5WB7h25CAVNI=
Date: Mon, 03 Aug 2026 21:06:01 -0700
To: mm-commits@vger.kernel.org,williams@redhat.com,stern@rowland.harvard.edu,stable@vger.kernel.org,roman.gushchin@linux.dev,hch@infradead.org,gregkh@linuxfoundation.org,glider@google.com,elver@google.com,dvyukov@google.com,broonie@kernel.org,bigeasy@linutronix.de,andreyknvl@gmail.com,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-fix-data-corruption-and-race-conditions-on-preempt_rt.patch removed from -mm tree
Message-Id: <20260804040601.E306B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: fix data corruption and race conditions on PREEMPT_RT
has been removed from the -mm tree.  Its filename was
     kcov-fix-data-corruption-and-race-conditions-on-preempt_rt.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: kcov: fix data corruption and race conditions on PREEMPT_RT
Date: Thu, 16 Jul 2026 08:01:29 +0900

syzbot is reporting KCOV state corruption on PREEMPT_RT kernels, for the
temporary storage used for saving/restoring remote KCOV state is currently
allocated as the per-CPU area.

On PREEMPT_RT kernels, softirq handlers run as preemptible task threads
(e.g., ksoftirqd). If a softirq context preempts a task running a remote
KCOV session, it safely saves the task's state into the per-CPU area.
However, if that softirq thread is subsequently preempted by a higher-
priority softirq thread on the same CPU, the second softirq will overwrite
the same per-CPU area, permanently destroying the original task's KCOV
state.

Fix this data corruption by moving the temporary storage from the per-CPU
area to the per-thread area. Since each softirq thread now owns its own
task context, nested softirq preemption no longer causes data overwrites.

Note that while the temporary storage is now on a per-thread basis, the
per-CPU kcov_percpu_data.lock must be retained, for we need to ensure that
kcov_remote_start() and kcov_remote_stop() operate atomically without
racing against asynchronous interrupts that manipulate the current task's
KCOV state.

It is likely that GFP_KERNEL allocation by vmalloc_node() in kcov_init()
has already called panic() before returning NULL, for there will be no
OOM-killable userspace processes when __init function of built-in module
runs. But this patch also fixes crashing the kernel when vmalloc_node()
in kcov_init() returned NULL, for kcov_init() left per-CPU irq_area == NULL
but kcov_remote_start() depends on per-CPU irq_area != NULL, resulting in

  (1) doing vmalloc() in kcov_remote_start() despite !in_task() context

  (2) out-of-array-bounds access if (1) succeeded but
      kcov->remote_size < CONFIG_KCOV_IRQ_AREA_SIZE

  (3) always leak memory allocated by (1), eventually killing all
      OOM-killable userspace processes

problems.

Link: https://lore.kernel.org/43552d09-2ce2-4b19-b0d3-a2d1ab952145@I-love.SAKURA.ne.jp
Reported-by: syzbot+3f51ad7ac3ae57a6fdcc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3f51ad7ac3ae57a6fdcc
Reported-by: syzbot+47cf95ca1f9dcca872c8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=47cf95ca1f9dcca872c8
Reported-by: syzbot+8a173e13208949931dc7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8a173e13208949931dc7
Reported-by: syzbot+90984d3713722683112e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=90984d3713722683112e
Analyzed-by: AI Mode in Google Search (no mail address)
Fixes: 5ff3b30ab57d ("kcov: collect coverage from interrupts")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    8 +++
 kernel/kcov.c         |   90 ++++++++++++++++++++--------------------
 lib/Kconfig.debug     |    5 +-
 3 files changed, 58 insertions(+), 45 deletions(-)

--- a/include/linux/sched.h~kcov-fix-data-corruption-and-race-conditions-on-preempt_rt
+++ a/include/linux/sched.h
@@ -1544,6 +1544,14 @@ struct task_struct {
 
 	/* Collect coverage from softirq context: */
 	unsigned int			kcov_softirq;
+
+	/* Temporary storage for preempting remote coverage collection: */
+	unsigned int			kcov_saved_mode;
+	unsigned int			kcov_saved_size;
+	void				*kcov_saved_area;
+	struct kcov			*kcov_saved_kcov;
+	int				kcov_saved_sequence;
+
 #endif
 
 #ifdef CONFIG_MEMCG_V1
--- a/kernel/kcov.c~kcov-fix-data-corruption-and-race-conditions-on-preempt_rt
+++ a/kernel/kcov.c
@@ -86,17 +86,12 @@ struct kcov_remote {
 
 static DEFINE_SPINLOCK(kcov_remote_lock);
 static DEFINE_HASHTABLE(kcov_remote_map, 4);
-static struct list_head kcov_remote_areas = LIST_HEAD_INIT(kcov_remote_areas);
+static struct list_head kcov_remote_areas[2] = {
+	LIST_HEAD_INIT(kcov_remote_areas[0]), LIST_HEAD_INIT(kcov_remote_areas[1])
+};
 
 struct kcov_percpu_data {
-	void			*irq_area;
 	local_lock_t		lock;
-
-	unsigned int		saved_mode;
-	unsigned int		saved_size;
-	void			*saved_area;
-	struct kcov		*saved_kcov;
-	int			saved_sequence;
 };
 
 static DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data) = {
@@ -132,12 +127,13 @@ static struct kcov_remote *kcov_remote_a
 }
 
 /* Must be called with kcov_remote_lock locked. */
-static struct kcov_remote_area *kcov_remote_area_get(unsigned int size)
+static struct kcov_remote_area *kcov_remote_area_get(unsigned int size, bool irq)
 {
 	struct kcov_remote_area *area;
 	struct list_head *pos;
+	struct list_head *list = &kcov_remote_areas[irq];
 
-	list_for_each(pos, &kcov_remote_areas) {
+	list_for_each(pos, list) {
 		area = list_entry(pos, struct kcov_remote_area, list);
 		if (area->size == size) {
 			list_del(&area->list);
@@ -149,11 +145,11 @@ static struct kcov_remote_area *kcov_rem
 
 /* Must be called with kcov_remote_lock locked. */
 static void kcov_remote_area_put(struct kcov_remote_area *area,
-					unsigned int size)
+				 unsigned int size, bool irq)
 {
 	INIT_LIST_HEAD(&area->list);
 	area->size = size;
-	list_add(&area->list, &kcov_remote_areas);
+	list_add(&area->list, &kcov_remote_areas[irq]);
 	/*
 	 * KMSAN doesn't instrument this file, so it may not know area->list
 	 * is initialized. Unpoison it explicitly to avoid reports in
@@ -390,6 +386,12 @@ void kcov_task_init(struct task_struct *
 	kcov_task_reset(t);
 	t->kcov_remote = NULL;
 	t->kcov_handle = current->kcov_handle;
+	t->kcov_softirq = 0;
+	t->kcov_saved_mode = 0;
+	t->kcov_saved_size = 0;
+	t->kcov_saved_area = NULL;
+	t->kcov_saved_kcov = NULL;
+	t->kcov_saved_sequence = 0;
 }
 
 static void kcov_reset(struct kcov *kcov)
@@ -836,17 +838,16 @@ static inline bool kcov_mode_enabled(uns
 static void kcov_remote_softirq_start(struct task_struct *t)
 	__must_hold(&kcov_percpu_data.lock)
 {
-	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
 	unsigned int mode;
 
 	mode = READ_ONCE(t->kcov_mode);
 	barrier();
 	if (kcov_mode_enabled(mode)) {
-		data->saved_mode = mode;
-		data->saved_size = t->kcov_size;
-		data->saved_area = t->kcov_area;
-		data->saved_sequence = t->kcov_sequence;
-		data->saved_kcov = t->kcov;
+		t->kcov_saved_mode = mode;
+		t->kcov_saved_size = t->kcov_size;
+		t->kcov_saved_area = t->kcov_area;
+		t->kcov_saved_sequence = t->kcov_sequence;
+		t->kcov_saved_kcov = t->kcov;
 		kcov_stop(t);
 	}
 }
@@ -854,17 +855,15 @@ static void kcov_remote_softirq_start(st
 static void kcov_remote_softirq_stop(struct task_struct *t)
 	__must_hold(&kcov_percpu_data.lock)
 {
-	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
-
-	if (data->saved_kcov) {
-		kcov_start(t, data->saved_kcov, data->saved_size,
-				data->saved_area, data->saved_mode,
-				data->saved_sequence);
-		data->saved_mode = 0;
-		data->saved_size = 0;
-		data->saved_area = NULL;
-		data->saved_sequence = 0;
-		data->saved_kcov = NULL;
+	if (t->kcov_saved_kcov) {
+		kcov_start(t, t->kcov_saved_kcov, t->kcov_saved_size,
+			   t->kcov_saved_area, t->kcov_saved_mode,
+			   t->kcov_saved_sequence);
+		t->kcov_saved_mode = 0;
+		t->kcov_saved_size = 0;
+		t->kcov_saved_area = NULL;
+		t->kcov_saved_sequence = 0;
+		t->kcov_saved_kcov = NULL;
 	}
 }
 
@@ -927,17 +926,17 @@ void kcov_remote_start(u64 handle)
 	sequence = kcov->sequence;
 	if (in_task()) {
 		size = kcov->remote_size;
-		area = kcov_remote_area_get(size);
+		area = kcov_remote_area_get(size, false);
 	} else {
 		size = CONFIG_KCOV_IRQ_AREA_SIZE;
-		area = this_cpu_ptr(&kcov_percpu_data)->irq_area;
+		area = kcov_remote_area_get(size, true);
 	}
 	spin_unlock(&kcov_remote_lock);
 
-	/* Can only happen when in_task(). */
+	/* Allocate new buffer if we can sleep. */
 	if (!area) {
 		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
-		area = vmalloc(size * sizeof(unsigned long));
+		area = in_task() ? vmalloc(size * sizeof(unsigned long)) : NULL;
 		if (!area) {
 			kcov_put(kcov);
 			return;
@@ -1079,11 +1078,9 @@ void kcov_remote_stop(void)
 		kcov_move_area(kcov->mode, kcov->area, kcov->size, area);
 	spin_unlock(&kcov->lock);
 
-	if (in_task()) {
-		spin_lock(&kcov_remote_lock);
-		kcov_remote_area_put(area, size);
-		spin_unlock(&kcov_remote_lock);
-	}
+	spin_lock(&kcov_remote_lock);
+	kcov_remote_area_put(area, size, !in_task());
+	spin_unlock(&kcov_remote_lock);
 
 	local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 
@@ -1129,14 +1126,21 @@ static void __init selftest(void)
 
 static int __init kcov_init(void)
 {
-	int cpu;
+	int cpu = num_possible_cpus();
+
+#ifdef CONFIG_PREEMPT_RT
+	/* Allocate some extra buffers in order to prepare for softirq preemption. */
+	cpu = cpu >= 4 ? cpu * 2 : cpu + 4;
+#endif
+	while (cpu--) {
+		void *area = vmalloc(CONFIG_KCOV_IRQ_AREA_SIZE * sizeof(unsigned long));
+		unsigned long flags;
 
-	for_each_possible_cpu(cpu) {
-		void *area = vmalloc_node(CONFIG_KCOV_IRQ_AREA_SIZE *
-				sizeof(unsigned long), cpu_to_node(cpu));
 		if (!area)
 			return -ENOMEM;
-		per_cpu_ptr(&kcov_percpu_data, cpu)->irq_area = area;
+		spin_lock_irqsave(&kcov_remote_lock, flags);
+		kcov_remote_area_put(area, CONFIG_KCOV_IRQ_AREA_SIZE, true);
+		spin_unlock_irqrestore(&kcov_remote_lock, flags);
 	}
 
 	/*
--- a/lib/Kconfig.debug~kcov-fix-data-corruption-and-race-conditions-on-preempt_rt
+++ a/lib/Kconfig.debug
@@ -2219,10 +2219,11 @@ config KCOV_INSTRUMENT_ALL
 config KCOV_IRQ_AREA_SIZE
 	hex "Size of interrupt coverage collection area in words"
 	depends on KCOV
+	range 0x80 0x1000000
 	default 0x40000
 	help
-	  KCOV uses preallocated per-cpu areas to collect coverage from
-	  soft interrupts. This specifies the size of those areas in the
+	  KCOV uses preallocated areas to collect coverage from soft
+	  interrupts. This specifies the size of those areas in the
 	  number of unsigned long words.
 
 config KCOV_SELFTEST
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


