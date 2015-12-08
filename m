From: akpm@linux-foundation.org
Subject: +
 mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch
 added to -mm tree
Date: Tue, 08 Dec 2015 14:58:11 -0800
Message-ID: <56676083.fOT201dXX7wmlBYl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbLHW6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: ignore partial THP when moving task
has been added to the -mm tree.  Its filename is
     mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg: ignore partial THP when moving task

After "mm: rework mapcount accounting to enable 4k mapping of THPs" it is
possible to have a partial THP accessible via ptes.  Memcg task migration
code is not prepared for this situation and uncharges the tail page from
the original memcg while the original THP is still charged via the head
page which is not mapped to the moved task.  The page counter of the
origin memcg will underflow when the whole THP is uncharged later on and
lead to: WARNING: CPU: 0 PID: 1340 at mm/page_counter.c:26
page_counter_cancel+0x34/0x40() reported by Minchan Kim.

This patch prevents from the underflow by skipping any partial THP pages
in mem_cgroup_move_charge_pte_range.  PageTransCompound is checked when we
do pte walk.  This means that a process might leave a partial THP behind
in the original memcg if there is no other process mapping it via pmd but
this is considered acceptable because it shouldn't happen often and this
is not considered a memory leak because the original THP is still
accessible and reclaimable.  Moreover the task migration has always been
racy and never guaranteed to move all pages.

Reported-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5
+++ a/mm/memcontrol.c
@@ -4864,6 +4864,14 @@ retry:
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

mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress.patch
mm-get-rid-of-__alloc_pages_high_priority.patch
mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch
mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation.patch
mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch

