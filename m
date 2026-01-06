Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1EE2DECBF
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 18:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725482; cv=none; b=q1xBKNXQeeXnFwfQ9EQjr/Tk9lAinn++QiZxFofcdyFtbiQsQ4eK6ZUm2vrUF0iKHU1kUAhwpV/HxmZDvmT0hR0hQpDTVm3XCRmR5DxkzEHzipMteOehT3vllf8QKhc13E1IA0ie1qwQIFyXHKFcm8OnfCsNydt2sktn7M76rsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725482; c=relaxed/simple;
	bh=URtZDYpCT/19HAtzP5n1WdkLQzBx5QiUZ3S7A69Vm6M=;
	h=Date:To:From:Subject:Message-Id; b=r8xMGitt6F4RyobF5X0fMsCC/f7CFavXm9NXbpDpUqPYGgUdWsncnwz902XXTOHLxsoJKz3gl9o4TzZ+f6rUgU48EpG5QjNvniG8TUgVp8kjP+/pb2E4nK36F2z+pOAT+g07UQbLs4Sc7Md9xBOnKZQ9ol/O5yCHFm5U7MYksvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwKRZ2mY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwKRZ2mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5241FC116C6;
	Tue,  6 Jan 2026 18:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767725482;
	bh=URtZDYpCT/19HAtzP5n1WdkLQzBx5QiUZ3S7A69Vm6M=;
	h=Date:To:From:Subject:From;
	b=qwKRZ2mYeI4gDKFlGxNGsnenJmZ5/u4mhYW7tswQjbHo9ocGIS1mlOIpI2hgohJnT
	 SP1QXmQSyzlTH1+/QgdSPic0eOwTJdQ60+SZuhCpfZUy9eJ4vYpF3T95zBPlzwXfIH
	 prj9oRw4rO+uLLhj6IOYIN0wp/56YYr8/ei9MIYI=
Date: Tue, 06 Jan 2026 10:51:21 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch added to mm-new branch
Message-Id: <20260106185122.5241FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: mem_cgroup_get_from_ino() returns NULL on error
has been added to the -mm mm-new branch.  Its filename is
     memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: mem_cgroup_get_from_ino() returns NULL on error
Date: Thu, 25 Dec 2025 15:21:11 -0800

Change mem_cgroup_get_from_ino() to return NULL on error instead of
ERR_PTR values.  This simplifies the API: NULL indicates failure, and a
valid pointer indicates success with a CSS reference held that the caller
must release via mem_cgroup_put().

Link: https://lkml.kernel.org/r/20251225232116.294540-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c     |    6 ++----
 mm/shrinker_debug.c |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~memcg-mem_cgroup_get_from_ino-returns-null-on-error
+++ a/mm/memcontrol.c
@@ -3624,17 +3624,15 @@ struct mem_cgroup *mem_cgroup_get_from_i
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg = NULL;
 
 	cgrp = cgroup_get_from_id(ino);
 	if (IS_ERR(cgrp))
-		return ERR_CAST(cgrp);
+		return NULL;
 
 	css = cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
 	if (css)
 		memcg = container_of(css, struct mem_cgroup, css);
-	else
-		memcg = ERR_PTR(-ENOENT);
 
 	cgroup_put(cgrp);
 
--- a/mm/shrinker_debug.c~memcg-mem_cgroup_get_from_ino-returns-null-on-error
+++ a/mm/shrinker_debug.c
@@ -130,7 +130,7 @@ static ssize_t shrinker_debugfs_scan_wri
 
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
 		memcg = mem_cgroup_get_from_ino(ino);
-		if (!memcg || IS_ERR(memcg))
+		if (!memcg)
 			return -ENOENT;
 
 		if (!mem_cgroup_online(memcg)) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

lib-buildid-use-__kernel_read-for-sleepable-context.patch
mm-damon-core-get-memcg-reference-before-access.patch
memcg-introduce-private-id-api-for-in-kernel-users.patch
memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch
memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch
memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch
mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch
mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch
memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch

