Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D1E7FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441715; cv=none; b=M9uZTYcSomvdYeAbOKZKOmW97kRnaGnqCbUFIG/v6Ot5p6yixCCYiqU7FsMPG8U2YxqppbFfDP14lFPfmB2kq6sySIuHEgiq7ks7bkG4T896gE+w1pXACgiKEWeh5De0KDvoHW8OFHBZ4EkVvMzFxQ2gbZSku3H9VM+EI/pwb/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441715; c=relaxed/simple;
	bh=JKWJD1W59psKbm3mJB40vHHxeg1O456tXDaxTTJrQQM=;
	h=Date:To:From:Subject:Message-Id; b=W0KnveZ8HWuG30DMSpEhCoIUsJFnPDhd9V+qRDCEN8GkFzUy2AGTFnVIfWZSPCzqx1Nt7Qrrxe67egrWZqC2u7iCG+USF9zWJhH+1hx7K/j5EYYCHG1fvn36Se7g7RkSG1J5m8PyP/bj5RQbHsh4Ynv6zm1tx6S6Hr6HWGxax10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sCO11hFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sCO11hFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359A0C4CEF7;
	Sat, 29 Nov 2025 18:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441715;
	bh=JKWJD1W59psKbm3mJB40vHHxeg1O456tXDaxTTJrQQM=;
	h=Date:To:From:Subject:From;
	b=sCO11hFJ0Z3guQYNtb8232rl0OPa6BhrqgiTyCz8lERhbEb1A0N/8qlJPoen+4lPZ
	 jiW3JWOsl5yJ2phajw5AYrCSmXm9vN6qwY9wC2kh1Gb1NOLv76gTmHVeiJupS453qq
	 mwF9qYIeWD9V/Q5pDa/qAI6moEw113xkQBsiDFZY=
Date: Sat, 29 Nov 2025 10:41:54 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,lujialin4@huawei.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,axelrasmussen@google.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-inc-dec_lruvec_kmem_state-helpers.patch removed from -mm tree
Message-Id: <20251129184155.359A0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove inc/dec_lruvec_kmem_state helpers
has been removed from the -mm tree.  Its filename was
     memcg-remove-inc-dec_lruvec_kmem_state-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: remove inc/dec_lruvec_kmem_state helpers
Date: Wed, 26 Nov 2025 02:04:35 +0000

The dec_lruvec_kmem_state helper is unused by any caller and can be safely
removed.  Meanwhile, the inc_lruvec_kmem_state helper is only referenced
by shadow_lru_isolate, retaining these two helpers is unnecessary.  This
patch removes both helper functions to eliminate redundant code.

Link: https://lkml.kernel.org/r/20251126020435.1511637-1-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lu Jialin <lujialin4@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ----------
 mm/workingset.c            |    2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-inc-dec_lruvec_kmem_state-helpers
+++ a/include/linux/memcontrol.h
@@ -1452,16 +1452,6 @@ struct slabobj_ext {
 #endif
 } __aligned(8);
 
-static inline void inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
-{
-	mod_lruvec_kmem_state(p, idx, 1);
-}
-
-static inline void dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
-{
-	mod_lruvec_kmem_state(p, idx, -1);
-}
-
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
--- a/mm/workingset.c~memcg-remove-inc-dec_lruvec_kmem_state-helpers
+++ a/mm/workingset.c
@@ -749,7 +749,7 @@ static enum lru_status shadow_lru_isolat
 	if (WARN_ON_ONCE(node->count != node->nr_values))
 		goto out_invalid;
 	xa_delete_node(node, workingset_update_node);
-	inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
+	mod_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM, 1);
 
 out_invalid:
 	xa_unlock_irq(&mapping->i_pages);
_

Patches currently in -mm which might be from chenridong@huawei.com are


