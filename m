From: akpm@linux-foundation.org
Subject: + mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch added to -mm tree
Date: Wed, 22 Aug 2012 12:08:10 -0700
Message-ID: <20120822190811.76F9C5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:51550 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863Ab2HVTIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Aug 2012 15:08:14 -0400
Received: by wgbdt11 with SMTP id dt11so63583wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 12:08:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, cl@linux.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2
has been added to the -mm tree.  Its filename is
     mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2 mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2
+++ a/mm/mempolicy.c
@@ -1545,16 +1545,13 @@ struct mempolicy *get_vma_policy(struct 
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol = task->mempolicy;
-	int got_ref;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
 			struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
 									addr);
-			if (vpol) {
+			if (vpol)
 				pol = vpol;
-				got_ref = 1;
-			}
 		} else if (vma->vm_policy) {
 			pol = vma->vm_policy;
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag.patch
mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages-v2.patch
mm-compaction-abort-async-compaction-if-locks-are-contended-or-taking-too-long-v2.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch

