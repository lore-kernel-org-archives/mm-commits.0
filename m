From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-swapfile-fix-and-annotate-various-data-races-v2.patch added to -mm tree
Date: Thu, 13 Feb 2020 19:26:05 -0800
Message-ID: <20200214032605.h1OXnLws8%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbgBND0G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 22:26:06 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swapfile-fix-and-annotate-various-data-races-v2
has been added to the -mm tree.  Its filename is
     mm-swapfile-fix-and-annotate-various-data-races-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-fix-and-annotate-various-data-races-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-fix-and-annotate-various-data-races-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm-swapfile-fix-and-annotate-various-data-races-v2

add a missing annotation for si->flags in memory.c

Link: http://lkml.kernel.org/r/1581612647-5958-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-swapfile-fix-and-annotate-various-data-races-v2
+++ a/mm/memory.c
@@ -2955,8 +2955,8 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (!page) {
 		struct swap_info_struct *si = swp_swap_info(entry);
 
-		if (si->flags & SWP_SYNCHRONOUS_IO &&
-				__swap_count(entry) == 1) {
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
+		    __swap_count(entry) == 1) {
 			/* skip swapcache */
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
 							vmf->address);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-kmemleak-annotate-various-data-races-obj-ptr.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch
