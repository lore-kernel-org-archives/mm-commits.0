From: akpm@linux-foundation.org
Subject: + random-eliminate-redundant-new_rotate-variable.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:33:22 -0800
Message-ID: <200801220933.m0M9X2Gm014447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754977AbYAVJdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:33:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, tytso@mit.edu


The patch titled
     random: eliminate redundant new_rotate variable
has been added to the -mm tree.  Its filename is
     random-eliminate-redundant-new_rotate-variable.patch

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
Subject: random: eliminate redundant new_rotate variable
From: Matt Mackall <mpm@selenic.com>

- eliminate new_rotate
- move input_rotate masking
- simplify input_rotate update
- move input_rotate update to end of inner loop for readability

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/char/random.c~random-eliminate-redundant-new_rotate-variable drivers/char/random.c
--- a/drivers/char/random.c~random-eliminate-redundant-new_rotate-variable
+++ a/drivers/char/random.c
@@ -455,7 +455,7 @@ static void __add_entropy_words(struct e
 		0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 		0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
 	unsigned long i, add_ptr, tap1, tap2, tap3, tap4, tap5;
-	int new_rotate, input_rotate;
+	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
 	__u32 w, next_w;
 	unsigned long flags;
@@ -474,20 +474,10 @@ static void __add_entropy_words(struct e
 	add_ptr = r->add_ptr;
 
 	while (nwords--) {
-		w = rol32(next_w, input_rotate);
+		w = rol32(next_w, input_rotate & 31);
 		if (nwords > 0)
 			next_w = *in++;
 		i = add_ptr = (add_ptr - 1) & wordmask;
-		/*
-		 * Normally, we add 7 bits of rotation to the pool.
-		 * At the beginning of the pool, add an extra 7 bits
-		 * rotation, so that successive passes spread the
-		 * input bits across the pool evenly.
-		 */
-		new_rotate = input_rotate + 14;
-		if (i)
-			new_rotate = input_rotate + 7;
-		input_rotate = new_rotate & 31;
 
 		/* XOR in the various taps */
 		w ^= r->pool[(i + tap1) & wordmask];
@@ -497,6 +487,14 @@ static void __add_entropy_words(struct e
 		w ^= r->pool[(i + tap5) & wordmask];
 		w ^= r->pool[i];
 		r->pool[i] = (w >> 3) ^ twist_table[w & 7];
+
+		/*
+		 * Normally, we add 7 bits of rotation to the pool.
+		 * At the beginning of the pool, add an extra 7 bits
+		 * rotation, so that successive passes spread the
+		 * input bits across the pool evenly.
+		 */
+		input_rotate += i ? 7 : 14;
 	}
 
 	r->input_rotate = input_rotate;
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
