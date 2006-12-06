From: akpm@osdl.org
Subject: - fix-asm-constraints-in-i386-atomic_add_return.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:23:59 -0800
Message-ID: <200612062223.kB6MNxVO018576@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48312 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937733AbWLFWYQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:24:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baldrick@free.fr, ak@suse.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix asm constraints in i386 atomic_add_return
has been removed from the -mm tree.  Its filename was
     fix-asm-constraints-in-i386-atomic_add_return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix asm constraints in i386 atomic_add_return
From: Duncan Sands <baldrick@free.fr>

Since v->counter is both read and written, it should be an output as well
as an input for the asm.  The current code only gets away with this because
counter is volatile.  Also, according to Documents/atomic_ops.txt,
atomic_add_return should provide a memory barrier, in particular a compiler
barrier, so the asm should be marked as clobbering memory.

Test case:

#include <stdio.h>

typedef struct { int counter; } atomic_t; /* NB: no "volatile" */

#define ATOMIC_INIT(i)	{ (i) }

#define atomic_read(v)		((v)->counter)

static __inline__ int atomic_add_return(int i, atomic_t *v)
{
	int __i = i;

	__asm__ __volatile__(
		"lock; xaddl %0, %1;"
		:"=r"(i)
		:"m"(v->counter), "0"(i));
/*	__asm__ __volatile__(
		"lock; xaddl %0, %1"
		:"+r" (i), "+m" (v->counter)
		: : "memory"); */
	return i + __i;
}

int main (void) {
	atomic_t a = ATOMIC_INIT(0);
	int x;

	x = atomic_add_return (1, &a);
	if ((x!=1) || (atomic_read(&a)!=1))
		printf("fail: %i, %i\n", x, atomic_read(&a));
}


Signed-off-by: Duncan Sands <baldrick@free.fr>
Cc: Andi Kleen <ak@suse.de>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-i386/atomic.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-i386/atomic.h~fix-asm-constraints-in-i386-atomic_add_return include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~fix-asm-constraints-in-i386-atomic_add_return
+++ a/include/asm-i386/atomic.h
@@ -187,9 +187,9 @@ static __inline__ int atomic_add_return(
 	/* Modern 486+ processor */
 	__i = i;
 	__asm__ __volatile__(
-		LOCK_PREFIX "xaddl %0, %1;"
-		:"=r"(i)
-		:"m"(v->counter), "0"(i));
+		LOCK_PREFIX "xaddl %0, %1"
+		:"+r" (i), "+m" (v->counter)
+		: : "memory");
 	return i + __i;
 
 #ifdef CONFIG_M386
_

Patches currently in -mm which might be from baldrick@free.fr are


