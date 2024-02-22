Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6CD10A2D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560067; cv=none; b=p7gL1v3DNQl+5ZKmRB0/7XRtot1vq/Qqdpa22yePKyFqqNW2LrX95yYjgL/EDalhTXSfzhS796LKEji5cQ0zAQKQL3EMZ1YcXZfRyDkSRUmpsrQhzAvIX07Jxx1kJURQly7PIzkj5rl0FqRgv+Taqjn4tdrIMVCZmBUJAfKkF6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560067; c=relaxed/simple;
	bh=aK2mcPWWFvjDO10TSjD4gLBYW8WHwjPpEnIOIJOw+Qg=;
	h=Date:To:From:Subject:Message-Id; b=HeYcLT0HN0kMh2mBU8fGpqZCOpLj0wn0kH47iNkQKNj6CM3ySLqCSV38mctBv0RD6MSVDwOSCUbLiikXh4/F299WCop6kOSO/GGCdbB8lD0Fo9xivZ2TQB8ROhNKXb/RYyfPJQrruLLvWx36eLFfBgM4A8Qepby6lGaYyS71vBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MVEgBhPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MVEgBhPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494E1C43390;
	Thu, 22 Feb 2024 00:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560067;
	bh=aK2mcPWWFvjDO10TSjD4gLBYW8WHwjPpEnIOIJOw+Qg=;
	h=Date:To:From:Subject:From;
	b=MVEgBhPHjEFtZzIMMNE1euGFNhtfg32dVeoVC3me51RSZ9O1GeudnTl9fIrhpv2cm
	 sfilYjf0lp96yDbxyse1TDqJNE0jJUrPxPb0lSYttBxYXMNo/arOlLqcV+ri1WTKSj
	 P91Dxivd3TcoI5/MoQSopqZaKGMQ5vUeXDGmnS5E=
Date: Wed, 21 Feb 2024 16:01:06 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,haifeng.xu@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-disable-memcg_aware-when-cgroupmemory-is-set-to-nokmem.patch removed from -mm tree
Message-Id: <20240222000107.494E1C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: disable memcg_aware when cgroup.memory is set to "nokmem"
has been removed from the -mm tree.  Its filename was
     mm-list_lru-disable-memcg_aware-when-cgroupmemory-is-set-to-nokmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm: list_lru: disable memcg_aware when cgroup.memory is set to "nokmem"
Date: Thu, 28 Dec 2023 06:27:14 +0000

Actually, when using a boot time kernel option "cgroup.memory=nokmem", all
lru items are inserted to list_lru_node.  But for those users who invoke
list_lru_init_memcg() to initialize list_lru, list_lru_memcg_aware()
returns true.  And this brings unneeded operations related to memcg.

To make things more convenient, let's disable memcg_aware when
cgroup.memory is set to "nokmem".

Link: https://lkml.kernel.org/r/20231228062715.338672-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/list_lru.c~mm-list_lru-disable-memcg_aware-when-cgroupmemory-is-set-to-nokmem
+++ a/mm/list_lru.c
@@ -567,6 +567,9 @@ int __list_lru_init(struct list_lru *lru
 		lru->shrinker_id = shrinker->id;
 	else
 		lru->shrinker_id = -1;
+
+	if (mem_cgroup_kmem_disabled())
+		memcg_aware = false;
 #endif
 
 	lru->node = kcalloc(nr_node_ids, sizeof(*lru->node), GFP_KERNEL);
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are


