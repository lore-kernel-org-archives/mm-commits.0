Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353C922D4F1
	for <mm-commits@vger.kernel.org>; Sat, 10 May 2025 00:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746837949; cv=none; b=rRz21guV1DGla7n9Fq6WzAxt84fhjb99b4O5wW/Fee28Wl06iuhQ6MNm4Eo3RX+6EXl3CqQgG3rH+1HR2O3luuS0m9VQm7EwbbEZz5am78/VdpGqeBxycODT1C3QMGr3L213wVBwOi5dowqLSKYjSGkA/59D2A3E/bKoPhANju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746837949; c=relaxed/simple;
	bh=Po4c335hTMy+BW8lM6PSZywsQJhq76bEqK1YWsxxnXg=;
	h=Date:To:From:Subject:Message-Id; b=XCZxcq4CE3PXIiKoXqDxDNq9OdhsGNu9xO527+bxsy5WYqTYtWnYs1wkO90GeHG20NURQLyDZVVkD+gASv3fYaKOtX9CSQL4wTtqcX++qvL93h3fYoxvwFAGQsYd+qUYzpk1AgPyRVVYulLzCUPoHWi6m6NBIVqbez4Gibc9nEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i/ZSOA9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i/ZSOA9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4DDC4CEE4;
	Sat, 10 May 2025 00:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746837948;
	bh=Po4c335hTMy+BW8lM6PSZywsQJhq76bEqK1YWsxxnXg=;
	h=Date:To:From:Subject:From;
	b=i/ZSOA9icN5TuCRn4Z7wi4VzRI5fUmMcFRfvzMht+ROUrzn87oex1f72xK09IgePc
	 CaoFcWLdT3wEya6bmI5ju2OeasUZPbrm4x3AwR1RD+mpE0FcBD90q/BbYxoA7hybbv
	 a5oj3dqVlVt1zb0Z1uQ48UN9sGV1aXH/C6Wazab4=
Date: Fri, 09 May 2025 17:45:47 -0700
To: mm-commits@vger.kernel.org,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-clean-up-ifdef-logic-around-stack-allocation.patch added to mm-nonmm-unstable branch
Message-Id: <20250510004548.8B4DDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: clean-up ifdef logic around stack allocation
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

Therefore, clean up by Changing the order so OR is no longer needed.

[linus.walleij@linaro.org: rebased]
Link: https://lkml.kernel.org/r/20250509-fork-fixes-v3-1-e6c69dd356f2@linaro.org
Link: https://lkml.kernel.org/r/20250509-fork-fixes-v3-0-e6c69dd356f2@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-3-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
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
@@ -345,7 +339,13 @@ static void free_thread_stack(struct tas
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
@@ -377,8 +377,7 @@ static void free_thread_stack(struct tas
 	tsk->stack = NULL;
 }
 
-#  endif /* CONFIG_VMAP_STACK */
-# else /* !(THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)) */
+#else /* !(THREAD_SIZE >= PAGE_SIZE) */
 
 static struct kmem_cache *thread_stack_cache;
 
@@ -417,7 +416,8 @@ void thread_stack_cache_init(void)
 	BUG_ON(thread_stack_cache == NULL);
 }
 
-# endif /* THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK) */
+#endif /* THREAD_SIZE >= PAGE_SIZE */
+#endif /* CONFIG_VMAP_STACK */
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
 static struct kmem_cache *signal_cachep;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

task_stackh-remove-obsolete-__have_arch_kstack_end-check.patch
fork-clean-up-ifdef-logic-around-stack-allocation.patch
fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch
fork-check-charging-success-before-zeroing-stack.patch

