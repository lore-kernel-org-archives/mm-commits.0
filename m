Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE0780B
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723760319; cv=none; b=HduEwIxbvp3oy6p+OsHBZd8di5c76ChW4WfrvQ6VMWrOPWqRzwQ45N6GiM5O32yXbOGS85T+nyh9JeiDf+6q0MU66LlNv0RP5Dukc6mRMPcsQF2uYoQXuY6SRkzoX3PzXTWKFi8hiAxbAOllD6KRZyeBcu+Jfwiv91KonpiIY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723760319; c=relaxed/simple;
	bh=2HirZpSguoO/8q93eXnk+sdDKwWz6WP1OO0X9Dr0RUU=;
	h=Date:To:From:Subject:Message-Id; b=LGY3RiPnJP+f59r6p5OxjD7yALNfdvb8WZBBG1+Jrzu1lH4hx0iupOxbJSodPxhdCRPDPsyf/RwRY8lDyeoZHV0xgdz3cyjRZJjsCFedeSTsi94X1IhTvjykptjz6HIdQ8V9lHpBUolZZsIR6+TRqv3Pp68I67SdlRFB472kaC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uGaJz7e9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uGaJz7e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF89CC32786;
	Thu, 15 Aug 2024 22:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723760318;
	bh=2HirZpSguoO/8q93eXnk+sdDKwWz6WP1OO0X9Dr0RUU=;
	h=Date:To:From:Subject:From;
	b=uGaJz7e9IDX4V9KBlrhEag1UFn/JdUqq7yhRft8BQyonOtoSU3DbXTmMzhcGpCJL/
	 9pa4NBa0IdThEGRrUQM3u6oloYwPb4B7G69HKcxrw92UUeDnWJJHEVmkZrLQzPKJLs
	 kVl/TA43e4JCUS5Vtjxx0896rxFFB3uSK37CEHpc=
Date: Thu, 15 Aug 2024 15:18:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,dan.carpenter@linaro.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-replace-memcg-id-idr-with-xarray-v2.patch added to mm-unstable branch
Message-Id: <20240815221838.AF89CC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: replace memcg ID idr with xarray
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-replace-memcg-id-idr-with-xarray-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-replace-memcg-id-idr-with-xarray-v2.patch

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
memcg-replace-memcg-id-idr-with-xarray-v2.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch

