Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBB2215779
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 22:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750286020; cv=none; b=lGsFHVLFlKjsVL95j59MoSJ6/WZqRsd0th8zyktsePbhSi6u/PfqprnoraCQLjekCfngmEwgBrZ2Bdt5NbIBtrKzl0yX2UafTeSHYD730ravKWHiVMUXo/obnlaKBpSo+F583dPGfgYK5SKUlSOTgLb+FExKvSwlE5FwkHL0UxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750286020; c=relaxed/simple;
	bh=QLu3XaP6FPDo90XVgas0Juwmtr1PHKj5mmHOj/MFB9Y=;
	h=Date:To:From:Subject:Message-Id; b=fP9SNrKygesMEEPkzdWFYrN7ZXhyz/y1WlyjQkvrZYL75ep3psoqJRmbbxVHLO4LxDlZLIVNKYLuJCdLWIvh6y0cudSior8DipZue1oEY/XfWhepFggbO/McnaOjnYOUJHAskfOU7A8t8B55xejjZuAbQfHfkDEs5h5LG9+aGA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GdVPNSRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GdVPNSRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CBAC4CEE7;
	Wed, 18 Jun 2025 22:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750286019;
	bh=QLu3XaP6FPDo90XVgas0Juwmtr1PHKj5mmHOj/MFB9Y=;
	h=Date:To:From:Subject:From;
	b=GdVPNSRjEtWDRL+AaWJBQMtj1X8SwAqIIvJ/MGmmrqjG9zOlfFH6q66oiUoylGPA6
	 DxeT7ZRLPKNXIt4FJumF2U0DgLNfMyqX/0BA5SZqwfVtXNyII+uPMG2xuusAeMR2Qv
	 kue3Oiv5wIwC89xWIXjIAuX1uPxwQW4JHNG5a5kc=
Date: Wed, 18 Jun 2025 15:33:38 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-clean-up-ifdef-logic-around-stack-allocation.patch added to mm-nonmm-unstable branch
Message-Id: <20250618223339.62CBAC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: clean up ifdef logic around stack allocation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-clean-up-ifdef-logic-around-stack-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-clean-up-ifdef-logic-around-stack-allocation.patch

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

fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch
fork-clean-up-ifdef-logic-around-stack-allocation.patch

