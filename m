Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5C31388
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246931; cv=none; b=F4tEp2eB1zYdiGIVUTJZXdSKLoxgJ+WleZyXDgA4d2qKsqKxT1Aobn4oahBDYXmNGZ+ZJhFv534jxklpf7FkD5JWnZJmWOMuR46seMtnADZYThpmu0ouQJAiS6WfByphu7AWLTLMOt3rUWWwiNOOW6yqD07DIVSOe8yjKYb8gUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246931; c=relaxed/simple;
	bh=HWJLqp6WQnlU8OfQbLzUWfq0agWGuUk6ml5JJpEYYC0=;
	h=Date:To:From:Subject:Message-Id; b=UJmcz6a012hhbSVFUBGpeLvBjTtZ49hKYNdvyCmaSyL+L4lXQAh+BS4lt8Q1uNeyMZVC+dYmA6zAG5gOZoSTfIZ42UWchXPZDQ8EhPqMZG7GH7PjCK6y0ZEoJSUuxv7eelFb4BHzzxoMHRkTeVqt2L8g9Ip/dVFV93rn9eQA3o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TZkqRQ0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TZkqRQ0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F57C4CEC3;
	Mon,  2 Sep 2024 03:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246930;
	bh=HWJLqp6WQnlU8OfQbLzUWfq0agWGuUk6ml5JJpEYYC0=;
	h=Date:To:From:Subject:From;
	b=TZkqRQ0kFAS4aBcE2yaFhOSdRPjjbYOmu1aoRBaULfuEMtzRlOFf1apCYQl8D037p
	 81ib08ZXZaWA6oy2sooTR6ZpxK0kU4uXht1NNsT5TlwxpI4ByMPwq06NiZ74YdqnGn
	 VFR/3VEnERRnTJ8pzL61LEbd5FWe3qaSlR0vuo10=
Date: Sun, 01 Sep 2024 20:15:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,dan.carpenter@linaro.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-replace-memcg-id-idr-with-xarray-v2.patch removed from -mm tree
Message-Id: <20240902031530.B6F57C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: replace memcg ID idr with xarray
has been removed from the -mm tree.  Its filename was
     memcg-replace-memcg-id-idr-with-xarray-v2.patch

This patch was dropped because it was folded into memcg-replace-memcg-id-idr-with-xarray.patch

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: replace memcg ID idr with xarray
Date: Thu, 15 Aug 2024 08:54:02 -0700

fix error path in mem_cgroup_alloc(), per Dan

Link: https://lkml.kernel.org/r/20240815155402.3630804-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-replace-memcg-id-idr-with-xarray-v2
+++ a/mm/memcontrol.c
@@ -3496,16 +3496,17 @@ static struct mem_cgroup *mem_cgroup_all
 	struct mem_cgroup *memcg;
 	int node, cpu;
 	int __maybe_unused i;
-	long error = -ENOMEM;
+	long error;
 
 	memcg = kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), GFP_KERNEL);
 	if (!memcg)
-		return ERR_PTR(error);
+		return ERR_PTR(-ENOMEM);
 
 	error = xa_alloc(&mem_cgroup_ids, &memcg->id.id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
 	if (error)
 		goto fail;
+	error = -ENOMEM;
 
 	memcg->vmstats = kzalloc(sizeof(struct memcg_vmstats),
 				 GFP_KERNEL_ACCOUNT);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-move-v1-only-percpu-stats-in-separate-struct.patch
memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch
memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch
memcg-move-v1-events-and-statistics-code-to-v1-file.patch
memcg-make-v1-only-functions-static.patch
memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch
memcg-make-pgpgin-and-pgpgout-v1-only.patch
memcg-initiate-deprecation-of-v1-tcp-accounting.patch
memcg-initiate-deprecation-of-v1-soft-limit.patch
memcg-initiate-deprecation-of-oom_control.patch
memcg-initiate-deprecation-of-pressure_level.patch

