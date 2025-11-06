Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB0F2DC797
	for <mm-commits@vger.kernel.org>; Thu,  6 Nov 2025 23:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762472542; cv=none; b=opYh5ILwU4lLgn4kR9JFl206ADBpHLk3NB4Dhr0pJjZ1Nt9wTo4dWc4CS7H4xQPsBk8m/zDvO24+gQNze4iTzASmDHfMHqR3xXg6GqUsi1AlHBOx+DcUyd4kzUWK5OJiTkH2+jJv28PdxVpNp/ozAyvxU7YyDYOxwMTVlbjjl18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762472542; c=relaxed/simple;
	bh=8ZHz6ALlfoP3PR1Cw7jsbO5gKl1VHY0b4O3FcSv9mwo=;
	h=Date:To:From:Subject:Message-Id; b=nBAlP3+1lTVoiAVHMqhtqI0XLR6Uo4oKSKQ11Rbj/zJwbgWmEKNjF5jKJSQLoenbpymm7yeOrjZQn84UbSI0t7+6geZdje9o5mKn8mwO9R1gESnlFdfAaG68RA8GKP3jVM+TQ6YZTWRDqbco1jjvPZoXJMX3HVriIUyiyWC0TPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OfZozJx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OfZozJx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A93C19422;
	Thu,  6 Nov 2025 23:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762472541;
	bh=8ZHz6ALlfoP3PR1Cw7jsbO5gKl1VHY0b4O3FcSv9mwo=;
	h=Date:To:From:Subject:From;
	b=OfZozJx+lmCEwvX5yh9k+NvnubX0iVYeMNzwTnBZ34houZKFo4i1cwaCSLHx4HHvC
	 O6Q4SjT/2bBDaBOoB52mHa3lsruNGaDFpb9BU5A28XKLLT98YgJbuQkZK6ANURc9++
	 vMsR1cRz04n0RK+F79A6V2tUtOXsfsG5skmaNFLs=
Date: Thu, 06 Nov 2025 15:42:20 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-optimise-alloc_migration_target.patch added to mm-new branch
Message-Id: <20251106234221.71A93C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: migrate: optimise alloc_migration_target()
has been added to the -mm mm-new branch.  Its filename is
     migrate-optimise-alloc_migration_target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-optimise-alloc_migration_target.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: migrate: optimise alloc_migration_target()
Date: Thu, 6 Nov 2025 20:14:49 +0000

Extract the zone number directly from the folio instead of using the
folio's zone number to look up the zone and asking the zone what its
number is.

Link: https://lkml.kernel.org/r/20251106201452.2292631-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~migrate-optimise-alloc_migration_target
+++ a/mm/migrate.c
@@ -2198,7 +2198,7 @@ struct folio *alloc_migration_target(str
 		gfp_mask |= GFP_TRANSHUGE;
 		order = folio_order(src);
 	}
-	zidx = zone_idx(folio_zone(src));
+	zidx = folio_zonenum(src);
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
_

Patches currently in -mm which might be from willy@infradead.org are

hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch
migrate-optimise-alloc_migration_target.patch
memory_hotplug-optimise-try_offline_memory_block.patch

