Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2BA26FDB3
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126317; cv=none; b=W3/vWPGLhIUUcpPg+M/NhWtsYCMJafpUjS5qnOqgd0RxmzsM5U3TcK71cgowa9yuAUbraDDtAI14DwxhRp2ap92Nzd+31TyQUkW91Ug+LeO7N6R2lscdj7LC/gjKszwBFVuj7I/Wc4xr2I8IC54YAKuFD7HthBXqIFDBqm6sKME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126317; c=relaxed/simple;
	bh=8iHkGKp4goSwmAxqA2NzRv0RGh8A92X+a8NizKNEZnA=;
	h=Date:To:From:Subject:Message-Id; b=IrwsDKmsmnBIw3gLbljrWXNZ6Z4UHXriPyIm9rdNJqZ5naEcnpn+/WHj9DbNBdFCSnicsCwiAdY7BjooJJl8s9pK1fnIRz/gDdozsLO7zHg1ae9OqR+w4P+ybm4Zrwrpnl9OE25wRSslu4OykCPurhhD1VWZIBhlyqewwGiQ8Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vdBvcaBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vdBvcaBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A07C4CEE3;
	Thu, 10 Jul 2025 05:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126314;
	bh=8iHkGKp4goSwmAxqA2NzRv0RGh8A92X+a8NizKNEZnA=;
	h=Date:To:From:Subject:From;
	b=vdBvcaBUhV4QO4I7lZmzNzRrCD7DOuIwn3gfQkG9b1pgPCYFriHcc0G3WXN4tZbsy
	 TN2Rzm1ro964JCbgGyPkdfdzG6KoVUiLOIgUUvxqJc9YwtlwFDkSdv/DP75WO43rb6
	 Hg5B+xxmIbnMSRwzKWpX/RrklH5nShCD+EghL3DU=
Date: Wed, 09 Jul 2025 22:45:14 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,joshua.hahnjy@gmail.com,honggyu.kim@sk.com,hannes@cmpxchg.org,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch removed from -mm tree
Message-Id: <20250710054514.B4A07C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: use alloc_migartion_target() with no migration fallback nodemask
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: use alloc_migartion_target() with no migration fallback nodemask
Date: Mon, 16 Jun 2025 10:23:44 -0700

Patch series "mm/damon: use alloc_migrate_target() for
DAMOS_MIGRATE_{HOT,COLD}".

DAMOS_MIGRATE_{HOT,COLD} implementation resembles that for demotion, and
hence the behavior is also similar to that.  But, since those are not only
for demotion but general migrations, it would be better to match with that
for move_pages() system call.  Make the implementation and the behavior
more similar to move_pages() by not setting migration fallback nodes, and
using alloc_migration_target() instead of alloc_migrate_folio().

alloc_migrate_folio() was renamed from alloc_demote_folio() and been
non-static function, to let DAMOS_MIGRATE_{HOT,COLD} call it.  As
alloc_migration_target() is called instead, the renaming and de-static
changes are no more required but could only make future code readers be
confused.  Revert the changes, too.


This patch (of 3):

DAMOS_MIGRATE_{HOT,COLD} implementation resembles that for
demote_folio_list().  Because those are not only for demotion but general
folio migrations, it makes more sense to behave similarly to move_pages()
system call.  Make the behavior more similar to move_pages(), by using
alloc_migration_target() instead of alloc_migrate_folio(), without
fallback nodemask.

Link: https://lkml.kernel.org/r/20250616172346.67659-2-sj@kernel.org
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

 mm/damon/paddr.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask
+++ a/mm/damon/paddr.c
@@ -386,7 +386,6 @@ static unsigned int __damon_pa_migrate_f
 		int target_nid)
 {
 	unsigned int nr_succeeded = 0;
-	nodemask_t allowed_mask = NODE_MASK_NONE;
 	struct migration_target_control mtc = {
 		/*
 		 * Allocate from 'node', or fail quickly and quietly.
@@ -396,7 +395,6 @@ static unsigned int __damon_pa_migrate_f
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOWARN | __GFP_NOMEMALLOC | GFP_NOWAIT,
 		.nid = target_nid,
-		.nmask = &allowed_mask
 	};
 
 	if (pgdat->node_id == target_nid || target_nid == NUMA_NO_NODE)
@@ -406,7 +404,7 @@ static unsigned int __damon_pa_migrate_f
 		return 0;
 
 	/* Migration ignores all cpuset and mempolicy settings */
-	migrate_pages(migrate_folios, alloc_migrate_folio, NULL,
+	migrate_pages(migrate_folios, alloc_migration_target, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DAMON,
 		      &nr_succeeded);
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch

