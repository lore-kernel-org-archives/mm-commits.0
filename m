Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CADD50F
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706428932; cv=none; b=Wenj34JUUomPgoB0xi2bE0gyh6kDC+T9pLmlnzTw6lC2INV3k6gt0K8BEpG1MWK1eISPNQ6mxwriL1WFXnS790YIkPj4Ri6kgEuosKKP/ylCIPcAMldNdYvqirgsC+dpJsCWu+Wiua28Z8CW1VRxsEkvUPQ4P/fbiHFUG8EHMQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706428932; c=relaxed/simple;
	bh=/o2pgw5a9yG1zJFcRd7ibitKMarISQBIbQ3YVZHz76c=;
	h=Date:To:From:Subject:Message-Id; b=RUeaUKjLyuvfdn1A2MRjVvbVyr4d2tozUnn0/aZqYO/bcQNwzOQo7D+cE1gKxjyaShFEYEa4GzXt/RYB1dxZg72wvAs9C2A2Snc4HTbA+F3GjOfgVU4KmItZ5veqRQZ8uRzkV7tJnDGqifkDRqcKVt5fbXMNdY8f/Ozh0mr+ekY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k9QU0MQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k9QU0MQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9610FC433F1;
	Sun, 28 Jan 2024 08:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706428931;
	bh=/o2pgw5a9yG1zJFcRd7ibitKMarISQBIbQ3YVZHz76c=;
	h=Date:To:From:Subject:From;
	b=k9QU0MQhc3ysgQG0U6lVjDwIMXkKZEvquTsta2JIHhiq1ggghIJeZ3b0Q4cgooMSu
	 okia2h9b4lPxozYmUdcV2XogDeBFht6/LC2YlkxjT4aepWSHB13GFFlh9ikVrddAsV
	 9Wsdde8iwxg4p/3w8ID0/I4n9mAIhIifc1UbHeUY=
Date: Sun, 28 Jan 2024 00:02:07 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,minchan@google.com,mhocko@kernel.org,hannes@cmpxchg.org,chrisl@kernel.org,tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled.patch added to mm-unstable branch
Message-Id: <20240128080210.9610FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: don't periodically flush stats when memcg is disabled
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled.patch

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
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled
+++ a/mm/memcontrol.c
@@ -5622,7 +5622,7 @@ static int mem_cgroup_css_online(struct
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
-	if (unlikely(mem_cgroup_is_root(memcg)))
+	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
 		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
 				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
_

Patches currently in -mm which might be from tjmercier@google.com are

mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled.patch

