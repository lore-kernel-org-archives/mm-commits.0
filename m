From: akpm@linux-foundation.org
Subject: + blackfin-smp-convert-to-common-asm-generic-atomich.patch added to -mm tree
Date: Tue, 21 Jun 2011 16:06:07 -0700
Message-ID: <201106212306.p5LN67Cb030247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308Ab1FUXGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 19:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, arnd@arndb.de, asharma@fb.com


The patch titled
     Blackfin: SMP: convert to common asm-generic/atomic.h
has been added to the -mm tree.  Its filename is
     blackfin-smp-convert-to-common-asm-generic-atomich.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Blackfin: SMP: convert to common asm-generic/atomic.h
=46rom: Mike Frysinger <vapier@gentoo.org>

Now that common code supports SMP systems, switch our SMP atomic logic
over to it to avoid code duplication.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/atomic.h |  111 +++------------------------
 1 file changed, 13 insertions(+), 98 deletions(-)

diff -puN arch/blackfin/include/asm/atomic.h~blackfin-smp-convert-to-co=
mmon-asm-generic-atomich arch/blackfin/include/asm/atomic.h
--- a/arch/blackfin/include/asm/atomic.h~blackfin-smp-convert-to-common=
-asm-generic-atomich
+++ a/arch/blackfin/include/asm/atomic.h
@@ -1,117 +1,32 @@
 /*
-=C2=A0* Copyright 2004-2009 Analog Devices Inc.
-=C2=A0*
-=C2=A0* Licensed under the GPL-2 or later.
-=C2=A0*/
+ * Copyright 2004-2011 Analog Devices Inc.
+=A0*
+=A0* Licensed under the GPL-2 or later.
+=A0*/
=20
 #ifndef __ARCH_BLACKFIN_ATOMIC__
 #define __ARCH_BLACKFIN_ATOMIC__
=20
-#ifndef CONFIG_SMP
-# include <asm-generic/atomic.h>
-#else
+#ifdef CONFIG_SMP
=20
-#include <linux/types.h>
-#include <asm/system.h>	/* local_irq_XXX() */
-
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- */
-
-#define ATOMIC_INIT(i)	{ (i) }
-#define atomic_set(v, i)	(((v)->counter) =3D i)
-
-#define atomic_read(v)	__raw_uncached_fetch_asm(&(v)->counter)
+#include <linux/linkage.h>
=20
 asmlinkage int __raw_uncached_fetch_asm(const volatile int *ptr);
-
 asmlinkage int __raw_atomic_update_asm(volatile int *ptr, int value);
-
 asmlinkage int __raw_atomic_clear_asm(volatile int *ptr, int value);
-
 asmlinkage int __raw_atomic_set_asm(volatile int *ptr, int value);
-
 asmlinkage int __raw_atomic_xor_asm(volatile int *ptr, int value);
-
 asmlinkage int __raw_atomic_test_asm(const volatile int *ptr, int valu=
e);
=20
-static inline void atomic_add(int i, atomic_t *v)
-{
-	__raw_atomic_update_asm(&v->counter, i);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	__raw_atomic_update_asm(&v->counter, -i);
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	return __raw_atomic_update_asm(&v->counter, i);
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	return __raw_atomic_update_asm(&v->counter, -i);
-}
-
-static inline void atomic_inc(volatile atomic_t *v)
-{
-	__raw_atomic_update_asm(&v->counter, 1);
-}
-
-static inline void atomic_dec(volatile atomic_t *v)
-{
-	__raw_atomic_update_asm(&v->counter, -1);
-}
-
-static inline void atomic_clear_mask(int mask, atomic_t *v)
-{
-	__raw_atomic_clear_asm(&v->counter, mask);
-}
-
-static inline void atomic_set_mask(int mask, atomic_t *v)
-{
-	__raw_atomic_set_asm(&v->counter, mask);
-}
-
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()    barrier()
-#define smp_mb__after_atomic_dec() barrier()
-#define smp_mb__before_atomic_inc()    barrier()
-#define smp_mb__after_atomic_inc() barrier()
-
-#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
-#define atomic_dec_return(v) atomic_sub_return(1,(v))
-#define atomic_inc_return(v) atomic_add_return(1,(v))
-
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n=
)))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
-
-#define __atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c =3D atomic_read(v);					\
-	while (c !=3D (u) && (old =3D atomic_cmpxchg((v), c, c + (a))) !=3D c=
) \
-		c =3D old;					\
-	c;							\
-})
-
-/*
- * atomic_inc_and_test - increment and test
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-#define atomic_inc_and_test(v) (atomic_inc_return(v) =3D=3D 0)
-
-#define atomic_sub_and_test(i,v) (atomic_sub_return((i), (v)) =3D=3D 0=
)
-#define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) =3D=3D 0)
+#define atomic_read(v) __raw_uncached_fetch_asm(&(v)->counter)
=20
+#define atomic_add_return(i, v) __raw_atomic_update_asm(&(v)->counter,=
 i)
+#define atomic_sub_return(i, v) __raw_atomic_update_asm(&(v)->counter,=
 -(i))
+#define atomic_clear_mask(m, v) __raw_atomic_clear_asm(&(v)->counter, =
m)
+#define atomic_set_mask(m, v)   __raw_atomic_set_asm(&(v)->counter, m)
=20
 #endif
=20
+#include <asm-generic/atomic.h>
+
 #endif
_

Patches currently in -mm which might be from vapier@gentoo.org are

mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch
asm-generic-systemh-drop-useless-__kernel__.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch
asm-generic-atomich-simplify-inc-dec-test-helpers.patch
asm-generic-atomich-fix-type-used-in-atomic_clear_mask.patch
asm-generic-atomich-add-atomic_set_mask-helper.patch
asm-generic-atomich-allow-smp-peeps-to-leverage-this.patch
blackfin-smp-punt-unused-atomic_test_mask-helper.patch
blackfin-smp-convert-to-common-asm-generic-atomich.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
