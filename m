Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A52215043
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188170; cv=none; b=bSqOAJ3oDT0piLuznibCurNj8aEPBfqgS6ZfJCPtyrA0JWLJcl8TlUmwo7I3dfRELzUIoA9TV1PNLJQF40yvQwnziFit4j6cMShf19LppF9fi1lxqewfMX4zqJN0U6sEaB6S3ABechkk1UuXtcJBsaR8QQ2YAFD7lRzHJflHeRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188170; c=relaxed/simple;
	bh=fHFuiKLT/pKgn752HUpVjMexPZfa/W74uMMW7zz243I=;
	h=Date:To:From:Subject:Message-Id; b=L3Dtkf/NjoFHkXye+RgSGOSNRc9qpJx7uZ2yDVJqQ0dgSBC2kyLe0fId5rOW7H6GnxES6bDgFH5AOQUMbJJBlwFoKpTIIIewdzAhRGc89lr2WSkmWLRvkfKoiGRX/cGoJ+xFyVnDjytqSTK0sCGOBYEGSIsdpjGG2HKvlAlM5qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G6T20vZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G6T20vZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526FEC4CEEC;
	Mon, 17 Mar 2025 05:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188170;
	bh=fHFuiKLT/pKgn752HUpVjMexPZfa/W74uMMW7zz243I=;
	h=Date:To:From:Subject:From;
	b=G6T20vZyuUU5nRl90ScZ/HPAGKQLXfkMN2Z28xl1w/Hrpi7fxm+GEtzh5blov38wp
	 6wNH4UNR7Q6sEmkCgEOMv2jW21Bf7o2zODBxjsP3lQjbGbF14I/t+JiVMWTHH1RnUx
	 6SdYhD+6L4j2KjCgBW7kHj3D+8gOgVQ84p4mL0U8=
Date: Sun, 16 Mar 2025 22:09:29 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,wangweiyang2@huawei.com,vbabka@suse.cz,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-call-the-free-function-when-allocation-of-pn-fails.patch removed from -mm tree
Message-Id: <20250317050930.526FEC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: call the free function when allocation of pn fails
has been removed from the -mm tree.  Its filename was
     memcg-call-the-free-function-when-allocation-of-pn-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3433,6 +3433,16 @@ struct mem_cgroup *mem_cgroup_get_from_i
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
@@ -3457,23 +3467,10 @@ static bool alloc_mem_cgroup_per_node_in
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
@@ -3481,7 +3478,7 @@ static void __mem_cgroup_free(struct mem
 	obj_cgroup_put(memcg->orig_objcg);
 
 	for_each_node(node)
-		free_mem_cgroup_per_node_info(memcg, node);
+		free_mem_cgroup_per_node_info(memcg->nodeinfo[node]);
 	memcg1_free_events(memcg);
 	kfree(memcg->vmstats);
 	free_percpu(memcg->vmstats_percpu);
_

Patches currently in -mm which might be from chenridong@huawei.com are


