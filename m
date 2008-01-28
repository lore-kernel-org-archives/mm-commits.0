From: akpm@linux-foundation.org
Subject: + slob-fix-free-block-merging-at-head-of-subpage.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:22:10 -0800
Message-ID: <200801280523.m0S5N9oH013640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYA1FXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:23:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com


The patch titled
     slob: fix free block merging at head of subpage
has been added to the -mm tree.  Its filename is
     slob-fix-free-block-merging-at-head-of-subpage.patch

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
slob-fix-free-block-merging-at-head-of-subpage.patch
slob-reduce-external-fragmentation-by-using-three-free-lists.patch
slob-correct-kconfig-description.patch
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
random-add-async-notification-support-to-dev-random.patch
