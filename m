Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F2D390C94
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298434; cv=none; b=THvAyoLEQshU8Jl42sUh/UoHFPgFbvVuGzZw2l9ezO9GXa6dMixkHlhJWApKTEdSO7aClFzAPzFzPbvBrYqouX5Rb1eUFFAAf1I7Fag6+OAvMFqbzekrZfVqS6sp427WC8zPCkkJj0IbVsCwfMOkmmrp5MM+yd216JxvfM73xFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298434; c=relaxed/simple;
	bh=FYEnLB0sUS/hQRiAb2c9DEs2WBlWZ5zS1D+re16wscs=;
	h=Date:To:From:Subject:Message-Id; b=k6bdN3S5aCZbe9v43JiupnXN9z3URCmgFGOTai4MfJCy4zGps8M1lCHI67LLmTISXrsBtiDOJ1YQ6YKDcjBeCtZvkXSmQE9gN0tDRvWZX9TbU9LxIZO259CASan+lCTCO9WL8Vwg/wsFIEujRTNsVE9DNs7rMRT/Hq4Nyvi88ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UP0NRbEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UP0NRbEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C421F000E9;
	Wed, 29 Jul 2026 04:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298433;
	bh=aynPnZxu+VtUH/NE1UwsqHHUrR71T6NVa2XH4u0buvk=;
	h=Date:To:From:Subject;
	b=UP0NRbEGW2QZ9FuoRS6e/PFS7BV5UerS3DDmYG1jgi8iFFHK5Is5oBOCu53Fwy//o
	 X0qUXcP/mQoZ4kNOa6nMlNNyEfeTPxul2cd67aZVWYhnojpjOrlPrX1EELYC4aE7LV
	 kuii3icWKMBVvJOWwEdegF5WG+uin6xIr3PDKxfw=
Date: Tue, 28 Jul 2026 21:13:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,jic23@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-fix-stale-list-name-in-migrate_folios_move-comment.patch removed from -mm tree
Message-Id: <20260729041353.66C421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: fix stale list name in migrate_folios_move() comment
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-stale-list-name-in-migrate_folios_move-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/migrate: fix stale list name in migrate_folios_move() comment
Date: Wed, 1 Jul 2026 05:17:21 +0000

The return-value description in migrate_folios_move() still refers to
unmap_folios, but that list no longer exists.  Update this name to
src_folios.

Link: https://lore.kernel.org/20260701-migrate-cleanups-prep-v2-2-d9e8f17130b1@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-stale-list-name-in-migrate_folios_move-comment
+++ a/mm/migrate.c
@@ -1739,7 +1739,7 @@ static void migrate_folios_move(struct l
 		/*
 		 * The rules are:
 		 *	0: folio will be freed
-		 *	-EAGAIN: stay on the unmap_folios list
+		 *	-EAGAIN: stay on the src_folios list
 		 *	Other errno: put on ret_folios list
 		 */
 		switch (rc) {
_

Patches currently in -mm which might be from shivankg@amd.com are


