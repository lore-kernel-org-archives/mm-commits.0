From: akpm@linux-foundation.org
Subject: - atomich-i386-type-safety-fix.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:56 -0700
Message-ID: <200705090254.l492suvn009864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934636AbXEICzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@muc.de, mm-commits@vger.kernel.org


The patch titled
     atomic.h: i386 type safety fix
has been removed from the -mm tree.  Its filename was
     atomich-i386-type-safety-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atomic.h: i386 type safety fix
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Remove an explicit cast to an integer type for the result returned by cmpxchg.
 It is not per se a problem on the i386 architecture, because sizeof(int) ==
sizeof(long), but whenever this code is cut'n'pasted to a accept passing an
atomic64_t value as parameter to cmpxchg, xchg and add_unless, having 64 bits
inputs casted to 32 bits.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/atomic.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-i386/atomic.h~atomich-i386-type-safety-fix include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~atomich-i386-type-safety-fix
+++ a/include/asm-i386/atomic.h
@@ -207,8 +207,8 @@ static __inline__ int atomic_sub_return(
 	return atomic_add_return(-i,v);
 }
 
-#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
+#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
 
 /**
  * atomic_add_unless - add unless the number is already a given value
@@ -221,7 +221,7 @@ static __inline__ int atomic_sub_return(
  */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;			\
 	c = atomic_read(v);					\
 	for (;;) {						\
 		if (unlikely(c == (u)))				\
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
