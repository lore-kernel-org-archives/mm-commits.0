Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC5E635
	for <mm-commits@vger.kernel.org>; Thu, 19 Jun 2025 00:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750291739; cv=none; b=guimNEdsRilmLM4MkLeYpbG0TS7WhGgadHWxEr8X8dZdOuFCJqkQUECQ/0/jUTq6M0PTEXvCQKcU5kKe31UrNB2z+o72r4PTIj8TGEvdQYqVyRR1q+1NSKLpDnqicRQAdBfgt4XC1+rpOFtIyIdGy9lJAvQZfVwZrT5OgFYkYcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750291739; c=relaxed/simple;
	bh=nCyrJ9Y6ixXQSKitD7fMq8gSgnM1YcNfS1ojWByM8do=;
	h=Date:To:From:Subject:Message-Id; b=bfhZTnAKbsNcwMzUwuvY0nO5y5jpKkrxmkjRrn1pD9KzF87biWe2eidaD6N1OAqsDFNkeIrjV0D8j8g7LdAmeOFg5+jhSoYTVbi1bdvJY3YLt+SgRKIkbg/+1RUK4XMpJd3svSpjeRc4QEZYX2lAhJRjyTu/GUcKxd9hTFWdVlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JYwSRoYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JYwSRoYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91C1C4CEE7;
	Thu, 19 Jun 2025 00:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750291738;
	bh=nCyrJ9Y6ixXQSKitD7fMq8gSgnM1YcNfS1ojWByM8do=;
	h=Date:To:From:Subject:From;
	b=JYwSRoYFoUWCGiLRru2xbvPF7ubp51y7ZvwPzMYxijg7+H4H+GIV75QfGLawoSK3L
	 J5TJbPWgn4txlHWxfsUUTGaHpsi5UECqEiLYTPnC40fNXZoKg5jyeGyrUCcyckfTzF
	 7M5ZCeX8ZhI9UjVm0iDjOH9VDIbDAJCMaAZw2ob4=
Date: Wed, 18 Jun 2025 17:08:58 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,richard.henderson@linaro.org,mattst88@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kent.overstreet@linux.dev,hca@linux.ibm.com,gor@linux.ibm.com,dennis@kernel.org,david@redhat.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu.patch added to mm-new branch
Message-Id: <20250619000858.A91C1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu: conditionally define _shared_alloc_tag via CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/percpu: conditionally define _shared_alloc_tag via CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
Date: Wed, 18 Jun 2025 09:58:09 +0800

Recently discovered this entry while checking kallsyms on ARM64:
ffff800083e509c0 D _shared_alloc_tag

If ARCH_NEEDS_WEAK_PER_CPU is not defined(it is only defined for s390 and
alpha architectures), there's no need to statically define the percpu
variable _shared_alloc_tag.

Therefore, we need to implement isolation for this purpose.

When building the core kernel code for s390 or alpha architectures,
ARCH_NEEDS_WEAK_PER_CPU remains undefined (as it is gated by #if
defined(MODULE)).  However, when building modules for these architectures,
the macro is explicitly defined.

Therefore, we remove all instances of ARCH_NEEDS_WEAK_PER_CPU from the
code and introduced CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU to replace the
relevant logic.  We can now conditionally define the perpcu variable
_shared_alloc_tag based on CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU.  This
allows architectures (such as s390/alpha) that require weak definitions
for percpu variables in modules to include the definition, while others
can omit it via compile-time exclusion.

Link: https://lkml.kernel.org/r/20250618015809.1235761-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>	[s390]
Cc: Chistoph Lameter <cl@linux.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig              |    1 +
 arch/alpha/include/asm/percpu.h |    5 ++---
 arch/s390/Kconfig               |    1 +
 arch/s390/include/asm/percpu.h  |    5 ++---
 include/linux/alloc_tag.h       |    6 +++---
 include/linux/percpu-defs.h     |    7 ++++---
 lib/alloc_tag.c                 |    2 ++
 mm/Kconfig                      |    7 +++++++
 8 files changed, 22 insertions(+), 12 deletions(-)

--- a/arch/alpha/include/asm/percpu.h~mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu
+++ a/arch/alpha/include/asm/percpu.h
@@ -9,10 +9,9 @@
  * way above 4G.
  *
  * Always use weak definitions for percpu variables in modules.
+ * Therefore, we have enabled CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
+ * in the Kconfig.
  */
