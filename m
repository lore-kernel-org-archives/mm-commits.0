Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9250C214813
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 19:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770923123; cv=none; b=FQI1VA8Igrd4aFbSWCa8nawMTLVyeIZz9IwEJz9CJQUX5yct6GEwFT2kqrVWRwBeyXApPUtvkLlForZsNqjY+Jk+DVPDmDgu9FftSCtL8Fr4cmYKI9jkRWZmT7l2KdlyJezxNpQ91WKJxCS6uPI/XnROYGCganjiQX2isUTm1P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770923123; c=relaxed/simple;
	bh=6LMDb5Xosa8bNc0AVIZnQb7gvD8YuKbg4WAJE+CoQPI=;
	h=Date:To:From:Subject:Message-Id; b=ae3YvB4YNT4bpOVnyiLe0FXB5Itrsd0jHGoYKyGYk7T+OllmNKquMAw8hHg7d/i9GJlhx+l3KfBorT4NFSddwzzLH8bMVtmwHuA+CDWaL7zZuqvrO+CdCZkOcmvTSQvgY+WZLfn9ybuV+tQmvh1TpckhJ0IFBcJKwZF7qLE02Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kpZRChcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kpZRChcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBA1C4CEF7;
	Thu, 12 Feb 2026 19:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770923123;
	bh=6LMDb5Xosa8bNc0AVIZnQb7gvD8YuKbg4WAJE+CoQPI=;
	h=Date:To:From:Subject:From;
	b=kpZRChcybAGz241+F+Prg4Tsk22GHrsYFABUnVS3ErThdn0XSpb2QgEuNrsHeiGtZ
	 5bqd67a7o3a4c3U+1YcoQEv4UtDkELB2nCDKHsRatEa01v7sECaihCH1qyGk+nUawg
	 GTcSHDVtmf0iVdgGz3ga5+167yUakMczErlcW/oY=
Date: Thu, 12 Feb 2026 11:05:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,thomas.hellstrom@linux.intel.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch added to mm-unstable branch
Message-Id: <20260212190523.1DBA1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()
Date: Wed, 11 Feb 2026 17:46:11 -0800

The softleaf_is_migration() check is unreachable as entries that are not
device_private are filtered out.  Similarly, the PTE-level equivalent in
migrate_vma_collect_pmd() skips migration entries.

This dead branch also contained a double spin_unlock(ptl) bug.

Link: https://lkml.kernel.org/r/20260212014611.416695-1-dave@stgolabs.net
Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
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
-			migration_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
-			return -EAGAIN;
-		}
-
 		if (softleaf_is_device_private_write(entry))
 			write = MIGRATE_PFN_WRITE;
 	} else {
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch

