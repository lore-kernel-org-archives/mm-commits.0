From: akpm@linux-foundation.org
Subject: - fix-compile-error-on-nommu-for-is_swap_pte.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:00 -0800
Message-ID: <200802132015.m1DKF0ZR011263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756746AbYBMUPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, bunk@stusta.de, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Fix compile error on nommu for is_swap_pte
has been removed from the -mm tree.  Its filename was
     fix-compile-error-on-nommu-for-is_swap_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix compile error on nommu for is_swap_pte
From: Matt Mackall <mpm@selenic.com>

  CC      mm/vmscan.o
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/vmscan.c:44:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h: In function 'is_swap_pte':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_none'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_present'

Does it ever make sense to ask "is this pte a swap entry?" on a machine
with no MMU?  Presumably this also means it has no ptes too, right?  In
which case, it's better to comment the whole function out.  Then when
someone tries to ask the above meaningless question, they get a compile
error rather than a meaningless answer.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Reported-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/swapops.h~fix-compile-error-on-nommu-for-is_swap_pte include/linux/swapops.h
--- a/include/linux/swapops.h~fix-compile-error-on-nommu-for-is_swap_pte
+++ a/include/linux/swapops.h
@@ -42,11 +42,13 @@ static inline pgoff_t swp_offset(swp_ent
 	return entry.val & SWP_OFFSET_MASK(entry);
 }
 
+#ifdef CONFIG_MMU
 /* check whether a pte points to a swap entry */
 static inline int is_swap_pte(pte_t pte)
 {
 	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
 }
+#endif
 
 /*
  * Convert the arch-dependent pte representation of a swp_entry_t into an
_

Patches currently in -mm which might be from mpm@selenic.com are

x86-configurable-dmi-scanning-code.patch
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
