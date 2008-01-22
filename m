From: akpm@linux-foundation.org
Subject: + random-simplify-and-rename-credit_entropy_store.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:33:28 -0800
Message-ID: <200801220933.m0M9X8dD014462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38255 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756461AbYAVJdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:33:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, tytso@mit.edu


The patch titled
     random: simplify and rename credit_entropy_store
has been added to the -mm tree.  Its filename is
     random-simplify-and-rename-credit_entropy_store.patch

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
Subject: random: simplify and rename credit_entropy_store
From: Matt Mackall <mpm@selenic.com>

- emphasize bits in the name
- make zero bits lock-free
- simplify logic

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN drivers/char/random.c~random-simplify-and-rename-credit_entropy_store drivers/char/random.c
--- a/drivers/char/random.c~random-simplify-and-rename-credit_entropy_store
+++ a/drivers/char/random.c
@@ -441,7 +441,7 @@ static struct entropy_store nonblocking_
 /*
  * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
- * credit_entropy_store if this is appropriate.
+ * credit_entropy_bits if this is appropriate.
  *
  * The pool is stirred with a primitive polynomial of the appropriate
  * degree, and then twisted.  We twist by three bits at a time because
@@ -515,24 +515,22 @@ static void mix_pool_bytes(struct entrop
 /*
  * Credit (or debit) the entropy store with n bits of entropy
  */
-static void credit_entropy_store(struct entropy_store *r, int nbits)
+static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	unsigned long flags;
 
+	if (!nbits)
+		return;
+
 	spin_lock_irqsave(&r->lock, flags);
 
-	if (r->entropy_count + nbits < 0) {
-		DEBUG_ENT("negative entropy/overflow (%d+%d)\n",
-			  r->entropy_count, nbits);
+	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
+	r->entropy_count += nbits;
+	if (r->entropy_count < 0) {
+		DEBUG_ENT("negative entropy/overflow\n");
 		r->entropy_count = 0;
-	} else if (r->entropy_count + nbits > r->poolinfo->POOLBITS) {
+	} else if (r->entropy_count > r->poolinfo->POOLBITS)
 		r->entropy_count = r->poolinfo->POOLBITS;
-	} else {
-		r->entropy_count += nbits;
-		if (nbits)
-			DEBUG_ENT("added %d entropy credits to %s\n",
-				  nbits, r->name);
-	}
 
 	/* should we wake readers? */
 	if (r == &input_pool && r->entropy_count >= random_read_wakeup_thresh)
@@ -619,8 +617,8 @@ static void add_timer_randomness(struct 
 		 * Round down by 1 bit on general principles,
 		 * and limit entropy entimate to 12 bits.
 		 */
-		credit_entropy_store(&input_pool,
-				     min_t(int, fls(delta>>1), 11));
+		credit_entropy_bits(&input_pool,
+				    min_t(int, fls(delta>>1), 11));
 	}
 out:
 	preempt_enable();
@@ -703,7 +701,7 @@ static void xfer_secondary_pool(struct e
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
 		mix_pool_bytes(r, tmp, bytes);
-		credit_entropy_store(r, bytes*8);
+		credit_entropy_bits(r, bytes*8);
 	}
 }
 
@@ -1074,7 +1072,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (get_user(ent_count, p))
 			return -EFAULT;
-		credit_entropy_store(&input_pool, ent_count);
+		credit_entropy_bits(&input_pool, ent_count);
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1089,7 +1087,7 @@ static long random_ioctl(struct file *f,
 				    size);
 		if (retval < 0)
 			return retval;
-		credit_entropy_store(&input_pool, ent_count);
+		credit_entropy_bits(&input_pool, ent_count);
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
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
