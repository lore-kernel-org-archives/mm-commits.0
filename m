Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8001D1FD7;
	Mon, 12 Feb 2024 22:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707777048; cv=none; b=F/lUGZ4mgb+NiXeul8j1pATN7+TKVKAdFVePulRmZZtBP9ie7qKT17Q0NhWRENFS0WLh6QMY9v7WEYU54IxWMGWQ5juOPtbGScB5mPXz8jtU/E8s7FxfWyyOc+scqQDxkqxhdlbyBZgqntZTomsQL7Veqcwd3d2VhTnAaWDvXu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707777048; c=relaxed/simple;
	bh=arNrNdq1U2jRMGMoLLjHgljDP1l349QDh1b2d/xif58=;
	h=Date:To:From:Subject:Message-Id; b=p6GIXDomTS7eSFlnWT/572W9y9Axaw28tsJ6DF9n85ZYHA24cNrxNzmy048b1tiO7Y62h09YsZgTEIaGylbNQ68gli3eLejZjXjLXKUF8AgpjPCXuGNQVNCIpIXRos/DhHqnlYnCXZyt5tV22sFWV+cielyvDV/edPfryJVqXcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2fPYtyx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2fPYtyx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBBAC433F1;
	Mon, 12 Feb 2024 22:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707777048;
	bh=arNrNdq1U2jRMGMoLLjHgljDP1l349QDh1b2d/xif58=;
	h=Date:To:From:Subject:From;
	b=2fPYtyx9RzSL4FIhRJuRCRhLXW7YC/nVC/M5RF07icgu9U/IyTjIe8TGwzpNEY5ub
	 +VEbEE+8KGZR8asUUeexsJRZT6tisBtLM/HFuF4WCK8SankNan0RnAag92+momBYNY
	 imZ/Cb8E5BydV6hoQIT/PQ3BonGTlfX8LhmlT4a0=
Date: Mon, 12 Feb 2024 14:30:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + introduce-cpu_dcache_is_aliasing-across-all-architectures.patch added to mm-unstable branch
Message-Id: <20240212223048.3DBBAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Introduce cpu_dcache_is_aliasing() across all architectures
has been added to the -mm mm-unstable branch.  Its filename is
     introduce-cpu_dcache_is_aliasing-across-all-architectures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/introduce-cpu_dcache_is_aliasing-across-all-architectures.patch

This patch will later appear in the mm-unstable branch at
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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Introduce cpu_dcache_is_aliasing() across all architectures
Date: Mon, 12 Feb 2024 11:31:00 -0500

Introduce a generic way to query whether the data cache is virtually
aliased on all architectures.  Its purpose is to ensure that subsystems
which are incompatible with virtually aliased data caches (e.g.  FS_DAX)
can reliably query this.

For data cache aliasing, there are three scenarios dependending on the
architecture. Here is a breakdown based on my understanding:

A) The data cache is always aliasing:

* arc
* csky
* m68k (note: shared memory mappings are incoherent ? SHMLBA is missing there.)
* sh
* parisc

B) The data cache aliasing is statically known or depends on querying CPU
   state at runtime:

* arm (cache_is_vivt() || cache_is_vipt_aliasing())
* mips (cpu_has_dc_aliases)
* nios2 (NIOS2_DCACHE_SIZE > PAGE_SIZE)
* sparc32 (vac_cache_size > PAGE_SIZE)
* sparc64 (L1DCACHE_SIZE > PAGE_SIZE)
* xtensa (DCACHE_WAY_SIZE > PAGE_SIZE)

C) The data cache is never aliasing:

* alpha
* arm64 (aarch64)
* hexagon
* loongarch (but with incoherent write buffers, which are disabled since
             commit d23b7795 ("LoongArch: Change SHMLBA from SZ_64K to PAGE_SIZE"))
* microblaze
* openrisc
* powerpc
* riscv
* s390
* um
* x86

Require architectures in A) and B) to select ARCH_HAS_CPU_CACHE_ALIASING and
implement "cpu_dcache_is_aliasing()".

Architectures in C) don't select ARCH_HAS_CPU_CACHE_ALIASING, and thus
cpu_dcache_is_aliasing() simply evaluates to "false".

Note that this leaves "cpu_icache_is_aliasing()" to be implemented as future
work. This would be useful to gate features like XIP on architectures
which have aliasing CPU dcache-icache but not CPU dcache-dcache.

Use "cpu_dcache" and "cpu_cache" rather than just "dcache" and "cache"
to clarify that we really mean "CPU data cache" and "CPU cache" to
eliminate any possible confusion with VFS "dentry cache" and "page
cache".

Link: https://lore.kernel.org/lkml/20030910210416.GA24258@mail.jlokier.co.uk/
Link: https://lkml.kernel.org/r/20240212163101.19614-8-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Michael Sclafani <dm-devel@lists.linux.dev>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig                    |    1 +
 arch/arc/include/asm/cachetype.h    |    9 +++++++++
 arch/arm/Kconfig                    |    1 +
 arch/arm/include/asm/cachetype.h    |    2 ++
 arch/csky/Kconfig                   |    1 +
 arch/csky/include/asm/cachetype.h   |    9 +++++++++
 arch/m68k/Kconfig                   |    1 +
 arch/m68k/include/asm/cachetype.h   |    9 +++++++++
 arch/mips/Kconfig                   |    1 +
 arch/mips/include/asm/cachetype.h   |    9 +++++++++
 arch/nios2/Kconfig                  |    1 +
 arch/nios2/include/asm/cachetype.h  |   10 ++++++++++
 arch/parisc/Kconfig                 |    1 +
 arch/parisc/include/asm/cachetype.h |    9 +++++++++
 arch/sh/Kconfig                     |    1 +
 arch/sh/include/asm/cachetype.h     |    9 +++++++++
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/cachetype.h  |   14 ++++++++++++++
 arch/xtensa/Kconfig                 |    1 +
 arch/xtensa/include/asm/cachetype.h |   10 ++++++++++
 include/linux/cacheinfo.h           |    6 ++++++
 mm/Kconfig                          |    6 ++++++
 22 files changed, 112 insertions(+)

--- /dev/null
+++ a/arch/arc/include/asm/cachetype.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_ARC_CACHETYPE_H
+#define __ASM_ARC_CACHETYPE_H
+
+#include <linux/types.h>
+
+#define cpu_dcache_is_aliasing()	true
+
+#endif
--- a/arch/arc/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/arc/Kconfig
@@ -6,6 +6,7 @@
 config ARC
 	def_bool y
 	select ARC_TIMERS
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DMA_PREP_COHERENT
--- a/arch/arm/include/asm/cachetype.h~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/arm/include/asm/cachetype.h
@@ -20,6 +20,8 @@ extern unsigned int cacheid;
 #define icache_is_vipt_aliasing()	cacheid_is(CACHEID_VIPT_I_ALIASING)
 #define icache_is_pipt()		cacheid_is(CACHEID_PIPT)
 
+#define cpu_dcache_is_aliasing()	(cache_is_vivt() || cache_is_vipt_aliasing())
+
 /*
  * __LINUX_ARM_ARCH__ is the minimum supported CPU architecture
  * Mask out support which will never be present on newer CPUs.
--- a/arch/arm/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/arm/Kconfig
@@ -5,6 +5,7 @@ config ARM
 	select ARCH_32BIT_OFF_T
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE if HAVE_KRETPROBES && FRAME_POINTER && !ARM_UNWIND
 	select ARCH_HAS_BINFMT_FLAT
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_CPU_FINALIZE_INIT if MMU
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
--- /dev/null
+++ a/arch/csky/include/asm/cachetype.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_CSKY_CACHETYPE_H
+#define __ASM_CSKY_CACHETYPE_H
+
+#include <linux/types.h>
+
+#define cpu_dcache_is_aliasing()	true
+
+#endif
--- a/arch/csky/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/csky/Kconfig
@@ -2,6 +2,7 @@
 config CSKY
 	def_bool y
 	select ARCH_32BIT_OFF_T
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
--- /dev/null
+++ a/arch/m68k/include/asm/cachetype.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_M68K_CACHETYPE_H
+#define __ASM_M68K_CACHETYPE_H
+
+#include <linux/types.h>
+
+#define cpu_dcache_is_aliasing()	true
+
+#endif
--- a/arch/m68k/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/m68k/Kconfig
@@ -3,6 +3,7 @@ config M68K
 	bool
 	default y
 	select ARCH_32BIT_OFF_T
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CPU_FINALIZE_INIT if MMU
 	select ARCH_HAS_CURRENT_STACK_POINTER
--- /dev/null
+++ a/arch/mips/include/asm/cachetype.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_MIPS_CACHETYPE_H
+#define __ASM_MIPS_CACHETYPE_H
+
+#include <asm/cpu-features.h>
+
+#define cpu_dcache_is_aliasing()	cpu_has_dc_aliases
+
+#endif
--- a/arch/mips/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/mips/Kconfig
@@ -4,6 +4,7 @@ config MIPS
 	default y
 	select ARCH_32BIT_OFF_T if !64BIT
 	select ARCH_BINFMT_ELF_STATE if MIPS_FP_SUPPORT
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER if !CC_IS_CLANG || CLANG_VERSION >= 140000
 	select ARCH_HAS_DEBUG_VIRTUAL if !64BIT
--- /dev/null
+++ a/arch/nios2/include/asm/cachetype.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_NIOS2_CACHETYPE_H
+#define __ASM_NIOS2_CACHETYPE_H
+
+#include <asm/page.h>
+#include <asm/cache.h>
+
+#define cpu_dcache_is_aliasing()	(NIOS2_DCACHE_SIZE > PAGE_SIZE)
+
+#endif
--- a/arch/nios2/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/nios2/Kconfig
@@ -2,6 +2,7 @@
 config NIOS2
 	def_bool y
 	select ARCH_32BIT_OFF_T
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
--- /dev/null
+++ a/arch/parisc/include/asm/cachetype.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_PARISC_CACHETYPE_H
+#define __ASM_PARISC_CACHETYPE_H
+
+#include <linux/types.h>
+
+#define cpu_dcache_is_aliasing()	true
+
+#endif
--- a/arch/parisc/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/parisc/Kconfig
@@ -8,6 +8,7 @@ config PARISC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_SYSCALL_TRACEPOINTS
 	select ARCH_WANT_FRAME_POINTERS
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_DMA_ALLOC if PA11
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_STRICT_KERNEL_RWX
--- /dev/null
+++ a/arch/sh/include/asm/cachetype.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_SH_CACHETYPE_H
+#define __ASM_SH_CACHETYPE_H
+
+#include <linux/types.h>
+
+#define cpu_dcache_is_aliasing()	true
+
+#endif
--- a/arch/sh/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/sh/Kconfig
@@ -2,6 +2,7 @@
 config SUPERH
 	def_bool y
 	select ARCH_32BIT_OFF_T
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM && MMU
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if SPARSEMEM && MMU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
--- /dev/null
+++ a/arch/sparc/include/asm/cachetype.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_SPARC_CACHETYPE_H
+#define __ASM_SPARC_CACHETYPE_H
+
+#include <asm/page.h>
+
+#ifdef CONFIG_SPARC32
+extern int vac_cache_size;
+#define cpu_dcache_is_aliasing()	(vac_cache_size > PAGE_SIZE)
+#else
+#define cpu_dcache_is_aliasing()	(L1DCACHE_SIZE > PAGE_SIZE)
+#endif
+
+#endif
--- a/arch/sparc/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/sparc/Kconfig
@@ -13,6 +13,7 @@ config 64BIT
 config SPARC
 	bool
 	default y
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_MIGHT_HAVE_PC_PARPORT if SPARC64 && PCI
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select DMA_OPS
--- /dev/null
+++ a/arch/xtensa/include/asm/cachetype.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_XTENSA_CACHETYPE_H
+#define __ASM_XTENSA_CACHETYPE_H
+
+#include <asm/cache.h>
+#include <asm/page.h>
+
+#define cpu_dcache_is_aliasing()	(DCACHE_WAY_SIZE > PAGE_SIZE)
+
+#endif
--- a/arch/xtensa/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/arch/xtensa/Kconfig
@@ -2,6 +2,7 @@
 config XTENSA
 	def_bool y
 	select ARCH_32BIT_OFF_T
+	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_BINFMT_FLAT if !MMU
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VM_PGTABLE
--- a/include/linux/cacheinfo.h~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/include/linux/cacheinfo.h
@@ -138,4 +138,10 @@ static inline int get_cpu_cacheinfo_id(i
 #define use_arch_cache_info()	(false)
 #endif
 
+#ifndef CONFIG_ARCH_HAS_CPU_CACHE_ALIASING
+#define cpu_dcache_is_aliasing()	false
+#else
+#include <asm/cachetype.h>
+#endif
+
 #endif /* _LINUX_CACHEINFO_H */
--- a/mm/Kconfig~introduce-cpu_dcache_is_aliasing-across-all-architectures
+++ a/mm/Kconfig
@@ -973,6 +973,12 @@ config IDLE_PAGE_TRACKING
 	  See Documentation/admin-guide/mm/idle_page_tracking.rst for
 	  more details.
 
+# Architectures which implement cpu_dcache_is_aliasing() to query
+# whether the data caches are aliased (VIVT or VIPT with dcache
+# aliasing) need to select this.
+config ARCH_HAS_CPU_CACHE_ALIASING
+	bool
+
 config ARCH_HAS_CACHE_LINE_SIZE
 	bool
 
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch
dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch
nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dcssblk-handle-alloc_dax-eopnotsupp-failure.patch
virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dax-check-for-data-cache-aliasing-at-runtime.patch
introduce-cpu_dcache_is_aliasing-across-all-architectures.patch
dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch

