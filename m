From: akpm@osdl.org
Subject: - atomich-i386-type-safety-fix.patch removed from -mm tree
Date: Sat, 27 Jan 2007 02:18:42 -0800
Message-ID: <200701271019.l0RAJW76007075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47632 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbXA0KTo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 05:19:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@muc.de, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     atomic.h: i386 type safety fix
has been removed from the -mm tree.  Its filename was
     atomich-i386-type-safety-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: atomic.h: i386 type safety fix
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This patch removes an explicit cast to an integer type for the result returned
by cmpxchg.  It is not per se a problem on the i386 architecture, because
sizeof(int) == sizeof(long), but whenever this code is cut'n'pasted to a
accept passing an atomic64_t value as parameter to cmpxchg, xchg and
add_unless, having 64 bits inputs casted to 32 bits.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@muc.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-i386/atomic.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN include/asm-i386/atomic.h~atomich-i386-type-safety-fix include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~atomich-i386-type-safety-fix
+++ a/include/asm-i386/atomic.h
@@ -207,8 +207,9 @@ static __inline__ int atomic_sub_return(
 	return atomic_add_return(-i,v);
 }
 
-#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+#define atomic_cmpxchg(v, old, new) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (old), (new)))
+#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
 
 /**
  * atomic_add_unless - add unless the number is already a given value
@@ -221,7 +222,7 @@ static __inline__ int atomic_sub_return(
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

relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64-fix.patch
local_t-architecture-independent-extension.patch
local_t-alpha-extension.patch
local_t-alpha-extension-fix.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
