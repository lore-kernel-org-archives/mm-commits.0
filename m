From: akpm@linux-foundation.org
Subject: + mm-page_isolation-fix-potential-warning-from-user.patch
 added to -mm tree
Date: Thu, 23 Jan 2020 17:56:40 -0800
Message-ID: <20200124015640.XeSZrsiqb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgAXB4l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jan 2020 20:56:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, david@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: fix potential warning from user
has been added to the -mm tree.  Its filename is
     mm-page_isolation-fix-potential-warning-from-user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-fix-potential-warning-from-user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-fix-potential-warning-from-user.patch

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
@@ -8231,7 +8231,7 @@ struct page *has_unmovable_pages(struct
 		if (is_migrate_cma(migratetype))
 			return NULL;
 
-		goto unmovable;
+		return page;
 	}
 
 	for (; iter < pageblock_nr_pages; iter++) {
@@ -8241,7 +8241,7 @@ struct page *has_unmovable_pages(struct
 		page = pfn_to_page(pfn + iter);
 
 		if (PageReserved(page))
-			goto unmovable;
+			return page;
 
 		/*
 		 * If the zone is movable and we have ruled out all reserved
@@ -8261,7 +8261,7 @@ struct page *has_unmovable_pages(struct
 			unsigned int skip_pages;
 
 			if (!hugepage_migration_supported(page_hstate(head)))
-				goto unmovable;
+				return page;
 
 			skip_pages = compound_nr(head) - (page - head);
 			iter += skip_pages - 1;
@@ -8303,12 +8303,9 @@ struct page *has_unmovable_pages(struct
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

mm-hotplug-silence-a-lockdep-splat-with-printk.patch
mm-page_isolation-fix-potential-warning-from-user.patch
