From: akpm@linux-foundation.org
Subject: + random-remove-some-prefetch-logic.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:33:23 -0800
Message-ID: <200801220933.m0M9X3uI014450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418AbYAVJdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:33:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, tytso@mit.edu


The patch titled
     random: remove some prefetch logic
has been added to the -mm tree.  Its filename is
     random-remove-some-prefetch-logic.patch

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
Subject: random: remove some prefetch logic
From: Matt Mackall <mpm@selenic.com>

The urandom output pool (ie the fast path) fits in one cacheline, so
this is pretty unnecessary. Further, the output path has already
fetched the entire pool to hash it before calling in here.

(This was the only user of prefetch_range in the kernel, and it passed
in words rather than bytes!)

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/char/random.c~random-remove-some-prefetch-logic drivers/char/random.c
--- a/drivers/char/random.c~random-remove-some-prefetch-logic
+++ a/drivers/char/random.c
@@ -457,7 +457,7 @@ static void __add_entropy_words(struct e
 	unsigned long i, add_ptr, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
-	__u32 w, next_w;
+	__u32 w;
 	unsigned long flags;
 
 	/* Taps are constant, so we can load them without holding r->lock.  */
@@ -466,17 +466,13 @@ static void __add_entropy_words(struct e
 	tap3 = r->poolinfo->tap3;
 	tap4 = r->poolinfo->tap4;
 	tap5 = r->poolinfo->tap5;
-	next_w = *in++;
 
 	spin_lock_irqsave(&r->lock, flags);
-	prefetch_range(r->pool, wordmask);
 	input_rotate = r->input_rotate;
 	add_ptr = r->add_ptr;
 
 	while (nwords--) {
-		w = rol32(next_w, input_rotate & 31);
-		if (nwords > 0)
-			next_w = *in++;
+		w = rol32(*in++, input_rotate & 31);
 		i = add_ptr = (add_ptr - 1) & wordmask;
 
 		/* XOR in the various taps */
_

Patches currently in -mm which might be from mpm@selenic.com are

git-x86.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-pid-pagemap-interface-fix.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
remove-unused-code-from-mm-tiny-shmemc.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
