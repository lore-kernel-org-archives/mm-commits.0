From: akpm@linux-foundation.org
Subject: - slob-fix-free-block-merging-at-head-of-subpage.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:42 -0800
Message-ID: <200802052232.m15MWNnf012322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762286AbYBEWlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     slob: fix free block merging at head of subpage
has been removed from the -mm tree.  Its filename was
     slob-fix-free-block-merging-at-head-of-subpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slob: fix free block merging at head of subpage
From: Matt Mackall <mpm@selenic.com>

We weren't merging freed blocks at the beginning of the free list.  Fixing
this showed a 2.5% efficiency improvement in a userspace test harness.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/slob.c~slob-fix-free-block-merging-at-head-of-subpage mm/slob.c
--- a/mm/slob.c~slob-fix-free-block-merging-at-head-of-subpage
+++ a/mm/slob.c
@@ -398,6 +398,10 @@ static void slob_free(void *block, int s
 	sp->units += units;
 
 	if (b < sp->free) {
+		if (b + units == sp->free) {
+			units += slob_units(sp->free);
+			sp->free = slob_next(sp->free);
+		}
 		set_slob(b, units, sp->free);
 		sp->free = b;
 	} else {
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
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
random-add-async-notification-support-to-dev-random.patch
