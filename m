From: akpm@linux-foundation.org
Subject: + cris-import-memsetc-from-newlib-fixes-compile-error-with-newer-pre43-gcc.patch added to -mm tree
Date: Thu, 14 Feb 2008 10:44:09 -0800
Message-ID: <200802141844.m1EIi9o6029653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbYBNSo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 13:44:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, bunk@stusta.de, mikael.starvik@axis.com


The patch titled
     cris: import memset.c from newlib: fixes compile error with newer (pre4.3) gcc
has been added to the -mm tree.  Its filename is
     cris-import-memsetc-from-newlib-fixes-compile-error-with-newer-pre43-gcc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: import memset.c from newlib: fixes compile error with newer (pre4.3) gcc
From: Jesper Nilsson <jesper.nilsson@axis.com>

Adrian Bunk reported the following compile error with a SVN head GCC:

...
CC arch/cris/arch-v10/lib/memset.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c: In function 'memset':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:164: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:165: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:166: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:167: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:185: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:189: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:192: error: lvalue required as increment operand
... etc ...

This is due to the use of the construct:

	*((long*)dst)++ = lc;

Which is no longer legal since casts don't return an lvalue.

The solution is to import the implementation from newlib,
which is continually autotested together with GCC mainline,
and uses the construct:

	*(long *) dst = lc; dst += 4;

With this change, the generated code actually shrinks 76 bytes
since gcc notices that it can use autoincrement for the move
instruction in CRIS.

   text    data     bss     dec     hex filename
    304       0       0     304     130 memset.old.o
   text    data     bss     dec     hex filename
    228       0       0     228      e4 memset.o

Since this is an import of a file from newlib, I'm not touching
the formatting or correcting any checkpatch errors.

Note also that even if the two files for the CRIS v10 and CRIS v32
are identical at the moment, it might be possible to tweak the
CRIS v32 version. Thus, I'm not yet folding them into the same file,
at least not until we've done some research on it.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/lib/memset.c |  407 +++++++++++++++--------------
 arch/cris/arch-v32/lib/memset.c |  410 +++++++++++++++---------------
 2 files changed, 415 insertions(+), 402 deletions(-)

