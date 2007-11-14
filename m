From: akpm@linux-foundation.org
Subject: + crisv10-usercopy-library-add-lineendings-to-asm.patch added to -mm tree
Date: Wed, 14 Nov 2007 08:41:58 -0800
Message-ID: <200711141641.lAEGfwoC015018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674AbXKNQma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 11:42:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     CRISv10 usercopy library add lineendings to asm
has been added to the -mm tree.  Its filename is
     crisv10-usercopy-library-add-lineendings-to-asm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRISv10 usercopy library add lineendings to asm
From: Jesper Nilsson <jesper.nilsson@axis.com>

Removes warning when compiling arch/cris/arch-v10/lib/usercopy.c

No change except adding \n\ on the end of the lines has been done.
Removes warning about multi-line string literals.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/lib/usercopy.c |  314 ++++++++++++++--------------
 1 file changed, 157 insertions(+), 157 deletions(-)

diff -puN arch/cris/arch-v10/lib/usercopy.c~crisv10-usercopy-library-add-lineendings-to-asm arch/cris/arch-v10/lib/usercopy.c
--- a/arch/cris/arch-v10/lib/usercopy.c~crisv10-usercopy-library-add-lineendings-to-asm
+++ a/arch/cris/arch-v10/lib/usercopy.c
@@ -92,58 +92,58 @@ __copy_user (void __user *pdst, const vo
 	.ifnc %0%1%2%3,$r13$r11$r12$r10					\n\
 	.err								\n\
 	.endif								\n\
-
-	;; Save the registers we'll use in the movem process
-	;; on the stack.
-	subq	11*4,$sp
-	movem	$r10,[$sp]
-
-	;; Now we've got this:
-	;; r11 - src
-	;; r13 - dst
-	;; r12 - n
-
-	;; Update n for the first loop
-	subq	44,$r12
-
-; Since the noted PC of a faulting instruction in a delay-slot of a taken
-; branch, is that of the branch target, we actually point at the from-movem
-; for this case.  There is no ambiguity here; if there was a fault in that
-; instruction (meaning a kernel oops), the faulted PC would be the address
-; after *that* movem.
-
-0:
-	movem	[$r11+],$r10
-	subq   44,$r12
-	bge	0b
-	movem	$r10,[$r13+]
-1:
-	addq   44,$r12  ;; compensate for last loop underflowing n
-
-	;; Restore registers from stack
-	movem [$sp+],$r10
-2:
-	.section .fixup,\"ax\"
-
-; To provide a correct count in r10 of bytes that failed to be copied,
-; we jump back into the loop if the loop-branch was taken.  There is no
-; performance penalty for sany use; the program will segfault soon enough.
-
-3:
-	move.d [$sp],$r10
-	addq 44,$r10
-	move.d $r10,[$sp]
-	jump 0b
-4:
-	movem [$sp+],$r10
-	addq 44,$r10
-	addq 44,$r12
-	jump 2b
-
-	.previous
-	.section __ex_table,\"a\"
-	.dword 0b,3b
-	.dword 1b,4b
+									\n\
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
+									\n\
+; Since the noted PC of a faulting instruction in a delay-slot of a taken \n\
+; branch, is that of the branch target, we actually point at the from-movem \n\
+; for this case.  There is no ambiguity here; if there was a fault in that \n\
+; instruction (meaning a kernel oops), the faulted PC would be the address \n\
+; after *that* movem.							\n\
+									\n\
+0:									\n\
+	movem	[$r11+],$r10						\n\
+	subq   44,$r12							\n\
+	bge	0b							\n\
+	movem	$r10,[$r13+]						\n\
+1:									\n\
+	addq   44,$r12  ;; compensate for last loop underflowing n	\n\
+									\n\
+	;; Restore registers from stack					\n\
+	movem [$sp+],$r10						\n\
+2:									\n\
+	.section .fixup,\"ax\"						\n\
+									\n\
+; To provide a correct count in r10 of bytes that failed to be copied,	\n\
+; we jump back into the loop if the loop-branch was taken.  There is no	\n\
+; performance penalty for sany use; the program will segfault soon enough.\n\
+									\n\
+3:									\n\
+	move.d [$sp],$r10						\n\
+	addq 44,$r10							\n\
+	move.d $r10,[$sp]						\n\
+	jump 0b								\n\
+4:									\n\
+	movem [$sp+],$r10						\n\
+	addq 44,$r10							\n\
+	addq 44,$r12							\n\
+	jump 2b								\n\
+									\n\
+	.previous							\n\
+	.section __ex_table,\"a\"					\n\
+	.dword 0b,3b							\n\
+	.dword 1b,4b							\n\
 	.previous"
 
      /* Outputs */ : "=r" (dst), "=r" (src), "=r" (n), "=r" (retn)
@@ -253,59 +253,59 @@ __copy_user_zeroing (void __user *pdst, 
        If you want to check that the allocation was right; then
        check the equalities in the first comment.  It should say
        "r13=r13, r11=r11, r12=r12" */
-    __asm__ volatile ("
+    __asm__ volatile ("\n\
 	.ifnc %0%1%2%3,$r13$r11$r12$r10					\n\
 	.err								\n\
 	.endif								\n\
-
-	;; Save the registers we'll use in the movem process
-	;; on the stack.
-	subq	11*4,$sp
-	movem	$r10,[$sp]
-
-	;; Now we've got this:
-	;; r11 - src
-	;; r13 - dst
-	;; r12 - n
-
-	;; Update n for the first loop
-	subq	44,$r12
-0:
-	movem	[$r11+],$r10
-1:
-	subq   44,$r12
-	bge	0b
-	movem	$r10,[$r13+]
-
-	addq   44,$r12  ;; compensate for last loop underflowing n
-
-	;; Restore registers from stack
-	movem [$sp+],$r10
-4:
-	.section .fixup,\"ax\"
-
-;; Do not jump back into the loop if we fail.  For some uses, we get a
-;; page fault somewhere on the line.  Without checking for page limits,
-;; we don't know where, but we need to copy accurately and keep an
-;; accurate count; not just clear the whole line.  To do that, we fall
-;; down in the code below, proceeding with smaller amounts.  It should
-;; be kept in mind that we have to cater to code like what at one time
-;; was in fs/super.c:
-;;  i = size - copy_from_user((void *)page, data, size);
-;; which would cause repeated faults while clearing the remainder of
-;; the SIZE bytes at PAGE after the first fault.
-;; A caveat here is that we must not fall through from a failing page
-;; to a valid page.
-
-3:
-	movem  [$sp+],$r10
-	addq	44,$r12 ;; Get back count before faulting point.
-	subq	44,$r11 ;; Get back pointer to faulting movem-line.
-	jump	4b	;; Fall through, pretending the fault didn't happen.
-
-	.previous
-	.section __ex_table,\"a\"
-	.dword 1b,3b
+									\n\
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
+1:									\n\
+	subq   44,$r12							\n\
+	bge	0b							\n\
+	movem	$r10,[$r13+]						\n\
+									\n\
+	addq   44,$r12  ;; compensate for last loop underflowing n	\n\
+									\n\
+	;; Restore registers from stack					\n\
+	movem [$sp+],$r10						\n\
+4:									\n\
+	.section .fixup,\"ax\"						\n\
+									\n\
+;; Do not jump back into the loop if we fail.  For some uses, we get a	\n\
+;; page fault somewhere on the line.  Without checking for page limits,	\n\
+;; we don't know where, but we need to copy accurately and keep an	\n\
+;; accurate count; not just clear the whole line.  To do that, we fall	\n\
+;; down in the code below, proceeding with smaller amounts.  It should	\n\
+;; be kept in mind that we have to cater to code like what at one time	\n\
+;; was in fs/super.c:							\n\
+;;  i = size - copy_from_user((void *)page, data, size);		\n\
+;; which would cause repeated faults while clearing the remainder of	\n\
+;; the SIZE bytes at PAGE after the first fault.			\n\
+;; A caveat here is that we must not fall through from a failing page	\n\
+;; to a valid page.							\n\
+									\n\
+3:									\n\
+	movem  [$sp+],$r10						\n\
+	addq	44,$r12 ;; Get back count before faulting point.	\n\
+	subq	44,$r11 ;; Get back pointer to faulting movem-line.	\n\
+	jump	4b	;; Fall through, pretending the fault didn't happen.\n\
+									\n\
+	.previous							\n\
+	.section __ex_table,\"a\"					\n\
+	.dword 1b,3b							\n\
 	.previous"
 
      /* Outputs */ : "=r" (dst), "=r" (src), "=r" (n), "=r" (retn)
@@ -425,64 +425,64 @@ __do_clear_user (void __user *pto, unsig
       If you want to check that the allocation was right; then
       check the equalities in the first comment.  It should say
       something like "r13=r13, r11=r11, r12=r12". */
-    __asm__ volatile ("
+    __asm__ volatile ("\n\
 	.ifnc %0%1%2,$r13$r12$r10					\n\
 	.err								\n\
 	.endif								\n\
-
-	;; Save the registers we'll clobber in the movem process
-	;; on the stack.  Don't mention them to gcc, it will only be
-	;; upset.
-	subq	11*4,$sp
-	movem	$r10,[$sp]
-
-	clear.d $r0
-	clear.d $r1
-	clear.d $r2
-	clear.d $r3
-	clear.d $r4
-	clear.d $r5
-	clear.d $r6
-	clear.d $r7
-	clear.d $r8
-	clear.d $r9
-	clear.d $r10
-	clear.d $r11
-
-	;; Now we've got this:
-	;; r13 - dst
-	;; r12 - n
-
-	;; Update n for the first loop
-	subq	12*4,$r12
-0:
-	subq   12*4,$r12
-	bge	0b
-	movem	$r11,[$r13+]
-1:
-	addq   12*4,$r12        ;; compensate for last loop underflowing n
-
-	;; Restore registers from stack
-	movem [$sp+],$r10
-2:
-	.section .fixup,\"ax\"
-3:
-	move.d [$sp],$r10
-	addq 12*4,$r10
-	move.d $r10,[$sp]
-	clear.d $r10
-	jump 0b
-
-4:
-	movem [$sp+],$r10
-	addq 12*4,$r10
-	addq 12*4,$r12
-	jump 2b
-
-	.previous
-	.section __ex_table,\"a\"
-	.dword 0b,3b
-	.dword 1b,4b
+									\n\
+	;; Save the registers we'll clobber in the movem process	\n\
+	;; on the stack.  Don't mention them to gcc, it will only be	\n\
+	;; upset.							\n\
+	subq	11*4,$sp						\n\
+	movem	$r10,[$sp]						\n\
+									\n\
+	clear.d $r0							\n\
+	clear.d $r1							\n\
+	clear.d $r2							\n\
+	clear.d $r3							\n\
+	clear.d $r4							\n\
+	clear.d $r5							\n\
+	clear.d $r6							\n\
+	clear.d $r7							\n\
+	clear.d $r8							\n\
+	clear.d $r9							\n\
+	clear.d $r10							\n\
+	clear.d $r11							\n\
+									\n\
+	;; Now we've got this:						\n\
+	;; r13 - dst							\n\
+	;; r12 - n							\n\
+									\n\
+	;; Update n for the first loop					\n\
+	subq	12*4,$r12						\n\
+0:									\n\
+	subq   12*4,$r12						\n\
+	bge	0b							\n\
+	movem	$r11,[$r13+]						\n\
+1:									\n\
+	addq   12*4,$r12        ;; compensate for last loop underflowing n\n\
+									\n\
+	;; Restore registers from stack					\n\
+	movem [$sp+],$r10						\n\
+2:									\n\
+	.section .fixup,\"ax\"						\n\
+3:									\n\
+	move.d [$sp],$r10						\n\
+	addq 12*4,$r10							\n\
+	move.d $r10,[$sp]						\n\
+	clear.d $r10							\n\
+	jump 0b								\n\
+									\n\
+4:									\n\
+	movem [$sp+],$r10						\n\
+	addq 12*4,$r10							\n\
+	addq 12*4,$r12							\n\
+	jump 2b								\n\
+									\n\
+	.previous							\n\
+	.section __ex_table,\"a\"					\n\
+	.dword 0b,3b							\n\
+	.dword 1b,4b							\n\
 	.previous"
 
      /* Outputs */ : "=r" (dst), "=r" (n), "=r" (retn)
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
