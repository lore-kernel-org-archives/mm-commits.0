Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8016F2EA156
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762476658; cv=none; b=paP6HzE/NKMWzuMyupkqlzFIRLpfrp05yONTFpLqb17KQVUgpOlxeqDz7J58mNjlGjM9eWpbE1mTP6fotiiIgQ19Xff/V7/A2vU6WuF8cu6wUg7MAZ1mLd1c7f1bCpoSvQn85aAXG74H0u0gjNqR56M3BoZWWlFqxd3P/ZfhJug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762476658; c=relaxed/simple;
	bh=gM3ysOoOXk4M86ruglqo+8KUpDwexcFUMylbp8rmNjo=;
	h=Date:To:From:Subject:Message-Id; b=o7mKwpxPZkU3tFp4Shqh8Gsb6d5u+qqFoA0JbiSbISxD/SVvGjNyWYwlcVSQXbCPQioxKsE323RN6RCc7PSFwT+qc8ryNbIrvNX1f5fb9ObupU5RWllEh/bzzJ6NqDfG5Ya+2NGsLCJoc2aYNetwAAdDKnDabQ/v8PY/CaZk7YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l1quieEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l1quieEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410EAC4CEFB;
	Fri,  7 Nov 2025 00:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762476658;
	bh=gM3ysOoOXk4M86ruglqo+8KUpDwexcFUMylbp8rmNjo=;
	h=Date:To:From:Subject:From;
	b=l1quieEdM+dNYKDDlqICkCgOxRihfxaWMazGGxQpAfpLREHzo6tDAAesFakPE0DI2
	 t+9qBNcNax6bqmCjiSqsExbYji6zxDi4/tLv5gQ8kCoCinJl033eV4I0vaFjb3zh1X
	 jaIu4K7LvjnWtTtzCLYv5ry8Bm0ofqj8Vldf4zLw=
Date: Thu, 06 Nov 2025 16:50:56 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-optimise-alloc_migration_target-fix.patch added to mm-new branch
Message-Id: <20251107005058.410EAC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: fix zidx type
has been added to the -mm mm-new branch.  Its filename is
     migrate-optimise-alloc_migration_target-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-optimise-alloc_migration_target-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: fix zidx type
Date: Thu, 6 Nov 2025 19:41:13 -0500

folio_zonenum() returns enum zone_type. It would be better to also
fix zidx's type.

Link: https://lkml.kernel.org/r/26E8FF35-503E-4F14-98F7-7B4FA25FBD37@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~migrate-optimise-alloc_migration_target-fix
+++ a/mm/migrate.c
@@ -2172,7 +2172,7 @@ struct folio *alloc_migration_target(str
 	gfp_t gfp_mask;
 	unsigned int order = 0;
 	int nid;
-	int zidx;
+	enum zone_type zidx;
 
 	mtc = (struct migration_target_control *)private;
 	gfp_mask = mtc->gfp_mask;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch
mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache.patch
mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch
migrate-optimise-alloc_migration_target-fix.patch

