From: akpm@linux-foundation.org
Subject: + random-consolidate-wakeup-logic.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:33:14 -0800
Message-ID: <200801220932.m0M9WsIx014417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079AbYAVJdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:33:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, tytso@mit.edu


The patch titled
     random: consolidate wakeup logic
has been added to the -mm tree.  Its filename is
     random-consolidate-wakeup-logic.patch

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
Subject: random: consolidate wakeup logic
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff -puN drivers/char/random.c~random-consolidate-wakeup-logic drivers/char/random.c
--- a/drivers/char/random.c~random-consolidate-wakeup-logic
+++ a/drivers/char/random.c
@@ -540,6 +540,10 @@ static void credit_entropy_store(struct 
 				  nbits, r->name);
 	}
 
+	/* should we wake readers? */
+	if (r == &input_pool && r->entropy_count >= random_read_wakeup_thresh)
+		wake_up_interruptible(&random_read_wait);
+
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
@@ -624,10 +628,6 @@ static void add_timer_randomness(struct 
 		credit_entropy_store(&input_pool,
 				     min_t(int, fls(delta>>1), 11));
 	}
-
-	if (input_pool.entropy_count >= random_read_wakeup_thresh)
-		wake_up_interruptible(&random_read_wait);
-
 out:
 	preempt_enable();
 }
@@ -1082,12 +1082,6 @@ static int random_ioctl(struct inode *in
 		if (get_user(ent_count, p))
 			return -EFAULT;
 		credit_entropy_store(&input_pool, ent_count);
-		/*
-		 * Wake up waiting processes if we have enough
-		 * entropy.
-		 */
-		if (input_pool.entropy_count >= random_read_wakeup_thresh)
-			wake_up_interruptible(&random_read_wait);
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1103,12 +1097,6 @@ static int random_ioctl(struct inode *in
 		if (retval < 0)
 			return retval;
 		credit_entropy_store(&input_pool, ent_count);
-		/*
-		 * Wake up waiting processes if we have enough
-		 * entropy.
-		 */
-		if (input_pool.entropy_count >= random_read_wakeup_thresh)
-			wake_up_interruptible(&random_read_wait);
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
