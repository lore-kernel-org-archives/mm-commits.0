Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B7D33DF
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 02:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732760240; cv=none; b=SPaS9vSbA6WbPs2fMALK7pgDWkblPReYH8HGyTqYtJoaLZCY69MJbTgp6vDoAda0PjJrfhFBzTzZFXp77gJLcaW04BNCoPptVE//uCzOjF/EIs1OIicFD3y3vNIx43ukIVZA0EN88NCC69GRaGyRcVKFFKXg2XMf1uqORj2BdfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732760240; c=relaxed/simple;
	bh=OoV6oPDTRsWYFRW8K9I7aQ7+rHs0PftygWLnAYMBb6k=;
	h=Date:To:From:Subject:Message-Id; b=a4ocVG/p8jiN+wQDvMPck/UIcqHQC62/+qKpaUYUtPbQQeU8IURyj+b7E38hhw232LQUt/holoRKqHfXs1iDOEYMc42oqXtGwx5opLZmrN+1/SvUytXzXTmXEuCr5JFtwo2hWziPRylaSQpL5Qfphce7nCytJP5YFpMIpJ5SlJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cfaKeO4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cfaKeO4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D43DC4CECC;
	Thu, 28 Nov 2024 02:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732760239;
	bh=OoV6oPDTRsWYFRW8K9I7aQ7+rHs0PftygWLnAYMBb6k=;
	h=Date:To:From:Subject:From;
	b=cfaKeO4APplN7CVv9VjLhX32Rqb8fs32FIKDis5z81nea7WuLuSRzJH4ULSdX4w13
	 ykc6cJkZ5XusFvu2i+qZaeKmeZNyvmS76j8nXQjSJgKsJMYKcYL4X8onnzOb97UD2/
	 IkldCa1FW5RhlhvqyqTk6LnxuB6yiEXjE96b1b7Y=
Date: Wed, 27 Nov 2024 18:17:18 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincenzo.frascino@arm.com,vincent.guittot@linaro.org,vbabka@suse.cz,urezki@gmail.com,tj@kernel.org,tglx@linutronix.de,ryabinin.a.a@gmail.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,qiang.zhang1211@gmail.com,penberg@kernel.org,paulmck@kernel.org,neeraj.upadhyay@kernel.org,mingo@redhat.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,longman@redhat.com,Liam.Howlett@Oracle.com,kasan-dev@googlegroups.com,juri.lelli@redhat.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,jannh@google.com,iamjoonsoo.kim@lge.com,glider@google.com,frederic@kernel.org,elver@google.com,dvyukov@google.com,dietmar.eggemann@arm.com,cl@linux.com,bsegall@google.com,boqun.feng@gmail.com,bigeasy@linutronix.de,andreyknvl@gmail.com,42.hyeyoo@gmail.com,peterz@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour.patch added to mm-unstable branch
Message-Id: <20241128021719.6D43DC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: make kasan_record_aux_stack_noalloc() the default behaviour
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour.patch

This patch will later appear in the mm-unstable branch at
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
From: Peter Zijlstra <peterz@infradead.org>
Subject: kasan: make kasan_record_aux_stack_noalloc() the default behaviour
Date: Fri, 22 Nov 2024 16:54:51 +0100

kasan_record_aux_stack_noalloc() was introduced to record a stack trace
without allocating memory in the process.  It has been added to callers
which were invoked while a raw_spinlock_t was held.  More and more callers
were identified and changed over time.  Is it a good thing to have this
while functions try their best to do a locklessly setup?  The only
downside of having kasan_record_aux_stack() not allocate any memory is
that we end up without a stacktrace if stackdepot runs out of memory and
at the same stacktrace was not recorded before To quote Marco Elver from
https://lore.kernel.org/all/CANpmjNPmQYJ7pv1N3cuU8cP18u7PP_uoZD8YxwZd4jtbof9nVQ@mail.gmail.com/

