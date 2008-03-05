From: akpm@linux-foundation.org
Subject: - cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:44 -0800
Message-ID: <200803050744.m257iiE9021535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758098AbYCEHvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:51:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, bunk@stusta.de, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS: Import string.c (memcpy) from newlib: fixes compile error with gcc 4
has been removed from the -mm tree.  Its filename was
     cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CRIS: Import string.c (memcpy) from newlib: fixes compile error with gcc 4
From: Jesper Nilsson <jesper.nilsson@axis.com>

Adrian Bunk reported another compile error with a SVN head GCC:

...
  CC      arch/cris/arch-v10/lib/string.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/string.c:138:
error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/string.c:138:
error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/string.c:139:
error: lvalue required as increment operand
...

This is due to the use of the construct:

	*((long*)dst)++ = lc;

Which isn't legal since casts don't return an lvalue.

The solution is to import the implementation from newlib,
which is continually autotested together with GCC mainline,
and uses the construct:

	*(long *) dst = lc; dst += 4;

Since this is an import of a file from newlib, I'm not touching
the formatting or correcting any checkpatch errors.

As for the earlier fix for memset.c, even if the two files for
CRIS v10 and CRIS v32 are identical at the moment, it might
be possible to tweak the CRIS v32 version.
Thus, I'm not yet folding them into the same file, at least not
until we've done some research on it.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/lib/string.c |  337 +++++++++++++++---------------
 arch/cris/arch-v32/lib/string.c |  331 +++++++++++++++--------------
 2 files changed, 348 insertions(+), 320 deletions(-)

