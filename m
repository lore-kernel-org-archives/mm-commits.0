From: akpm@linux-foundation.org
Subject: + i386-make-the-32-bit-frame-pointer-backtracer-fall-back-to-traditional.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:20:42 -0800
Message-ID: <200801100620.m0A6KMPb008617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbYAJGU5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:20:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     i386: make the 32 bit Frame Pointer backtracer fall back to traditional
has been added to the -mm tree.  Its filename is
     i386-make-the-32-bit-frame-pointer-backtracer-fall-back-to-traditional.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i386: make the 32 bit Frame Pointer backtracer fall back to traditional
From: Arjan van de Ven <arjan@linux.intel.com>

The 32 bit Frame Pointer backtracer code checks if the EBP is valid to do a
backtrace; however currently on a failure it just gives up and prints
nothing.  That's not very nice; we can do better and still print a decent
backtrace.

This patch changes the backtracer to fall back to the non-framepointer
backtracer if the EBP value isn't within the expected range; so on weird
stack corruption cases we get at least something out...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/traps_32.c |   43 +++++++++++++++++------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff -puN arch/x86/kernel/traps_32.c~i386-make-the-32-bit-frame-pointer-backtracer-fall-back-to-traditional arch/x86/kernel/traps_32.c
--- a/arch/x86/kernel/traps_32.c~i386-make-the-32-bit-frame-pointer-backtracer-fall-back-to-traditional
+++ a/arch/x86/kernel/traps_32.c
@@ -120,26 +120,28 @@ static inline unsigned long print_contex
 {
 #ifdef	CONFIG_FRAME_POINTER
 	struct stack_frame *frame = (struct stack_frame *)bp;
-	while (valid_stack_ptr(tinfo, frame, sizeof(*frame))) {
-		struct stack_frame *next;
-		unsigned long addr;
-
-		addr = frame->return_address;
-		if (__kernel_text_address(addr))
-			ops->address(data, addr);
-		/*
-		 * break out of recursive entries (such as
-		 * end_of_stack_stop_unwind_function). Also,
-		 * we can never allow a frame pointer to
-		 * move downwards!
-		 */
-		next = frame->next_frame;
-		ebp = (unsigned long) next;
-		if (next <= frame)
-			break;
-		frame = next;
-	}
-#else
+	if (valid_stack_ptr(tinfo, frame, sizeof(*frame)))
+		while (valid_stack_ptr(tinfo, frame, sizeof(*frame))) {
+			struct stack_frame *next;
+			unsigned long addr;
+
+			addr = frame->return_address;
+			if (__kernel_text_address(addr))
+				ops->address(data, addr);
+			/*
+			 * break out of recursive entries (such as
+			 * end_of_stack_stop_unwind_function). Also,
+			 * we can never allow a frame pointer to
+			 * move downwards!
+			 */
+			next = frame->next_frame;
+			bp = (unsigned long)next;
+			if (next <= frame)
+				break;
+			frame = next;
+		}
+	else
+#endif
 	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
 		unsigned long addr;
 
@@ -147,7 +149,6 @@ static inline unsigned long print_contex
 		if (__kernel_text_address(addr))
 			ops->address(data, addr);
 	}
-#endif
 	return bp;
 }
 
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-input.patch
git-sched.patch
fix-x86-32-bit-frame_pointer-chasing-code.patch
i386-make-the-32-bit-frame-pointer-backtracer-fall-back-to-traditional.patch
drivers-edac-use-round_jiffies_relative.patch
