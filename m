From: akpm@linux-foundation.org
Subject: + mm-vmscan-delete-unused-pgdat_reclaimable_pages.patch added to
 -mm tree
Date: Tue, 30 May 2017 13:53:42 -0700
Message-ID: <592ddbd6.TivlUsjGIJduoGSf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57120 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdE3Uxn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 16:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: delete unused pgdat_reclaimable_pages()
has been added to the -mm tree.  Its filename is
     mm-vmscan-delete-unused-pgdat_reclaimable_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-delete-unused-pgdat_reclaimable_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-delete-unused-pgdat_reclaimable_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: delete unused pgdat_reclaimable_pages()

Patch series "mm: per-lruvec slab stats"

Josef is working on a new approach to balancing slab caches and the page
cache.  For this to work, he needs slab cache statistics on the lruvec
level.  These patches implement that by adding infrastructure that allows
updating and reading generic VM stat items per lruvec, then switches some
existing VM accounting sites, including the slab accounting ones, to this
new cgroup-aware API.

I'll follow up with more patches on this, because there is actually
substantial simplification that can be done to the memory controller when
we replace private memcg accounting with making the existing VM accounting
sites cgroup-aware.  But this is enough for Josef to base his slab reclaim
work on, so here goes.


This patch (of 6): delete unused pgdat_reclaimable_pages().

Link: http://lkml.kernel.org/r/20170530181724.27197-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/vmscan.c          |   16 ----------------
 2 files changed, 17 deletions(-)

diff -puN include/linux/swap.h~mm-vmscan-delete-unused-pgdat_reclaimable_pages include/linux/swap.h
--- a/include/linux/swap.h~mm-vmscan-delete-unused-pgdat_reclaimable_pages
+++ a/include/linux/swap.h
@@ -289,7 +289,6 @@ extern void lru_cache_add_active_or_unev
 
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
-extern unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
 extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
diff -puN mm/vmscan.c~mm-vmscan-delete-unused-pgdat_reclaimable_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-delete-unused-pgdat_reclaimable_pages
+++ a/mm/vmscan.c
@@ -228,22 +228,6 @@ unsigned long zone_reclaimable_pages(str
 	return nr;
 }
 
-unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat)
-{
-	unsigned long nr;
-
-	nr = node_page_state_snapshot(pgdat, NR_ACTIVE_FILE) +
-	     node_page_state_snapshot(pgdat, NR_INACTIVE_FILE) +
-	     node_page_state_snapshot(pgdat, NR_ISOLATED_FILE);
-
-	if (get_nr_swap_pages() > 0)
-		nr += node_page_state_snapshot(pgdat, NR_ACTIVE_ANON) +
-		      node_page_state_snapshot(pgdat, NR_INACTIVE_ANON) +
-		      node_page_state_snapshot(pgdat, NR_ISOLATED_ANON);
-
-	return nr;
-}
