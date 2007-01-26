From: akpm@osdl.org
Subject: + atomich-complete-atomic_long-operations-in-asm-generic-fix.patch added to -mm tree
Date: Thu, 25 Jan 2007 21:41:31 -0800
Message-ID: <200701260541.l0Q5fVC8008464@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46510 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030763AbXAZFlo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 00:41:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     atomic.h: complete atomic_long operations in asm-generic fix
has been added to the -mm tree.  Its filename is
     atomich-complete-atomic_long-operations-in-asm-generic-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atomic.h: complete atomic_long operations in asm-generic fix
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

As Joe Perches pointed out, 4 casts to (long) are unneeded here.

The *_test functions only return integers, never a long.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/atomic.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/atomic.h~atomich-complete-atomic_long-operations-in-asm-generic-fix include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomich-complete-atomic_long-operations-in-asm-generic-fix
+++ a/include/asm-generic/atomic.h
@@ -70,28 +70,28 @@ static inline int atomic_long_sub_and_te
 {
 	atomic64_t *v = (atomic64_t *)l;
 
-	return (long)atomic64_sub_and_test(i, v);
+	return atomic64_sub_and_test(i, v);
 }
 
 static inline int atomic_long_dec_and_test(atomic_long_t *l)
 {
 	atomic64_t *v = (atomic64_t *)l;
 
-	return (long)atomic64_dec_and_test(v);
+	return atomic64_dec_and_test(v);
 }
 
 static inline int atomic_long_inc_and_test(atomic_long_t *l)
 {
 	atomic64_t *v = (atomic64_t *)l;
 
-	return (long)atomic64_inc_and_test(v);
+	return atomic64_inc_and_test(v);
 }
 
 static inline int atomic_long_add_negative(long i, atomic_long_t *l)
 {
 	atomic64_t *v = (atomic64_t *)l;
 
-	return (long)atomic64_add_negative(i, v);
+	return atomic64_add_negative(i, v);
 }
 
 static inline long atomic_long_add_return(long i, atomic_long_t *l)
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-complete-atomic_long-operations-in-asm-generic-fix.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