diff -puN arch/cris/arch-v10/lib/memset.c~cris-import-memsetc-from-newlib-fixes-compile-error-with-newer-pre43-gcc arch/cris/arch-v10/lib/memset.c
--- a/arch/cris/arch-v10/lib/memset.c~cris-import-memsetc-from-newlib-fixes-compile-error-with-newer-pre43-gcc
+++ a/arch/cris/arch-v10/lib/memset.c
@@ -1,252 +1,259 @@
-/*#************************************************************************#*/
-/*#-------------------------------------------------------------------------*/
-/*#                                                                         */
-/*# FUNCTION NAME: memset()                                                 */
-/*#                                                                         */
-/*# PARAMETERS:  void* dst;   Destination address.                          */
-/*#              int     c;   Value of byte to write.                       */
-/*#              int   len;   Number of bytes to write.                     */
-/*#                                                                         */
-/*# RETURNS:     dst.                                                       */
-/*#                                                                         */
-/*# DESCRIPTION: Sets the memory dst of length len bytes to c, as standard. */
-/*#              Framework taken from memcpy.  This routine is              */
-/*#              very sensitive to compiler changes in register allocation. */
-/*#              Should really be rewritten to avoid this problem.          */
-/*#                                                                         */
-/*#-------------------------------------------------------------------------*/
-/*#                                                                         */
-/*# HISTORY                                                                 */
-/*#                                                                         */
-/*# DATE      NAME            CHANGES                                       */
-/*# ----      ----            -------                                       */
-/*# 990713    HP              Tired of watching this function (or           */
-/*#                           really, the nonoptimized generic              */
-/*#                           implementation) take up 90% of simulator      */
-/*#                           output.  Measurements needed.                 */
-/*#                                                                         */
-/*#-------------------------------------------------------------------------*/
-
-#include <linux/types.h>
-
-/* No, there's no macro saying 12*4, since it is "hard" to get it into
-   the asm in a good way.  Thus better to expose the problem everywhere.
-   */
-
-/* Assuming 1 cycle per dword written or read (ok, not really true), and
-   one per instruction, then 43+3*(n/48-1) <= 24+24*(n/48-1)
-   so n >= 45.7; n >= 0.9; we win on the first full 48-byte block to set. */
-
-#define ZERO_BLOCK_SIZE (1*12*4)
-
-void *memset(void *pdst,
-             int c,
-             size_t plen)
+/* A memset for CRIS.
+   Copyright (C) 1999-2005 Axis Communications.
+   All rights reserved.
+
+   Redistribution and use in source and binary forms, with or without
+   modification, are permitted provided that the following conditions
+   are met:
+
+   1. Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+
+   2. Neither the name of Axis Communications nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+   THIS SOFTWARE IS PROVIDED BY AXIS COMMUNICATIONS AND ITS CONTRIBUTORS
+   ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL AXIS
+   COMMUNICATIONS OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+   INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+   STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+   IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+   POSSIBILITY OF SUCH DAMAGE.  */
+
+/* FIXME: This file should really only be used for reference, as the
+   result is somewhat depending on gcc generating what we expect rather
+   than what we describe.  An assembly file should be used instead.  */
+
+/* Note the multiple occurrence of the expression "12*4", including the
+   asm.  It is hard to get it into the asm in a good way.  Thus better to
+   expose the problem everywhere: no macro.  */
+
+/* Assuming one cycle per dword written or read (ok, not really true; the
+   world is not ideal), and one cycle per instruction, then 43+3*(n/48-1)
+   <= 24+24*(n/48-1) so n >= 45.7; n >= 0.9; we win on the first full
+   48-byte block to set.  */
+
+#define MEMSET_BY_BLOCK_THRESHOLD (1 * 48)
+
+/* No name ambiguities in this file.  */
+__asm__ (".syntax no_register_prefix");
+
+void *memset(void *pdst, int c, unsigned int plen)
 {
-  /* Ok.  Now we want the parameters put in special registers.
-     Make sure the compiler is able to make something useful of this. */
+  /* Now we want the parameters in special registers.  Make sure the
+     compiler does something usable with this.  */
 
   register char *return_dst __asm__ ("r10") = pdst;
   register int n __asm__ ("r12") = plen;
   register int lc __asm__ ("r11") = c;
 
-  /* Most apps use memset sanely.  Only those memsetting about 3..4
-     bytes or less get penalized compared to the generic implementation
-     - and that's not really sane use. */
-
-  /* Ugh.  This is fragile at best.  Check with newer GCC releases, if
-     they compile cascaded "x |= x << 8" sanely! */
-  __asm__("movu.b %0,$r13\n\t"
-          "lslq 8,$r13\n\t"
-	  "move.b %0,$r13\n\t"
-	  "move.d $r13,%0\n\t"
-	  "lslq 16,$r13\n\t"
-	  "or.d $r13,%0"
-          : "=r" (lc) : "0" (lc) : "r13");
-
-  {
-    register char *dst __asm__ ("r13") = pdst;
+  /* Most apps use memset sanely.  Memsetting about 3..4 bytes or less get
+     penalized here compared to the generic implementation.  */
 
-  /* This is NONPORTABLE, but since this whole routine is     */
-  /* grossly nonportable that doesn't matter.                 */
+  /* This is fragile performancewise at best.  Check with newer GCC
+     releases, if they compile cascaded "x |= x << 8" to sane code.  */
+  __asm__("movu.b %0,r13						\n\
+	   lslq 8,r13							\n\
+	   move.b %0,r13						\n\
+	   move.d r13,%0						\n\
+	   lslq 16,r13							\n\
+	   or.d r13,%0"
+          : "=r" (lc)		/* Inputs.  */
+	  : "0" (lc)		/* Outputs.  */
+	  : "r13");		/* Trash.  */
 
-  if (((unsigned long) pdst & 3) != 0
-     /* Oops! n=0 must be a legal call, regardless of alignment. */
-      && n >= 3)
   {
-    if ((unsigned long)dst & 1)
-    {
-      *dst = (char) lc;
-      n--;
-      dst++;
-    }
-
-    if ((unsigned long)dst & 2)
-    {
-      *(short *)dst = lc;
-      n -= 2;
-      dst += 2;
-    }
-  }
-
-  /* Now the fun part.  For the threshold value of this, check the equation
-     above. */
-  /* Decide which copying method to use. */
-  if (n >= ZERO_BLOCK_SIZE)
-  {
-    /* For large copies we use 'movem' */
+    register char *dst __asm__ ("r13") = pdst;
 
-  /* It is not optimal to tell the compiler about clobbering any
-     registers; that will move the saving/restoring of those registers
-     to the function prologue/epilogue, and make non-movem sizes
-     suboptimal.
-
-      This method is not foolproof; it assumes that the "asm reg"
-     declarations at the beginning of the function really are used
-     here (beware: they may be moved to temporary registers).
-      This way, we do not have to save/move the registers around into
-     temporaries; we can safely use them straight away.
-
-      If you want to check that the allocation was right; then
-      check the equalities in the first comment.  It should say
-      "r13=r13, r12=r12, r11=r11" */
-    __asm__ volatile ("\n\
-	;; Check that the following is true (same register names on	\n\
-	;; both sides of equal sign, as in r8=r8):			\n\
-	;; %0=r13, %1=r12, %4=r11					\n\
-	;;								\n\
-	;; Save the registers we'll clobber in the movem process	\n\
-	;; on the stack.  Don't mention them to gcc, it will only be	\n\
-	;; upset.							\n\
-	subq	11*4,$sp						\n\
-	movem	$r10,[$sp]						\n\
-									\n\
-	move.d	$r11,$r0						\n\
-	move.d	$r11,$r1						\n\
-	move.d	$r11,$r2						\n\
-	move.d	$r11,$r3						\n\
-	move.d	$r11,$r4						\n\
-	move.d	$r11,$r5						\n\
-	move.d	$r11,$r6						\n\
-	move.d	$r11,$r7						\n\
-	move.d	$r11,$r8						\n\
-	move.d	$r11,$r9						\n\
-	move.d	$r11,$r10						\n\
-									\n\
-	;; Now we've got this:						\n\
-	;; r13 - dst							\n\
-	;; r12 - n							\n\
+    if (((unsigned long) pdst & 3) != 0
+	/* Oops! n = 0 must be a valid call, regardless of alignment.  */
+	&& n >= 3)
+      {
+	if ((unsigned long) dst & 1)
+	  {
+	    *dst = (char) lc;
+	    n--;
+	    dst++;
+	  }
+
+	if ((unsigned long) dst & 2)
+	  {
+	    *(short *) dst = lc;
+	    n -= 2;
+	    dst += 2;
+	  }
+      }
+
+    /* Decide which setting method to use.  */
+    if (n >= MEMSET_BY_BLOCK_THRESHOLD)
+      {
+	/* It is not optimal to tell the compiler about clobbering any
+	   registers; that will move the saving/restoring of those registers
+	   to the function prologue/epilogue, and make non-block sizes
+	   suboptimal.  */
+	__asm__ volatile
+	  ("\
+	   ;; GCC does promise correct register allocations, but let's	\n\
+	   ;; make sure it keeps its promises.				\n\
+	   .ifnc %0-%1-%4,$r13-$r12-$r11				\n\
+	   .error \"GCC reg alloc bug: %0-%1-%4 != $r13-$r12-$r11\"	\n\
+	   .endif							\n\
+									\n\
+	   ;; Save the registers we'll clobber in the movem process	\n\
+	   ;; on the stack.  Don't mention them to gcc, it will only be	\n\
+	   ;; upset.							\n\
+	   subq	   11*4,sp						\n\
+	   movem   r10,[sp]						\n\
+									\n\
+	   move.d  r11,r0						\n\
+	   move.d  r11,r1						\n\
+	   move.d  r11,r2						\n\
+	   move.d  r11,r3						\n\
+	   move.d  r11,r4						\n\
+	   move.d  r11,r5						\n\
+	   move.d  r11,r6						\n\
+	   move.d  r11,r7						\n\
+	   move.d  r11,r8						\n\
+	   move.d  r11,r9						\n\
+	   move.d  r11,r10						\n\
 									\n\
-	;; Update n for the first loop					\n\
-	subq	12*4,$r12						\n\
+	   ;; Now we've got this:					\n\
+	   ;; r13 - dst							\n\
+	   ;; r12 - n							\n\
+									\n\
+	   ;; Update n for the first loop				\n\
+	   subq	   12*4,r12						\n\
 0:									\n\
-	subq	12*4,$r12						\n\
-	bge	0b							\n\
-	movem	$r11,[$r13+]						\n\
+"
+#ifdef __arch_common_v10_v32
+	   /* Cater to branch offset difference between v32 and v10.  We
+	      assume the branch below has an 8-bit offset.  */
+"	   setf\n"
+#endif
+"	   subq	  12*4,r12						\n\
+	   bge	   0b							\n\
+	   movem	r11,[r13+]					\n\
 									\n\
-	addq	12*4,$r12 ;; compensate for last loop underflowing n	\n\
+	   ;; Compensate for last loop underflowing n.			\n\
+	   addq	  12*4,r12						\n\
 									\n\
-	;; Restore registers from stack					\n\
-	movem	[$sp+],$r10"
+	   ;; Restore registers from stack.				\n\
+	   movem [sp+],r10"
 
-     /* Outputs */ : "=r" (dst), "=r" (n)
-     /* Inputs */ : "0" (dst), "1" (n), "r" (lc));
+	   /* Outputs.	*/
+	   : "=r" (dst), "=r" (n)
 
-  }
+	   /* Inputs.  */
+	   : "0" (dst), "1" (n), "r" (lc));
+      }
+
+    /* An ad-hoc unroll, used for 4*12-1..16 bytes. */
+    while (n >= 16)
+      {
+	*(long *) dst = lc; dst += 4;
+	*(long *) dst = lc; dst += 4;
+	*(long *) dst = lc; dst += 4;
+	*(long *) dst = lc; dst += 4;
+	n -= 16;
+      }
 
-    /* Either we directly starts copying, using dword copying
-       in a loop, or we copy as much as possible with 'movem'
-       and then the last block (<44 bytes) is copied here.
-       This will work since 'movem' will have updated src,dst,n. */
-
-    while ( n >= 16 )
-    {
-      *((long*)dst)++ = lc;
-      *((long*)dst)++ = lc;
-      *((long*)dst)++ = lc;
-      *((long*)dst)++ = lc;
-      n -= 16;
-    }
-
-    /* A switch() is definitely the fastest although it takes a LOT of code.
-     * Particularly if you inline code this.
-     */
     switch (n)
-    {
+      {
       case 0:
         break;
+
       case 1:
-        *(char*)dst = (char) lc;
+        *dst = (char) lc;
         break;
+
       case 2:
-        *(short*)dst = (short) lc;
+        *(short *) dst = (short) lc;
         break;
+
       case 3:
-        *((short*)dst)++ = (short) lc;
-        *(char*)dst = (char) lc;
+        *(short *) dst = (short) lc; dst += 2;
+        *dst = (char) lc;
         break;
+
       case 4:
-        *((long*)dst)++ = lc;
+        *(long *) dst = lc;
         break;
+
       case 5:
-        *((long*)dst)++ = lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *dst = (char) lc;
         break;
+
       case 6:
-        *((long*)dst)++ = lc;
-        *(short*)dst = (short) lc;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc;
         break;
+
       case 7:
-        *((long*)dst)++ = lc;
-        *((short*)dst)++ = (short) lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc; dst += 2;
+        *dst = (char) lc;
         break;
+
       case 8:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc;
         break;
+
       case 9:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *dst = (char) lc;
         break;
+
       case 10:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *(short*)dst = (short) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc;
         break;
+
       case 11:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((short*)dst)++ = (short) lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc; dst += 2;
+        *dst = (char) lc;
         break;
+
       case 12:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc;
         break;
+
       case 13:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *dst = (char) lc;
         break;
+
       case 14:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *(short*)dst = (short) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc;
         break;
+
       case 15:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((short*)dst)++ = (short) lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc; dst += 2;
+        *dst = (char) lc;
         break;
-    }
+      }
   }
 