| I'd be in favor, it simplifies things. And stack depot should be
| able to replenish its pool sufficiently in the "non-aux" cases
| i.e. regular allocations. Worst case we fail to record some
| aux stacks, but I think that's only really bad if there's a bug
| around one of these allocations. In general the probabilities
| of this being a regression are extremely small [...]

Make the kasan_record_aux_stack_noalloc() behaviour default as
kasan_record_aux_stack().

[bigeasy@linutronix.de: dressed the diff as patch]
Link: https://lkml.kernel.org/r/20241122155451.Mb2pmeyJ@linutronix.de
Fixes: 7cb3007ce2da2 ("kasan: generic: introduce kasan_record_aux_stack_noalloc()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: syzbot+39f85d612b7c20d8db48@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67275485.050a0220.3c8d68.0a37.GAE@googl=
e.com
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: syzkaller-bugs@googlegroups.com
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h     |    2 --
 include/linux/task_work.h |    3 ---
 kernel/irq_work.c         |    2 +-
 kernel/rcu/tiny.c         |    2 +-
 kernel/rcu/tree.c         |    4 ++--
 kernel/sched/core.c       |    2 +-
 kernel/task_work.c        |   14 +-------------
 kernel/workqueue.c        |    2 +-
 mm/kasan/generic.c        |   18 ++++++------------
 mm/slub.c                 |    2 +-
 10 files changed, 14 insertions(+), 37 deletions(-)

--- a/include/linux/kasan.h~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/include/linux/kasan.h
@@ -491,7 +491,6 @@ void kasan_cache_create(struct kmem_cach
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
 void kasan_record_aux_stack(void *ptr);
-void kasan_record_aux_stack_noalloc(void *ptr);
 
 #else /* CONFIG_KASAN_GENERIC */
 
@@ -509,7 +508,6 @@ static inline void kasan_cache_create(st
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
 static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
 static inline void kasan_record_aux_stack(void *ptr) {}
-static inline void kasan_record_aux_stack_noalloc(void *ptr) {}
 
 #endif /* CONFIG_KASAN_GENERIC */
 
--- a/include/linux/task_work.h~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/include/linux/task_work.h
@@ -19,9 +19,6 @@ enum task_work_notify_mode {
 	TWA_SIGNAL,
 	TWA_SIGNAL_NO_IPI,
 	TWA_NMI_CURRENT,
-
-	TWA_FLAGS = 0xff00,
-	TWAF_NO_ALLOC = 0x0100,
 };
 
 static inline bool task_work_pending(struct task_struct *task)
--- a/kernel/irq_work.c~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/kernel/irq_work.c
@@ -147,7 +147,7 @@ bool irq_work_queue_on(struct irq_work *
 	if (!irq_work_claim(work))
 		return false;
 
-	kasan_record_aux_stack_noalloc(work);
+	kasan_record_aux_stack(work);
 
 	preempt_disable();
 	if (cpu != smp_processor_id()) {
--- a/kernel/rcu/tiny.c~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/kernel/rcu/tiny.c
@@ -250,7 +250,7 @@ EXPORT_SYMBOL_GPL(poll_state_synchronize
 void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 {
 	if (head)
-		kasan_record_aux_stack_noalloc(ptr);
+		kasan_record_aux_stack(ptr);
 
 	__kvfree_call_rcu(head, ptr);
 }
--- a/kernel/rcu/tree.c~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/kernel/rcu/tree.c
@@ -3083,7 +3083,7 @@ __call_rcu_common(struct rcu_head *head,
 	}
 	head->func = func;
 	head->next = NULL;
-	kasan_record_aux_stack_noalloc(head);
+	kasan_record_aux_stack(head);
 	local_irq_save(flags);
 	rdp = this_cpu_ptr(&rcu_data);
 	lazy = lazy_in && !rcu_async_should_hurry();
@@ -3817,7 +3817,7 @@ void kvfree_call_rcu(struct rcu_head *he
 		return;
 	}
 
-	kasan_record_aux_stack_noalloc(ptr);
+	kasan_record_aux_stack(ptr);
 	success = add_ptr_to_bulk_krc_lock(&krcp, &flags, ptr, !head);
 	if (!success) {
 		run_page_cache_worker(krcp);
--- a/kernel/sched/core.c~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/kernel/sched/core.c
@@ -10590,7 +10590,7 @@ void task_tick_mm_cid(struct rq *rq, str
 		return;
 
 	/* No page allocation under rq lock */
-	task_work_add(curr, work, TWA_RESUME | TWAF_NO_ALLOC);
+	task_work_add(curr, work, TWA_RESUME);
 }
 
 void sched_mm_cid_exit_signals(struct task_struct *t)
--- a/kernel/task_work.c~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/kernel/task_work.c
@@ -55,26 +55,14 @@ int task_work_add(struct task_struct *ta
 		  enum task_work_notify_mode notify)
 {
 	struct callback_head *head;
-	int flags = notify & TWA_FLAGS;
 
-	notify &= ~TWA_FLAGS;
 	if (notify == TWA_NMI_CURRENT) {
 		if (WARN_ON_ONCE(task != current))
 			return -EINVAL;
 		if (!IS_ENABLED(CONFIG_IRQ_WORK))
 			return -EINVAL;
 	} else {
-		/*
-		 * Record the work call stack in order to print it in KASAN
-		 * reports.
-		 *
-		 * Note that stack allocation can fail if TWAF_NO_ALLOC flag
-		 * is set and new page is needed to expand the stack buffer.
-		 */
-		if (flags & TWAF_NO_ALLOC)
-			kasan_record_aux_stack_noalloc(work);
-		else
-			kasan_record_aux_stack(work);
+		kasan_record_aux_stack(work);
 	}
 
 	head = READ_ONCE(task->task_works);
--- a/kernel/workqueue.c~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/kernel/workqueue.c
@@ -2180,7 +2180,7 @@ static void insert_work(struct pool_work
 	debug_work_activate(work);
 
 	/* record the work call stack in order to print it in KASAN reports */
-	kasan_record_aux_stack_noalloc(work);
+	kasan_record_aux_stack(work);
 
 	/* we own @work, set data and link */
 	set_work_pwq(work, pwq, extra_flags);
--- a/mm/kasan/generic.c~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/mm/kasan/generic.c
@@ -524,7 +524,11 @@ size_t kasan_metadata_size(struct kmem_c
 			sizeof(struct kasan_free_meta) : 0);
 }
 
-static void __kasan_record_aux_stack(void *addr, depot_flags_t depot_flags)
+/*
+ * This function avoids dynamic memory allocations and thus can be called from
+ * contexts that do not allow allocating memory.
+ */
+void kasan_record_aux_stack(void *addr)
 {
 	struct slab *slab = kasan_addr_to_slab(addr);
 	struct kmem_cache *cache;
@@ -541,17 +545,7 @@ static void __kasan_record_aux_stack(voi
 		return;
 
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
-	alloc_meta->aux_stack[0] = kasan_save_stack(0, depot_flags);
-}
-
-void kasan_record_aux_stack(void *addr)
-{
-	return __kasan_record_aux_stack(addr, STACK_DEPOT_FLAG_CAN_ALLOC);
-}
-
-void kasan_record_aux_stack_noalloc(void *addr)
-{
-	return __kasan_record_aux_stack(addr, 0);
+	alloc_meta->aux_stack[0] = kasan_save_stack(0, 0);
 }
 
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
--- a/mm/slub.c~kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour
+++ a/mm/slub.c
@@ -2296,7 +2296,7 @@ bool slab_free_hook(struct kmem_cache *s
 			 * We have to do this manually because the rcu_head is
 			 * not located inside the object.
 			 */
-			kasan_record_aux_stack_noalloc(x);
+			kasan_record_aux_stack(x);
 
 			delayed_free->object = x;
 			call_rcu(&delayed_free->head, slab_free_after_rcu_debug);
_

Patches currently in -mm which might be from peterz@infradead.org are

kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour.patch

