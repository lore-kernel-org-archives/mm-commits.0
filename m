From: akpm@osdl.org
Subject: - local_t-mips-extension-fix.patch removed from -mm tree
Date: Sat, 27 Jan 2007 02:19:13 -0800
Message-ID: <200701271020.l0RAK3Ah007126@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbXA0KX0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 05:23:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     local_t-mips-extension fix
has been removed from the -mm tree.  Its filename was
     local_t-mips-extension-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: local_t-mips-extension fix
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Correction of MIPS variables and config options.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-mips/local.h |   85 ++++++++++++++++++-------------------
 1 files changed, 43 insertions(+), 42 deletions(-)

diff -puN include/asm-mips/local.h~local_t-mips-extension-fix include/asm-mips/local.h
--- a/include/asm-mips/local.h~local_t-mips-extension-fix
+++ a/include/asm-mips/local.h
@@ -1,8 +1,9 @@
-#ifndef _ARCH_POWERPC_LOCAL_H
-#define _ARCH_POWERPC_LOCAL_H
+#ifndef _ARCH_MIPS_LOCAL_H
+#define _ARCH_MIPSRPC_LOCAL_H
 
 #include <linux/percpu.h>
 #include <asm/atomic.h>
+#include <asm/war.h>
 
 typedef struct
 {
@@ -20,7 +21,7 @@ typedef struct
 #define local_dec(l)	local_long_dec(&(l)->a)
 
 
-#ifndef CONFIG_64BITS
+#ifndef CONFIG_64BIT
 
 /*
  * Same as above, but return the result value
@@ -40,8 +41,8 @@ static __inline__ int local_add_return(i
 		"	beqzl	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -54,16 +55,16 @@ static __inline__ int local_add_return(i
 		"	beqz	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result += i;
-		&(l->a.counter) = result;
+		l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -85,8 +86,8 @@ static __inline__ int local_sub_return(i
 		"	beqzl	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -99,16 +100,16 @@ static __inline__ int local_sub_return(i
 		"	beqz	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result -= i;
-		&(l->a.counter) = result;
+		l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -142,8 +143,8 @@ static __inline__ int local_sub_if_posit
 		"	.set	reorder					\n"
 		"1:							\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -160,17 +161,17 @@ static __inline__ int local_sub_if_posit
 		"	.set	reorder					\n"
 		"1:							\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result -= i;
 		if (result >= 0)
-			&(l->a.counter) = result;
+			l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -251,7 +252,7 @@ static __inline__ int local_sub_if_posit
  */
 #define local_add_negative(i,l) (local_add_return(i, (l)) < 0)
 
-#else /* CONFIG_64BITS */
+#else /* CONFIG_64BIT */
 
 /*
  * Same as above, but return the result value
@@ -271,8 +272,8 @@ static __inline__ long local_add_return(
 		"	beqzl	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -285,16 +286,16 @@ static __inline__ long local_add_return(
 		"	beqz	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result += i;
-		&(l->a.counter) = result;
+		l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -316,8 +317,8 @@ static __inline__ long local_sub_return(
 		"	beqzl	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -330,16 +331,16 @@ static __inline__ long local_sub_return(
 		"	beqz	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result -= i;
-		&(l->a.counter) = result;
+		l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -373,8 +374,8 @@ static __inline__ long local_sub_if_posi
 		"	.set	reorder					\n"
 		"1:							\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else if (cpu_has_llsc) {
 		unsigned long temp;
@@ -391,17 +392,17 @@ static __inline__ long local_sub_if_posi
 		"	.set	reorder					\n"
 		"1:							\n"
 		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
-		: "Ir" (i), "m" (&(l->a.counter))
+		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
+		: "Ir" (i), "m" (l->a.counter)
 		: "memory");
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		result = &(l->a.counter);
+		result = l->a.counter;
 		result -= i;
 		if (result >= 0)
-			&(l->a.counter) = result;
+			l->a.counter = result;
 		local_irq_restore(flags);
 	}
 
@@ -483,7 +484,7 @@ static __inline__ long local_sub_if_posi
  */
 #define local_add_negative(i,l) (local_add_return(i, (l)) < 0)
 
-#endif /* !CONFIG_64BITS */
+#endif /* !CONFIG_64BIT */
 
 
 /* Use these for per-cpu local_t variables: on some archs they are
@@ -521,4 +522,4 @@ static __inline__ long local_sub_if_posi
 #define __cpu_local_add(i, l)	cpu_local_add((i), (l))
 #define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
 
-#endif /* _ARCH_POWERPC_LOCAL_H */
+#endif /* _ARCH_MIPS_LOCAL_H */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
local_t-mips-extension-fix.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
