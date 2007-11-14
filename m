From: akpm@linux-foundation.org
Subject: + crisv10-string-library-add-lineendings-to-asm.patch added to -mm tree
Date: Wed, 14 Nov 2007 08:48:40 -0800
Message-ID: <200711141648.lAEGmec5015355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbXKNQso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 11:48:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     CRISv10 string library add lineendings to asm
has been added to the -mm tree.  Its filename is
     crisv10-string-library-add-lineendings-to-asm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-mtd.patch
cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
cris-dont-include-bitopsh-in-posix_typesh.patch
crisv10-serial-driver-rewrite-take-three.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
crisv10-fix-timer-interrupt-parameters.patch
crisv10-improve-and-bugfix-fasttimer.patch
crisv32-add-cache-flush-operations.patch
cris-tlbh-should-include-linux-pagemaph.patch
crisv10-ethernet-declare-mac-fix.patch
crisv10-usercopy-library-add-lineendings-to-asm.patch
crisv10-string-library-add-lineendings-to-asm.patch
crisv10-memset-library-add-lineendings-to-asm.patch