-#if defined(MODULE) && defined(CONFIG_SMP)
-#define ARCH_NEEDS_WEAK_PER_CPU
-#endif
 
 #include <asm-generic/percpu.h>
 
--- a/arch/alpha/Kconfig~mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu
+++ a/arch/alpha/Kconfig
@@ -7,6 +7,7 @@ config ALPHA
 	select ARCH_HAS_DMA_OPS if PCI
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
+	select ARCH_MODULE_NEEDS_WEAK_PER_CPU if SMP
 	select ARCH_NO_PREEMPT
 	select ARCH_NO_SG_CHAIN
 	select ARCH_USE_CMPXCHG_LOCKREF
--- a/arch/s390/include/asm/percpu.h~mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu
+++ a/arch/s390/include/asm/percpu.h
@@ -16,10 +16,9 @@
  * For 64 bit module code, the module may be more than 4G above the
  * per cpu area, use weak definitions to force the compiler to
  * generate external references.
+ * Therefore, we have enabled CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
+ * in the Kconfig.
  */
-#if defined(MODULE)
-#define ARCH_NEEDS_WEAK_PER_CPU
-#endif
 
 /*
  * We use a compare-and-swap loop since that uses less cpu cycles than
--- a/arch/s390/Kconfig~mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu
+++ a/arch/s390/Kconfig
@@ -132,6 +132,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+	select ARCH_MODULE_NEEDS_WEAK_PER_CPU
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
--- a/include/linux/alloc_tag.h~mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu
+++ a/include/linux/alloc_tag.h
@@ -88,7 +88,7 @@ static inline struct alloc_tag *ct_to_al
 	return container_of(ct, struct alloc_tag, ct);
 }
 
-#ifdef ARCH_NEEDS_WEAK_PER_CPU
+#if defined(CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU) && defined(MODULE)
 /*
  * When percpu variables are required to be defined as weak, static percpu
  * variables can't be used inside a function (see comments for DECLARE_PER_CPU_SECTION).
@@ -102,7 +102,7 @@ DECLARE_PER_CPU(struct alloc_tag_counter
 		.ct = CODE_TAG_INIT,						\
 		.counters = &_shared_alloc_tag };
 
-#else /* ARCH_NEEDS_WEAK_PER_CPU */
+#else /* CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU && MODULE */
 
 #ifdef MODULE
 
@@ -123,7 +123,7 @@ DECLARE_PER_CPU(struct alloc_tag_counter
 
 #endif /* MODULE */
 
-#endif /* ARCH_NEEDS_WEAK_PER_CPU */
+#endif /* CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU && MODULE */
 
 DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
--- a/include/linux/percpu-defs.h~mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu
+++ a/include/linux/percpu-defs.h
@@ -63,14 +63,15 @@
  * 1. The symbol must be globally unique, even the static ones.
  * 2. Static percpu variables cannot be defined inside a function.
  *
- * Archs which need weak percpu definitions should define
- * ARCH_NEEDS_WEAK_PER_CPU in asm/percpu.h when necessary.
+ * Archs which need weak percpu definitions should set
+ * CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU when necessary.
  *
  * To ensure that the generic code observes the above two
  * restrictions, if CONFIG_DEBUG_FORCE_WEAK_PER_CPU is set weak
  * definition is used for all cases.
  */
-#if defined(ARCH_NEEDS_WEAK_PER_CPU) || defined(CONFIG_DEBUG_FORCE_WEAK_PER_CPU)
+#if (defined(CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU) && defined(MODULE)) || \
+	defined(CONFIG_DEBUG_FORCE_WEAK_PER_CPU)
 /*
  * __pcpu_scope_* dummy variable is used to enforce scope.  It
  * receives the static modifier when it's used in front of
--- a/lib/alloc_tag.c~mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu
+++ a/lib/alloc_tag.c
@@ -24,8 +24,10 @@ static bool mem_profiling_support;
 
 static struct codetag_type *alloc_tag_cttype;
 
+#ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
 DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 EXPORT_SYMBOL(_shared_alloc_tag);
+#endif
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
--- a/mm/Kconfig~mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu
+++ a/mm/Kconfig
@@ -934,6 +934,13 @@ config ARCH_SUPPORTS_PUD_PFNMAP
 	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 
 #
+# Architectures that always use weak definitions for percpu
+# variables in modules should set this.
+#
+config ARCH_MODULE_NEEDS_WEAK_PER_CPU
+       bool
+
+#
 # UP and nommu archs use km based percpu allocator
 #
 config NEED_PER_CPU_KM
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu.patch

