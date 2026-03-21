Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3474B311967
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 18:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774116951; cv=none; b=lR6nldw3TYbzIXriXFfLi7qZR/GBmyaKgKPLQ6OUSWNvHrJIQLa9/ir8ETk3xYoh3gZfC8Ur28a+w1E0Go7dltHtiIskJgzjA0bO3HbrIA7RA8h0RxJVCSNpNsjHOoj1JSrUzWNWcgaen75aPEPqMj0Qjdj4QxV71ZjKtltgLw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774116951; c=relaxed/simple;
	bh=QPiS+agyQQBlSGcguzbEVwAddLPCW5t6sbKDYKI7KOA=;
	h=Date:To:From:Subject:Message-Id; b=mm1hfzDG6gURhu3h3pEqgOQ6FQKAYjz/aRpMv7aF4jt84REZwJeiweRtf+Wc/2ec3q9Ln0Ovvxr6SbJ+HSEhMfWnSy/go9ofTn4T/YummdEA9b9SQqZonXWHJqOameKgDL1b5iAPxS3z/i1r5kTEHGMQfrMls3EsX+y/dcv1DJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ewJi5+ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ewJi5+ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6B8C19421;
	Sat, 21 Mar 2026 18:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774116950;
	bh=QPiS+agyQQBlSGcguzbEVwAddLPCW5t6sbKDYKI7KOA=;
	h=Date:To:From:Subject:From;
	b=ewJi5+ye2ru2whUZnZmqpMFz46dQNPJ7TPB8X9u+hbh+Kcas7BShoUFd8Ct2tW7kJ
	 wfOXasm7Y01GTGskZYVa7IixtbDM9w0vNZRl/9zhz774aqIbgWeQ4vt6BHWA5ziXRd
	 UcpnV8hf1D1VtH2cr1AwuvjNLMhRPKgrwI39kpIo=
Date: Sat, 21 Mar 2026 11:15:50 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,axelrasmussen@google.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch added to mm-new branch
Message-Id: <20260321181550.AE6B8C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch

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
From: Bing Jiao <bingjiao@google.com>
Subject: mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
Date: Sat, 21 Mar 2026 03:34:13 +0000

In try_charge_memcg(), the 'reclaim_options' variable is initialized once
at the start of the function.  However, the function contains a retry
loop.  If reclaim_options were modified during an iteration (e.g., by
encountering a memsw limit), the modified state would persist into
subsequent retries.

This leads to incorrect reclaim behavior.  Specifically,
MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit is
reached.  After reclaimation attempts, a subsequent retry may successfully
charge memcg->memsw but fail on the memcg->memory charge.  In this case,
swapping should be permitted, but the carried-over state prevents it.

This issue was identified during code reading of try_charge_memcg() while
analyzing memsw limit behavior in tiered-memory systems; no production
failures have been reported yet.

Fix by moving the initialization of 'reclaim_options' inside the retry
loop, ensuring a clean state for every reclaim attempt.

Link: https://lkml.kernel.org/r/20260321033500.2558070-1-bingjiao@google.com
Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg
+++ a/mm/memcontrol.c
@@ -2558,7 +2558,7 @@ static int try_charge_memcg(struct mem_c
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
-	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	unsigned int reclaim_options;
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
@@ -2572,6 +2572,7 @@ retry:
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
 
+	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
_

Patches currently in -mm which might be from bingjiao@google.com are

mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio.patch
mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch

