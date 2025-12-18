Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BBCEEB3
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 23:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766098825; cv=none; b=ZGTWT72m5s/p1iMSb6sv3shYrK1Fnq0HKf/1VjTzGTVkEHnjE9koMMzd3/wOILfjtWZZAzKOmccvznOqvLOW+JDKILNSuuSuJtSo6aSJ9jbFFemFVWUk7zRPImfEkxJiV/4YX66qx0HWG4X4N/YrQYUnLitZivdZhuKcjje934g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766098825; c=relaxed/simple;
	bh=gUsSd7ESUOZsbiLA+We4ERkYHAb18QPRypZzJq8ulvk=;
	h=Date:To:From:Subject:Message-Id; b=bEQSjLSlHGR06wVDwLFeAKECm5A8JeHaMFQkmbmXzW01WBcJ83v6XTy0mD3KFHfmCe9caELH5gS5Pd5GE5f55lK9+kYK2stC13ETe8lWemL/zWFH+jH7q3k4cebHmMcOHWjGerJJYaF0FAp0d79nmTTSjjJYMrEaYMJdKFclu6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OO7+vRm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OO7+vRm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE34BC4CEFB;
	Thu, 18 Dec 2025 23:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766098824;
	bh=gUsSd7ESUOZsbiLA+We4ERkYHAb18QPRypZzJq8ulvk=;
	h=Date:To:From:Subject:From;
	b=OO7+vRm+AXoL470vZ+JM8cjTShjP6T4yJtWJfnG9e5rbykVF0zqBBkkx5AaoEksFr
	 z8pqjirIvgd0UUBBGptVzZzVvpa/CvMRuT7aFyQf/uS3uEukioNjSAE4Q2vbVXw5qU
	 f2r+ELhDiATKWw+rfuX5tt/tR3/mYHoBrR+e4aUU=
Date: Thu, 18 Dec 2025 15:00:24 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,linux@roeck-us.net,jackmanb@google.com,hannes@cmpxchg.org,daniel@thingy.jp,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-report-1-as-zone_batchsize-for-config_mmu.patch added to mm-hotfixes-unstable branch
Message-Id: <20251218230024.AE34BC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: report 1 as zone_batchsize for !CONFIG_MMU
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-report-1-as-zone_batchsize-for-config_mmu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-report-1-as-zone_batchsize-for-config_mmu.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/page_alloc: report 1 as zone_batchsize for !CONFIG_MMU
Date: Thu, 18 Dec 2025 00:31:59 -0800

Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
moved the error handling (0-handling) of zone_batchsize from its callers
to inside the function.  However, the commit left out the error handling
for the NOMMU case, leading to deadlocks on NOMMU systems.

For NOMMU systems, return 1 instead of 0 for zone_batchsize, which
restores the previous deadlock-free behavior.

There is no functional difference expected with this patch before commit
2783088ef24e, other than the pr_debug in zone_pcp_init now printing out 1
instead of 0 for zones in NOMMU systems.  Not only is this a pr_debug, the
difference is purely semantic anyways.

Link: https://lkml.kernel.org/r/20251218083200.2435789-1-joshua.hahnjy@gmail.com
Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reported-by: Daniel Palmer <daniel@thingy.jp>
Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-report-1-as-zone_batchsize-for-config_mmu
+++ a/mm/page_alloc.c
@@ -5924,7 +5924,7 @@ static int zone_batchsize(struct zone *z
 	 * recycled, this leads to the once large chunks of space being
 	 * fragmented and becoming unavailable for high-order allocations.
 	 */
-	return 0;
+	return 1;
 #endif
 }
 
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-page_alloc-report-1-as-zone_batchsize-for-config_mmu.patch

