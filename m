From: akpm@linux-foundation.org
Subject: + fix-compile-error-on-nommu-for-is_swap_pte.patch added to -mm tree
Date: Fri, 08 Feb 2008 14:06:32 -0800
Message-ID: <200802082206.m18M6WGt015826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbYBHWHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 17:07:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, vapier@gentoo.org


The patch titled
     Fix compile error on nommu for is_swap_pte
has been added to the -mm tree.  Its filename is
     fix-compile-error-on-nommu-for-is_swap_pte.patch

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
Subject: Fix compile error on nommu for is_swap_pte
From: Matt Mackall <mpm@selenic.com>

Does it ever make sense to ask "is this pte a swap entry?" on a machine
with no MMU?  Presumably this also means it has no ptes too, right?  In
which case, it's better to comment the whole function out.  Then when
someone tries to ask the above meaningless question, they get a compile
error rather than a meaningless answer.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Mike Frysinger <vapier@gentoo.org>
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

origin.patch
fix-compile-error-on-nommu-for-is_swap_pte.patch
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
