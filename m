From: akpm@linux-foundation.org
Subject: + slab-pass-correct-flags-to-kmem_getpages.patch added to -mm tree
Date: Tue, 04 Mar 2008 12:34:11 -0800
Message-ID: <200803042034.m24KYBJ5027844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756152AbYCDUfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:35:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, kamalesh@linux.vnet.ibm.com, mel@csn.ul.ie, penberg@cs.helsinki.fi, stable@kernel.org


The patch titled
     slab: pass correct flags to kmem_getpages()
has been added to the -mm tree.  Its filename is
     slab-pass-correct-flags-to-kmem_getpages.patch

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
Subject: slab: pass correct flags to kmem_getpages()
From: Christoph Lameter <clameter@sgi.com>

The NUMA fallback logic should be passing local_flags to kmem_get_pages() and
not simply the flags.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-pass-correct-flags-to-kmem_getpages mm/slab.c
--- a/mm/slab.c~slab-pass-correct-flags-to-kmem_getpages
+++ a/mm/slab.c
@@ -3280,7 +3280,7 @@ retry:
 		if (local_flags & __GFP_WAIT)
 			local_irq_enable();
 		kmem_flagcheck(cache, flags);
-		obj = kmem_getpages(cache, flags, -1);
+		obj = kmem_getpages(cache, local_flags, -1);
 		if (local_flags & __GFP_WAIT)
 			local_irq_disable();
 		if (obj) {
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-slub.patch
hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
slab-pass-correct-flags-to-kmem_getpages.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
ntfs-fix-nommu-build.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-move-cache_line_size-to-linux-cacheh.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

