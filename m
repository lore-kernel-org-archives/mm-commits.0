From: akpm@linux-foundation.org
Subject: - add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:45 -0800
Message-ID: <200802080808.m1888QcN014635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45023 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761254AbYBHIUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg64 and cmpxchg64_local to alpha
has been removed from the -mm tree.  Its filename was
     add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add cmpxchg64 and cmpxchg64_local to alpha
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/system.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN include/asm-alpha/system.h~add-cmpxchg64-and-cmpxchg64_local-to-alpha include/asm-alpha/system.h
--- a/include/asm-alpha/system.h~add-cmpxchg64-and-cmpxchg64_local-to-alpha
+++ a/include/asm-alpha/system.h
@@ -681,13 +681,18 @@ __cmpxchg(volatile void *ptr, unsigned l
 	return old;
 }
 
-#define cmpxchg(ptr,o,n)						 \
+#define cmpxchg(ptr, o, n)						 \
   ({									 \
      __typeof__(*(ptr)) _o_ = (o);					 \
      __typeof__(*(ptr)) _n_ = (n);					 \
      (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
+#define cmpxchg64(ptr, o, n)						 \
+  ({									 \
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				 \
+	cmpxchg((ptr), (o), (n));					 \
+  })
 
 static inline unsigned long
 __cmpxchg_u8_local(volatile char *m, long old, long new)
@@ -803,13 +808,19 @@ __cmpxchg_local(volatile void *ptr, unsi
 	return old;
 }
 
-#define cmpxchg_local(ptr,o,n)						 \
+#define cmpxchg_local(ptr, o, n)					 \
   ({									 \
      __typeof__(*(ptr)) _o_ = (o);					 \
      __typeof__(*(ptr)) _n_ = (n);					 \
      (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
+#define cmpxchg64_local(ptr, o, n)					 \
+  ({									 \
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				 \
+	cmpxchg_local((ptr), (o), (n));					 \
+  })
+
 
 #endif /* __ASSEMBLY__ */
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
