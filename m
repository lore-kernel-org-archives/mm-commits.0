Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C8426ED48
	for <mm-commits@vger.kernel.org>; Wed, 26 Nov 2025 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764180612; cv=none; b=q9gerZyMEPchJSiwNqD5EfXwMhCb0fop7XNB9hvPUt6XJG0kaVddgKeGE0ZtFfoKaUEn95hicm7JG/WxkHFnR7NfGohzdDf6DGdOm1T4zJcfcjcipKuup5fiN1bSIx5AW3muUd9Uu8UbstRrP4BGZ+dAYzMwm9GLPrBHPTjILiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764180612; c=relaxed/simple;
	bh=X6ipl/YpZgTn1HQmN5vCe+RPAG0ZRmJOR8caOe9TAnM=;
	h=Date:To:From:Subject:Message-Id; b=Qk7a3fbwMVwpRsC4of7yzHvbFDh01L9MeG0Tv2eYsYVm/IDwExqkhY0RO36sBM8CdgMKnAGmw4zsihUAOroNIttET72oMV/0sMfZtRff5CJinTPK2w8X02YzEaL0oAH4IMaVJ1IpuYmb+1hvtr1U3QJw6VdY+J4FUswKu93hR1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PRkAEeJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PRkAEeJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586A9C4CEF7;
	Wed, 26 Nov 2025 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764180611;
	bh=X6ipl/YpZgTn1HQmN5vCe+RPAG0ZRmJOR8caOe9TAnM=;
	h=Date:To:From:Subject:From;
	b=PRkAEeJZImexDJzYwtJw6pNX9al2/luMYP4HNlXw78Wl+NsVklXPokfTFdFvJrZyD
	 zJlcepqpgl4n5S66a8mSw33S47iPcmp/639KNrqv/zW6sbMlwky+AfUiHRZB6k2NyZ
	 zqywyYRWDcXeeFWBhc5bMcvfUTyRyW7IhBV/OdnY=
Date: Wed, 26 Nov 2025 10:10:10 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,lujialin4@huawei.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,axelrasmussen@google.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-inc-dec_lruvec_kmem_state-helpers.patch added to mm-unstable branch
Message-Id: <20251126181011.586A9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove inc/dec_lruvec_kmem_state helpers
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-remove-inc-dec_lruvec_kmem_state-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-inc-dec_lruvec_kmem_state-helpers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

memcg-remove-inc-dec_lruvec_kmem_state-helpers.patch

