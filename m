From: akpm@linux-foundation.org
Subject: + include-linux-gfph-convert-bug_on-into-vm_bug_on.patch added to -mm tree
Date: Mon, 18 Apr 2011 13:58:19 -0700
Message-ID: <201104182058.p3IKwJKK024450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833Ab1DRU66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 16:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, cl@linux.com


The patch titled
     include/linux/gfp.h: convert BUG_ON() into VM_BUG_ON()
has been added to the -mm tree.  Its filename is
     include-linux-gfph-convert-bug_on-into-vm_bug_on.patch

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
Subject: include/linux/gfp.h: convert BUG_ON() into VM_BUG_ON()
From: Dave Hansen <dave@linux.vnet.ibm.com>

VM_BUG_ON() if effectively a BUG_ON() undef #ifdef CONFIG_DEBUG_VM.  That
is exactly what we have here now, and two different folks have suggested
doing it this way.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/gfp.h~include-linux-gfph-convert-bug_on-into-vm_bug_on include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-gfph-convert-bug_on-into-vm_bug_on
+++ a/include/linux/gfp.h
@@ -249,9 +249,7 @@ static inline enum zone_type gfp_zone(gf
 
 	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
 					 ((1 << ZONES_SHIFT) - 1);
-#ifdef CONFIG_DEBUG_VM
-	BUG_ON((GFP_ZONE_BAD >> bit) & 1);
-#endif
+	VM_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	return z;
 }
 
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
include-linux-gfph-work-around-apparent-sparse-confusion.patch
include-linux-gfph-convert-bug_on-into-vm_bug_on.patch
mm-rename-alloc_pages_exact.patch
mm-make-new-alloc_pages_exact.patch
mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch

