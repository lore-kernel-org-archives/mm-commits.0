Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF47F289837
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849745; cv=none; b=taB+xZOish8x+kT1ncOMnjF9af8e4uTdzJyHuPrPN1JOsDtUX3HAw/qRzYMPE/XapLL0IZI5u8gTFJrKn6m7TJkF1gdvs75r3tPfHyKs7NiEF8vKQOoe8fBjKB8Qm9ukz1YHh3RviXww0kq6fhYGl74qDHRZrY9d2ghUBmn3Cc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849745; c=relaxed/simple;
	bh=buiTtdoYnqWEGij3h0ZMJyXirYmYiXbt4RM6Ey+jBEg=;
	h=Date:To:From:Subject:Message-Id; b=M003WaIUqlVx89oZ5OPBootmmhfZI6DomZwqUUweSTwnpiW9KBYZmDH14KFb+JN3oFb5IL1lqVlbJSNmDIS2gRPJBYWIOfUHMQhztQyor954xWGqpD3WqvZsi8vTgAQ52QbhvVwo6q4Qdl+dras8Al46t1o6GNqbR3/1pKEj39U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UUlIg6CJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UUlIg6CJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AB6C4CEE4;
	Wed, 21 May 2025 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849744;
	bh=buiTtdoYnqWEGij3h0ZMJyXirYmYiXbt4RM6Ey+jBEg=;
	h=Date:To:From:Subject:From;
	b=UUlIg6CJeMguHx3mK/Sb6LNL1rK14OVMHAuv5R8Tns9X7F6t4QWs0Xj4yytjy+430
	 sWk6RkCwgZmvnzmcMJZCesWHha1Sz13xyfjJvn/wM57l7c78NQ1q/5FXBlJ31UOiU9
	 emHOLpdCoZ8sOojB3PLBJR+3gM3JQPdjuaXMUejc=
Date: Wed, 21 May 2025 10:49:04 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch removed from -mm tree
Message-Id: <20250521174904.A1AB6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: clean-up naming of vm_stack/vm_struct variables in vmap stacks code
has been removed from the -mm tree.  Its filename was
     fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: fork: clean-up naming of vm_stack/vm_struct variables in vmap stacks code
Date: Fri, 09 May 2025 08:29:27 +0200

There are two data types: "struct vm_struct" and "struct vm_stack" that
have the same local variable names: vm_stack, or vm, or s, which makes the
code confusing to read.

Change the code so the naming is consistent:

struct vm_struct is always called vm_area
struct vm_stack is always called vm_stack

One change altering vfree(vm_stack) to vfree(vm_area->addr) may look like
a semantic change but it is not: vm_area->addr points to the vm_stack. 
This was done to improve readability.

[linus.walleij@linaro.org: rebased and added new users of the variable names, address review comments]
Link: https://lore.kernel.org/20240311164638.2015063-4-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20250509-fork-fixes-v3-2-e6c69dd356f2@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   60 +++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

--- a/kernel/fork.c~fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code
+++ a/kernel/fork.c
@@ -198,14 +198,14 @@ struct vm_stack {
 	struct vm_struct *stack_vm_area;
 };
 
-static bool try_release_thread_stack_to_cache(struct vm_struct *vm)
+static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 {
 	unsigned int i;
 
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
 		struct vm_struct *tmp = NULL;
 
-		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
+		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
 			return true;
 	}
 	return false;
@@ -214,11 +214,12 @@ static bool try_release_thread_stack_to_
 static void thread_stack_free_rcu(struct rcu_head *rh)
 {
 	struct vm_stack *vm_stack = container_of(rh, struct vm_stack, rcu);
+	struct vm_struct *vm_area = vm_stack->stack_vm_area;
 
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
 		return;
 
-	vfree(vm_stack);
+	vfree(vm_area->addr);
 }
 
 static void thread_stack_delayed_free(struct task_struct *tsk)
