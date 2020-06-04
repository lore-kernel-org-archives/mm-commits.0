From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-update-page-mem_cgroup-stability-rules.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:20:36 -0700
Message-ID: <20200604172036.IIklLKr5v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730014AbgFDRUi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: update page->mem_cgroup stability rules
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-update-page-mem_cgroup-stability-rules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: update page->mem_cgroup stability rules

The previous patches have simplified the access rules around
page->mem_cgroup somewhat:

1. We never change page->mem_cgroup while the page is isolated by
   somebody else.  This was by far the biggest exception to our rules and
   it didn't stop at lock_page() or lock_page_memcg().

2. We charge pages before they get put into page tables now, so the
   somewhat fishy rule about "can be in page table as long as it's still
   locked" is now gone and boiled down to having an exclusive reference to
   the page.

Document the new rules.  Any of the following will stabilize the
page->mem_cgroup association:

- the page lock
- LRU isolation
- lock_page_memcg()
- exclusive access to the page

Link: http://lkml.kernel.org/r/20200508183105.225460-20-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-update-page-mem_cgroup-stability-rules
+++ a/mm/memcontrol.c
@@ -1201,9 +1201,8 @@ int mem_cgroup_scan_tasks(struct mem_cgr
  * @page: the page
  * @pgdat: pgdat of the page
  *
- * This function is only safe when following the LRU page isolation
- * and putback protocol: the LRU lock must be held, and the page must
- * either be PageLRU() or the caller must have isolated/allocated it.
+ * This function relies on page->mem_cgroup being stable - see the
+ * access rules in commit_charge().
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
 {
@@ -2659,18 +2658,12 @@ static void commit_charge(struct page *p
 {
 	VM_BUG_ON_PAGE(page->mem_cgroup, page);
 	/*
-	 * Nobody should be changing or seriously looking at
-	 * page->mem_cgroup at this point:
+	 * Any of the following ensures page->mem_cgroup stability:
 	 *
-	 * - the page is uncharged
-	 *
-	 * - the page is off-LRU
-	 *
-	 * - an anonymous fault has exclusive page access, except for
-	 *   a locked page table
-	 *
-	 * - a page cache insertion, a swapin fault, or a migration
-	 *   have the page locked
+	 * - the page lock
+	 * - LRU isolation
+	 * - lock_page_memcg()
+	 * - exclusive reference
 	 */
 	page->mem_cgroup = memcg;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
