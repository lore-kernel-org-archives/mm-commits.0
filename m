From: akpm@linux-foundation.org
Subject: + powerpc-fix-for-oprofile-callgraph-for-power-64-bit-user-apps.patch added to -mm tree
Date: Thu, 08 May 2008 12:53:18 -0700
Message-ID: <200805081953.m48JrIrC002751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbYEHUHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cel@us.ibm.com, carll@us.ibm.com, maynardj@us.ibm.com


The patch titled
     powerpc: fix for OProfile callgraph for Power 64 bit user apps
has been added to the -mm tree.  Its filename is
     powerpc-fix-for-oprofile-callgraph-for-power-64-bit-user-apps.patch

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
Subject: powerpc: fix for OProfile callgraph for Power 64 bit user apps
From: Carl Love <cel@us.ibm.com>

Fix the 64 bit user code backtrace which currently may hang the system.

Signed-off-by: Carl Love <carll@us.ibm.com>
Cc: Maynard Johnson <maynardj@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/oprofile/backtrace.c |   33 ++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/oprofile/backtrace.c~powerpc-fix-for-oprofile-callgraph-for-power-64-bit-user-apps arch/powerpc/oprofile/backtrace.c
--- a/arch/powerpc/oprofile/backtrace.c~powerpc-fix-for-oprofile-callgraph-for-power-64-bit-user-apps
+++ a/arch/powerpc/oprofile/backtrace.c
@@ -53,19 +53,40 @@ static unsigned int user_getsp32(unsigne
 #ifdef CONFIG_PPC64
 static unsigned long user_getsp64(unsigned long sp, int is_first)
 {
-	unsigned long stack_frame[3];
+	unsigned long stk_frm_lr;
+	unsigned long stk_frm_sp;
+	unsigned long size;
+
+	/* Issue the __copy_from_user_inatomic() third argument currently
+	 * only takes sizes 1, 2, 4 or 8 bytes.  Don't read more then the
+	 * first 48 bytes of the stack frame.  That is all that is
+	 * guaranteed to exist.  Reading more may cause the system to hang.
+	 *
+	 * 64 bit stack frame layout:
+	 * 0-7   bytes is the pointer to previous stack
+	 * 8-15  bytes condition register save area
+	 * 16-23 bytes link register save area
+	 */
+	size = sizeof(unsigned long);
+	if (!access_ok(VERIFY_READ, (void __user *)sp, size))
+		return 0;
 
-	if (!access_ok(VERIFY_READ, (void __user *)sp, sizeof(stack_frame)))
+	if (__copy_from_user_inatomic(&stk_frm_sp, (void __user *)sp,
+					size))
 		return 0;
 
-	if (__copy_from_user_inatomic(stack_frame, (void __user *)sp,
-					sizeof(stack_frame)))
+	/* get the LR from the user stack */
+	if (!access_ok(VERIFY_READ, (void __user *)(sp+16), size))
+		return 0;
+
+	if (__copy_from_user_inatomic(&stk_frm_lr, (void __user *)(sp+16),
+					size))
 		return 0;
 
 	if (!is_first)
-		oprofile_add_trace(STACK_LR64(stack_frame));
+		oprofile_add_trace(stk_frm_lr);
 
-	return STACK_SP(stack_frame);
+	return stk_frm_sp;
 }
 #endif
 
_

Patches currently in -mm which might be from cel@us.ibm.com are

powerpc-fix-for-oprofile-callgraph-for-power-64-bit-user-apps.patch

