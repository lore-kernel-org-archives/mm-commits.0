Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8729289837
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849743; cv=none; b=EvBEr3TpNIDi2nN60hlMPwfkHJXHjS1kf+epFL4YD0wV97ynGX+PM7RN6XxBeb38HTafPoWwjFSTl/1AC2FezYoT9D8r4jsGN3IyByTQUo1Q6bFd0XJEMos1KBfTvII2wZIOxGrDrBpq5A6dM9ts/jc5mhdSXKkjCZfT6sULtdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849743; c=relaxed/simple;
	bh=/pn3bsLY4CJLawMDISYi55ForbIVzGF757TjcKG/3o4=;
	h=Date:To:From:Subject:Message-Id; b=i+jmTn+/qGdPk6f8rcFci/IYSeN01Ox7G1f1fiA/k0/v4giL+eyyLPLxKV+DtG5EK5g6OpfnrzxNWdOjVfjc9tx9vfDBpV30m9UNUm0c74lNMGFtyQyofNCoPdY1uIgW5tXvJvxLlNJ9Spdd7JfpL1rJARjW+45daLBx2ZecgXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mnKOkEl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mnKOkEl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D6AC4CEE4;
	Wed, 21 May 2025 17:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849743;
	bh=/pn3bsLY4CJLawMDISYi55ForbIVzGF757TjcKG/3o4=;
	h=Date:To:From:Subject:From;
	b=mnKOkEl9cjARl32gfGPXzi6obroMwXLq2vttEBPb4yhg+sAvP6WyVT4sVn1KocTUg
	 bI0cDhIvmAxxzBiBhtFnyK1U2w+4VhMVHs8cqHD51SZiVmmMzNqBEoiKTj4U4DCcPv
	 43E9aRo0gWJGHck1uLNzsSg5vSHoYUBncZ2+cyOk=
Date: Wed, 21 May 2025 10:49:02 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-clean-up-ifdef-logic-around-stack-allocation.patch removed from -mm tree
Message-Id: <20250521174903.80D6AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: clean-up ifdef logic around stack allocation
has been removed from the -mm tree.  Its filename was
     fork-clean-up-ifdef-logic-around-stack-allocation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: fork: clean-up ifdef logic around stack allocation
Date: Fri, 09 May 2025 08:29:26 +0200

Patch series "fork: Page operation cleanups in the fork code", v3.

This patchset consists of outtakes from a 1 year+ old patchset from Pasha,
which all stand on their own.  See:
https://lore.kernel.org/all/20240311164638.2015063-1-pasha.tatashin@soleen.com/

These are good cleanups for readability so I split these off, rebased on
v6.15-rc1, addressed review comments and send them separately.

All mentions of dynamic stack are removed from the patchset as we have no
idea whether that will go anywhere.


This patch (of 3):

There is unneeded OR in the ifdef functions that are used to allocate and
free kernel stacks based on direct map or vmap.

Therefore, clean up by changing the order so OR is no longer needed.

[linus.walleij@linaro.org: rebased]
Link: https://lkml.kernel.org/r/20250509-fork-fixes-v3-1-e6c69dd356f2@linaro.org
Link: https://lkml.kernel.org/r/20250509-fork-fixes-v3-0-e6c69dd356f2@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-3-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/kernel/fork.c~fork-clean-up-ifdef-logic-around-stack-allocation
+++ a/kernel/fork.c
@@ -185,13 +185,7 @@ static inline void free_task_struct(stru
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
@@ -342,7 +336,13 @@ static void free_thread_stack(struct tas
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
@@ -374,8 +374,7 @@ static void free_thread_stack(struct tas
 	tsk->stack = NULL;
 }
 
-#  endif /* CONFIG_VMAP_STACK */
-# else /* !(THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)) */
+#else /* !(THREAD_SIZE >= PAGE_SIZE) */
 
 static struct kmem_cache *thread_stack_cache;
 
@@ -414,7 +413,8 @@ void thread_stack_cache_init(void)
 	BUG_ON(thread_stack_cache == NULL);
 }
 
-# endif /* THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK) */
+#endif /* THREAD_SIZE >= PAGE_SIZE */
+#endif /* CONFIG_VMAP_STACK */
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
 static struct kmem_cache *signal_cachep;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


