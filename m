Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A313E866B
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777313502; cv=none; b=VnzuFPQRa1K/MgLg+BBw/7oj5+lG0NRJkji2zjrK/QNiEP1f0vGe9fBL7UttvmV6fQopSVYzDvoH5oAf/1iDNx5u15zyL12L8ZIeJG6QXw/kbb00KEcINMOWKMDrlvOYQJIXCY/HZt+BmSWXZ8klgUU5Tq3Xqy4ndX1UazXdJns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777313502; c=relaxed/simple;
	bh=J5tQ2G/TmQjZQrf0R8YUbv7pRgQDbw767Ww9+BS/aMs=;
	h=Date:To:From:Subject:Message-Id; b=RCI8i5A/Kh6tTR1XjmULND3RMUjPvymq3Kert1Eo8HSJFWM4z0yCEwDUAQrOuyQhqWiQLLKgC1j8dlr+B1ogpIh2udjMIKHB+DoPgcqEpoUMsifcJ3yuHBIxVkYT6DViPnYEvp2urQZxygGMN5FHzS6UQmzHcR3u9xlUVUHjfvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dJlbeR34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dJlbeR34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE08C19425;
	Mon, 27 Apr 2026 18:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777313502;
	bh=J5tQ2G/TmQjZQrf0R8YUbv7pRgQDbw767Ww9+BS/aMs=;
	h=Date:To:From:Subject:From;
	b=dJlbeR34iD5ol6mX3ODDqwZL4XxA67ZAz4GYIlUf4hqsCUc4Y4rYDulMOtcQAp06z
	 QknvWz6BURjUAtm7l2t1wq0IcKRsMCWfaWJfFykkZCnrjVfZhQQA9/S9a426KONgXc
	 hCReT0UXtAtjzND/OVnGogujG7ZKEIzwOaj4Ou8I=
Date: Mon, 27 Apr 2026 11:11:41 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-remove-sc-file_taken.patch removed from -mm tree
Message-Id: <20260427181142.0EE08C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: remove sc->file_taken
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-sc-file_taken.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/vmscan: remove sc->file_taken
Date: Fri, 24 Apr 2026 01:43:23 +0800

No one is using it now, just remove it.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-12-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-sc-file_taken
+++ a/mm/vmscan.c
@@ -173,7 +173,6 @@ struct scan_control {
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
-		unsigned int file_taken;
 		unsigned int taken;
 	} nr;
 
@@ -2040,8 +2039,6 @@ static unsigned long shrink_inactive_lis
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;
-	if (file)
-		sc->nr.file_taken += nr_taken;
 
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

