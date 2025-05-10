Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8DC22F776
	for <mm-commits@vger.kernel.org>; Sat, 10 May 2025 00:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746837951; cv=none; b=mFf762cUea7HI9a7v/0kp1dyoVWY1f0agiHwDsSZecduZJv+KpI9gD7qdIMJB5aWK5KoWir17/eopVtn/flfseNI0sjho9WPMBhNyMuvMYk6EzyLYrSvSzwNKlcxFml5LXlV/VCG6ycozK7wg0wuLsOKr3Iu6iOxH6iwg6gzXsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746837951; c=relaxed/simple;
	bh=CJfVFpkhxWuFFw1kvL6etCZyI4wV0hQBaldQBk6lS8M=;
	h=Date:To:From:Subject:Message-Id; b=gds4jFFFky4h7aGw5UHy210lUOxdN7fZyBcmur1Qb1u2XyTbyjB3edabpgpSVXxnm+Z9S1oSKjmE0nmihcqSUT8ptJkfv/poHI3sC1PIIqjqYQV8xkwMCixZqA78YCaG2dx7A32i5ms6a2olwzch9sKoXiUh/AjqtEVD0D26hTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FUdbFXRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FUdbFXRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F761C4CEE4;
	Sat, 10 May 2025 00:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746837950;
	bh=CJfVFpkhxWuFFw1kvL6etCZyI4wV0hQBaldQBk6lS8M=;
	h=Date:To:From:Subject:From;
	b=FUdbFXRXdHEe49bBSK3txqR8ZoDhy7/QKExBcGU+HJ2bvTEE58f2X68WkKN93pynO
	 ulQTN0waofMa8aPt0BOQGI47kNwiSAwDhDip8fzd4EuqUenbXyGcMLcZxjNQp+/GnW
	 7BK4Lddm89cjAL14j1CXigtw2vKwL785qYTREzIM=
Date: Fri, 09 May 2025 17:45:49 -0700
To: mm-commits@vger.kernel.org,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch added to mm-nonmm-unstable branch
Message-Id: <20250510004550.6F761C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: clean-up naming of vm_stack/vm_struct variables in vmap stacks code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   60 +++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

--- a/kernel/fork.c~fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code
+++ a/kernel/fork.c
@@ -201,14 +201,14 @@ struct vm_stack {
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
@@ -217,11 +217,12 @@ static bool try_release_thread_stack_to_
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
@@ -234,32 +235,32 @@ static void thread_stack_delayed_free(st
 
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
@@ -267,38 +268,35 @@ static int memcg_charge_kernel_stack(str
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
@@ -314,8 +312,8 @@ static int alloc_thread_stack_node(struc
 	if (!stack)
 		return -ENOMEM;
 
-	vm = find_vm_area(stack);
-	if (memcg_charge_kernel_stack(vm)) {
+	vm_area = find_vm_area(stack);
+	if (memcg_charge_kernel_stack(vm_area)) {
 		vfree(stack);
 		return -ENOMEM;
 	}
@@ -324,7 +322,7 @@ static int alloc_thread_stack_node(struc
 	 * free_thread_stack() can be called in interrupt context,
 	 * so cache the vm_struct.
 	 */
-	tsk->stack_vm_area = vm;
+	tsk->stack_vm_area = vm_area;
 	stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
 	return 0;
@@ -437,11 +435,11 @@ static struct kmem_cache *mm_cachep;
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
@@ -457,12 +455,12 @@ void exit_task_stack_account(struct task
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

task_stackh-remove-obsolete-__have_arch_kstack_end-check.patch
fork-clean-up-ifdef-logic-around-stack-allocation.patch
fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch
fork-check-charging-success-before-zeroing-stack.patch

