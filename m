From: akpm@linux-foundation.org
Subject: + x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch added to -mm tree
Date: Tue, 12 Feb 2008 14:00:34 -0800
Message-ID: <200802122200.m1CM0YZY024502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753447AbYBLWBV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 17:01:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, clameter@sgi.com, mingo@elte.hu, penberg@cs.helsinki.fi, tglx@linutronix.de, vegard.nossum@gmail.com


The patch titled
     x86: cast cmpxchg and cmpxchg_local result for 386 and 486
has been added to the -mm tree.  Its filename is
     x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Christoph Lameter <clameter@sgi.com>
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
+		__ret = __typeof__(*(ptr))__cmpxchg64((ptr),		\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+		__ret = __typeof__(*(ptr))cmpxchg_486_u64((ptr),	\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
 })
@@ -312,10 +318,12 @@ extern unsigned long long cmpxchg_486_u6
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = __cmpxchg64_local((ptr), (unsigned long long)(o), \
+		__ret = __typeof__(*(ptr))__cmpxchg64_local((ptr),	\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+		__ret = __typeof__(*(ptr))cmpxchg_486_u64((ptr),	\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
 })
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
fix-frv-cmpxchg_local.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-create-modpost-file.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
