From: akpm@linux-foundation.org
Subject: + mm-reclaim-madv_free-pages-fix.patch added to -mm tree
Date: Fri, 03 Mar 2017 14:19:43 -0800
Message-ID: <58b9ebff.xLePBAPTy7nqAMLR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752161AbdCCWUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:20:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up lazyfree page handling
has been added to the -mm tree.  Its filename is
     mm-reclaim-madv_free-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-reclaim-madv_free-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-reclaim-madv_free-pages-fix.patch

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
Subject: mm: clean up lazyfree page handling

We can make it simple to understand without need to be aware of
clean-swapin page.
This patch just clean up lazyfree page handling in try_to_unmap_one.

Link: http://lkml.kernel.org/r/20170303025237.GB3503@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/rmap.c~mm-reclaim-madv_free-pages-fix mm/rmap.c
--- a/mm/rmap.c~mm-reclaim-madv_free-pages-fix
+++ a/mm/rmap.c
@@ -1415,17 +1415,17 @@ static int try_to_unmap_one(struct page
 			VM_BUG_ON_PAGE(!PageSwapCache(page) && PageSwapBacked(page),
 				page);
 
-			/*
-			 * swapin page could be clean, it has data stored in
-			 * swap. We can't silently discard it without setting
-			 * swap entry in the page table.
-			 */
-			if (!PageDirty(page) && !PageSwapCache(page)) {
-				/* It's a freeable page by MADV_FREE */
-				dec_mm_counter(mm, MM_ANONPAGES);
-				goto discard;
-			} else if (!PageSwapBacked(page)) {
-				/* dirty MADV_FREE page */
+			/* MADV_FREE page check */
+			if (!PageSwapBacked(page)) {
+				if (!PageDirty(page)) {
+					dec_mm_counter(mm, MM_ANONPAGES);
+					goto discard;
+				}
+
+				/*
+				 * If the page was redirtied, it cannot be
+				 * discarded. Remap the page to page table.
+				 */
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = SWAP_DIRTY;
 				page_vma_mapped_walk_done(&pvmw);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-reclaim-madv_free-pages-fix.patch

