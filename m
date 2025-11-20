Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCB03242C0
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675080; cv=none; b=boMw7KeBlnaFaA0diZH7D12DHvdSg9gq1NnM4jFkCywc+wMy9WX6wG8jA0w1WlldEr4Rbli7vdiSXZ1BGdWVq+55vOpaKBD4cwizB3qsQJcD2x9zlstJNaf59EHNEHgbjDwPH7iXcoVUzHoa5EqBRQJNqsGbcogXzLXwBeW1J+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675080; c=relaxed/simple;
	bh=JEpAHNFA3A3i6whPqJ14ZVXesZjLcy+NwD9/BoLDcQM=;
	h=Date:To:From:Subject:Message-Id; b=KIkPLsRgTlAPO5vAaUeSZ1rSki+P72eUDkWkmXoK9IIRmsNaK1TEARQaUEa9jK1D+tQvLLNg7xkiEWCwMaH1TtTopIh8l2kzwtqxkHf6skWB6vp4Wh4eosRl4hT0FBY2MdHmHKrSC/NloVrSqw+5CJlMir+CjG9whxZGlYVrT24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kjH0aE5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kjH0aE5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C630C4CEF1;
	Thu, 20 Nov 2025 21:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675079;
	bh=JEpAHNFA3A3i6whPqJ14ZVXesZjLcy+NwD9/BoLDcQM=;
	h=Date:To:From:Subject:From;
	b=kjH0aE5JfAKX1sDH4ae0p3ybOtj7cVcS0md7nZnIzMzbHmXImH00hF+KekRHr12XA
	 x81imTiwNGcMYO6RRAvp0yj76gAmyEFB9IRsxo4gSN8lzK07jFe+M1Lny54GdS9nyR
	 ni5QPKXJxlOtNB20q2hCeTUB6V5FaH4QxIZJPq0A=
Date: Thu, 20 Nov 2025 13:44:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate-optimise-alloc_migration_target.patch removed from -mm tree
Message-Id: <20251120214439.9C630C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: migrate: optimise alloc_migration_target()
has been removed from the -mm tree.  Its filename was
     migrate-optimise-alloc_migration_target.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: migrate: optimise alloc_migration_target()
Date: Thu, 6 Nov 2025 20:14:49 +0000

Extract the zone number directly from the folio instead of using the
folio's zone number to look up the zone and asking the zone what its
number is.

[ziy@nvidia.com: fix folio_zonenum() return type]
  Link: https://lkml.kernel.org/r/26E8FF35-503E-4F14-98F7-7B4FA25FBD37@nvidia.com
Link: https://lkml.kernel.org/r/20251106201452.2292631-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~migrate-optimise-alloc_migration_target
+++ a/mm/migrate.c
@@ -2164,7 +2164,7 @@ struct folio *alloc_migration_target(str
 	gfp_t gfp_mask;
 	unsigned int order = 0;
 	int nid;
-	int zidx;
+	enum zone_type zidx;
 
 	mtc = (struct migration_target_control *)private;
 	gfp_mask = mtc->gfp_mask;
@@ -2190,7 +2190,7 @@ struct folio *alloc_migration_target(str
 		gfp_mask |= GFP_TRANSHUGE;
 		order = folio_order(src);
 	}
-	zidx = zone_idx(folio_zone(src));
+	zidx = folio_zonenum(src);
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-tweak-__vma_enter_locked.patch

