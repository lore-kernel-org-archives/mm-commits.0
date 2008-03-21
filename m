From: akpm@linux-foundation.org
Subject: - x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:17 -0700
Message-ID: <200803212031.m2LKVHeC009061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761261AbYCUUbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, clameter@sgi.com, mingo@elte.hu, penberg@cs.helsinki.fi, tglx@linutronix.de, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     x86: cast cmpxchg and cmpxchg_local result for 386 and 486
has been removed from the -mm tree.  Its filename was
     x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: cast cmpxchg and cmpxchg_local result for 386 and 486
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

mm/slub.c: In function 'slab_alloc':
mm/slub.c:1637: warning: assignment makes pointer from integer without a cast
mm/slub.c:1637: warning: assignment makes pointer from integer without a cast
mm/slub.c: In function 'slab_free':
mm/slub.c:1796: warning: assignment makes pointer from integer without a cast
mm/slub.c:1796: warning: assignment makes pointer from integer without a cast
Hmmm.. That cmpxchg local needs to be fixed? Mathieu?

A cast is needed in the 386 and 486 code because the type is a pointer.  In
every other integer case the original cmpxchg code (and the cmpxchg_local
which has been copied from it) worked fine, but since we touch a pointer,
the type needs to be casted in the cmpxchg_local and cmpxchg macros.

The more recent code (586+) does not have this problem (the cast is already
there).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/cmpxchg_32.h |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff -puN include/asm-x86/cmpxchg_32.h~x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486 include/asm-x86/cmpxchg_32.h
--- a/include/asm-x86/cmpxchg_32.h~x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486
+++ a/include/asm-x86/cmpxchg_32.h
@@ -269,22 +269,26 @@ static inline unsigned long cmpxchg_386(
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
+		__ret = (__typeof__(*(ptr)))__cmpxchg((ptr),		\
+				(unsigned long)(o), (unsigned long)(n),	\
+				sizeof(*(ptr)));			\
 	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
+		__ret = (__typeof__(*(ptr)))cmpxchg_386((ptr),		\
+				(unsigned long)(o), (unsigned long)(n),	\
+				sizeof(*(ptr)));			\
 	__ret;								\
 })
 #define cmpxchg_local(ptr, o, n)					\
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg_local((ptr), (unsigned long)(o),	\
-					(unsigned long)(n), sizeof(*(ptr))); \
+		__ret = (__typeof__(*(ptr)))__cmpxchg_local((ptr),	\
+				(unsigned long)(o), (unsigned long)(n),	\
+				sizeof(*(ptr)));			\
 	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
+		__ret = (__typeof__(*(ptr)))cmpxchg_386((ptr),		\
+				(unsigned long)(o), (unsigned long)(n),	\
+				sizeof(*(ptr)));			\
 	__ret;								\
 })
 #endif
@@ -301,10 +305,12 @@ extern unsigned long long cmpxchg_486_u6
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = __cmpxchg64((ptr), (unsigned long long)(o),	\
+		__ret = (__typeof__(*(ptr)))__cmpxchg64((ptr),		\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
 })
@@ -312,10 +318,12 @@ extern unsigned long long cmpxchg_486_u6
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = __cmpxchg64_local((ptr), (unsigned long long)(o), \
+		__ret = (__typeof__(*(ptr)))__cmpxchg64_local((ptr),	\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
 })
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
make-marker_debug-static.patch

