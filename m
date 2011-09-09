From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch added to -mm tree
Date: Fri, 09 Sep 2011 14:36:09 -0700
Message-ID: <201109092136.p89La91q008231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933939Ab1IIVgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2011 17:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com


The patch titled
     arch/x86/kernel/e820.c: quiet sparse noise about plain integer as NULL pointer
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch

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
Subject: arch/x86/kernel/e820.c: quiet sparse noise about plain integer as NULL pointer
From: H Hartley Sweeten <hartleys@visionengravers.com>

The last parameter to sort() is a pointer to the function used to swap
items.  This parameter should be NULL, not 0, when not used.  This quiets
the following sparse warning:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/e820.c~arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer
+++ a/arch/x86/kernel/e820.c
@@ -296,7 +296,7 @@ int __init sanitize_e820_map(struct e820
 	chg_nr = chgidx;
 
 	/* sort change-point list by memory addresses (low -> high) */
-	sort(change_point, chg_nr, sizeof *change_point, cpcompare, 0);
+	sort(change_point, chg_nr, sizeof *change_point, cpcompare, NULL);
 
 	/* create a new bios memory map, removing overlaps */
 	overlap_entries = 0;	 /* number of entries in the overlap table */
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error.patch

