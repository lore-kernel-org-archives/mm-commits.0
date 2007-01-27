From: akpm@osdl.org
Subject: - atomich-complete-atomic_long-operations-in-asm-generic.patch removed from -mm tree
Date: Sat, 27 Jan 2007 02:18:31 -0800
Message-ID: <200701271019.l0RAJLRK007057@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbXA0KT3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 05:19:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     atomic.h: complete atomic_long operations in asm-generic
has been removed from the -mm tree.  Its filename was
     atomich-complete-atomic_long-operations-in-asm-generic.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: atomic.h: complete atomic_long operations in asm-generic
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/atomic.h |  168 +++++++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)

diff -puN include/asm-generic/atomic.h~atomich-complete-atomic_long-operations-in-asm-generic include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomich-complete-atomic_long-operations-in-asm-generic
+++ a/include/asm-generic/atomic.h
@@ -66,6 +66,90 @@ static inline void atomic_long_sub(long 
 	atomic64_sub(i, v);
 }
 
+static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_sub_and_test(i, v);
+}
+
+static inline int atomic_long_dec_and_test(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_dec_and_test(v);
+}
+
+static inline int atomic_long_inc_and_test(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_inc_and_test(v);
+}
+
+static inline int atomic_long_add_negative(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_add_negative(i, v);
+}
+
+static inline long atomic_long_add_return(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_add_return(i, v);
+}
+
+static inline long atomic_long_sub_return(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_sub_return(i, v);
+}
+
+static inline long atomic_long_inc_return(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_inc_return(v);
+}
+
+static inline long atomic_long_dec_return(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_dec_return(v);
+}
+
+static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_add_unless(v, a, u);
+}
+
+static inline long atomic_long_inc_not_zero(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_inc_not_zero(v);
+}
+
+static inline long atomic_long_cmpxchg(atomic_long_t *l, long old, long new)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_cmpxchg(v, old, new);
+}
+
+static inline long atomic_long_xchg(atomic_long_t *l, long new)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_xchg(v, new);
+}
+
 #else  /*  BITS_PER_LONG == 64  */
 
 typedef atomic_t atomic_long_t;
@@ -113,6 +197,90 @@ static inline void atomic_long_sub(long 
 	atomic_sub(i, v);
 }
 
+static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return atomic_sub_and_test(i, v);
+}
+
+static inline int atomic_long_dec_and_test(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return atomic_dec_and_test(v);
+}
+
+static inline int atomic_long_inc_and_test(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return atomic_inc_and_test(v);
+}
+
+static inline int atomic_long_add_negative(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return atomic_add_negative(i, v);
+}
+
+static inline long atomic_long_add_return(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_add_return(i, v);
+}
+
+static inline long atomic_long_sub_return(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_sub_return(i, v);
+}
+
+static inline long atomic_long_inc_return(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_inc_return(v);
+}
+
+static inline long atomic_long_dec_return(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_dec_return(v);
+}
+
+static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_add_unless(v, a, u);
+}
+
+static inline long atomic_long_inc_not_zero(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_inc_not_zero(v);
+}
+
+static inline long atomic_long_cmpxchg(atomic_long_t *l, long old, long new)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_cmpxchg(v, old, new);
+}
+
+static inline long atomic_long_xchg(atomic_long_t *l, long new)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_xchg(v, new);
+}
+
 #endif  /*  BITS_PER_LONG == 64  */
 
 #endif  /*  _ASM_GENERIC_ATOMIC_H  */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-complete-atomic_long-operations-in-asm-generic-fix.patch
atomich-complete-atomic_long-operations-in-asm-generic-fix-2.patch
atomich-complete-atomic_long-operations-in-asm-generic-fix-3.patch
atomich-complete-atomic_long-operations-in-asm-generic-sparc-fix.patch
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