diff -puN arch/cris/arch-v10/lib/string.c~cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4 arch/cris/arch-v10/lib/string.c
--- a/arch/cris/arch-v10/lib/string.c~cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4
+++ a/arch/cris/arch-v10/lib/string.c
@@ -1,55 +1,59 @@
-/*#************************************************************************#*/
-/*#-------------------------------------------------------------------------*/
-/*#                                                                         */
-/*# FUNCTION NAME: memcpy()                                                 */
-/*#                                                                         */
-/*# PARAMETERS:  void* dst;   Destination address.                          */
-/*#              void* src;   Source address.                               */
-/*#              int   len;   Number of bytes to copy.                      */
-/*#                                                                         */
-/*# RETURNS:     dst.                                                       */
-/*#                                                                         */
-/*# DESCRIPTION: Copies len bytes of memory from src to dst.  No guarantees */
-/*#              about copying of overlapping memory areas. This routine is */
-/*#              very sensitive to compiler changes in register allocation. */
-/*#              Should really be rewritten to avoid this problem.          */
-/*#                                                                         */
-/*#-------------------------------------------------------------------------*/
-/*#                                                                         */
-/*# HISTORY                                                                 */
-/*#                                                                         */
-/*# DATE      NAME            CHANGES                                       */
-/*# ----      ----            -------                                       */
-/*# 941007    Kenny R         Creation                                      */
-/*# 941011    Kenny R         Lots of optimizations and inlining.           */
-/*# 941129    Ulf A           Adapted for use in libc.                      */
-/*# 950216    HP              N==0 forgotten if non-aligned src/dst.        */
-/*#                           Added some optimizations.                     */
-/*# 001025    HP              Make src and dst char *.  Align dst to	    */
-/*#			      dword, not just word-if-both-src-and-dst-	    */
-/*#			      are-misaligned.				    */
-/*#                                                                         */
-/*#-------------------------------------------------------------------------*/
-
-#include <linux/types.h>
-
-void *memcpy(void *pdst,
-             const void *psrc,
-             size_t pn)
+/* A memcpy for CRIS.
+   Copyright (C) 1994-2005 Axis Communications.
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
+#include <stddef.h>
+
+/* Break even between movem and move16 is really at 38.7 * 2, but
+   modulo 44, so up to the next multiple of 44, we use ordinary code.  */
+#define MEMCPY_BY_BLOCK_THRESHOLD (44 * 2)
+
+/* No name ambiguities in this file.  */
+__asm__ (".syntax no_register_prefix");
+
+void *
+memcpy(void *pdst, const void *psrc, size_t pn)
 {
-  /* Ok.  Now we want the parameters put in special registers.
+  /* Now we want the parameters put in special registers.
      Make sure the compiler is able to make something useful of this.
-      As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
+     As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
-     If gcc was alright, it really would need no temporaries, and no
-     stack space to save stuff on. */
+     If gcc was allright, it really would need no temporaries, and no
+     stack space to save stuff on.  */
 
   register void *return_dst __asm__ ("r10") = pdst;
-  register char *dst __asm__ ("r13") = pdst;
-  register const char *src __asm__ ("r11") = psrc;
+  register unsigned char *dst __asm__ ("r13") = pdst;
+  register unsigned const char *src __asm__ ("r11") = psrc;
   register int n __asm__ ("r12") = pn;
-  
- 
+
   /* When src is aligned but not dst, this makes a few extra needless
      cycles.  I believe it would take as many to check that the
      re-alignment was unnecessary.  */
@@ -59,167 +63,174 @@ void *memcpy(void *pdst,
       && n >= 3)
   {
     if ((unsigned long) dst & 1)
-    {
-      n--;
-      *(char*)dst = *(char*)src;
-      src++;
-      dst++;
-    }
+      {
+	n--;
+	*dst = *src;
+	src++;
+	dst++;
+      }
 
     if ((unsigned long) dst & 2)
-    {
-      n -= 2;
-      *(short*)dst = *(short*)src;
-      src += 2;
-      dst += 2;
-    }
+      {
+	n -= 2;
+	*(short *) dst = *(short *) src;
+	src += 2;
+	dst += 2;
+      }
   }
 
-  /* Decide which copying method to use. */
-  if (n >= 44*2)                /* Break even between movem and
-                                   move16 is at 38.7*2, but modulo 44. */
-  {
-    /* For large copies we use 'movem' */
-
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
-      "r13=r13, r11=r11, r12=r12" */
-    __asm__ volatile ("\n\
-	;; Check that the following is true (same register names on	\n\
-	;; both sides of equal sign, as in r8=r8):			\n\
-	;; %0=r13, %1=r11, %2=r12					\n\
-	;;								\n\
-	;; Save the registers we'll use in the movem process		\n\
-	;; on the stack.						\n\
-	subq	11*4,$sp						\n\
-	movem	$r10,[$sp]						\n\
+  /* Decide which copying method to use.  */
+  if (n >= MEMCPY_BY_BLOCK_THRESHOLD)
+    {
+      /* It is not optimal to tell the compiler about clobbering any
+	 registers; that will move the saving/restoring of those registers
+	 to the function prologue/epilogue, and make non-movem sizes
+	 suboptimal.  */
+      __asm__ volatile
+	("\
+	 ;; GCC does promise correct register allocations, but let's	\n\
+	 ;; make sure it keeps its promises.				\n\
+	 .ifnc %0-%1-%2,$r13-$r11-$r12					\n\
+	 .error \"GCC reg alloc bug: %0-%1-%4 != $r13-$r12-$r11\"	\n\
+	 .endif								\n\
 									\n\
-	;; Now we've got this:						\n\
-	;; r11 - src							\n\
-	;; r13 - dst							\n\
-	;; r12 - n							\n\
+	 ;; Save the registers we'll use in the movem process		\n\
+	 ;; on the stack.						\n\
+	 subq	11*4,sp							\n\
+	 movem	r10,[sp]						\n\
 									\n\
-	;; Update n for the first loop					\n\
-	subq	44,$r12							\n\
+	 ;; Now we've got this:						\n\
+	 ;; r11 - src							\n\
+	 ;; r13 - dst							\n\
+	 ;; r12 - n							\n\
+									\n\
+	 ;; Update n for the first loop.				\n\
+	 subq	 44,r12							\n\
 0:									\n\
-	movem	[$r11+],$r10						\n\
-	subq	44,$r12							\n\
-	bge	0b							\n\
-	movem	$r10,[$r13+]						\n\
+"
+#ifdef __arch_common_v10_v32
+	 /* Cater to branch offset difference between v32 and v10.  We
+	    assume the branch below has an 8-bit offset.  */
+"	 setf\n"
+#endif
+"	 movem	[r11+],r10						\n\
+	 subq	44,r12							\n\
+	 bge	 0b							\n\
+	 movem	r10,[r13+]						\n\
 									\n\
-	addq	44,$r12 ;; compensate for last loop underflowing n	\n\
+	 ;; Compensate for last loop underflowing n.			\n\
+	 addq	44,r12							\n\
 									\n\
-	;; Restore registers from stack					\n\
-	movem	[$sp+],$r10"
+	 ;; Restore registers from stack.				\n\
+	 movem [sp+],r10"
 
-     /* Outputs */ : "=r" (dst), "=r" (src), "=r" (n) 
-     /* Inputs */ : "0" (dst), "1" (src), "2" (n));
-    
-  }
+	 /* Outputs.  */
+	 : "=r" (dst), "=r" (src), "=r" (n)
 
-  /* Either we directly starts copying, using dword copying
-     in a loop, or we copy as much as possible with 'movem' 
-     and then the last block (<44 bytes) is copied here.
-     This will work since 'movem' will have updated src,dst,n. */
+	 /* Inputs.  */
+	 : "0" (dst), "1" (src), "2" (n));
+    }
 
-  while ( n >= 16 )
-  {
-    *((long*)dst)++ = *((long*)src)++;
-    *((long*)dst)++ = *((long*)src)++;
-    *((long*)dst)++ = *((long*)src)++;
-    *((long*)dst)++ = *((long*)src)++;
-    n -= 16;
-  }
+  while (n >= 16)
+    {
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+
+      n -= 16;
+    }
 
-  /* A switch() is definitely the fastest although it takes a LOT of code.
-   * Particularly if you inline code this.
-   */
   switch (n)
-  {
+    {
     case 0:
       break;
+
     case 1:
-      *(char*)dst = *(char*)src;
+      *dst = *src;
       break;
+
     case 2:
-      *(short*)dst = *(short*)src;
+      *(short *) dst = *(short *) src;
       break;
+
     case 3:
-      *((short*)dst)++ = *((short*)src)++;
-      *(char*)dst = *(char*)src;
+      *(short *) dst = *(short *) src; dst += 2; src += 2;
+      *dst = *src;
       break;
+
     case 4:
-      *((long*)dst)++ = *((long*)src)++;
+      *(long *) dst = *(long *) src;
       break;
+
     case 5:
-      *((long*)dst)++ = *((long*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *dst = *src;
       break;
+
     case 6:
-      *((long*)dst)++ = *((long*)src)++;
-      *(short*)dst = *(short*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src;
       break;
+
     case 7:
-      *((long*)dst)++ = *((long*)src)++;
-      *((short*)dst)++ = *((short*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src; dst += 2; src += 2;
+      *dst = *src;
       break;
+
     case 8:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src;
       break;
+
     case 9:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *dst = *src;
       break;
+
     case 10:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *(short*)dst = *(short*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src;
       break;
+
     case 11:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((short*)dst)++ = *((short*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src; dst += 2; src += 2;
+      *dst = *src;
       break;
+
     case 12:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src;
       break;
+
     case 13:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *dst = *src;
       break;
+
     case 14:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *(short*)dst = *(short*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src;
       break;
+
     case 15:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((short*)dst)++ = *((short*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src; dst += 2; src += 2;
+      *dst = *src;
       break;
-  }
+    }
 
-  return return_dst; /* destination pointer. */
-} /* memcpy() */
+  return return_dst;
+}
diff -puN arch/cris/arch-v32/lib/string.c~cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4 arch/cris/arch-v32/lib/string.c
--- a/arch/cris/arch-v32/lib/string.c~cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4
+++ a/arch/cris/arch-v32/lib/string.c
@@ -1,55 +1,59 @@
-/*#************************************************************************#*/
-/*#-------------------------------------------------------------------------*/
-/*#                                                                         */
-/*# FUNCTION NAME: memcpy()                                                 */
-/*#                                                                         */
-/*# PARAMETERS:  void* dst;   Destination address.                          */
-/*#              void* src;   Source address.                               */
-/*#              int   len;   Number of bytes to copy.                      */
-/*#                                                                         */
-/*# RETURNS:     dst.                                                       */
-/*#                                                                         */
-/*# DESCRIPTION: Copies len bytes of memory from src to dst.  No guarantees */
-/*#              about copying of overlapping memory areas. This routine is */
-/*#              very sensitive to compiler changes in register allocation. */
-/*#              Should really be rewritten to avoid this problem.          */
-/*#                                                                         */
-/*#-------------------------------------------------------------------------*/
-/*#                                                                         */
-/*# HISTORY                                                                 */
-/*#                                                                         */
-/*# DATE      NAME            CHANGES                                       */
-/*# ----      ----            -------                                       */
-/*# 941007    Kenny R         Creation                                      */
-/*# 941011    Kenny R         Lots of optimizations and inlining.           */
-/*# 941129    Ulf A           Adapted for use in libc.                      */
-/*# 950216    HP              N==0 forgotten if non-aligned src/dst.        */
-/*#                           Added some optimizations.                     */
-/*# 001025    HP              Make src and dst char *.  Align dst to	    */
-/*#			      dword, not just word-if-both-src-and-dst-	    */
-/*#			      are-misaligned.				    */
-/*#                                                                         */
-/*#-------------------------------------------------------------------------*/
-
-#include <linux/types.h>
-
-void *memcpy(void *pdst,
-             const void *psrc,
-             size_t pn)
+/* A memcpy for CRIS.
+   Copyright (C) 1994-2005 Axis Communications.
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
+#include <stddef.h>
+
+/* Break even between movem and move16 is really at 38.7 * 2, but
+   modulo 44, so up to the next multiple of 44, we use ordinary code.  */
+#define MEMCPY_BY_BLOCK_THRESHOLD (44 * 2)
+
+/* No name ambiguities in this file.  */
+__asm__ (".syntax no_register_prefix");
+
+void *
+memcpy(void *pdst, const void *psrc, size_t pn)
 {
-  /* Ok.  Now we want the parameters put in special registers.
+  /* Now we want the parameters put in special registers.
      Make sure the compiler is able to make something useful of this.
-      As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
+     As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
-     If gcc was alright, it really would need no temporaries, and no
-     stack space to save stuff on. */
+     If gcc was allright, it really would need no temporaries, and no
+     stack space to save stuff on.  */
 
   register void *return_dst __asm__ ("r10") = pdst;
-  register char *dst __asm__ ("r13") = pdst;
-  register const char *src __asm__ ("r11") = psrc;
+  register unsigned char *dst __asm__ ("r13") = pdst;
+  register unsigned const char *src __asm__ ("r11") = psrc;
   register int n __asm__ ("r12") = pn;
 
-
   /* When src is aligned but not dst, this makes a few extra needless
      cycles.  I believe it would take as many to check that the
      re-alignment was unnecessary.  */
@@ -59,161 +63,174 @@ void *memcpy(void *pdst,
       && n >= 3)
   {
     if ((unsigned long) dst & 1)
-    {
-      n--;
-      *(char*)dst = *(char*)src;
-      src++;
-      dst++;
-    }
+      {
+	n--;
+	*dst = *src;
+	src++;
+	dst++;
+      }
 
     if ((unsigned long) dst & 2)
-    {
-      n -= 2;
-      *(short*)dst = *(short*)src;
-      src += 2;
-      dst += 2;
-    }
+      {
+	n -= 2;
+	*(short *) dst = *(short *) src;
+	src += 2;
+	dst += 2;
+      }
   }
 
-  /* Decide which copying method to use.  Movem is dirt cheap, so the
-     overheap is low enough to always use the minimum block size as the
-     threshold.  */
-  if (n >= 44)
-  {
-    /* For large copies we use 'movem' */
-
-  /* It is not optimal to tell the compiler about clobbering any
-     registers; that will move the saving/restoring of those registers
-     to the function prologue/epilogue, and make non-movem sizes
-     suboptimal.  */
-    __asm__ volatile ("							\n\
-        ;; Check that the register asm declaration got right.		\n\
-        ;; The GCC manual explicitly says TRT will happen.		\n\
-	.ifnc %0-%1-%2,$r13-$r11-$r12					\n\
-	.err								\n\
-	.endif								\n\
-									\n\
-	;; Save the registers we'll use in the movem process		\n\
-									\n\
-	;; on the stack.						\n\
-	subq 	11*4,$sp						\n\
-	movem	$r10,[$sp]						\n\
-									\n\
-        ;; Now we've got this:						\n\
-	;; r11 - src							\n\
-	;; r13 - dst							\n\
-	;; r12 - n							\n\
+  /* Decide which copying method to use.  */
+  if (n >= MEMCPY_BY_BLOCK_THRESHOLD)
+    {
+      /* It is not optimal to tell the compiler about clobbering any
+	 registers; that will move the saving/restoring of those registers
+	 to the function prologue/epilogue, and make non-movem sizes
+	 suboptimal.  */
+      __asm__ volatile
+	("\
+	 ;; GCC does promise correct register allocations, but let's	\n\
+	 ;; make sure it keeps its promises.				\n\
+	 .ifnc %0-%1-%2,$r13-$r11-$r12					\n\
+	 .error \"GCC reg alloc bug: %0-%1-%4 != $r13-$r12-$r11\"	\n\
+	 .endif								\n\
+									\n\
+	 ;; Save the registers we'll use in the movem process		\n\
+	 ;; on the stack.						\n\
+	 subq	11*4,sp							\n\
+	 movem	r10,[sp]						\n\
+									\n\
+	 ;; Now we've got this:						\n\
+	 ;; r11 - src							\n\
+	 ;; r13 - dst							\n\
+	 ;; r12 - n							\n\
 									\n\
-        ;; Update n for the first loop					\n\
-        subq    44,$r12							\n\
+	 ;; Update n for the first loop.				\n\
+	 subq	 44,r12							\n\
 0:									\n\
-	movem	[$r11+],$r10						\n\
-        subq   44,$r12							\n\
-        bge     0b							\n\
-	movem	$r10,[$r13+]						\n\
+"
+#ifdef __arch_common_v10_v32
+	 /* Cater to branch offset difference between v32 and v10.  We
+	    assume the branch below has an 8-bit offset.  */
+"	 setf\n"
+#endif
+"	 movem	[r11+],r10						\n\
+	 subq	44,r12							\n\
+	 bge	 0b							\n\
+	 movem	r10,[r13+]						\n\
+									\n\
+	 ;; Compensate for last loop underflowing n.			\n\
+	 addq	44,r12							\n\
 									\n\
-        addq   44,$r12  ;; compensate for last loop underflowing n	\n\
-									\n\
-	;; Restore registers from stack					\n\
-        movem [$sp+],$r10"
+	 ;; Restore registers from stack.				\n\
+	 movem [sp+],r10"
 
-     /* Outputs */ : "=r" (dst), "=r" (src), "=r" (n)
-     /* Inputs */ : "0" (dst), "1" (src), "2" (n));
+	 /* Outputs.  */
+	 : "=r" (dst), "=r" (src), "=r" (n)
 
-  }
+	 /* Inputs.  */
+	 : "0" (dst), "1" (src), "2" (n));
+    }
 
-  /* Either we directly starts copying, using dword copying
-     in a loop, or we copy as much as possible with 'movem'
-     and then the last block (<44 bytes) is copied here.
-     This will work since 'movem' will have updated src,dst,n. */
+  while (n >= 16)
+    {
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
 
-  while ( n >= 16 )
-  {
-    *((long*)dst)++ = *((long*)src)++;
-    *((long*)dst)++ = *((long*)src)++;
-    *((long*)dst)++ = *((long*)src)++;
-    *((long*)dst)++ = *((long*)src)++;
-    n -= 16;
-  }
+      n -= 16;
+    }
 
-  /* A switch() is definitely the fastest although it takes a LOT of code.
-   * Particularly if you inline code this.
-   */
   switch (n)
-  {
+    {
     case 0:
       break;
+
     case 1:
-      *(char*)dst = *(char*)src;
+      *dst = *src;
       break;
+
     case 2:
-      *(short*)dst = *(short*)src;
+      *(short *) dst = *(short *) src;
       break;
+
     case 3:
-      *((short*)dst)++ = *((short*)src)++;
-      *(char*)dst = *(char*)src;
+      *(short *) dst = *(short *) src; dst += 2; src += 2;
+      *dst = *src;
       break;
+
     case 4:
-      *((long*)dst)++ = *((long*)src)++;
+      *(long *) dst = *(long *) src;
       break;
+
     case 5:
-      *((long*)dst)++ = *((long*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *dst = *src;
       break;
+
     case 6:
-      *((long*)dst)++ = *((long*)src)++;
-      *(short*)dst = *(short*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src;
       break;
+
     case 7:
-      *((long*)dst)++ = *((long*)src)++;
-      *((short*)dst)++ = *((short*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src; dst += 2; src += 2;
+      *dst = *src;
       break;
+
     case 8:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src;
       break;
+
     case 9:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *dst = *src;
       break;
+
     case 10:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *(short*)dst = *(short*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src;
       break;
+
     case 11:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((short*)dst)++ = *((short*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src; dst += 2; src += 2;
+      *dst = *src;
       break;
+
     case 12:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src;
       break;
+
     case 13:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *dst = *src;
       break;
+
     case 14:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *(short*)dst = *(short*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src;
       break;
+
     case 15:
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((long*)dst)++ = *((long*)src)++;
-      *((short*)dst)++ = *((short*)src)++;
-      *(char*)dst = *(char*)src;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(long *) dst = *(long *) src; dst += 4; src += 4;
+      *(short *) dst = *(short *) src; dst += 2; src += 2;
+      *dst = *src;
       break;
-  }
+    }
 
-  return return_dst; /* destination pointer. */
-} /* memcpy() */
+  return return_dst;
+}
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are


