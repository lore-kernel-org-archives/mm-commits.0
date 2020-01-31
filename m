From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_isolation-fix-potential-warning-from-user.patch removed from -mm
 tree
Date: Fri, 31 Jan 2020 15:19:20 -0800
Message-ID: <20200131231920.IR206bJuM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgAaXTW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, david@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: fix potential warning from user
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-fix-potential-warning-from-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/page_isolation: fix potential warning from user

It makes sense to call the WARN_ON_ONCE(zone_idx(zone) == ZONE_MOVABLE)
from start_isolate_page_range(), but should avoid triggering it from
userspace, i.e, from is_mem_section_removable() because it could crash the
system by a non-root user if warn_on_panic is set.

While at it, simplify the code a bit by removing an unnecessary jump
label.

Link: http://lkml.kernel.org/r/20200120163915.1469-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |   11 ++++-------
 mm/page_isolation.c |   18 +++++++++++-------
 2 files changed, 15 insertions(+), 14 deletions(-)

--- a/mm/page_alloc.c~mm-page_isolation-fix-potential-warning-from-user
+++ a/mm/page_alloc.c
@@ -8214,7 +8214,7 @@ struct page *has_unmovable_pages(struct
 		if (is_migrate_cma(migratetype))
 			return NULL;
 
-		goto unmovable;
+		return page;
 	}
 
 	for (; iter < pageblock_nr_pages; iter++) {
@@ -8224,7 +8224,7 @@ struct page *has_unmovable_pages(struct
 		page = pfn_to_page(pfn + iter);
 
 		if (PageReserved(page))
-			goto unmovable;
+			return page;
 
 		/*
 		 * If the zone is movable and we have ruled out all reserved
@@ -8244,7 +8244,7 @@ struct page *has_unmovable_pages(struct
 			unsigned int skip_pages;
 
 			if (!hugepage_migration_supported(page_hstate(head)))
-				goto unmovable;
+				return page;
 
 			skip_pages = compound_nr(head) - (page - head);
 			iter += skip_pages - 1;
@@ -8286,12 +8286,9 @@ struct page *has_unmovable_pages(struct
 		 * is set to both of a memory hole page and a _used_ kernel
 		 * page at boot.
 		 */
-		goto unmovable;
+		return page;
 	}
 	return NULL;
-unmovable:
-	WARN_ON_ONCE(zone_idx(zone) == ZONE_MOVABLE);
-	return pfn_to_page(pfn + iter);
 }
 
 #ifdef CONFIG_CONTIG_ALLOC
--- a/mm/page_isolation.c~mm-page_isolation-fix-potential-warning-from-user
+++ a/mm/page_isolation.c
@@ -54,14 +54,18 @@ static int set_migratetype_isolate(struc
 
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
-	if (!ret)
+	if (!ret) {
 		drain_all_pages(zone);
-	else if ((isol_flags & REPORT_FAILURE) && unmovable)
-		/*
-		 * printk() with zone->lock held will guarantee to trigger a
-		 * lockdep splat, so defer it here.
-		 */
-		dump_page(unmovable, "unmovable page");
+	} else {
+		WARN_ON_ONCE(zone_idx(zone) == ZONE_MOVABLE);
+
+		if ((isol_flags & REPORT_FAILURE) && unmovable)
+			/*
+			 * printk() with zone->lock held will likely trigger a
+			 * lockdep splat, so defer it here.
+			 */
+			dump_page(unmovable, "unmovable page");
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from cai@lca.pw are
