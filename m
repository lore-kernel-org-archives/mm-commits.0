From: akpm@linux-foundation.org
Subject: + fix-process-crash-caused-by-randomisation-and-64k-pages.patch added to -mm tree
Date: Fri, 16 Mar 2007 10:28:25 -0800
Message-ID: <200703161828.l2GISPRj018735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58285 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965826AbXCPS3H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 14:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, arjan@infradead.org, mingo@elte.hu


The patch titled
     fix process crash caused by randomisation and 64k pages
has been added to the -mm tree.  Its filename is
     fix-process-crash-caused-by-randomisation-and-64k-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix process crash caused by randomisation and 64k pages
From: James Bottomley <James.Bottomley@SteelEye.com>

This bug was seen on ppc64, but it could have occurred on any architecture
with a page size of 64k or above.  The problem is that
fs/binfmt_elf.c:randomize_stack_top() randomizes the stack to within 0x7ff
pages.  On 4k page machines, this is 8MB; on 64k page boxes, this is 128MB.
 The problem is that the new binary layout (selected in
arch_pick_mmap_layout) places the mapping segment 128MB or the stack rlimit
away from the top of the process memory, whichever is larger.  If you chose
an rlimit of less than 128MB (most defaults are in the 8Mb range) then you
can end up having your entire stack randomized away.

The fix is to make randomize_stack_top() only steal at most 8MB, which this
patch does.  However, I have to point out that even with this, your stack
rlimit might not be exactly what you get if it's > 128MB, because you're
still losing the random offset of up to 8MB.

The true fix should be to leave an explicit gap for the randomization plus
a buffer when determining mmap_base, but that would involve fixing all the
architectures.

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/binfmt_elf.c~fix-process-crash-caused-by-randomisation-and-64k-pages fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fix-process-crash-caused-by-randomisation-and-64k-pages
+++ a/fs/binfmt_elf.c
@@ -508,7 +508,7 @@ out:
 #define INTERPRETER_ELF 2
 
 #ifndef STACK_RND_MASK
-#define STACK_RND_MASK 0x7ff		/* with 4K pages 8MB of VA */
+#define STACK_RND_MASK 0x7ff0000	/* 8MB of VA */
 #endif
 
 static unsigned long randomize_stack_top(unsigned long stack_top)
@@ -516,14 +516,12 @@ static unsigned long randomize_stack_top
 	unsigned int random_variable = 0;
 
 	if ((current->flags & PF_RANDOMIZE) &&
-		!(current->personality & ADDR_NO_RANDOMIZE)) {
+		!(current->personality & ADDR_NO_RANDOMIZE))
 		random_variable = get_random_int() & STACK_RND_MASK;
-		random_variable <<= PAGE_SHIFT;
-	}
 #ifdef CONFIG_STACK_GROWSUP
-	return PAGE_ALIGN(stack_top) + random_variable;
+	return PAGE_ALIGN(stack_top + random_variable);
 #else
-	return PAGE_ALIGN(stack_top) - random_variable;
+	return PAGE_ALIGN(stack_top - random_variable);
 #endif
 }
 
_

Patches currently in -mm which might be from James.Bottomley@SteelEye.com are

fix-process-crash-caused-by-randomisation-and-64k-pages.patch
git-scsi-misc.patch
git-scsi-rc-fixes.patch
fix--confusion-in-fusion-driver.patch
introduce-config_has_dma.patch
