From: akpm@linux-foundation.org
Subject: [merged]
 mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch removed
 from -mm tree
Date: Thu, 13 Jul 2017 13:43:06 -0700
Message-ID: <20170713204306.ahjdmRpv7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdGMUnH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.belits@cavium.com, chris@chris-wilson.co.uk, darrick.wong@oracle.com, david.daney@cavium.com, hannes@cmpxchg.org, hch@infradead.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.com, ralf@linux-mips.org, vbabka@suse.cz


The patch titled
     Subject: mm, migration: do not trigger OOM killer when migrating memory
has been removed from the -mm tree.  Its filename was
     mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, migration: do not trigger OOM killer when migrating memory

Page migration (for memory hotplug, soft_offline_page or mbind) needs to
allocate a new memory.  This can trigger an oom killer if the target
memory is depleated.  Although quite unlikely, still possible, especially
for the memory hotplug (offlining of memoery).  Up to now we didn't really
have reasonable means to back off.  __GFP_NORETRY can fail just too easily
and __GFP_THISNODE sticks to a single node and that is not suitable for
all callers.

But now that we have __GFP_RETRY_MAYFAIL we should use it.  It is
preferable to fail the migration than disrupt the system by killing some
processes.

Link: http://lkml.kernel.org/r/20170623085345.11304-7-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alex Belits <alex.belits@cavium.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 +-
 mm/mempolicy.c          |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/migrate.h~mm-migration-do-not-trigger-oom-killer-when-migrating-memory include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migration-do-not-trigger-oom-killer-when-migrating-memory
+++ a/include/linux/migrate.h
@@ -34,7 +34,7 @@ extern char *migrate_reason_names[MR_TYP
 static inline struct page *new_page_nodemask(struct page *page,
 				int preferred_nid, nodemask_t *nodemask)
 {
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
+	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
 
 	if (PageHuge(page))
 		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
diff -puN mm/mempolicy.c~mm-migration-do-not-trigger-oom-killer-when-migrating-memory mm/mempolicy.c
--- a/mm/mempolicy.c~mm-migration-do-not-trigger-oom-killer-when-migrating-memory
+++ a/mm/mempolicy.c
@@ -1078,7 +1078,8 @@ static struct page *new_page(struct page
 	/*
 	 * if !vma, alloc_page_vma() will use task or system default policy
 	 */
-	return alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+	return alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL,
+			vma, address);
 }
 #else
 
_

Patches currently in -mm which might be from mhocko@suse.com are


