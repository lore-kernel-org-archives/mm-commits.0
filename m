Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961612BF01B
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750116638; cv=none; b=TRokhuoLS6D7uThtUVL4JEKXmRoDlRjeE9u6XatMRA7E150gPWxGW56H5RLlLembW6dnNKMRek42BswThZ5YjnmpueE3u6kQf6u/HbJF2u2rhXovgS+cAEmLmcFptQaU2NjKeW2J922+5QDLqpWYaR4llnEhdNggnQiNdqqHymk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750116638; c=relaxed/simple;
	bh=oWG4wta5fC7OMribGyCX1UQ1XYH8lJ8WmgPmr8l0t+E=;
	h=Date:To:From:Subject:Message-Id; b=gEfMgn99CwT5/tCnelRTFiuBuqn5y1EoH7zFC7GgGjjWckTms7OeilX7Fyms+r6LP7WY6qECQgsrkOzJHzgJKuIDKWTxPv8JwEqoGJuNbuJGnFQ0DEzEhkG0adUpSFsXKm0pvd1hvh9KBOSYGgMsgdDZ5N5DvU6Ky7yY7+ZiVVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nW0IT8wW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nW0IT8wW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C85C4CEEA;
	Mon, 16 Jun 2025 23:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750116638;
	bh=oWG4wta5fC7OMribGyCX1UQ1XYH8lJ8WmgPmr8l0t+E=;
	h=Date:To:From:Subject:From;
	b=nW0IT8wWl57kIgnN/Zn+hlwVGzb8xNIe66yjSjsqUEA32uBHAWo0wI/hid2sQZGZf
	 hlHgatvKCwWEEVOl8mzJq9kQBtjxXjoRzBpL4YvbKYHT5szhoVqTPO71z3A2GsN6+z
	 /3Dozw4ntDoNovzJzhHSV5m/3bykr8ug7rzW7+CM=
Date: Mon, 16 Jun 2025 16:30:37 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,joshua.hahnjy@gmail.com,honggyu.kim@sk.com,hannes@cmpxchg.org,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch added to mm-new branch
Message-Id: <20250616233038.01C85C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: use alloc_migartion_target() with no migration fallback nodemask
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch

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

mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch

