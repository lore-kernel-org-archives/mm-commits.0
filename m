From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-clean-up-some-minor-coding-style.patch removed from -mm tree
Date: Fri, 31 Jan 2020 15:19:04 -0800
Message-ID: <20200131231904.bb7VrQKAz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXTG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@linux.ibm.com, chris@chrisdown.name, hch@lst.de, jgg@mellanox.com, jglisse@redhat.com, jhubbard@nvidia.com, mhocko@kernel.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/migrate: clean up some minor coding style
has been removed from the -mm tree.  Its filename was
     mm-migrate-clean-up-some-minor-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: clean up some minor coding style

Fix some comment typos and coding style clean up in preparation for the
next patch.  No functional changes.

Link: http://lkml.kernel.org/r/20200107211208.24595-3-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

--- a/mm/migrate.c~mm-migrate-clean-up-some-minor-coding-style
+++ a/mm/migrate.c
@@ -986,7 +986,7 @@ static int move_to_new_page(struct page
 		}
 
 		/*
-		 * Anonymous and movable page->mapping will be cleard by
+		 * Anonymous and movable page->mapping will be cleared by
 		 * free_pages_prepare so don't reset it here for keeping
 		 * the type to work PageAnon, for example.
 		 */
@@ -1199,8 +1199,7 @@ out:
 		/*
 		 * A page that has been migrated has all references
 		 * removed and will be freed. A page that has not been
-		 * migrated will have kepts its references and be
-		 * restored.
+		 * migrated will have kept its references and be restored.
 		 */
 		list_del(&page->lru);
 
@@ -2779,27 +2778,18 @@ static void migrate_vma_insert_page(stru
 	if (pte_present(*ptep)) {
 		unsigned long pfn = pte_pfn(*ptep);
 
-		if (!is_zero_pfn(pfn)) {
-			pte_unmap_unlock(ptep, ptl);
-			mem_cgroup_cancel_charge(page, memcg, false);
-			goto abort;
-		}
+		if (!is_zero_pfn(pfn))
+			goto unlock_abort;
 		flush = true;
-	} else if (!pte_none(*ptep)) {
-		pte_unmap_unlock(ptep, ptl);
-		mem_cgroup_cancel_charge(page, memcg, false);
-		goto abort;
-	}
+	} else if (!pte_none(*ptep))
+		goto unlock_abort;
 
 	/*
-	 * Check for usefaultfd but do not deliver the fault. Instead,
+	 * Check for userfaultfd but do not deliver the fault. Instead,
 	 * just back off.
 	 */
-	if (userfaultfd_missing(vma)) {
-		pte_unmap_unlock(ptep, ptl);
-		mem_cgroup_cancel_charge(page, memcg, false);
-		goto abort;
-	}
+	if (userfaultfd_missing(vma))
+		goto unlock_abort;
 
 	inc_mm_counter(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, addr, false);
@@ -2823,6 +2813,9 @@ static void migrate_vma_insert_page(stru
 	*src = MIGRATE_PFN_MIGRATE;
 	return;
 
+unlock_abort:
+	pte_unmap_unlock(ptep, ptl);
+	mem_cgroup_cancel_charge(page, memcg, false);
 abort:
 	*src &= ~MIGRATE_PFN_MIGRATE;
 }
@@ -2855,9 +2848,8 @@ void migrate_vma_pages(struct migrate_vm
 		}
 
 		if (!page) {
-			if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE)) {
+			if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE))
 				continue;
-			}
 			if (!notified) {
 				notified = true;
 
_

Patches currently in -mm which might be from rcampbell@nvidia.com are
