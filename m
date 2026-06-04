Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CF5374726
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 19:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780602031; cv=none; b=jgC7jWs8Z2Qu4xBY2LjRfvrQBgZO8Um2qQsLFUGI2SYj+AnJpUg7NsROJMg01+WrrATTHSRyJoa3hY0xq+iWcyp7LPy2U49Vcq6xq8lQOniuPiKFVFG60TAJxDlfyCu9m28QJKmwK8nt7hbzNjpGD/RTUI+UhBxK6K00Q9WzCnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780602031; c=relaxed/simple;
	bh=i9NBEby7YsYhlAdWer84SHqciFztoYSNqv2SUErgLnE=;
	h=Date:To:From:Subject:Message-Id; b=QKhx8dt9A6DkmxJq5OTsiWkxYqCN2MgFQWbdcLOiHkprUk2maZwrrBgZSUUMvUU7FoOH6aAODtUB3EHF+XftW83KtLDwgQdFrCMzzbTHJ7qUDp9anFZgt31FKDGaq1oQfcTcD7efgN2rdI04XxlmSuGUTnGJ8heWhS9RHWm65kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GBQLnQKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GBQLnQKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCDE1F00893;
	Thu,  4 Jun 2026 19:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780602029;
	bh=pwOYbL9Ojq9x7dWRPQQc0WytokQI/ld/WzYWxqoA0MA=;
	h=Date:To:From:Subject;
	b=GBQLnQKvbQaxDPY5TYFRu9xYXMjRU7y2glO95h9+RigB3aSuhLKfUnuN+3d1aLaUb
	 7j5/83XXXgDnqzFP/Bo7ARF3hDOGr+1f66kugF23cz+np9BaBjUkgV1b4DH0UXavUe
	 7p6gSo3UC87mFIxyourGNDnTyzypkqfVFJtuBEtM=
Date: Thu, 04 Jun 2026 12:40:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,shijianlin11@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-only-update-numa-min-ratios-on-sysctl-write.patch added to mm-unstable branch
Message-Id: <20260604194029.BDCDE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: only update NUMA min ratios on sysctl write
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-only-update-numa-min-ratios-on-sysctl-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-only-update-numa-min-ratios-on-sysctl-write.patch

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
From: Jianlin Shi <shijianlin11@foxmail.com>
Subject: mm/page_alloc: only update NUMA min ratios on sysctl write
Date: Thu, 4 Jun 2026 12:01:38 +0800

The sysctl handlers for min_unmapped_ratio and min_slab_ratio invoke
setup_min_unmapped_ratio() and setup_min_slab_ratio() unconditionally
after proc_dointvec_minmax(), even for read operations.

These setup functions first zero all per-NUMA node thresholds
(min_unmapped_pages and min_slab_pages) before recalculating them. 
Reading /proc sysctl entries therefore temporarily resets node reclaim
thresholds to zero, which may disturb the behavior of __node_reclaim() and
node_reclaim() during the recomputation.

Fix this by only calling the setup functions when the sysctl is actually
written (write == 1), matching the behavior of existing sysctl handlers
like min_free_kbytes and watermark_scale_factor.

This only affects systems with CONFIG_NUMA.

Link: https://lore.kernel.org/tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-only-update-numa-min-ratios-on-sysctl-write
+++ a/mm/page_alloc.c
@@ -6653,7 +6653,8 @@ static int sysctl_min_unmapped_ratio_sys
 	if (rc)
 		return rc;
 
-	setup_min_unmapped_ratio();
+	if (write)
+		setup_min_unmapped_ratio();
 
 	return 0;
 }
@@ -6680,7 +6681,8 @@ static int sysctl_min_slab_ratio_sysctl_
 	if (rc)
 		return rc;
 
-	setup_min_slab_ratio();
+	if (write)
+		setup_min_slab_ratio();
 
 	return 0;
 }
_

Patches currently in -mm which might be from shijianlin11@foxmail.com are

mm-page_alloc-only-update-numa-min-ratios-on-sysctl-write.patch

