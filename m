Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0622BF01B
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750116640; cv=none; b=Ch+UnZtqtEaCZ1hgvqEatu4rCml9q9JrUuw7jZDrdxD6QYvAZnvAohMBIA0wiheZ5CpeHyt/E8+sSxvpHFBispEkBtJvmmG25A22Vj/39EcoQcqjNFtGh0QKI072W4++QSzrlC9Q0lgIdKnYkchuFuV2QEDSMRPHgXdvweqbe00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750116640; c=relaxed/simple;
	bh=MjHcsJYfkTdl9I4WM69pk9PseI9Xlzsvu59nhBuXlS4=;
	h=Date:To:From:Subject:Message-Id; b=XqlPCDb2PWbVlLTaMdWr6qXjW4EtMIovpz+cHgiVZYC5x4CkK+g16H9QICuAVXIG9xPm97p/lXLjxTXh7l4WV2kei7OClgAw0uCyZHMk7p8/fXd6RLZ9ffJAHwnaD+L95/JDn3YrVxHixBAQb0D1GNc7mztwreku5GvebPlMf8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=glBBPp3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="glBBPp3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18B5C4CEEA;
	Mon, 16 Jun 2025 23:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750116640;
	bh=MjHcsJYfkTdl9I4WM69pk9PseI9Xlzsvu59nhBuXlS4=;
	h=Date:To:From:Subject:From;
	b=glBBPp3tQpHVybA/uVTF2lLxIeZTPXNawq6rxljw0v4AmLHrDDRIK4LYILjpOF4zC
	 sShmM9mqwDUamnJUMPO6dSl4xDhuGH3TDBJlRmmNnf6KKmScZi6N13QlF8dqcNoKMV
	 imX2C+YLe9P1P5v36rMR8TvSWzlyour9/tu9nzCo=
Date: Mon, 16 Jun 2025 16:30:39 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,joshua.hahnjy@gmail.com,honggyu.kim@sk.com,hannes@cmpxchg.org,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch added to mm-new branch
Message-Id: <20250616233039.F18B5C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm: rename alloc_demote_folio to alloc_migrate_folio"
has been added to the -mm mm-new branch.  Its filename is
     revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Revert "mm: rename alloc_demote_folio to alloc_migrate_folio"
Date: Mon, 16 Jun 2025 10:23:45 -0700

This reverts commit 8f75267d22bdf8e3baf70f2fa7092d8c2f58da71.

Commit 8f75267d22bd ("mm: rename alloc_demote_folio to
alloc_migrate_folio") was to reflect the fact the function is called for
not only demotion, but also general migrations from
DAMOS_MIGRATE_{HOT,COLD}.  The previous commit made the DAMOS actions to
not use alloc_migrate_folio(), though.  So, demote_folio_list() is the
only caller of alloc_migrate_folio(), and the name could now be rather
confusing.  Revert the renaming commit.

Link: https://lkml.kernel.org/r/20250616172346.67659-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/vmscan.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/internal.h~revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio
+++ a/mm/internal.h
@@ -1227,7 +1227,7 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-struct folio *alloc_migrate_folio(struct folio *src, unsigned long private);
+struct folio *alloc_demote_folio(struct folio *src, unsigned long private);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
--- a/mm/vmscan.c~revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio
+++ a/mm/vmscan.c
@@ -1006,7 +1006,7 @@ static void folio_check_dirty_writeback(
 		mapping->a_ops->is_dirty_writeback(folio, dirty, writeback);
 }
 
-struct folio *alloc_migrate_folio(struct folio *src, unsigned long private)
+struct folio *alloc_demote_folio(struct folio *src, unsigned long private)
 {
 	struct folio *dst;
 	nodemask_t *allowed_mask;
@@ -1069,7 +1069,7 @@ static unsigned int demote_folio_list(st
 	node_get_allowed_targets(pgdat, &allowed_mask);
 
 	/* Demotion ignores all cpuset and mempolicy settings */
-	migrate_pages(demote_folios, alloc_migrate_folio, NULL,
+	migrate_pages(demote_folios, alloc_demote_folio, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch

