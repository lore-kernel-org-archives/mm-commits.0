From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-fix-documentation-for-compound-parameter.patch removed from
 -mm tree
Date: Wed, 27 Jul 2016 12:03:26 -0700
Message-ID: <5799057e.eeoX027UVKL/ZlAy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:03:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roy.qing.li@gmail.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix documentation for compound parameter
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-documentation-for-compound-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li RongQing <roy.qing.li@gmail.com>
Subject: mm: memcontrol: fix documentation for compound parameter

commit f627c2f53786 ("memcg: adjust to support new THP refcounting")
adds a compound parameter for several functions, and change one as
compound for mem_cgroup_move_account but it does not change the
comments.

Link: http://lkml.kernel.org/r/1465368216-9393-1-git-send-email-roy.qing.li@gmail.com
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-documentation-for-compound-parameter mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-documentation-for-compound-parameter
+++ a/mm/memcontrol.c
@@ -4507,7 +4507,7 @@ static struct page *mc_handle_file_pte(s
 /**
  * mem_cgroup_move_account - move account of the page
  * @page: the page
- * @nr_pages: number of regular pages (>1 for huge pages)
+ * @compound: charge the page as compound or small page
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
  *
@@ -5369,6 +5369,7 @@ bool mem_cgroup_low(struct mem_cgroup *r
  * @mm: mm context of the victim
  * @gfp_mask: reclaim mode
  * @memcgp: charged memcg return
+ * @compound: charge the page as compound or small page
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
  * pages according to @gfp_mask if necessary.
@@ -5431,6 +5432,7 @@ out:
  * @page: page to charge
  * @memcg: memcg to charge the page to
  * @lrucare: page might be on LRU already
+ * @compound: charge the page as compound or small page
  *
  * Finalize a charge transaction started by mem_cgroup_try_charge(),
  * after page->mapping has been set up.  This must happen atomically
@@ -5482,6 +5484,7 @@ void mem_cgroup_commit_charge(struct pag
  * mem_cgroup_cancel_charge - cancel a page charge
  * @page: page to charge
  * @memcg: memcg to charge the page to
+ * @compound: charge the page as compound or small page
  *
  * Cancel a charge transaction started by mem_cgroup_try_charge().
  */
_

Patches currently in -mm which might be from roy.qing.li@gmail.com are


