Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800C214A9B
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762906332; cv=none; b=Iagtbk/cCZIn6E2XToSsU5TN+ffDoFdASb08MAHf1d0KYjkBljPpu+U+W6ru3vDvQkyDYxKs5lQwhAR1t+7L7U71i7xn2WhjZyDBE2YXETvkSZ511m+y6AL6j8kLb066/lX1LFFoD/H4MD0MnzZ3nMh0cw9lurQME85uScynJtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762906332; c=relaxed/simple;
	bh=oklGl+Vj/NUwDMujOTbmILOK3dhaEG2RjUlycvw0VWI=;
	h=Date:To:From:Subject:Message-Id; b=sqBaQz0Rl8WsY87cD5+se9FwOZU25hgXhOLuxuXnUDlKcFGhrWk2CtvB6mXJEqMtEoglnZp/9YZyPUW88EG9NeGjkhfOKwj3mkwquMkSI7iouNq2oWgZjoU6yj1nFqrbFdx/kcPQh1wOdWMWVx42IpeZ02yaHq4xBORWJQi3bPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NtkmnQwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NtkmnQwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEECCC4CEFB;
	Wed, 12 Nov 2025 00:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762906332;
	bh=oklGl+Vj/NUwDMujOTbmILOK3dhaEG2RjUlycvw0VWI=;
	h=Date:To:From:Subject:From;
	b=NtkmnQwNMVQ6s4ZEQv6Wc480DyP+2gOIdd4R4Y9/OnMsBfLTUcvkDZBK8c0+eEejs
	 9dBAFjV7QfBOEM+R77B4B4n9Nigb93ufv4M4v+TU20wLoPrBV0xaKJPK+ttuS2XU7i
	 vsdjsyJs5KkzEnlp+RdZRBs9jpK+W9kuYkoW3JQE=
Date: Tue, 11 Nov 2025 16:12:11 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,mhocko@suse.com,kirill@shutemov.name,jackmanb@google.com,hannes@cmpxchg.org,clm@fb.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix.patch removed from -mm tree
Message-Id: <20251112001211.DEECCC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix.patch

This patch was dropped because it was folded into mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix
Date: Tue, 14 Oct 2025 12:28:22 -0700

checking for 0-ness is sufficient, per Vlastimil

Since to_free and pcp->count cannot become negative, make the checks into an
equality check instead.

Link: https://lkml.kernel.org/r/20251014192827.851389-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Chris Mason <clm@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix
+++ a/mm/page_alloc.c
@@ -2884,7 +2884,7 @@ static bool free_frozen_page_commit(stru
 		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
 		to_free -= to_free_batched;
 
-		if (to_free <= 0 || pcp->count <= 0)
+		if (to_free == 0 || pcp->count == 0)
 			break;
 
 		pcp_spin_unlock(pcp);
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch
mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch
mm-page_alloc-vmstat-simplify-refresh_cpu_vm_stats-change-detection.patch
mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch
mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch

