From: akpm@linux-foundation.org
Subject: - powerpc-fix-for-oprofile-callgraph-for-power-64-bit-user-apps.patch removed from -mm tree
Date: Mon, 09 Jun 2008 18:00:47 -0700
Message-ID: <200806100100.m5A10lug018174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761AbYFJBB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 21:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cel@us.ibm.com, carll@us.ibm.com, maynardj@us.ibm.com, michael@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     powerpc: fix for OProfile callgraph for Power 64 bit user apps
has been removed from the -mm tree.  Its filename was
     powerpc-fix-for-oprofile-callgraph-for-power-64-bit-user-apps.patch

This patch was dropped because it doesn't seem to be needed

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: fix for OProfile callgraph for Power 64 bit user apps
From: Carl Love <cel@us.ibm.com>

Fix the 64 bit user code backtrace which currently may hang the system.

Signed-off-by: Carl Love <carll@us.ibm.com>
Cc: Maynard Johnson <maynardj@us.ibm.com>

On Thu, 15 May 2008 10:20:44 +1000
Michael Ellerman <michael@ellerman.id.au> wrote:
>
> __copy_from_user_inatomic() accepts any value for n, it just has a
> special case for 1, 2, 4 and 8 - but it should still work for other
> values.
> 
> The old code copied 24 bytes from sp, and the new code copies 8 bytes
> from sp and 8 bytes from sp + 16 - so I don't see where the 48 bytes
> comes in to it?
> 
> \ufeffAlso the comment is a little hard to parse, I think you mean "Issue:
> the ..", but I read "Issue" as a verb in that sentence. And "Don't read
> more then" should be "than".

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

