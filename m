Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD86F159583
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664156; cv=none; b=I1/pCOeues2HgCBtWhWxy1W3OTqyTSZCX479poWBE712tHmrW2qkDulqips40nXKYYKNix/rHme2v8X874VAg+V1N7dMtiw4hIFWfstOyiNS+bWY2jXNvdYCJii3TI1fC+KMnQKqgqKPtR/iulhB/uedzAxrVDkW2KYJ4QbPIQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664156; c=relaxed/simple;
	bh=MuF8VM/N3/WDNcKkmCY435Ha0oSF9jlxFNlJVdqstgY=;
	h=Date:To:From:Subject:Message-Id; b=OAUotukAjo+dfWYqK/IygIxCTCHE2STmh/UXFXhD2uWk07V4HmPOv1X8JOjgwjreSf/TaOt1N6DEEwh0xAI2VJtih94bd5zUCE3VDWZxvc7QWkll66O1i3GUZtJtLiLnOyCc+GDF2pzrsQqTzkQFJpjavMsxM8Q3fo/30kYzB0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EkoeLeHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EkoeLeHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7FAC113CC;
	Thu,  2 May 2024 15:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714664156;
	bh=MuF8VM/N3/WDNcKkmCY435Ha0oSF9jlxFNlJVdqstgY=;
	h=Date:To:From:Subject:From;
	b=EkoeLeHm0rj9b+4QODSzZDp5qhjJ1cTpJ5EYUy12vPrgfQMMO2lrWltgF4buy1g6b
	 90UD4s/kl21Pap+BqqbY+c6HufjmBz3x1lSG9S+aIWjTwAv3O8Fl2c+84ZBSfsybmQ
	 wMbhA1v+N+MYWqGhK/18ybH75j4mPg80bpuSR17U=
Date: Thu, 02 May 2024 08:35:54 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-account-memory-used-for-memcg-vmstats-and-lruvec-stats.patch added to mm-unstable branch
Message-Id: <20240502153555.AE7FAC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: account memory used for memcg vmstats and lruvec stats
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-account-memory-used-for-memcg-vmstats-and-lruvec-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-account-memory-used-for-memcg-vmstats-and-lruvec-stats.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: account memory used for memcg vmstats and lruvec stats
Date: Wed, 1 May 2024 10:26:12 -0700

The percpu memory used by memcg's memory statistics is already accounted. 
For consistency, let's enable accounting for vmstats and lruvec stats as
well.

Link: https://lkml.kernel.org/r/20240501172617.678560-4-shakeel.butt@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-account-memory-used-for-memcg-vmstats-and-lruvec-stats
+++ a/mm/memcontrol.c
@@ -5540,8 +5540,8 @@ static int alloc_mem_cgroup_per_node_inf
 	if (!pn)
 		return 1;
 
-	pn->lruvec_stats = kzalloc_node(sizeof(struct lruvec_stats), GFP_KERNEL,
-					node);
+	pn->lruvec_stats = kzalloc_node(sizeof(struct lruvec_stats),
+					GFP_KERNEL_ACCOUNT, node);
 	if (!pn->lruvec_stats)
 		goto fail;
 
@@ -5612,7 +5612,8 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 	}
 
-	memcg->vmstats = kzalloc(sizeof(struct memcg_vmstats), GFP_KERNEL);
+	memcg->vmstats = kzalloc(sizeof(struct memcg_vmstats),
+				 GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats)
 		goto fail;
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-account-memory-used-for-memcg-vmstats-and-lruvec-stats.patch

