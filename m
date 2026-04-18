Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63505372EF0
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499169; cv=none; b=CVexQVbJOdcK+txPZH8CEm3/PzK6udHaKs4HZKZve36X8DfcrD9Hq+wGvcjbLDEFZRqblUH/xSXdwsnoz0awSPlQv8BmKSQMjWlmB1mQ/LWm872E3Qg2paQ1eZTNoTyjPxkG4AQ/yN6OIUUP+1CrcEglZQVxIQ6MqDpCUyRxtNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499169; c=relaxed/simple;
	bh=s+5nRHnWlTqwjsTFZ+/ameGMko/Kf5Hc24IElWcQQp0=;
	h=Date:To:From:Subject:Message-Id; b=GuTUVYPKc8bhJScTHo26c00dKfFH9J2LavlCx1+G5WIKR03BuKb74hnzg6W5kvXoQ2/o1s3TtiZEHXEpig+/tLejfrSipGMw6Gs+jf2UtDC+IxuVwcTp43tXQbwAUhqB5Us0lWByo62NlI3oqK6tnA7HfKKOZ1HAsNEzg0UN2v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=la1lU8yO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="la1lU8yO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BDDC19424;
	Sat, 18 Apr 2026 07:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499169;
	bh=s+5nRHnWlTqwjsTFZ+/ameGMko/Kf5Hc24IElWcQQp0=;
	h=Date:To:From:Subject:From;
	b=la1lU8yO8Z/II/xswt4qVZ5QcvRvXf5GwIG0+9u/MypeJQyEQkQ+uMsb2XJ4Bvjt8
	 YCcR8BUWxMx7wFX1jOz5gUkLGh7jEDnszXVEtU6ytSXdagV0fQOiK0V9KI+Dd0kYB4
	 mPAD21+olYxCa180Bj00bfqj2D1ZpED8j5RBTjQ4=
Date: Sat, 18 Apr 2026 00:59:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,thomas.hellstrom@linux.intel.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch removed from -mm tree
Message-Id: <20260418075928.98BDDC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()
Date: Wed, 11 Feb 2026 17:46:11 -0800

The softleaf_is_migration() check is unreachable as entries that are not
device_private are filtered out.  Similarly, the PTE-level equivalent in
migrate_vma_collect_pmd() skips migration entries.

This dead branch also contained a double spin_unlock(ptl) bug.

Link: https://lore.kernel.org/20260212014611.416695-1-dave@stgolabs.net
Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd
+++ a/mm/migrate_device.c
@@ -175,12 +175,6 @@ static int migrate_vma_collect_huge_pmd(
 			return migrate_vma_collect_skip(start, end, walk);
 		}
 
-		if (softleaf_is_migration(entry)) {
-			softleaf_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
-			return -EAGAIN;
-		}
-
 		if (softleaf_is_device_private_write(entry))
 			write = MIGRATE_PFN_WRITE;
 	} else {
_

Patches currently in -mm which might be from dave@stgolabs.net are


