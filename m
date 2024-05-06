Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13AA38F94
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957151; cv=none; b=Al3s48Q30OXO988rIOjjFo9aFtLp2pc6IK3sisQaNoAau2XFSU/8TxboTo3Byt9HynzrNdkUArXuWT7rmYVnHp9YLA2DErdOoGG4VMqZj7UnBeQwnsujKgwGpWUG2Cr4qLfporfUbYCV2Kxm9jJFSgYWaVJAbzKauYr1xxFrWYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957151; c=relaxed/simple;
	bh=Dot+bNUUewWHCd6H4wh6vE5X4zMv9QLN1nu24yFmWHs=;
	h=Date:To:From:Subject:Message-Id; b=Bpuibp5f7ZHDAcWhYZE4JlYgdDU2KpcF0GIePxKI765LQ7WhMA7CKP1XF5M5E59JbXaIrvUjGmjd4JWKAx7YjxeedjyFDGZN6vKxyxG95a8xHYgFpGGfguoyQIX1spPjhDjbltfEK3yw4sCrtk+Wp89D/SYDs1WUuIWIuc0XcPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AMb40Q67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AMb40Q67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A9DC113CC;
	Mon,  6 May 2024 00:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957150;
	bh=Dot+bNUUewWHCd6H4wh6vE5X4zMv9QLN1nu24yFmWHs=;
	h=Date:To:From:Subject:From;
	b=AMb40Q672FsQ3I7GPVDiyoLWyAW3SiDLV4EVBf93WL/b8HbKdZLN3xfkmRK1BNluD
	 Q3FC1Fs4SM5Igpclpdb3C+20023qmAzLP6wNeEjp2Cda95dC8zQnsFaZWxXlzba5gw
	 P1LzqlZb/vzX15Ues5lVc4DODrO+9PKvPYCRKlNU=
Date: Sun, 05 May 2024 17:59:10 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-account-memory-used-for-memcg-vmstats-and-lruvec-stats.patch removed from -mm tree
Message-Id: <20240506005910.92A9DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: account memory used for memcg vmstats and lruvec stats
has been removed from the -mm tree.  Its filename was
     mm-memcg-account-memory-used-for-memcg-vmstats-and-lruvec-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: account memory used for memcg vmstats and lruvec stats
Date: Wed, 1 May 2024 10:26:12 -0700

The percpu memory used by memcg's memory statistics is already accounted. 
For consistency, let's enable accounting for vmstats and lruvec stats as
well.

Link: https://lkml.kernel.org/r/20240501172617.678560-4-shakeel.butt@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-account-memory-used-for-memcg-vmstats-and-lruvec-stats
+++ a/mm/memcontrol.c
@@ -5540,8 +5540,8 @@ static int alloc_mem_cgroup_per_node_inf
 	if (!pn)
 		return 1;
 
-	pn->lruvec_stats = kzalloc_node(sizeof(struct lruvec_stats), GFP_KERNEL,
-					node);
+	pn->lruvec_stats = kzalloc_node(sizeof(struct lruvec_stats),
+					GFP_KERNEL_ACCOUNT, node);
 	if (!pn->lruvec_stats)
 		goto fail;
 
@@ -5612,7 +5612,8 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 	}
 
-	memcg->vmstats = kzalloc(sizeof(struct memcg_vmstats), GFP_KERNEL);
+	memcg->vmstats = kzalloc(sizeof(struct memcg_vmstats),
+				 GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats)
 		goto fail;
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


