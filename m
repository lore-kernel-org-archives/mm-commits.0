From: akpm@linux-foundation.org
Subject: [merged] alpha-fix-percpu-build-breakage.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:26:44 -0700
Message-ID: <200907011726.n61HQidV001459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146AbZGAR16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:27:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ink@jurassic.park.msu.ru, max@stro.at, rth@twiddle.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     alpha: fix percpu build breakage
has been removed from the -mm tree.  Its filename was
     alpha-fix-percpu-build-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: fix percpu build breakage
From: Tejun Heo <tj@kernel.org>

alpha percpu access requires custom SHIFT_PERCPU_PTR() definition for
modules to work around addressing range limitation.  This is done via
generating inline assembly using C preprocessing which forces the
assembler to generate external reference.  This happens behind the
compiler's back and makes the compiler think that static percpu variables
in modules are unused.

This used to be worked around by using __unused attribute for percpu
variables which prevent the compiler from omitting the variable; however,
recent declare/definition attribute unification change broke this as
__used can't be used for declaration.  Also, in the process,
PER_CPU_ATTRIBUTES definition in alpha percpu.h got broken.

This patch adds PER_CPU_DEF_ATTRIBUTES which is only used for definitions
and make alpha use it to add __used for percpu variables in modules.  This
also fixes the PER_CPU_ATTRIBUTES double definition bug.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: maximilian attems <max@stro.at>
Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/percpu.h |    6 +++---
 include/asm-generic/percpu.h    |    4 ++++
 include/linux/percpu-defs.h     |    3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff -puN arch/alpha/include/asm/percpu.h~alpha-fix-percpu-build-breakage arch/alpha/include/asm/percpu.h
--- a/arch/alpha/include/asm/percpu.h~alpha-fix-percpu-build-breakage
+++ a/arch/alpha/include/asm/percpu.h
@@ -30,7 +30,7 @@ extern unsigned long __per_cpu_offset[NR
 
 #ifndef MODULE
 #define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
-#define PER_CPU_ATTRIBUTES
+#define PER_CPU_DEF_ATTRIBUTES
 #else
 /*
  * To calculate addresses of locally defined variables, GCC uses 32-bit
@@ -49,7 +49,7 @@ extern unsigned long __per_cpu_offset[NR
 		: "=&r"(__ptr), "=&r"(tmp_gp));		\
 	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
 
-#define PER_CPU_ATTRIBUTES	__used
+#define PER_CPU_DEF_ATTRIBUTES	__used
 
 #endif /* MODULE */
 
@@ -71,7 +71,7 @@ extern unsigned long __per_cpu_offset[NR
 #define __get_cpu_var(var)		per_cpu_var(var)
 #define __raw_get_cpu_var(var)		per_cpu_var(var)
 
-#define PER_CPU_ATTRIBUTES
+#define PER_CPU_DEF_ATTRIBUTES
 
 #endif /* SMP */
 
diff -puN include/asm-generic/percpu.h~alpha-fix-percpu-build-breakage include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~alpha-fix-percpu-build-breakage
+++ a/include/asm-generic/percpu.h
@@ -97,4 +97,8 @@ extern void setup_per_cpu_areas(void);
 #define PER_CPU_ATTRIBUTES
 #endif
 
+#ifndef PER_CPU_DEF_ATTRIBUTES
+#define PER_CPU_DEF_ATTRIBUTES
+#endif
+
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff -puN include/linux/percpu-defs.h~alpha-fix-percpu-build-breakage include/linux/percpu-defs.h
--- a/include/linux/percpu-defs.h~alpha-fix-percpu-build-breakage
+++ a/include/linux/percpu-defs.h
@@ -24,7 +24,8 @@
 
 #define DEFINE_PER_CPU_SECTION(type, name, section)			\
 	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+	PER_CPU_ATTRIBUTES PER_CPU_DEF_ATTRIBUTES			\
+	__typeof__(type) per_cpu__##name
 
 /*
  * Variant on the per-CPU variable declaration/definition theme used for
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch

