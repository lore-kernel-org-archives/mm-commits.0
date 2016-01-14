From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:39:09 -0800
Message-ID: <5698238d.c4CvdLhbyDRC/vak%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbcANWjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:39:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: ignore partial THP when moving task
has been removed from the -mm tree.  Its filename was
     mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch

This patch was dropped because it was folded into mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg: ignore partial THP when moving task

After "mm: rework mapcount accounting to enable 4k mapping of THPs" it is
possible to have a partial THP accessible via ptes.  Memcg task migration
code is not prepared for this situation and uncharges the tail page from
the original memcg while the original THP is still charged via the head
page which is not mapped to the moved task.  The page counter of the
origin memcg will underflow when the whole THP is uncharged later on and
lead to:

WARNING: CPU: 0 PID: 1340 at mm/page_counter.c:26 page_counter_cancel+0x34/0x40()

as reported by Minchan Kim.

This patch prevents from the underflow by skipping any partial THP pages
in mem_cgroup_move_charge_pte_range.  PageTransCompound is checked when we
do pte walk.  This means that a process might leave a partial THP behind
in the original memcg if there is no other process mapping it via pmd but
this is considered acceptable because it shouldn't happen often and this
is not considered a memory leak because the original THP is still
accessible and reclaimable.  Moreover the task migration has always been
racy and never guaranteed to move all pages.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5
+++ a/mm/memcontrol.c
@@ -4899,6 +4899,14 @@ retry:
 		switch (get_mctgt_type(vma, addr, ptent, &target)) {
 		case MC_TARGET_PAGE:
 			page = target.page;
+			/*
+			 * We can have a part of the split pmd here. Moving it
+			 * can be done but it would be too convoluted so simply
+			 * ignore such a partial THP and keep it in original
+			 * memcg. There should be somebody mapping the head.
+			 */
+			if (PageCompound(page))
+				goto put;
 			if (isolate_lru_page(page))
 				goto put;
 			if (!mem_cgroup_move_account(page, false,
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-get-rid-of-__alloc_pages_high_priority.patch
mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch
mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation.patch
mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch

