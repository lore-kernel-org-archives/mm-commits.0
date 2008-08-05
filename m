From: akpm@linux-foundation.org
Subject: - binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch removed from -mm tree
Date: Mon, 04 Aug 2008 21:17:50 -0700
Message-ID: <200808050417.m754Ho4K016422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287AbYHEESn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 00:18:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, dhowells@redhat.com, dwmw2@infradead.org, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     binfmt_elf_fdpic: convert initial stack alignment to arch_align_stack()
has been removed from the -mm tree.  Its filename was
     binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch

This patch was dropped because an updated version will be merged

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
switch to using that instead.  Move the initial alignment up before the
initial stores while we're at it.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack
+++ a/fs/binfmt_elf_fdpic.c
@@ -482,11 +482,18 @@ static int create_elf_fdpic_tables(struc
 	int loop;
 	int nr;	/* reset for each csp adjustment */
 
-	/* we're going to shovel a whole load of stuff onto the stack */
+	/*
+	 * we're going to shovel a whole load of stuff onto the stack
+	 *
+	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
+	 * evictions by the processes running on the same package. One
+	 * thing we can do is to shuffle the initial stack for them, so
+	 * we give the architecture an opportunity to do so here.
+	 */
 #ifdef CONFIG_MMU
-	sp = bprm->p;
+	sp = arch_align_stack(bprm->p);
 #else
-	sp = mm->start_stack;
+	sp = arch_align_stack(mm->start_stack);
 
 	/* stack the program arguments and environment */
 	if (elf_fdpic_transfer_args_to_stack(bprm, &sp) < 0)
@@ -527,20 +534,6 @@ static int create_elf_fdpic_tables(struc
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
