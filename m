Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6861DC998
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 23:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738019342; cv=none; b=cipyaqExngS7CKYzqIm7LGNggK2407dh1m7N7e09UK3OCrC4W8/bjV8jCp82d+nCZv7ZwcbJ/KbIfexulF8b0r5OuVIvTSBtgZ/v/djSd3wFrzqaAEnWZ2fWQQJlxHdSLzQyvnPbjbedlnRCcjA/vH/16aZzOHqCFDohkZkpnP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738019342; c=relaxed/simple;
	bh=lMWaWrZVSxZdjGQuu2BXr2Y9JhFBMqdPR4bnjhlWshA=;
	h=Date:To:From:Subject:Message-Id; b=K5HhGg0oPnItCazPyyLndE1I3AFS3NI9h4f6M/fTRVOPA7FDTfEITv06GxlJyT7nm1HCPNWqX2U6pVkr3QN5Z+GoDxTgVZ6c4nY2z1xf9LQSsEYvJJboapA2Rxp0DpmGe5VhDNJQCkLX7d6uAXVFHUH8PKID5f16aHLz9BUXlO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XHdEVFN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XHdEVFN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F241DC4CED2;
	Mon, 27 Jan 2025 23:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738019342;
	bh=lMWaWrZVSxZdjGQuu2BXr2Y9JhFBMqdPR4bnjhlWshA=;
	h=Date:To:From:Subject:From;
	b=XHdEVFN73wF9qYY1gSxIpErt0bCJ2hHs33bmmCKeOnr17bwIuaWXguCngyqyDhuhx
	 GFRisArOAgFFpzeK+VK8ZacvBDQYrPZ5dg6kYqFBwma7Urp/vis8fHfqYtKCbKWo39
	 XiwCzd6qIJNJjbAsYvBwG/+P04bA3BRcJzmVJgPc=
Date: Mon, 27 Jan 2025 15:09:01 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,wangweiyang2@huawei.com,vbabka@suse.cz,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-call-the-free-function-when-allocation-of-pn-fails.patch added to mm-unstable branch
Message-Id: <20250127230901.F241DC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: call the free function when allocation of pn fails
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-call-the-free-function-when-allocation-of-pn-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-call-the-free-function-when-allocation-of-pn-fails.patch

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
Subject: memcg: call the free function when allocation of pn fails
Date: Fri, 24 Jan 2025 07:35:12 +0000

The 'free_mem_cgroup_per_node_info' function is used to free the
'mem_cgroup_per_node' struct.  Using 'pn' as the input for the
free_mem_cgroup_per_node_info function will be much clearer.  Call
'free_mem_cgroup_per_node_info' when 'alloc_mem_cgroup_per_node_info'
fails, to free 'pn' as a whole, which makes the code more cohesive.

Link: https://lkml.kernel.org/r/20250124073514.2375622-3-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Finkel <davidf@vimeo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/mm/memcontrol.c~memcg-call-the-free-function-when-allocation-of-pn-fails
+++ a/mm/memcontrol.c
@@ -3424,6 +3424,16 @@ struct mem_cgroup *mem_cgroup_get_from_i
 }
 #endif
 
+static void free_mem_cgroup_per_node_info(struct mem_cgroup_per_node *pn)
+{
+	if (!pn)
+		return;
+
+	free_percpu(pn->lruvec_stats_percpu);
+	kfree(pn->lruvec_stats);
+	kfree(pn);
+}
+
 static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
@@ -3448,23 +3458,10 @@ static bool alloc_mem_cgroup_per_node_in
 	memcg->nodeinfo[node] = pn;
 	return true;
 fail:
-	kfree(pn->lruvec_stats);
-	kfree(pn);
+	free_mem_cgroup_per_node_info(pn);
 	return false;
 }
 
-static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
-{
-	struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
-
-	if (!pn)
-		return;
-
-	free_percpu(pn->lruvec_stats_percpu);
-	kfree(pn->lruvec_stats);
-	kfree(pn);
-}
-
 static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
@@ -3472,7 +3469,7 @@ static void __mem_cgroup_free(struct mem
 	obj_cgroup_put(memcg->orig_objcg);
 
 	for_each_node(node)
-		free_mem_cgroup_per_node_info(memcg, node);
+		free_mem_cgroup_per_node_info(memcg->nodeinfo[node]);
 	memcg1_free_events(memcg);
 	kfree(memcg->vmstats);
 	free_percpu(memcg->vmstats_percpu);
_

Patches currently in -mm which might be from chenridong@huawei.com are

memcg-use-ofp_peak_unset-instead-of-1.patch
memcg-call-the-free-function-when-allocation-of-pn-fails.patch
memcg-factor-out-the-replace_stock_objcg-function.patch
memcg-add-config_memcg_v1-for-local-functions.patch