@@ -231,32 +232,32 @@ static void thread_stack_delayed_free(st
 
 static int free_vm_stack_cache(unsigned int cpu)
 {
-	struct vm_struct **cached_vm_stacks = per_cpu_ptr(cached_stacks, cpu);
+	struct vm_struct **cached_vm_stack_areas = per_cpu_ptr(cached_stacks, cpu);
 	int i;
 
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		struct vm_struct *vm_stack = cached_vm_stacks[i];
+		struct vm_struct *vm_area = cached_vm_stack_areas[i];
 
-		if (!vm_stack)
+		if (!vm_area)
 			continue;
 
-		vfree(vm_stack->addr);
-		cached_vm_stacks[i] = NULL;
+		vfree(vm_area->addr);
+		cached_vm_stack_areas[i] = NULL;
 	}
 
 	return 0;
 }
 
-static int memcg_charge_kernel_stack(struct vm_struct *vm)
+static int memcg_charge_kernel_stack(struct vm_struct *vm_area)
 {
 	int i;
 	int ret;
 	int nr_charged = 0;
 
-	BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
+	BUG_ON(vm_area->nr_pages != THREAD_SIZE / PAGE_SIZE);
 
 	for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
-		ret = memcg_kmem_charge_page(vm->pages[i], GFP_KERNEL, 0);
+		ret = memcg_kmem_charge_page(vm_area->pages[i], GFP_KERNEL, 0);
 		if (ret)
 			goto err;
 		nr_charged++;
@@ -264,38 +265,35 @@ static int memcg_charge_kernel_stack(str
 	return 0;
 err:
 	for (i = 0; i < nr_charged; i++)
-		memcg_kmem_uncharge_page(vm->pages[i], 0);
+		memcg_kmem_uncharge_page(vm_area->pages[i], 0);
 	return ret;
 }
 
 static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
-	struct vm_struct *vm;
+	struct vm_struct *vm_area;
 	void *stack;
 	int i;
 
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		struct vm_struct *s;
-
-		s = this_cpu_xchg(cached_stacks[i], NULL);
-
-		if (!s)
+		vm_area = this_cpu_xchg(cached_stacks[i], NULL);
+		if (!vm_area)
 			continue;
 
 		/* Reset stack metadata. */
-		kasan_unpoison_range(s->addr, THREAD_SIZE);
+		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
-		stack = kasan_reset_tag(s->addr);
+		stack = kasan_reset_tag(vm_area->addr);
 
 		/* Clear stale pointers from reused stack. */
 		memset(stack, 0, THREAD_SIZE);
 
-		if (memcg_charge_kernel_stack(s)) {
-			vfree(s->addr);
+		if (memcg_charge_kernel_stack(vm_area)) {
+			vfree(vm_area->addr);
 			return -ENOMEM;
 		}
 
-		tsk->stack_vm_area = s;
+		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
 		return 0;
 	}
@@ -311,8 +309,8 @@ static int alloc_thread_stack_node(struc
 	if (!stack)
 		return -ENOMEM;
 
-	vm = find_vm_area(stack);
-	if (memcg_charge_kernel_stack(vm)) {
+	vm_area = find_vm_area(stack);
+	if (memcg_charge_kernel_stack(vm_area)) {
 		vfree(stack);
 		return -ENOMEM;
 	}
@@ -321,7 +319,7 @@ static int alloc_thread_stack_node(struc
 	 * free_thread_stack() can be called in interrupt context,
 	 * so cache the vm_struct.
 	 */
-	tsk->stack_vm_area = vm;
+	tsk->stack_vm_area = vm_area;
 	stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
 	return 0;
@@ -517,11 +515,11 @@ void vm_area_free(struct vm_area_struct
 static void account_kernel_stack(struct task_struct *tsk, int account)
 {
 	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
-		struct vm_struct *vm = task_stack_vm_area(tsk);
+		struct vm_struct *vm_area = task_stack_vm_area(tsk);
 		int i;
 
 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
-			mod_lruvec_page_state(vm->pages[i], NR_KERNEL_STACK_KB,
+			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
 					      account * (PAGE_SIZE / 1024));
 	} else {
 		void *stack = task_stack_page(tsk);
@@ -537,12 +535,12 @@ void exit_task_stack_account(struct task
 	account_kernel_stack(tsk, -1);
 
 	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
-		struct vm_struct *vm;
+		struct vm_struct *vm_area;
 		int i;
 
-		vm = task_stack_vm_area(tsk);
+		vm_area = task_stack_vm_area(tsk);
 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
-			memcg_kmem_uncharge_page(vm->pages[i], 0);
+			memcg_kmem_uncharge_page(vm_area->pages[i], 0);
 	}
 }
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


