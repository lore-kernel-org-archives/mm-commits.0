From: akpm@linux-foundation.org
Subject: [merged] asm-generic-atomich-allow-smp-peeps-to-leverage-this.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:30:08 -0700
Message-ID: <201107271928.p6RJSssj003351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754885Ab1G0T3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, arnd@arndb.de, asharma@fb.com, mm-commits@vger.kernel.org


The patch titled
     asm-generic/atomic.h: allow SMP peeps to leverage this
has been removed from the -mm tree.  Its filename was
     asm-generic-atomich-allow-smp-peeps-to-leverage-this.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/atomic.h: allow SMP peeps to leverage this
From: Mike Frysinger <vapier@gentoo.org>

Only a few core funcs need to be implemented for SMP systems, so allow the
arches to override them while getting the rest for free.

At least, this is enough to allow the Blackfin SMP port to use things.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/atomic.h~asm-generic-atomich-allow-smp-peeps-to-leverage-this include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~asm-generic-atomich-allow-smp-peeps-to-leverage-this
+++ a/include/asm-generic/atomic.h
@@ -16,7 +16,11 @@
 #define __ASM_GENERIC_ATOMIC_H
 
 #ifdef CONFIG_SMP
-#error not SMP safe
+/* Force people to define core atomics */
+# if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
+     !defined(atomic_clear_mask) || !defined(atomic_set_mask)
+#  error "SMP requires a little arch-specific magic"
+# endif
 #endif
 
 /*
@@ -34,7 +38,9 @@
  *
  * Atomically reads the value of @v.
  */
+#ifndef atomic_read
 #define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#endif
 
 /**
  * atomic_set - set atomic variable
@@ -55,6 +61,7 @@
  *
  * Atomically adds @i to @v and returns the result
  */
+#ifndef atomic_add_return
 static inline int atomic_add_return(int i, atomic_t *v)
 {
 	unsigned long flags;
@@ -68,6 +75,7 @@ static inline int atomic_add_return(int 
 
 	return temp;
 }
+#endif
 
 /**
  * atomic_sub_return - subtract integer from atomic variable
@@ -76,6 +84,7 @@ static inline int atomic_add_return(int 
  *
  * Atomically subtracts @i from @v and returns the result
  */
+#ifndef atomic_sub_return
 static inline int atomic_sub_return(int i, atomic_t *v)
 {
 	unsigned long flags;
@@ -89,6 +98,7 @@ static inline int atomic_sub_return(int 
 
 	return temp;
 }
+#endif
 
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
@@ -147,6 +157,7 @@ static inline int __atomic_add_unless(at
  *
  * Atomically clears the bits set in @mask from @v
  */
+#ifndef atomic_clear_mask
 static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
 {
 	unsigned long flags;
@@ -156,6 +167,7 @@ static inline void atomic_clear_mask(uns
 	v->counter &= mask;
 	raw_local_irq_restore(flags);
 }
+#endif
 
 /**
  * atomic_set_mask - Atomically set bits in atomic variable
@@ -164,6 +176,7 @@ static inline void atomic_clear_mask(uns
  *
  * Atomically sets the bits set in @mask in @v
  */
+#ifndef atomic_set_mask
 static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 {
 	unsigned long flags;
@@ -172,6 +185,7 @@ static inline void atomic_set_mask(unsig
 	v->counter |= mask;
 	raw_local_irq_restore(flags);
 }
+#endif
 
 /* Assume that atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()	barrier()
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch

