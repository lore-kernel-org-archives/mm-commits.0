From: akpm@linux-foundation.org
Subject: + mn10300-use-generic-atomich.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:32:19 -0700
Message-ID: <201004301932.o3UJWJXD007551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627Ab0D3Tdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@efficios.com, arnd@arndb.de, dhowells@redhat.com, heiko.carstens@de.ibm.com, jamie@shareable.org, mingo@elte.hu, peter.fritzsche@gmx.de, schwidefsky@de.ibm.com, wesolows@foobazco.org


The patch titled
     mn10300: use generic atomic.h
has been added to the -mm tree.  Its filename is
     mn10300-use-generic-atomich.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: use generic atomic.h
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

asm-generic/atomic.h has been derived from the mn10300 implementation. 
Remove the now duplicated mn10300 implementation by including the generic
version instead.

This adds cmpxchg_local() and cmpxchg64_local() for free to the
architecture, as they are implemented in asm-generic/atomic.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Peter Fritzsche <peter.fritzsche@gmx.de>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Keith M Wesolowski <wesolows@foobazco.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/atomic.h |  158 ----------------------------
 1 file changed, 1 insertion(+), 157 deletions(-)

diff -puN arch/mn10300/include/asm/atomic.h~mn10300-use-generic-atomich arch/mn10300/include/asm/atomic.h
--- a/arch/mn10300/include/asm/atomic.h~mn10300-use-generic-atomich
+++ a/arch/mn10300/include/asm/atomic.h
@@ -1,157 +1 @@
-/* MN10300 Atomic counter operations
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_ATOMIC_H
-#define _ASM_ATOMIC_H
-
-#ifdef CONFIG_SMP
-#error not SMP safe
-#endif
-
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- */
-
-#define ATOMIC_INIT(i)	{ (i) }
-
-#ifdef __KERNEL__
-
-/**
- * atomic_read - read atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically reads the value of @v.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
- */
-#define atomic_read(v)	((v)->counter)
-
-/**
- * atomic_set - set atomic variable
- * @v: pointer of type atomic_t
- * @i: required value
- *
- * Atomically sets the value of @v to @i.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
- */
-#define atomic_set(v, i) (((v)->counter) = (i))
-
-#include <asm/system.h>
-
-/**
- * atomic_add_return - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int temp;
-
-	local_irq_save(flags);
-	temp = v->counter;
-	temp += i;
-	v->counter = temp;
-	local_irq_restore(flags);
-
-	return temp;
-}
-
-/**
- * atomic_sub_return - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int temp;
-
-	local_irq_save(flags);
-	temp = v->counter;
-	temp -= i;
-	v->counter = temp;
-	local_irq_restore(flags);
-
-	return temp;
-}
-
-static inline int atomic_add_negative(int i, atomic_t *v)
-{
-	return atomic_add_return(i, v) < 0;
-}
-
-static inline void atomic_add(int i, atomic_t *v)
-{
-	atomic_add_return(i, v);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	atomic_sub_return(i, v);
-}
-
-static inline void atomic_inc(atomic_t *v)
-{
-	atomic_add_return(1, v);
-}
-
-static inline void atomic_dec(atomic_t *v)
-{
-	atomic_sub_return(1, v);
-}
-
-#define atomic_dec_return(v)		atomic_sub_return(1, (v))
-#define atomic_inc_return(v)		atomic_add_return(1, (v))
-
-#define atomic_sub_and_test(i, v)	(atomic_sub_return((i), (v)) == 0)
-#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
-#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
-
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
-
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-	unsigned long flags;
-
-	mask = ~mask;
-	local_irq_save(flags);
-	*addr &= mask;
-	local_irq_restore(flags);
-}
-
-#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
-#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
-
-/* Atomic operations are already serializing on MN10300??? */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-#include <asm-generic/atomic-long.h>
