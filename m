From: akpm@linux-foundation.org
Subject: + binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch added to -mm tree
Date: Mon, 11 Aug 2008 14:19:03 -0700
Message-ID: <200808112119.m7BLJ46M021963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758084AbYHKVTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 17:19:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, dhowells@redhat.com


The patch titled
     binfmt_elf_fdpic: convert initial stack alignment to arch_align_stack()
has been added to the -mm tree.  Its filename is
     binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch

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
Subject: binfmt_elf_fdpic: convert initial stack alignment to arch_align_stack()
From: Paul Mundt <lethal@linux-sh.org>

binfmt_elf_fdpic seems to have grabbed a hard-coded hack from an ancient
version of binfmt_elf in order to try and fix up initial stack alignment
on multi-threaded x86, which while in addition to being unused, was also
pushed down beyond the first set of operations on the stack pointer,
negating the entire purpose.

These days, we have an architecture independent arch_align_stack(), so we
switch to using that instead. Move the initial alignment up before the
initial stores while we're at it.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack
+++ a/fs/binfmt_elf_fdpic.c
@@ -466,7 +466,8 @@ error_kill:
 #endif
 
 /*
- * present useful information to the program
+ * present useful information to the program by shovelling it onto the new
+ * process's stack
  */
 static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 				   struct mm_struct *mm,
@@ -483,9 +484,13 @@ static int create_elf_fdpic_tables(struc
 	int loop;
 	int nr;	/* reset for each csp adjustment */
 
-	/* we're going to shovel a whole load of stuff onto the stack */
 #ifdef CONFIG_MMU
-	sp = bprm->p;
+	/* In some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
+	 * by the processes running on the same package. One thing we can do is
+	 * to shuffle the initial stack for them, so we give the architecture
+	 * an opportunity to do so here.
+	 */
+	sp = arch_align_stack(bprm->p);
 #else
 	sp = mm->start_stack;
 
@@ -528,20 +533,6 @@ static int create_elf_fdpic_tables(struc
 			return -EFAULT;
 	}
 
-#if defined(__i386__) && defined(CONFIG_SMP)
-	/* in some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
-	 * by the processes running on the same package. One thing we can do is
-	 * to shuffle the initial stack for them.
-	 *
-	 * the conditionals here are unneeded, but kept in to make the code
-	 * behaviour the same as pre change unless we have hyperthreaded
-	 * processors. This keeps Mr Marcelo Person happier but should be
-	 * removed for 2.5
-	 */
-	if (smp_num_siblings > 1)
-		sp = sp - ((current->pid % 64) << 7);
-#endif
