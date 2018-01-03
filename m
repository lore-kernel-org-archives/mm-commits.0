From: akpm@linux-foundation.org
Subject: + mm-release-locked-page-in-do_swap_page.patch added to -mm tree
Date: Tue, 02 Jan 2018 16:06:59 -0800
Message-ID: <5a4c1ea3.uNYxkRNblLm56Uzt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeACAHA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 19:07:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, 1514407817.4169.4.camel@HansenPartnership.com, hughd@google.com, James.Bottomley@hansenpartnership.com, sergey.senozhatsky@gmail.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: release locked page in do_swap_page()
has been added to the -mm tree.  Its filename is
     mm-release-locked-page-in-do_swap_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-release-locked-page-in-do_swap_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-release-locked-page-in-do_swap_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/memory.c: release locked page in do_swap_page()

James reported a bug in swap paging-in from his testing.  It is that
do_swap_page doesn't release locked page so system hang-up happens due to
a deadlock on PG_locked.

It was introduced by 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of
synchronous device") because I missed swap cache hit places to update
swapcache variable to work well with other logics against swapcache in
do_swap_page.

This patch fixes it.

Debugged by James Bottomley.

Link: http://lkml.kernel.org/r/<1514407817.4169.4.camel@HansenPartnership.com>
Link: http://lkml.kernel.org/r/20180102235606.GA19438@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-release-locked-page-in-do_swap_page mm/memory.c
--- a/mm/memory.c~mm-release-locked-page-in-do_swap_page
+++ a/mm/memory.c
@@ -2857,8 +2857,11 @@ int do_swap_page(struct vm_fault *vmf)
 	int ret = 0;
 	bool vma_readahead = swap_use_vma_readahead();
 
-	if (vma_readahead)
+	if (vma_readahead) {
 		page = swap_readahead_detect(vmf, &swap_ra);
+		swapcache = page;
+	}
+
 	if (!pte_unmap_same(vma->vm_mm, vmf->pmd, vmf->pte, vmf->orig_pte)) {
 		if (page)
 			put_page(page);
@@ -2889,9 +2892,12 @@ int do_swap_page(struct vm_fault *vmf)
 
 
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
-	if (!page)
+	if (!page) {
 		page = lookup_swap_cache(entry, vma_readahead ? vma : NULL,
 					 vmf->address);
+		swapcache = page;
+	}
+
 	if (!page) {
 		struct swap_info_struct *si = swp_swap_info(entry);
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-release-locked-page-in-do_swap_page.patch
mm-swap-clean-up-swap-readahead.patch
mm-swap-unify-cluster-based-and-vma-based-swap-readahead.patch
mm-do-not-stall-register_shrinker.patch