-  return return_dst; /* destination pointer. */
-} /* memset() */
+  return return_dst;
+}
diff -puN arch/cris/arch-v32/lib/memset.c~cris-import-memsetc-from-newlib-fixes-compile-error-with-newer-pre43-gcc arch/cris/arch-v32/lib/memset.c
--- a/arch/cris/arch-v32/lib/memset.c~cris-import-memsetc-from-newlib-fixes-compile-error-with-newer-pre43-gcc
+++ a/arch/cris/arch-v32/lib/memset.c
@@ -1,253 +1,259 @@
-/*#************************************************************************#*/
-/*#-------------------------------------------------------------------------*/
-/*#                                                                         */
-/*# FUNCTION NAME: memset()                                                 */
-/*#                                                                         */
-/*# PARAMETERS:  void* dst;   Destination address.                          */
-/*#              int     c;   Value of byte to write.                       */
-/*#              int   len;   Number of bytes to write.                     */
-/*#                                                                         */
-/*# RETURNS:     dst.                                                       */
-/*#                                                                         */
-/*# DESCRIPTION: Sets the memory dst of length len bytes to c, as standard. */
-/*#              Framework taken from memcpy.  This routine is              */
-/*#              very sensitive to compiler changes in register allocation. */
-/*#              Should really be rewritten to avoid this problem.          */
-/*#                                                                         */
-/*#-------------------------------------------------------------------------*/
-/*#                                                                         */
-/*# HISTORY                                                                 */
-/*#                                                                         */
-/*# DATE      NAME            CHANGES                                       */
-/*# ----      ----            -------                                       */
-/*# 990713    HP              Tired of watching this function (or           */
-/*#                           really, the nonoptimized generic              */
-/*#                           implementation) take up 90% of simulator      */
-/*#                           output.  Measurements needed.                 */
-/*#                                                                         */
-/*#-------------------------------------------------------------------------*/
-
-#include <linux/types.h>
-
-/* No, there's no macro saying 12*4, since it is "hard" to get it into
-   the asm in a good way.  Thus better to expose the problem everywhere.
-   */
-
-/* Assuming 1 cycle per dword written or read (ok, not really true), and
-   one per instruction, then 43+3*(n/48-1) <= 24+24*(n/48-1)
-   so n >= 45.7; n >= 0.9; we win on the first full 48-byte block to set. */
-
-#define ZERO_BLOCK_SIZE (1*12*4)
-
-void *memset(void *pdst,
-             int c,
-             size_t plen)
+/* A memset for CRIS.
+   Copyright (C) 1999-2005 Axis Communications.
+   All rights reserved.
+
+   Redistribution and use in source and binary forms, with or without
+   modification, are permitted provided that the following conditions
+   are met:
+
+   1. Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+
+   2. Neither the name of Axis Communications nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+   THIS SOFTWARE IS PROVIDED BY AXIS COMMUNICATIONS AND ITS CONTRIBUTORS
+   ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL AXIS
+   COMMUNICATIONS OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+   INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+   STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+   IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+   POSSIBILITY OF SUCH DAMAGE.  */
+
+/* FIXME: This file should really only be used for reference, as the
+   result is somewhat depending on gcc generating what we expect rather
+   than what we describe.  An assembly file should be used instead.  */
+
+/* Note the multiple occurrence of the expression "12*4", including the
+   asm.  It is hard to get it into the asm in a good way.  Thus better to
+   expose the problem everywhere: no macro.  */
+
+/* Assuming one cycle per dword written or read (ok, not really true; the
+   world is not ideal), and one cycle per instruction, then 43+3*(n/48-1)
+   <= 24+24*(n/48-1) so n >= 45.7; n >= 0.9; we win on the first full
+   48-byte block to set.  */
+
+#define MEMSET_BY_BLOCK_THRESHOLD (1 * 48)
+
+/* No name ambiguities in this file.  */
+__asm__ (".syntax no_register_prefix");
+
+void *memset(void *pdst, int c, unsigned int plen)
 {
-  /* Ok.  Now we want the parameters put in special registers.
-     Make sure the compiler is able to make something useful of this. */
+  /* Now we want the parameters in special registers.  Make sure the
+     compiler does something usable with this.  */
 
   register char *return_dst __asm__ ("r10") = pdst;
   register int n __asm__ ("r12") = plen;
   register int lc __asm__ ("r11") = c;
 
-  /* Most apps use memset sanely.  Only those memsetting about 3..4
-     bytes or less get penalized compared to the generic implementation
-     - and that's not really sane use. */
-
-  /* Ugh.  This is fragile at best.  Check with newer GCC releases, if
-     they compile cascaded "x |= x << 8" sanely! */
-  __asm__("movu.b %0,$r13	\n\
-           lslq 8,$r13		\n\
-	   move.b %0,$r13	\n\
-	   move.d $r13,%0	\n\
-	   lslq 16,$r13		\n\
-	   or.d $r13,%0"
-          : "=r" (lc) : "0" (lc) : "r13");
-
-  {
-    register char *dst __asm__ ("r13") = pdst;
+  /* Most apps use memset sanely.  Memsetting about 3..4 bytes or less get
+     penalized here compared to the generic implementation.  */
 
-  /* This is NONPORTABLE, but since this whole routine is     */
-  /* grossly nonportable that doesn't matter.                 */
+  /* This is fragile performancewise at best.  Check with newer GCC
+     releases, if they compile cascaded "x |= x << 8" to sane code.  */
+  __asm__("movu.b %0,r13						\n\
+	   lslq 8,r13							\n\
+	   move.b %0,r13						\n\
+	   move.d r13,%0						\n\
+	   lslq 16,r13							\n\
+	   or.d r13,%0"
+          : "=r" (lc)		/* Inputs.  */
+	  : "0" (lc)		/* Outputs.  */
+	  : "r13");		/* Trash.  */
 
-  if (((unsigned long) pdst & 3) != 0
-     /* Oops! n=0 must be a legal call, regardless of alignment. */
-      && n >= 3)
   {
-    if ((unsigned long)dst & 1)
-    {
-      *dst = (char) lc;
-      n--;
-      dst++;
-    }
-
-    if ((unsigned long)dst & 2)
-    {
-      *(short *)dst = lc;
-      n -= 2;
-      dst += 2;
-    }
-  }
-
-  /* Now the fun part.  For the threshold value of this, check the equation
-     above. */
-  /* Decide which copying method to use. */
-  if (n >= ZERO_BLOCK_SIZE)
-  {
-    /* For large copies we use 'movem' */
+    register char *dst __asm__ ("r13") = pdst;
 
-  /* It is not optimal to tell the compiler about clobbering any
-     registers; that will move the saving/restoring of those registers
-     to the function prologue/epilogue, and make non-movem sizes
-     suboptimal.
-
-      This method is not foolproof; it assumes that the "asm reg"
-     declarations at the beginning of the function really are used
-     here (beware: they may be moved to temporary registers).
-      This way, we do not have to save/move the registers around into
-     temporaries; we can safely use them straight away.
-
-      If you want to check that the allocation was right; then
-      check the equalities in the first comment.  It should say
-      "r13=r13, r12=r12, r11=r11" */
-    __asm__ volatile ("							\n\
-        ;; Check that the register asm declaration got right.		\n\
-        ;; The GCC manual says it will work, but there *has* been bugs.	\n\
-	.ifnc %0-%1-%4,$r13-$r12-$r11					\n\
-	.err								\n\
-	.endif								\n\
-									\n\
-	;; Save the registers we'll clobber in the movem process	\n\
-	;; on the stack.  Don't mention them to gcc, it will only be	\n\
-	;; upset.							\n\
-	subq 	11*4,$sp						\n\
-        movem   $r10,[$sp]						\n\
-									\n\
-        move.d  $r11,$r0						\n\
-        move.d  $r11,$r1						\n\
-        move.d  $r11,$r2						\n\
-        move.d  $r11,$r3						\n\
-        move.d  $r11,$r4						\n\
-        move.d  $r11,$r5						\n\
-        move.d  $r11,$r6						\n\
-        move.d  $r11,$r7						\n\
-        move.d  $r11,$r8						\n\
-        move.d  $r11,$r9						\n\
-        move.d  $r11,$r10						\n\
-									\n\
-        ;; Now we've got this:						\n\
-	;; r13 - dst							\n\
-	;; r12 - n							\n\
+    if (((unsigned long) pdst & 3) != 0
+	/* Oops! n = 0 must be a valid call, regardless of alignment.  */
+	&& n >= 3)
+      {
+	if ((unsigned long) dst & 1)
+	  {
+	    *dst = (char) lc;
+	    n--;
+	    dst++;
+	  }
+
+	if ((unsigned long) dst & 2)
+	  {
+	    *(short *) dst = lc;
+	    n -= 2;
+	    dst += 2;
+	  }
+      }
+
+    /* Decide which setting method to use.  */
+    if (n >= MEMSET_BY_BLOCK_THRESHOLD)
+      {
+	/* It is not optimal to tell the compiler about clobbering any
+	   registers; that will move the saving/restoring of those registers
+	   to the function prologue/epilogue, and make non-block sizes
+	   suboptimal.  */
+	__asm__ volatile
+	  ("\
+	   ;; GCC does promise correct register allocations, but let's	\n\
+	   ;; make sure it keeps its promises.				\n\
+	   .ifnc %0-%1-%4,$r13-$r12-$r11				\n\
+	   .error \"GCC reg alloc bug: %0-%1-%4 != $r13-$r12-$r11\"	\n\
+	   .endif							\n\
+									\n\
+	   ;; Save the registers we'll clobber in the movem process	\n\
+	   ;; on the stack.  Don't mention them to gcc, it will only be	\n\
+	   ;; upset.							\n\
+	   subq	   11*4,sp						\n\
+	   movem   r10,[sp]						\n\
+									\n\
+	   move.d  r11,r0						\n\
+	   move.d  r11,r1						\n\
+	   move.d  r11,r2						\n\
+	   move.d  r11,r3						\n\
+	   move.d  r11,r4						\n\
+	   move.d  r11,r5						\n\
+	   move.d  r11,r6						\n\
+	   move.d  r11,r7						\n\
+	   move.d  r11,r8						\n\
+	   move.d  r11,r9						\n\
+	   move.d  r11,r10						\n\
 									\n\
-        ;; Update n for the first loop					\n\
-        subq    12*4,$r12						\n\
+	   ;; Now we've got this:					\n\
+	   ;; r13 - dst							\n\
+	   ;; r12 - n							\n\
+									\n\
+	   ;; Update n for the first loop				\n\
+	   subq	   12*4,r12						\n\
 0:									\n\
-        subq   12*4,$r12						\n\
-        bge     0b							\n\
-	movem	$r11,[$r13+]						\n\
+"
+#ifdef __arch_common_v10_v32
+	   /* Cater to branch offset difference between v32 and v10.  We
+	      assume the branch below has an 8-bit offset.  */
+"	   setf\n"
+#endif
+"	   subq	  12*4,r12						\n\
+	   bge	   0b							\n\
+	   movem	r11,[r13+]					\n\
 									\n\
-        addq   12*4,$r12  ;; compensate for last loop underflowing n	\n\
+	   ;; Compensate for last loop underflowing n.			\n\
+	   addq	  12*4,r12						\n\
 									\n\
-	;; Restore registers from stack					\n\
-        movem [$sp+],$r10"
+	   ;; Restore registers from stack.				\n\
+	   movem [sp+],r10"
 
-     /* Outputs */ : "=r" (dst), "=r" (n)
-     /* Inputs */ : "0" (dst), "1" (n), "r" (lc));
-  }
+	   /* Outputs.	*/
+	   : "=r" (dst), "=r" (n)
+
+	   /* Inputs.  */
+	   : "0" (dst), "1" (n), "r" (lc));
+      }
+
+    /* An ad-hoc unroll, used for 4*12-1..16 bytes. */
+    while (n >= 16)
+      {
+	*(long *) dst = lc; dst += 4;
+	*(long *) dst = lc; dst += 4;
+	*(long *) dst = lc; dst += 4;
+	*(long *) dst = lc; dst += 4;
+	n -= 16;
+      }
 
-    /* Either we directly starts copying, using dword copying
-       in a loop, or we copy as much as possible with 'movem'
-       and then the last block (<44 bytes) is copied here.
-       This will work since 'movem' will have updated src,dst,n. */
-
-    while ( n >= 16 )
-    {
-      *((long*)dst)++ = lc;
-      *((long*)dst)++ = lc;
-      *((long*)dst)++ = lc;
-      *((long*)dst)++ = lc;
-      n -= 16;
-    }
-
-    /* A switch() is definitely the fastest although it takes a LOT of code.
-     * Particularly if you inline code this.
-     */
     switch (n)
-    {
+      {
       case 0:
         break;
+
       case 1:
-        *(char*)dst = (char) lc;
+        *dst = (char) lc;
         break;
+
       case 2:
-        *(short*)dst = (short) lc;
+        *(short *) dst = (short) lc;
         break;
+
       case 3:
-        *((short*)dst)++ = (short) lc;
-        *(char*)dst = (char) lc;
+        *(short *) dst = (short) lc; dst += 2;
+        *dst = (char) lc;
         break;
+
       case 4:
-        *((long*)dst)++ = lc;
+        *(long *) dst = lc;
         break;
+
       case 5:
-        *((long*)dst)++ = lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *dst = (char) lc;
         break;
+
       case 6:
-        *((long*)dst)++ = lc;
-        *(short*)dst = (short) lc;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc;
         break;
+
       case 7:
-        *((long*)dst)++ = lc;
-        *((short*)dst)++ = (short) lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc; dst += 2;
+        *dst = (char) lc;
         break;
+
       case 8:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc;
         break;
+
       case 9:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *dst = (char) lc;
         break;
+
       case 10:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *(short*)dst = (short) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc;
         break;
+
       case 11:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((short*)dst)++ = (short) lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc; dst += 2;
+        *dst = (char) lc;
         break;
+
       case 12:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc;
         break;
+
       case 13:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *dst = (char) lc;
         break;
+
       case 14:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *(short*)dst = (short) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc;
         break;
+
       case 15:
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((long*)dst)++ = lc;
-        *((short*)dst)++ = (short) lc;
-        *(char*)dst = (char) lc;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(long *) dst = lc; dst += 4;
+        *(short *) dst = (short) lc; dst += 2;
+        *dst = (char) lc;
         break;
-    }
+      }
   }
 
-  return return_dst; /* destination pointer. */
-} /* memset() */
+  return return_dst;
+}
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-import-memsetc-from-newlib-fixes-compile-error-with-newer-pre43-gcc.patch
