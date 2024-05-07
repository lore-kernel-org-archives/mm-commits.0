Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6445D548F8
	for <mm-commits@vger.kernel.org>; Tue,  7 May 2024 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715100681; cv=none; b=nR7J9HzmfzNIdhlfAl0oDt7yR1nkcw2gwRHIDGA9tZnspi6Dt4va/dDUC/o5tKUPTWA9hMeKhAy488ip2J8NBJLzx5mc0t1g7yQam0gmvpw3rNTvFbVCiQD5Xl8I6/jvJRqXnz5Hsf5HlgeSyT1v8nDZJYSVKAWxWvUsKcogM/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715100681; c=relaxed/simple;
	bh=wYV29NVy3j4zsGeersL328SghzEREnQmHGXbX1LO0AU=;
	h=Date:To:From:Subject:Message-Id; b=XNL+JqU37ZfLyUBQzfnyCe0nTj/tPCKPbGiOyIb5zzGstPGsbpkU6BxZR9Wxbr1uw6lKHIBreOVrTz48gI/RaKApcggu2TQh/nr8AdnkuMbpKd1lnSuhiFtUkzpZ9KdA8CJV1DyHjHtiKtrRa5nfC4Ey79f/RR54MbBTihKa5YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1jqIGvzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1jqIGvzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3CFC2BBFC;
	Tue,  7 May 2024 16:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715100681;
	bh=wYV29NVy3j4zsGeersL328SghzEREnQmHGXbX1LO0AU=;
	h=Date:To:From:Subject:From;
	b=1jqIGvzQIwIaafuX54IL2ifqsHdYLitjbTSVWKv5kM/RVMs8xd1aqxwUAZcKqtKSB
	 EvRtF0eLrXykG97sfaTsDWYkg6kr62vNTz3Ma7RuDZeDWTSQkNMoMWWnPow6r4Y5vY
	 JTvI9tXuP7L4r4nOHOP4o7ymz/HMDwUB7zVVPTvE=
Date: Tue, 07 May 2024 09:51:20 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-make-alloc_mem_cgroup_per_node_info-return-bool.patch added to mm-unstable branch
Message-Id: <20240507165120.EF3CFC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: make alloc_mem_cgroup_per_node_info() return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-make-alloc_mem_cgroup_per_node_info-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-make-alloc_mem_cgroup_per_node_info-return-bool.patch

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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm: memcg: make alloc_mem_cgroup_per_node_info() return bool
Date: Tue, 7 May 2024 13:23:24 +0000

alloc_mem_cgroup_per_node_info() returns int that doesn't map to any errno
error code.  The only existing caller doesn't really need an error code so
change the the function to return bool (true on success) because this is
slightly less confusing and more consistent with the other code.

Link: https://lkml.kernel.org/r/20240507132324.1158510-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-make-alloc_mem_cgroup_per_node_info-return-bool
+++ a/mm/memcontrol.c
@@ -5637,13 +5637,13 @@ struct mem_cgroup *mem_cgroup_get_from_i
 }
 #endif
 
-static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
+static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
 
 	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, node);
 	if (!pn)
-		return 1;
+		return false;
 
 	pn->lruvec_stats = kzalloc_node(sizeof(struct lruvec_stats),
 					GFP_KERNEL_ACCOUNT, node);
@@ -5659,11 +5659,11 @@ static int alloc_mem_cgroup_per_node_inf
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
-	return 0;
+	return true;
 fail:
 	kfree(pn->lruvec_stats);
 	kfree(pn);
-	return 1;
+	return false;
 }
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
@@ -5736,7 +5736,7 @@ static struct mem_cgroup *mem_cgroup_all
 	}
 
 	for_each_node(node)
-		if (alloc_mem_cgroup_per_node_info(memcg, node))
+		if (!alloc_mem_cgroup_per_node_info(memcg, node))
 			goto fail;
 
 	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-memcg-make-alloc_mem_cgroup_per_node_info-return-bool.patch

