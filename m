Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2EC3D6CA6
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 23:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783036101; cv=none; b=ahELfLjEXs8seqjZAZwEuTMQd0x4Cceia/1PHYRxZe96aka56K8Fq3OSYIIwyuqmuMOn7ZEttW2MNTQV/RMpaN1luscmLvZEocqnXEmp7zAg+eLLyEX5/COh3BS8zaCExG5+ymFZ6EvdXp4B6wjyaMXsoOo/OMeUjrv3GtNj6wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783036101; c=relaxed/simple;
	bh=F1EbXg0Gv3UC3vIPlwtsLTyxi97mwA4Ta38Mk8E3P2E=;
	h=Date:To:From:Subject:Message-Id; b=pZ0WlX4o3eczeZKB+kghs1RXbmMka/PbA4Jj+9a6MAgBdNlW5P6NbL9kE4D2wBOMoVYH46QeRpPoHiaPPVB1BsHCMxLlpA/n0ufu6Lieqv+m3ucr5hS3FRf9GiPhvKxZ02daD7UsMahhJiRqrk4EGDK1o42P7+UlspKs+UEac4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zmwuGJjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zmwuGJjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAA41F000E9;
	Thu,  2 Jul 2026 23:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783036099;
	bh=+6PYH5CRqXSx5F9tGxqUSjuNgLNydNM/xQfnjtu3skI=;
	h=Date:To:From:Subject;
	b=zmwuGJjYdqv2aLz/XG3H1GGHiRQolYzoiLahdXKcQrgdKIBDSai8YsX6EaLcfqhak
	 gngo11v1vKCFr2WOUXg/qNpEZ4Nf2FqG402FI4yyK0QYE1L0DBXw+Xz/Y4cffnv5rw
	 pXgwLYQk7ihyf694TbtepKbPxRNKCC5DfU2ZBJUw=
Date: Thu, 02 Jul 2026 16:48:19 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,yingfu.zhou@shopee.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch added to mm-new branch
Message-Id: <20260702234819.7AAA41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: bail out proactive reclaim when memcg is dying
has been added to the -mm mm-new branch.  Its filename is
     memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: memcg: bail out proactive reclaim when memcg is dying
Date: Thu, 2 Jul 2026 20:02:29 +0800

Proactive reclaim via memory.reclaim can run for a long time - swap I/O
or thrashing again dominating the latency - and delays cgroup removal in
the same way.

Mitigate this by stopping the reclaim once memcg_is_dying().

Link: https://lore.kernel.org/20260702120235.376752-4-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/vmscan.c~memcg-bail-out-proactive-reclaim-when-memcg-is-dying
+++ a/mm/vmscan.c
@@ -7904,6 +7904,10 @@ int user_proactive_reclaim(char *buf,
 		if (signal_pending(current))
 			return -EINTR;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg && memcg_is_dying(memcg))
+			return -EAGAIN;
+
 		/*
 		 * This is the final attempt, drain percpu lru caches in the
 		 * hope of introducing more evictable pages.
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2.patch
mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch
memcg-bail-out-memoryhigh-when-memcg-is-dying.patch
memcg-bail-out-memorymax-when-memcg-is-dying.patch
memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch
memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch

