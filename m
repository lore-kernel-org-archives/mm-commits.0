Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A1F3002C5
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763674170; cv=none; b=csYvZPPFoWHLLqN8bs90A5e6TU5NpQ3W2QOjq84cMHrc9fJkpjeB/pmV2Gw9/qKJRIEUg8MQGCsLvTWPHvW9vZkqe5+cHsG2bMnvO8640OzAZiZPuZtcJwMOERnW6wXrvFyFzKMNAAcWasHF9/0M6JB3QY5VvNjnoTXWsu/E470=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763674170; c=relaxed/simple;
	bh=nnfsx20G6kNPArs8oYPAFxyiXrAZn/aGmIq+lTxnnZc=;
	h=Date:To:From:Subject:Message-Id; b=oZbJT/KVfgkn9n4OFvKG+Km9BLC8JgfSUgIlirIlXOb2JTT1cmfi56obielEcXT7DFt4//8/pi2zukGJ1z0K1KbHB3wqExa0wwuYYwS4BBew3AXCq5s6o8QMDDN5hpiX/1tEqHI7Zz5FrBKMvOADfJ3dUMz/vtg4xyT1AcOvYVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nwm1ujDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nwm1ujDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE596C4CEF1;
	Thu, 20 Nov 2025 21:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763674170;
	bh=nnfsx20G6kNPArs8oYPAFxyiXrAZn/aGmIq+lTxnnZc=;
	h=Date:To:From:Subject:From;
	b=Nwm1ujDz5TBJArGD0o4TqKUGa41YtGTrLPZxS8bEvlulXu1BztxnpMZOYP2ojNLWT
	 cnkz+ATfraUnCYISjKTTNg1v6LNsBm/rSc75DyCQgSBclSB0rgWtZ2K+uYgquaJNiz
	 aEBEKyT4j64UuRRdEzHMUXcHBqhNn75GpzGcAcmM=
Date: Thu, 20 Nov 2025 13:29:29 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] migrate-optimise-alloc_migration_target-fix.patch removed from -mm tree
Message-Id: <20251120212929.DE596C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: fix zidx type
has been removed from the -mm tree.  Its filename was
     migrate-optimise-alloc_migration_target-fix.patch

This patch was dropped because it was folded into migrate-optimise-alloc_migration_target.patch

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
@@ -2165,7 +2165,7 @@ struct folio *alloc_migration_target(str
 	gfp_t gfp_mask;
 	unsigned int order = 0;
 	int nid;
-	int zidx;
+	enum zone_type zidx;
 
 	mtc = (struct migration_target_control *)private;
 	gfp_mask = mtc->gfp_mask;
_

Patches currently in -mm which might be from ziy@nvidia.com are

migrate-optimise-alloc_migration_target.patch
mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch

