From: akpm@linux-foundation.org
Subject: - crisv10-string-library-add-lineendings-to-asm.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:12:21 -0800
Message-ID: <200711152112.lAFLCL8a015864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761764AbXKOVRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, mikael.starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRISv10 string library add lineendings to asm
has been removed from the -mm tree.  Its filename was
     crisv10-string-library-add-lineendings-to-asm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CRISv10 string library add lineendings to asm
From: Jesper Nilsson <jesper.nilsson@axis.com>

Add \n\ at end of lines inside asm statement to avoid warning.

No change except adding \n\ to end of line and correcting
whitespace has been done.
Removes warning about multi-line string literals when compiling
arch/cris/arch-v10/lib/string.c

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/lib/string.c |   54 +++++++++++++++---------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff -puN arch/cris/arch-v10/lib/string.c~crisv10-string-library-add-lineendings-to-asm arch/cris/arch-v10/lib/string.c
--- a/arch/cris/arch-v10/lib/string.c~crisv10-string-library-add-lineendings-to-asm
+++ a/arch/cris/arch-v10/lib/string.c
@@ -95,33 +95,33 @@ void *memcpy(void *pdst,
       If you want to check that the allocation was right; then
       check the equalities in the first comment.  It should say
       "r13=r13, r11=r11, r12=r12" */
-    __asm__ volatile ("
-        ;; Check that the following is true (same register names on
-        ;; both sides of equal sign, as in r8=r8):
-        ;; %0=r13, %1=r11, %2=r12
-        ;;
-	;; Save the registers we'll use in the movem process
-	;; on the stack.
-	subq 	11*4,$sp
-	movem	$r10,[$sp]
-
-        ;; Now we've got this:
-	;; r11 - src
-	;; r13 - dst
-	;; r12 - n
-	
-        ;; Update n for the first loop
-        subq    44,$r12
-0:
-	movem	[$r11+],$r10
-        subq   44,$r12
-        bge     0b
-	movem	$r10,[$r13+]
-
-        addq   44,$r12  ;; compensate for last loop underflowing n
-
-	;; Restore registers from stack
-        movem [$sp+],$r10" 
+    __asm__ volatile ("\n\
+	;; Check that the following is true (same register names on	\n\
+	;; both sides of equal sign, as in r8=r8):			\n\
+	;; %0=r13, %1=r11, %2=r12					\n\
+	;;								\n\
+	;; Save the registers we'll use in the movem process		\n\
+	;; on the stack.						\n\
+	subq	11*4,$sp						\n\
+	movem	$r10,[$sp]						\n\
+									\n\
+	;; Now we've got this:						\n\
+	;; r11 - src							\n\
+	;; r13 - dst							\n\
+	;; r12 - n							\n\
+									\n\
+	;; Update n for the first loop					\n\
+	subq	44,$r12							\n\
+0:									\n\
+	movem	[$r11+],$r10						\n\
+	subq	44,$r12							\n\
+	bge	0b							\n\
+	movem	$r10,[$r13+]						\n\
+									\n\
+	addq	44,$r12 ;; compensate for last loop underflowing n	\n\
+									\n\
+	;; Restore registers from stack					\n\
+	movem	[$sp+],$r10"
 
      /* Outputs */ : "=r" (dst), "=r" (src), "=r" (n) 
      /* Inputs */ : "0" (dst), "1" (src), "2" (n));
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
