From: akpm@linux-foundation.org
Subject: + random-clean-up-checkpatch-complaints-fix.patch added to -mm tree
Date: Mon, 04 Feb 2008 18:57:20 -0800
Message-ID: <200802050257.m152v1sn031708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbYBEC5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com


The patch titled
     random: revert braindamage that snuck into checkpatch cleanup
has been added to the -mm tree.  Its filename is
     random-clean-up-checkpatch-complaints-fix.patch

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
Subject: random: revert braindamage that snuck into checkpatch cleanup
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/random.c~random-clean-up-checkpatch-complaints-fix drivers/char/random.c
--- a/drivers/char/random.c~random-clean-up-checkpatch-complaints-fix
+++ a/drivers/char/random.c
@@ -1328,7 +1328,7 @@ ctl_table random_table[] = {
  * Rotation is separate from addition to prevent recomputation
  */
 #define ROUND(f, a, b, c, d, x, s)	\
-	(a += f(b, c, d) + in[x], a = (a << s) | (a >> (32 - s)))
+	(a += f(b, c, d) + x, a = (a << s) | (a >> (32 - s)))
 #define K1 0
 #define K2 013240474631UL
 #define K3 015666365641UL
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
remove-unused-code-from-mm-tiny-shmemc.patch
slob-fix-free-block-merging-at-head-of-subpage.patch
slob-reduce-external-fragmentation-by-using-three-free-lists.patch
slob-correct-kconfig-description.patch
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
