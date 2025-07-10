Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB50B286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127169; cv=none; b=Ax9iAnUs0uCs7DTgoKi9VmPfPj5ToL1+Vi/N/FX/SHg5/Lph22UhgpXWofH94PsMjE7eYPhi0AWlZAgnWzCrh/UGYFLkPUVYuUbZJogy8uP0TPnMePV1fUEncL7qOzGCPx5Yl7Pr3GDB3bygHqtiCUuXLJk5KJSKQUD3YoRDEVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127169; c=relaxed/simple;
	bh=vHq24bzNOB0wwX8rroKHLsWlFvIom5fL9gLOhyDNrxA=;
	h=Date:To:From:Subject:Message-Id; b=VKI0mJet5VAy/7yI+r1OZUlOvgLgGSPqg7cjfpvdrXe2x9oAvHXz1JhLhFvRPOwBRzfZAdGqrY9Ve9TCLAPwFJpUhhMswpkwtHa+rtWJbfo1Zu+Nyt2kxEF2uilFDo3LfhjmJ76/TMSBWodCa7vRwKVpKHYR5yuX5j1iN7eSpUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D8A1CX8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D8A1CX8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B517AC4CEE3;
	Thu, 10 Jul 2025 05:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127168;
	bh=vHq24bzNOB0wwX8rroKHLsWlFvIom5fL9gLOhyDNrxA=;
	h=Date:To:From:Subject:From;
	b=D8A1CX8AZPLfVUb/Tp5RbVMj3VXC1GD9eWV/hUO5hl3O8n1fQwQMhrAljom9bxVwM
	 BBETXZ6cgYwVvjMS31Ro35Sbz2+BF/3rEcNRbvfWfH6X3vteAzOFOcYFOWQxovVT7M
	 e0p7Kji9caMI1R3kmLz4IjzwH3MW7JaJ8uwcpEOM=
Date: Wed, 09 Jul 2025 22:59:28 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-clean-up-ifdef-logic-around-stack-allocation.patch removed from -mm tree
Message-Id: <20250710055928.B517AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: clean up ifdef logic around stack allocation
has been removed from the -mm tree.  Its filename was
     fork-clean-up-ifdef-logic-around-stack-allocation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: fork: clean up ifdef logic around stack allocation
Date: Wed, 18 Jun 2025 15:34:33 +0200

There is an unneeded OR in the ifdef functions that are used to allocate
and free kernel stacks based on direct map or vmap.  Adding dynamic stack
support would complicate this logic even further.

Therefore, clean up by changing the order so OR is no longer needed.

Link: https://lkml.kernel.org/r/20250618-fork-fixes-v4-1-2e05a2e1f5fc@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-3-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/kernel/fork.c~fork-clean-up-ifdef-logic-around-stack-allocation
+++ a/kernel/fork.c
@@ -188,13 +188,7 @@ static inline void free_task_struct(stru
 	kmem_cache_free(task_struct_cachep, tsk);
 }
 
-/*
- * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
- * kmemcache based allocator.
- */
-# if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
-
-#  ifdef CONFIG_VMAP_STACK
+#ifdef CONFIG_VMAP_STACK
 /*
  * vmalloc() is a bit slow, and calling vfree() enough times will force a TLB
  * flush.  Try to minimize the number of calls by caching stacks.
@@ -344,7 +338,13 @@ static void free_thread_stack(struct tas
 	tsk->stack_vm_area = NULL;
 }
 
-#  else /* !CONFIG_VMAP_STACK */
+#else /* !CONFIG_VMAP_STACK */
+
+/*
+ * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
+ * kmemcache based allocator.
+ */
+#if THREAD_SIZE >= PAGE_SIZE
 
 static void thread_stack_free_rcu(struct rcu_head *rh)
 {
@@ -376,8 +376,7 @@ static void free_thread_stack(struct tas
 	tsk->stack = NULL;
 }
 
-#  endif /* CONFIG_VMAP_STACK */
-# else /* !(THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)) */
+#else /* !(THREAD_SIZE >= PAGE_SIZE) */
 
 static struct kmem_cache *thread_stack_cache;
 
@@ -416,7 +415,8 @@ void thread_stack_cache_init(void)
 	BUG_ON(thread_stack_cache == NULL);
 }
 
-# endif /* THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK) */
+#endif /* THREAD_SIZE >= PAGE_SIZE */
+#endif /* CONFIG_VMAP_STACK */
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
 static struct kmem_cache *signal_cachep;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


