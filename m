Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17163793D2
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 05:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784870882; cv=none; b=n69Qix4wF66H/AwTV+MkM3OoT31Q2lrkAJ2xr7VTozUrm8sqvEgweezaFhD5SaHcIYrcjdz/j7/lCIP/haB7NydUrbslo/gLxlU7lSFQlUuuVhQMCAYzPzCkoIZ3u+VkleTJQ222KIPgsTQM82jTQB6lg79LOAPktFmPDrOkjZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784870882; c=relaxed/simple;
	bh=/j8GJRHnyqms3MPXygR7ld+82JJ/jRRyIdqSloS/yLA=;
	h=Date:To:From:Subject:Message-Id; b=svyqBUCsz0kSFQLddfybTJ9i012FUi81ZafPBQaY0BlJ49IrmOnMudgJMDoCDklK5UD/0KgBZy3M1Sva6rHR63JXJ7XXKiRk5k+/GhY+3JlvBdMzs/rSTrpApfr5H0RWqeGGprvUqYt1yANFPzXbN8PcA8nFGaLsDZk0TWidZws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AYW8fpy2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AYW8fpy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6035B1F00A3D;
	Fri, 24 Jul 2026 05:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784870880;
	bh=yCrVF9xoK2XETR9rgf2xSj9mPqamRWHJcDZnmJObcyw=;
	h=Date:To:From:Subject;
	b=AYW8fpy2bSzKPmkzjBLQkx2gSMS/dA1ao413yyH2dvKl2rSFLJvTerepW7OHEL43l
	 T3uhYfFPEufZ/RPp4KK4L+t0/9slAV51yQu5s3ptmprMW6G/JEeXnQbZDTjcKRo1CM
	 tr7kCu7D+cG+UltdGW3h0gltQBm7SAm87C46jhEw=
Date: Thu, 23 Jul 2026 22:27:59 -0700
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch removed from -mm tree
Message-Id: <20260724052800.6035B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: propagate real error code from per-node proactive reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm: vmscan: propagate real error code from per-node proactive reclaim
Date: Fri, 17 Jul 2026 19:32:59 +0800

It has been observed that per-node proactive reclaim always returns
-EAGAIN when any error occurs.  As discussed in the mailing list [1], the
interface should distinguish between cases where no reclaimable memory is
left and where another entity is concurrently using the same interface. 
Propagate the real error code, consistent with how memcg proactive reclaim
handles errors.

Link: https://lore.kernel.org/20260717113300.214717-3-ridong.chen@linux.dev
Link: https://lore.kernel.org/all/20250717235604.2atyx2aobwowpge3@offworld/T/#m3514718be82a31b05726a49da9b61fbfc69a589e [1]
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim
+++ a/mm/vmscan.c
@@ -8018,7 +8018,7 @@ static ssize_t reclaim_store(struct devi
 	int ret, nid = dev->id;
 
 	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));
-	return ret ? -EAGAIN : count;
+	return ret ? ret : count;
 }
 
 static DEVICE_ATTR_WO(reclaim);
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch
memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

