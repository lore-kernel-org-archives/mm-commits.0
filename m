From: akpm@linux-foundation.org
Subject: + atomic-fix-atomic_long_cmpxchg-xchg-for-64-bit-architectures.patch added to -mm tree
Date: Wed, 29 Apr 2009 08:24:53 -0700
Message-ID: <200904291524.n3TFOrUx005147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989AbZD2P1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 11:27:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, mathieu.desnoyers@polymtl.ca


The patch titled
     atomic: fix atomic_long_cmpxchg/xchg for 64 bit architectures
has been added to the -mm tree.  Its filename is
     atomic-fix-atomic_long_cmpxchg-xchg-for-64-bit-architectures.patch

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
Subject: atomic: fix atomic_long_cmpxchg/xchg for 64 bit architectures
From: Heiko Carstens <heiko.carstens@de.ibm.com>

On a linux-next allyesconfig build:

kernel/trace/ring_buffer.c:1726:
	warning: passing argument 1 of 'atomic_cmpxchg' from incompatible pointer type
linux-next/arch/s390/include/asm/atomic.h:112:
	note: expected 'struct atomic_t *' but argument is of type 'struct atomic64_t *'

atomic_long_cmpxchg and atomic_long_xchg are incorrectly defined for 64
bit architectures.  They should be mapped to the atomic64_* variants.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/atomic.h~atomic-fix-atomic_long_cmpxchg-xchg-for-64-bit-architectures include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomic-fix-atomic_long_cmpxchg-xchg-for-64-bit-architectures
+++ a/include/asm-generic/atomic.h
@@ -132,9 +132,9 @@ static inline long atomic_long_add_unles
 #define atomic_long_inc_not_zero(l) atomic64_inc_not_zero((atomic64_t *)(l))
 
 #define atomic_long_cmpxchg(l, old, new) \
-	(atomic_cmpxchg((atomic64_t *)(l), (old), (new)))
+	(atomic64_cmpxchg((atomic64_t *)(l), (old), (new)))
 #define atomic_long_xchg(v, new) \
-	(atomic_xchg((atomic64_t *)(l), (new)))
+	(atomic64_xchg((atomic64_t *)(l), (new)))
 
 #else  /*  BITS_PER_LONG == 64  */
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
atomic-fix-atomic_long_cmpxchg-xchg-for-64-bit-architectures.patch
linux-next.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch

