Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FC622F15E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849748; cv=none; b=YzXMvU2slFXNinp9TW5r18gqdtihzAv5lIspFM+g+ZXfPp/aQ7XJxlnh6gWMBKxHRuT4DYGyHadgbyrlvxrLx9EnILITKvxQwRddsO3aD5ncUl0kzG2dsukV8Eqk/cNoXtuJmvVQQGvbPm3mSn/Aj9nhr5vfSEqErUhf+6G72tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849748; c=relaxed/simple;
	bh=sV+fkYDTYSoZQxgyIxAo3ZKvc3REGDYynP4xsS3e5PM=;
	h=Date:To:From:Subject:Message-Id; b=tj9MkDMYKoMjokzwl1hNGr1uYi31QkynQdCnFcpO+L2lNuKtQ5Y6FK/z8e/jC7h6Z6+jykl4EHUHL+NOF5QSfv6CM11RBBTdfr4lLnXiQT4XC0u7npgP9FkDYIrH5y+OuLCHEpIwkvr0n9Ojk/wh/7NcQ45QyBaN8dL8DrGnJl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8iD7tev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8iD7tev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5D4C4CEEB;
	Wed, 21 May 2025 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849747;
	bh=sV+fkYDTYSoZQxgyIxAo3ZKvc3REGDYynP4xsS3e5PM=;
	h=Date:To:From:Subject:From;
	b=A8iD7tevifiJBA/nbLQBvKCng0oDC4zqyXDwONEvpl8yR3d0famVrfr83lCqwav9V
	 zUtI5XR04AL6H5RHRKM6wrp32unJZuZH5NG5GUSL7pLs9C0H9FgQTso4DCD6p0ITJ6
	 xpxN+WL3a1WWfHRCXppll2bVL3XzuMEVuwm57IAo=
Date: Wed, 21 May 2025 10:49:07 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,mjguzik@gmail.com,linus.walleij@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-define-a-local-gfp_vmap_stack.patch removed from -mm tree
Message-Id: <20250521174907.BE5D4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: define a local GFP_VMAP_STACK
has been removed from the -mm tree.  Its filename was
     fork-define-a-local-gfp_vmap_stack.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: fork: define a local GFP_VMAP_STACK
Date: Fri, 09 May 2025 09:25:09 +0200

The current allocation of VMAP stack memory is using (THREADINFO_GFP &
~__GFP_ACCOUNT) which is a complicated way of saying (GFP_KERNEL |
__GFP_ZERO):

<linux/thread_info.h>:
define THREADINFO_GFP (GFP_KERNEL_ACCOUNT | __GFP_ZERO)
<linux/gfp_types.h>:
define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)

This is an unfortunate side-effect of independent changes blurring the
picture:

commit 19809c2da28aee5860ad9a2eff760730a0710df0 changed (THREADINFO_GFP |
__GFP_HIGHMEM) to just THREADINFO_GFP since highmem became implicit.

commit 9b6f7e163cd0f468d1b9696b785659d3c27c8667 then added stack caching
and rewrote the allocation to (THREADINFO_GFP & ~__GFP_ACCOUNT) as cached
stacks need to be accounted separately.  However that code, when it
eventually accounts the memory does this:

  ret = memcg_kmem_charge(vm->pages[i], GFP_KERNEL, 0)

so the memory is charged as a GFP_KERNEL allocation.

Define a unique GFP_VMAP_STACK to use
GFP_KERNEL | __GFP_ZERO and move the comment there.

Link: https://lkml.kernel.org/r/20250509-gfp-stack-v1-1-82f6f7efc210@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reported-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   88 ++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 43 deletions(-)

--- a/kernel/fork.c~fork-define-a-local-gfp_vmap_stack
+++ a/kernel/fork.c
@@ -185,7 +185,13 @@ static inline void free_task_struct(stru
 	kmem_cache_free(task_struct_cachep, tsk);
 }
 
