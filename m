From: akpm@linux-foundation.org
Subject: + parisc-fix-compile-breakage-caused-by-inlining-maybe_mkwrite.patch added to -mm tree
Date: Sun, 16 Jan 2011 15:04:37 -0800
Message-ID: <201101162304.p0GN4bx1025120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab1APXFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Jan 2011 18:05:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, aarcange@redhat.com


The patch titled
     parisc: fix compile breakage caused by inlining maybe_mkwrite
has been added to the -mm tree.  Its filename is
     parisc-fix-compile-breakage-caused-by-inlining-maybe_mkwrite.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: fix compile breakage caused by inlining maybe_mkwrite
From: James Bottomley <James.Bottomley@HansenPartnership.com>

on Parisc, we have an include of linux/mm.h inside our asm/pgtable.h, so
14fd403f2 ("thp: export maybe_mkwrite") causes us an unsatisfiable use of
pte_mkwrite in linux/mm.h

The fix is obviously not to include linux/mm.h in our pgtable.h, which
unbreaks the build.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/pgtable.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/parisc/include/asm/pgtable.h~parisc-fix-compile-breakage-caused-by-inlining-maybe_mkwrite arch/parisc/include/asm/pgtable.h
--- a/arch/parisc/include/asm/pgtable.h~parisc-fix-compile-breakage-caused-by-inlining-maybe_mkwrite
+++ a/arch/parisc/include/asm/pgtable.h
@@ -10,11 +10,13 @@
  * we simulate an x86-style page table for the linux mm code
  */
 
-#include <linux/mm.h>		/* for vm_area_struct */
 #include <linux/bitops.h>
+#include <linux/spinlock.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
 
+struct vm_area_struct;
+
 /*
  * kern_addr_valid(ADDR) tests if ADDR is pointing to valid kernel
  * memory.  For the return value to be meaningful, ADDR must be >=
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are

origin.patch
mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n.patch
parisc-fix-compile-breakage-caused-by-inlining-maybe_mkwrite.patch
drivers-message-fusion-mptsasc-fix-warning.patch
scsi-fix-a-header-to-include-linux-typesh.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-fix.patch

