Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBBC7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VwVd+Xi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CA1C433CA;
	Mon, 11 Dec 2023 01:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257779;
	bh=9kV+DBzfTtlDwHZ+kGc9phO9rlPp8SjGkr0JO/92I+c=;
	h=Date:To:From:Subject:From;
	b=VwVd+Xi4cqI09/WaEWzP8Kj9bZP+Jo54xwFJX2X5TQ/yJPd7FWtivUUGbr/PEKrus
	 UZ/r/2SD9SUXYNLWb+nKX3LS26S3aYM4tjrrZ2ARsFmSwhKIb7GGKB/ug8XlcAknrZ
	 fI/TDtHjPUi/TpQUcVYbj7GjpSltsYkymRlsLpK0=
Date: Sun, 10 Dec 2023 17:22:58 -0800
To: mm-commits@vger.kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,arnd@arndb.de,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arch-remove-arch_thread_stack_allocator.patch removed from -mm tree
Message-Id: <20231211012259.06CA1C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch: remove ARCH_THREAD_STACK_ALLOCATOR
has been removed from the -mm tree.  Its filename was
     arch-remove-arch_thread_stack_allocator.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: arch: remove ARCH_THREAD_STACK_ALLOCATOR
Date: Thu, 16 Nov 2023 14:36:36 +0100

Patch series "Remove unused code after IA-64 removal".

While looking into something different I noticed that there are a couple
of Kconfig options which were only selected by IA-64 and which are now
unused.

So remove them and simplify the code a bit.


This patch (of 3):

IA-64 was the only architecture which selected ARCH_THREAD_STACK_ALLOCATOR.
IA-64 was removed with commit cf8e8658100d ("arch: Remove Itanium (IA-64)
architecture"). Therefore remove support for ARCH_THREAD_STACK_ALLOCATOR as
well.

Link: https://lkml.kernel.org/r/20231116133638.1636277-1-hca@linux.ibm.com
Link: https://lkml.kernel.org/r/20231116133638.1636277-2-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig  |    4 ----
 kernel/fork.c |   20 --------------------
 2 files changed, 24 deletions(-)

--- a/arch/Kconfig~arch-remove-arch_thread_stack_allocator
+++ a/arch/Kconfig
@@ -320,10 +320,6 @@ config HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	  should be implemented. Without this, the entire thread_struct
 	  field in task_struct will be left whitelisted.
 
-# Select if arch has its private alloc_thread_stack() function
-config ARCH_THREAD_STACK_ALLOCATOR
-	bool
-
 # Select if arch wants to size task_struct dynamically via arch_task_struct_size:
 config ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	bool
--- a/kernel/fork.c~arch-remove-arch_thread_stack_allocator
+++ a/kernel/fork.c
@@ -179,8 +179,6 @@ static inline void free_task_struct(stru
 }
 #endif
 
-#ifndef CONFIG_ARCH_THREAD_STACK_ALLOCATOR
-
 /*
  * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
  * kmemcache based allocator.
@@ -412,24 +410,6 @@ void thread_stack_cache_init(void)
 }
 
 # endif /* THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK) */
-#else /* CONFIG_ARCH_THREAD_STACK_ALLOCATOR */
-
-static int alloc_thread_stack_node(struct task_struct *tsk, int node)
-{
-	unsigned long *stack;
-
-	stack = arch_alloc_thread_stack_node(tsk, node);
-	tsk->stack = stack;
-	return stack ? 0 : -ENOMEM;
-}
-
-static void free_thread_stack(struct task_struct *tsk)
-{
-	arch_free_thread_stack(tsk);
-	tsk->stack = NULL;
-}
-
-#endif /* !CONFIG_ARCH_THREAD_STACK_ALLOCATOR */
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
 static struct kmem_cache *signal_cachep;
_

Patches currently in -mm which might be from hca@linux.ibm.com are