-#ifdef CONFIG_VMAP_STACK
+/*
+ * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
+ * kmemcache based allocator.
+ */
+# if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
+
+#  ifdef CONFIG_VMAP_STACK
 /*
  * vmalloc() is a bit slow, and calling vfree() enough times will force a TLB
  * flush.  Try to minimize the number of calls by caching stacks.
@@ -198,14 +204,14 @@ struct vm_stack {
 	struct vm_struct *stack_vm_area;
 };
 
-static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
+static bool try_release_thread_stack_to_cache(struct vm_struct *vm)
 {
 	unsigned int i;
 
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
 		struct vm_struct *tmp = NULL;
 
-		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
+		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
 			return true;
 	}
 	return false;
@@ -214,12 +220,11 @@ static bool try_release_thread_stack_to_
 static void thread_stack_free_rcu(struct rcu_head *rh)
 {
 	struct vm_stack *vm_stack = container_of(rh, struct vm_stack, rcu);
-	struct vm_struct *vm_area = vm_stack->stack_vm_area;
 
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
 		return;
 
-	vfree(vm_area->addr);
+	vfree(vm_stack);
 }
 
 static void thread_stack_delayed_free(struct task_struct *tsk)
@@ -232,32 +237,32 @@ static void thread_stack_delayed_free(st
 
 static int free_vm_stack_cache(unsigned int cpu)
 {
-	struct vm_struct **cached_vm_stack_areas = per_cpu_ptr(cached_stacks, cpu);
+	struct vm_struct **cached_vm_stacks = per_cpu_ptr(cached_stacks, cpu);
 	int i;
 
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		struct vm_struct *vm_area = cached_vm_stack_areas[i];
+		struct vm_struct *vm_stack = cached_vm_stacks[i];
 
-		if (!vm_area)
+		if (!vm_stack)
 			continue;
 
-		vfree(vm_area->addr);
-		cached_vm_stack_areas[i] = NULL;
+		vfree(vm_stack->addr);
+		cached_vm_stacks[i] = NULL;
 	}
 
 	return 0;
 }
 
-static int memcg_charge_kernel_stack(struct vm_struct *vm_area)
+static int memcg_charge_kernel_stack(struct vm_struct *vm)
 {
 	int i;
 	int ret;
 	int nr_charged = 0;
 
-	BUG_ON(vm_area->nr_pages != THREAD_SIZE / PAGE_SIZE);
+	BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
 
 	for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
-		ret = memcg_kmem_charge_page(vm_area->pages[i], GFP_KERNEL, 0);
+		ret = memcg_kmem_charge_page(vm->pages[i], GFP_KERNEL, 0);
 		if (ret)
 			goto err;
 		nr_charged++;
@@ -265,35 +270,38 @@ static int memcg_charge_kernel_stack(str
 	return 0;
 err:
 	for (i = 0; i < nr_charged; i++)
-		memcg_kmem_uncharge_page(vm_area->pages[i], 0);
+		memcg_kmem_uncharge_page(vm->pages[i], 0);
 	return ret;
 }
 
 static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
-	struct vm_struct *vm_area;
+	struct vm_struct *vm;
 	void *stack;
 	int i;
 
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		vm_area = this_cpu_xchg(cached_stacks[i], NULL);
-		if (!vm_area)
-			continue;
+		struct vm_struct *s;
 
-		if (memcg_charge_kernel_stack(vm_area)) {
-			vfree(vm_area->addr);
-			return -ENOMEM;
-		}
+		s = this_cpu_xchg(cached_stacks[i], NULL);
+
+		if (!s)
+			continue;
 
 		/* Reset stack metadata. */
-		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
+		kasan_unpoison_range(s->addr, THREAD_SIZE);
 
-		stack = kasan_reset_tag(vm_area->addr);
+		stack = kasan_reset_tag(s->addr);
 
 		/* Clear stale pointers from reused stack. */
 		memset(stack, 0, THREAD_SIZE);
 
-		tsk->stack_vm_area = vm_area;
+		if (memcg_charge_kernel_stack(s)) {
+			vfree(s->addr);
+			return -ENOMEM;
+		}
+
+		tsk->stack_vm_area = s;
 		tsk->stack = stack;
 		return 0;
 	}
@@ -309,8 +317,8 @@ static int alloc_thread_stack_node(struc
 	if (!stack)
 		return -ENOMEM;
 
-	vm_area = find_vm_area(stack);
-	if (memcg_charge_kernel_stack(vm_area)) {
+	vm = find_vm_area(stack);
+	if (memcg_charge_kernel_stack(vm)) {
 		vfree(stack);
 		return -ENOMEM;
 	}
@@ -319,7 +327,7 @@ static int alloc_thread_stack_node(struc
 	 * free_thread_stack() can be called in interrupt context,
 	 * so cache the vm_struct.
 	 */
-	tsk->stack_vm_area = vm_area;
+	tsk->stack_vm_area = vm;
 	stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
 	return 0;
@@ -334,13 +342,7 @@ static void free_thread_stack(struct tas
 	tsk->stack_vm_area = NULL;
 }
 
-#else /* !CONFIG_VMAP_STACK */
-
-/*
- * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
- * kmemcache based allocator.
- */
-#if THREAD_SIZE >= PAGE_SIZE
+#  else /* !CONFIG_VMAP_STACK */
 
 static void thread_stack_free_rcu(struct rcu_head *rh)
 {
@@ -372,7 +374,8 @@ static void free_thread_stack(struct tas
 	tsk->stack = NULL;
 }
 
-#else /* !(THREAD_SIZE >= PAGE_SIZE) */
+#  endif /* CONFIG_VMAP_STACK */
+# else /* !(THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)) */
 
 static struct kmem_cache *thread_stack_cache;
 
@@ -411,8 +414,7 @@ void thread_stack_cache_init(void)
 	BUG_ON(thread_stack_cache == NULL);
 }
 
-#endif /* THREAD_SIZE >= PAGE_SIZE */
-#endif /* CONFIG_VMAP_STACK */
+# endif /* THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK) */
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
 static struct kmem_cache *signal_cachep;
@@ -515,11 +517,11 @@ void vm_area_free(struct vm_area_struct
 static void account_kernel_stack(struct task_struct *tsk, int account)
 {
 	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
-		struct vm_struct *vm_area = task_stack_vm_area(tsk);
+		struct vm_struct *vm = task_stack_vm_area(tsk);
 		int i;
 
 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
-			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
+			mod_lruvec_page_state(vm->pages[i], NR_KERNEL_STACK_KB,
 					      account * (PAGE_SIZE / 1024));
 	} else {
 		void *stack = task_stack_page(tsk);
@@ -535,12 +537,12 @@ void exit_task_stack_account(struct task
 	account_kernel_stack(tsk, -1);
 
 	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
-		struct vm_struct *vm_area;
+		struct vm_struct *vm;
 		int i;
 
-		vm_area = task_stack_vm_area(tsk);
+		vm = task_stack_vm_area(tsk);
 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
-			memcg_kmem_uncharge_page(vm_area->pages[i], 0);
+			memcg_kmem_uncharge_page(vm->pages[i], 0);
 	}
 }
 
_

Patches currently in -mm which might be from linus.walleij@linaro.org are


