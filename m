From: akpm@linux-foundation.org
Subject: - powerpc-lock-bitops.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:27 -0700
Message-ID: <200710190345.l9J3jRhm013223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48761 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933839AbXJSDze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: lock bitops
has been removed from the -mm tree.  Its filename was
     powerpc-lock-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: lock bitops
From: Nick Piggin <npiggin@suse.de>

Add non-trivial lock bitops implementation for powerpc.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/bitops.h |   46 ++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff -puN include/asm-powerpc/bitops.h~powerpc-lock-bitops include/asm-powerpc/bitops.h
--- a/include/asm-powerpc/bitops.h~powerpc-lock-bitops
+++ a/include/asm-powerpc/bitops.h
@@ -86,6 +86,24 @@ static __inline__ void clear_bit(int nr,
 	: "cc" );
 }
 
+static __inline__ void clear_bit_unlock(int nr, volatile unsigned long *addr)
+{
+	unsigned long old;
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+
+	__asm__ __volatile__(
+	LWSYNC_ON_SMP
+"1:"	PPC_LLARX "%0,0,%3	# clear_bit_unlock\n"
+	"andc	%0,%0,%2\n"
+	PPC405_ERR77(0,%3)
+	PPC_STLCX "%0,0,%3\n"
+	"bne-	1b"
+	: "=&r" (old), "+m" (*p)
+	: "r" (mask), "r" (p)
+	: "cc", "memory");
+}
+
 static __inline__ void change_bit(int nr, volatile unsigned long *addr)
 {
 	unsigned long old;
@@ -125,6 +143,27 @@ static __inline__ int test_and_set_bit(u
 	return (old & mask) != 0;
 }
 
+static __inline__ int test_and_set_bit_lock(unsigned long nr,
+				       volatile unsigned long *addr)
+{
+	unsigned long old, t;
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+
+	__asm__ __volatile__(
+"1:"	PPC_LLARX "%0,0,%3		# test_and_set_bit_lock\n"
+	"or	%1,%0,%2 \n"
+	PPC405_ERR77(0,%3)
+	PPC_STLCX "%1,0,%3 \n"
+	"bne-	1b"
+	ISYNC_ON_SMP
+	: "=&r" (old), "=&r" (t)
+	: "r" (mask), "r" (p)
+	: "cc", "memory");
+
+	return (old & mask) != 0;
+}
+
 static __inline__ int test_and_clear_bit(unsigned long nr,
 					 volatile unsigned long *addr)
 {
@@ -185,6 +224,12 @@ static __inline__ void set_bits(unsigned
 
 #include <asm-generic/bitops/non-atomic.h>
 
+static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long *addr)
+{
+	__asm__ __volatile__(LWSYNC_ON_SMP "" ::: "memory");
+	__clear_bit(nr, addr);
+}
+
 /*
  * Return the zero-based bit position (LE, not IBM bit numbering) of
  * the most significant 1-bit in a double word.
@@ -266,7 +311,6 @@ static __inline__ int fls(unsigned int x
 #include <asm-generic/bitops/fls64.h>
 
 #include <asm-generic/bitops/hweight.h>
-#include <asm-generic/bitops/lock.h>
 
 #define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
 unsigned long find_next_zero_bit(const unsigned long *addr,
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4-fix-for-new-aops-patches.patch
