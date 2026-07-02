Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4173D6CA5
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 23:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783036103; cv=none; b=m62LfYkoKszqWvv6vpEnGeHtK4s+nEWyUwv8cJu6NrcycuJGhGUp0tEOszTMyL+oOkh2c6eDVpbLv7ET3eNKXe8rQasQsgzqYpUAKXRXMKMk8PJKSnGwYtNmmG4pgWgZNss+Vm23QWiztPlIsGu0NxLUQmMxpKBygnujTKQ/cJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783036103; c=relaxed/simple;
	bh=JhA/zXWvApK0oZcl8Hgm4unYvtEixQKP578Duyx9uFw=;
	h=Date:To:From:Subject:Message-Id; b=bF0fevRwAhK9eNLcKnnWejKRrGiqemOwA40p8tihmzDzjhJbVoKX3NEMq4TaCw1Zd3WW+mu1OjRMcKogReAnUNdw3wcf6pw6VuWRUjlw+KKtR/cs5R+fP1VbExLB+o/bggCgDJholruHMcGw60VarCGsw1k5bzwMXrSnVgxtufE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wuY33pBt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wuY33pBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FEC1F00A3A;
	Thu,  2 Jul 2026 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783036101;
	bh=oFaFCciGUPllPwV9hkhZDFGwa5scwwU1gjv9UFc8iKs=;
	h=Date:To:From:Subject;
	b=wuY33pBtZR6HiNbuKfT2eUQWEW3juBB4pMtg3HEW8wKtODXcpZ3nSFZjBMGR4g3cQ
	 a/m+OKBnlJ39T0mFxkgfQUSG5/E/M7clIM6Kzjlq1FHNUQdC/+B478GZIOfj44Nc6P
	 jAXj7y8xv9L59XMl7V/gX1wou5SpO7KcROLRVQIg=
Date: Thu, 02 Jul 2026 16:48:21 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,yingfu.zhou@shopee.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch added to mm-new branch
Message-Id: <20260702234821.94FEC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-v1: bail out reclaim when memcg is dying
has been added to the -mm mm-new branch.  Its filename is
     memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch

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
Subject: memcg-v1: bail out reclaim when memcg is dying
Date: Thu, 2 Jul 2026 20:02:30 +0800

The legacy memory.limit_in_bytes and memory.memsw.limit_in_bytes writers
retry page_counter_set_max() by reclaiming synchronously in the writer
context.  memory.force_empty similarly loops in synchronous reclaim until
the cgroup is empty or reclaim stops making progress.

These writes hold a kernfs active reference on the file.  If cgroup
removal starts in parallel, the remover sets CSS_DYING and then waits in
kernfs_drain() under cgroup_mutex for the active reference to drain. 
Continuing reclaim after the memcg is dying can therefore delay cgroup
removal and keep cgroup_mutex held for a long time.

Stop the v1 reclaim loops once the memcg is dying.  For limit resizing,
keep the existing -EBUSY semantics when the new limit could not be
installed.  For memory.force_empty, keep the existing best-effort success
semantics.

Link: https://lore.kernel.org/20260702120235.376752-5-jiayuan.chen@linux.dev
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

 mm/memcontrol-v1.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memcontrol-v1.c~memcg-v1-bail-out-reclaim-when-memcg-is-dying
+++ a/mm/memcontrol-v1.c
@@ -1805,6 +1805,10 @@ static int mem_cgroup_resize_max(struct
 		if (!ret)
 			break;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
@@ -1843,6 +1847,10 @@ static int mem_cgroup_force_empty(struct
 		if (signal_pending(current))
 			return -EINTR;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
 						  MEMCG_RECLAIM_MAY_SWAP, NULL))
 			nr_retries--;
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2.patch
mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch
memcg-bail-out-memoryhigh-when-memcg-is-dying.patch
memcg-bail-out-memorymax-when-memcg-is-dying.patch
memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch
memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch

