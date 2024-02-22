Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BCBA929
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560106; cv=none; b=N+4eMNyMGnpYHZUMaWg8dP/5ToUSTwuw+wHCXpYJ0FhiUmhZ2s/7xWp0FVsHkCIHbf0SsJ3Op8/D5CDieA7ByF6TbdaF0voR4kqBdy+LaMolkL62qSfV6ipro4C7barh/3veiDMCfEzl+cXbbAua17PfWUfHlIsFwPP29uGKiC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560106; c=relaxed/simple;
	bh=sH7gDAtfRN6FzLGdvh8g/r7WqvsRQT8xSvHe/Vn/KmY=;
	h=Date:To:From:Subject:Message-Id; b=qvzBeptkiueZZd18eBsWvlwXsDNJlty5/FZYZGLw/WTc2FqgB7B0Yt9XKlIsmNslm6h+hKkWMDYwV+RjhiUeWm4NwDcmVAmJILs8KvSvVQIt2dS6YLJGZpRaklf76TFrPfHsqYFns310MaQzp46+KtdheXfewybPsTpIVGsKMrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FOyzR2yU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FOyzR2yU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A577C43394;
	Thu, 22 Feb 2024 00:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560106;
	bh=sH7gDAtfRN6FzLGdvh8g/r7WqvsRQT8xSvHe/Vn/KmY=;
	h=Date:To:From:Subject:From;
	b=FOyzR2yUGz3A5TkXZM6oGi6GkE1LIOit7lQLX++lAzeVQpKN4hFln0ZydrzXpYL1W
	 IQHGAqitmjSv7c5YxdmOGbxCBEBz8ddeJFpSQ5v6go3Sg1WSRibVQO/nnDtfml1tYd
	 gPEcaA3Cw74SOxmaQzEJChllGXY6WS1uDQpkXWHM=
Date: Wed, 21 Feb 2024 16:01:46 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,minchan@google.com,mhocko@kernel.org,hannes@cmpxchg.org,chrisl@kernel.org,tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled.patch removed from -mm tree
Message-Id: <20240222000146.9A577C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: don't periodically flush stats when memcg is disabled
has been removed from the -mm tree.  Its filename was
     mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm: memcg: don't periodically flush stats when memcg is disabled
Date: Fri, 26 Jan 2024 21:19:25 +0000

The root memcg is onlined even when memcg is disabled.  When it's onlined
a 2 second periodic stat flush is started, but no stat flushing is
required when memcg is disabled because there can be no child memcgs. 
Most calls to flush memcg stats are avoided when memcg is disabled as a
result of the mem_cgroup_disabled check added in 7d7ef0a4686a ("mm: memcg:
restore subtree stats flushing"), but the periodic flushing started in
mem_cgroup_css_online is not.  Skip it.

Link: https://lkml.kernel.org/r/20240126211927.1171338-1-tjmercier@google.com
Fixes: aa48e47e3906 ("memcg: infrastructure to flush memcg stats")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Li <chrisl@kernel.org>
Reported-by: Minchan Kim <minchan@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Koutn <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled
+++ a/mm/memcontrol.c
@@ -5621,7 +5621,7 @@ static int mem_cgroup_css_online(struct
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
-	if (unlikely(mem_cgroup_is_root(memcg)))
+	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
 		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
 				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
_

Patches currently in -mm which might be from tjmercier@google.com are


