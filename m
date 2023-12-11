Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275907493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ov5wkVgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E780CC433C8;
	Mon, 11 Dec 2023 01:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257780;
	bh=fVXvwIXTL2ULI0qO0NkJxs0y+NruT48hLTyUW8skkvE=;
	h=Date:To:From:Subject:From;
	b=Ov5wkVgguUsLRDZXOTHfDL0tgUwXBCPivhpp2u/mnoN8aPysFfz9mtJtiQYDvqali
	 7VdYgD39goxr2Imd0Euckcdi3HkRlXA0Q2rAr3Gxr8kyZ/a0Wtz0MgSm4NLYU3OG2G
	 tC1RgvM4wTSahy1xVUdZvo8ltHZ+ngesjV7RrocU=
Date: Sun, 10 Dec 2023 17:22:59 -0800
To: mm-commits@vger.kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,arnd@arndb.de,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arch-remove-arch_task_struct_allocator.patch removed from -mm tree
Message-Id: <20231211012259.E780CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch: remove ARCH_TASK_STRUCT_ALLOCATOR
has been removed from the -mm tree.  Its filename was
     arch-remove-arch_task_struct_allocator.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: arch: remove ARCH_TASK_STRUCT_ALLOCATOR
Date: Thu, 16 Nov 2023 14:36:37 +0100

IA-64 was the only architecture which selected ARCH_TASK_STRUCT_ALLOCATOR.
IA-64 was removed with commit cf8e8658100d ("arch: Remove Itanium (IA-64)
architecture"). Therefore remove support for ARCH_THREAD_STACK_ALLOCATOR
as well.

Link: https://lkml.kernel.org/r/20231116133638.1636277-3-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig  |    5 -----
 kernel/fork.c |    6 ------
 2 files changed, 11 deletions(-)

--- a/arch/Kconfig~arch-remove-arch_task_struct_allocator
+++ a/arch/Kconfig
@@ -305,13 +305,8 @@ config ARCH_HAS_CPU_FINALIZE_INIT
 config ARCH_TASK_STRUCT_ON_STACK
 	bool
 
-# Select if arch has its private alloc_task_struct() function
-config ARCH_TASK_STRUCT_ALLOCATOR
-	bool
-
 config HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	bool
-	depends on !ARCH_TASK_STRUCT_ALLOCATOR
 	help
 	  An architecture should select this to provide hardened usercopy
 	  knowledge about what region of the thread_struct should be
--- a/kernel/fork.c~arch-remove-arch_task_struct_allocator
+++ a/kernel/fork.c
@@ -165,7 +165,6 @@ void __weak arch_release_task_struct(str
 {
 }
 
-#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 static struct kmem_cache *task_struct_cachep;
 
 static inline struct task_struct *alloc_task_struct_node(int node)
@@ -177,7 +176,6 @@ static inline void free_task_struct(stru
 {
 	kmem_cache_free(task_struct_cachep, tsk);
 }
-#endif
 
 /*
  * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
@@ -1001,7 +999,6 @@ static void set_max_threads(unsigned int
 int arch_task_struct_size __read_mostly;
 #endif
 
-#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 static void task_struct_whitelist(unsigned long *offset, unsigned long *size)
 {
 	/* Fetch thread_struct whitelist for the architecture. */
@@ -1016,12 +1013,10 @@ static void task_struct_whitelist(unsign
 	else
 		*offset += offsetof(struct task_struct, thread);
 }
-#endif /* CONFIG_ARCH_TASK_STRUCT_ALLOCATOR */
 
 void __init fork_init(void)
 {
 	int i;
-#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	0
 #endif
@@ -1034,7 +1029,6 @@ void __init fork_init(void)
 			arch_task_struct_size, align,
 			SLAB_PANIC|SLAB_ACCOUNT,
 			useroffset, usersize, NULL);
-#endif
 
 	/* do the arch specific task caches init */
 	arch_task_cache_init();
_

Patches currently in -mm which might be from hca@linux.ibm.com are


