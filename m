From: akpm@linux-foundation.org
Subject: + asm-generic-dont-warn-that-atomic_t-is-only-24-bit.patch added to -mm tree
Date: Fri, 30 Apr 2010 14:58:25 -0700
Message-ID: <201004302158.o3ULwPMW016143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320Ab0D3V7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 17:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.fritzsche@gmx.de


The patch titled
     asm-generic: don't warn that atomic_t is only 24 bit
has been added to the -mm tree.  Its filename is
     asm-generic-dont-warn-that-atomic_t-is-only-24-bit.patch

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
Subject: asm-generic: don't warn that atomic_t is only 24 bit
From: Peter Fritzsche <peter.fritzsche@gmx.de>

32-bit Sparc used to only allow usage of 24-bit of it's atomic_t type. 
This was corrected with linux 2.6.3 when Keith M Wesolowski changed the
implementation to use the parisc approach of having an array of spinlocks
to protect the atomic_t.

These warnings were also removed from the sparc implementation when the
new implementation was merged in BKrev:402e4949VThdc6D3iaosSFUgabMfvw, but
the warning still remained in some other places without any 24-bit-only
atomic_t implementation inside the kernel.

We should remove these warnings to allow users to rely on the full 32-bit
range of atomic_t.

Signed-off-by: Peter Fritzsche <peter.fritzsche@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/atomic.h~asm-generic-dont-warn-that-atomic_t-is-only-24-bit include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~asm-generic-dont-warn-that-atomic_t-is-only-24-bit
+++ a/include/asm-generic/atomic.h
@@ -30,8 +30,7 @@
  * atomic_read - read atomic variable
  * @v: pointer of type atomic_t
  *
- * Atomically reads the value of @v.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
+ * Atomically reads the value of @v.
  */
 #define atomic_read(v)	((v)->counter)
 
@@ -40,8 +39,7 @@
  * @v: pointer of type atomic_t
  * @i: required value
  *
- * Atomically sets the value of @v to @i.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
+ * Atomically sets the value of @v to @i.
  */
 #define atomic_set(v, i) (((v)->counter) = (i))
 
@@ -53,7 +51,6 @@
  * @v: pointer of type atomic_t
  *
  * Atomically adds @i to @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
@@ -75,7 +72,6 @@ static inline int atomic_add_return(int 
  * @v: pointer of type atomic_t
  *
  * Atomically subtracts @i from @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
  */
 static inline int atomic_sub_return(int i, atomic_t *v)
 {
_

Patches currently in -mm which might be from peter.fritzsche@gmx.de are

mn10300-use-generic-atomich.patch
asm-generic-dont-warn-that-atomic_t-is-only-24-bit.patch

