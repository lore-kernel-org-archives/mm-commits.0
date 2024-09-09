Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32842262B
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725908560; cv=none; b=mYyV249qSQwQpgV4XmuoNtIoO1JXxAC9xuyXS8PTyrrxqJg8+l4chiEmYTED7uN5dFQivNwCdtJrRayPCzkzB71PWrGTuj9Y89ko1V6l3YdxJddKsNeBvfzdzfOB3jBF0kh1A2zt/A+I7n4NWLoRvNDJFr/CdIKJdcyKIzoISZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725908560; c=relaxed/simple;
	bh=YgwwlMmq6kf3knQ5WdzZr5OgUIBA80VW9S63sUvaxgI=;
	h=Date:To:From:Subject:Message-Id; b=EjPkQQ+rjcCxkb2I476pUYlBSbejjEWm9sBcLSqVy/s1YuJ3qxI9Zb7UbKs3DfqLrDzW6bbafRx9pwYOTq2aq9Eyp+wM9Cfue+wwuS6MrBBioVb9lYyHMFRvwoT+MsqVa3YgwDPBcFop6OZBT7ZhNxht8qK9+JwCC5zcrmXbi/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CUja3mxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CUja3mxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAE8C4CEC5;
	Mon,  9 Sep 2024 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725908560;
	bh=YgwwlMmq6kf3knQ5WdzZr5OgUIBA80VW9S63sUvaxgI=;
	h=Date:To:From:Subject:From;
	b=CUja3mxgetoYq+Lx5qbwfJCtJbdNAYrJFquglO05ImqynkmWSRpWbQaNiKty7Evtx
	 2Z6RiurXdpx+0MQIsoAh+FPKXj25uB1bNZi/LZWgrpsIUs41mBpxA1WaUTI+JpF1PR
	 Iy3HNX6oq6ktlKDpfcHVnABRGTtCrzQ8Aew4Q60c=
Date: Mon, 09 Sep 2024 12:02:39 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,longman@redhat.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,chenridong@huawei.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-cleanup-with-config_memcg_v1.patch added to mm-unstable branch
Message-Id: <20240909190240.3BAE8C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: cleanup with !CONFIG_MEMCG_V1
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-cleanup-with-config_memcg_v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-cleanup-with-config_memcg_v1.patch

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
From: Michal Koutný <mkoutny@suse.com>
Subject: memcg: cleanup with !CONFIG_MEMCG_V1
Date: Mon, 9 Sep 2024 18:32:20 +0200

Patch series "Followups to controllers' v1 compilation".

The group of patches builds upon recent dissection of memory and cpuset
controller v1 code to under a separate configuration option.  The goal of
them patches is to produce behavior that appears to v1 controlelr users
same like if the controller wasn't compiled at all (and no change to v2
users).  Plus there are two preceding patches with cleanups I came across
when looking at the new code.


This patch (of 4):

Extern declarations have no definitions with !CONFIG_MEMCG_V1 and no
users, drop them altogether.

Link: https://lkml.kernel.org/r/20240909163223.3693529-1-mkoutny@suse.com
Link: https://lkml.kernel.org/r/20240909163223.3693529-2-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol-v1.h~memcg-cleanup-with-config_memcg_v1
+++ a/mm/memcontrol-v1.h
@@ -154,8 +154,6 @@ static inline bool memcg1_charge_skmem(s
 				       gfp_t gfp_mask) { return true; }
 static inline void memcg1_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages) {}
 
-extern struct cftype memsw_files[];
-extern struct cftype mem_cgroup_legacy_files[];
 #endif	/* CONFIG_MEMCG_V1 */
 
 #endif	/* __MM_MEMCONTROL_V1_H */
_

Patches currently in -mm which might be from mkoutny@suse.com are

memcg-cleanup-with-config_memcg_v1.patch
cgroup-cpuset-expose-cpuset-filesystem-with-cpuset-v1-only.patch
cgroup-disallow-mounting-v1-hierarchies-without-controller-implementation.patch
cgroup-do-not-report-unavailable-v1-controllers-in-proc-cgroups.patch

