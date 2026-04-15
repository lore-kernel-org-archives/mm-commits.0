Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB77625;
	Wed, 15 Apr 2026 01:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776215850; cv=none; b=qOjsQo8VlHeDXBAM+mKXP7ezhgQmMul6xzKOxfz7bXyLFfLR/9LIzWEPRUC9DFsZCfen3sa9BcvfPZOjgFzoO+qaG/P7h0vVJcjr7Ic9OhIHg5TEL1qTUYjssSdmuNqpqJ2omLBJAsFopyXRY5OmkPbQwUbZDCys/q872kh+f6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776215850; c=relaxed/simple;
	bh=TQd7G15SrjbobkzvLyUfO3cmOh63ieOEZ2KwsuO5jmk=;
	h=Date:To:From:Subject:Message-Id; b=cEJ1mWtjZ4rvPl0dZZRqU0n4FRaO4YDSzkeReTqBcJ5tbx+xrVvNdmaKT1UPlh6FYdCYc4fcU1d5H5UueKtG/l66uv/b03aSFqr4flvjXu+H1w8LxA1PIpUMM69zV0HiRgYbm3+lvMDGEMOmZiu7Sfu7xvP2gHCJAdb2/9i7QW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eH1k7P0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eH1k7P0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7835C19425;
	Wed, 15 Apr 2026 01:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776215850;
	bh=TQd7G15SrjbobkzvLyUfO3cmOh63ieOEZ2KwsuO5jmk=;
	h=Date:To:From:Subject:From;
	b=eH1k7P0PigpuQdTuzArh5GkUkz7cDDw/BQIfH2G/4KKqaSSyhpFvEBb6yqrQBL4dM
	 1VCGQBkZ1YmZQYUxccskEJwv4wc1PGh7e5RAEvOjAuQS0ptBqHwjmB3/noLtgO7+SF
	 2SjKMWR5+Ibyb/rU3ykCmIMWkeFaK07d7jPllW+E=
Date: Tue, 14 Apr 2026 18:17:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,nueralspacetech@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-migrate_device-fix-double-unlock.patch removed from -mm tree
Message-Id: <20260415011729.D7835C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: fix double unlock
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-fix-double-unlock.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Sunny Patel <nueralspacetech@gmail.com>
Subject: mm/migrate_device: fix double unlock
Date: Tue, 14 Apr 2026 02:45:49 +0530

migrate_vma_collect_huge_pmd() calls spin_unlock(ptl) after
softleaf_entry_wait_on_locked(), which already releases the ptl.

Link: https://lkml.kernel.org/r/20260413211559.20969-1-nueralspacetech@gmail.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_device-fix-double-unlock
+++ a/mm/migrate_device.c
@@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(
 
 		if (softleaf_is_migration(entry)) {
 			softleaf_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
 			return -EAGAIN;
 		}
 
_

Patches currently in -mm which might be from nueralspacetech@gmail.com are


