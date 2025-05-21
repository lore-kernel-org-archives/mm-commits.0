Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E1832C85;
	Wed, 21 May 2025 05:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806603; cv=none; b=Rvh95PR44cnhxU1pfJ8ZE3EOywt0nIJeJsBkEZ8FnFfc9CPBJw3h3r91DdOxXtbhCofXAMNcXJtmEVMTqoLesoeX3Vy4cszmaaQ0w35BVgtYhNJ+Zsj7OkBpQTYOV1sKmqTemoITwTKuebNkETiavtFYwQqeFljJ7NQISuvLQKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806603; c=relaxed/simple;
	bh=jBiZ01pex1Im3tkQ9vn6tyF27fv4w7THik48ltgXgoQ=;
	h=Date:To:From:Subject:Message-Id; b=Wk4MyVNlH++rApRyeUaPCh0hIJZwbr5uqu5Z2xj7oow/SKBgw5DY5LSbWx0mbZkEL+N7N1BhVt7EhZv5fhuNw9w9NQoOjx0a//SfkNBe4AExxKzTVYrrOMuf/W7pSNqan3mCsx9S6/22i/xjESqzXi9WANQopN3dV0Ik7Xoo/wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WCMsXdri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WCMsXdri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1D3C4CEE4;
	Wed, 21 May 2025 05:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806602;
	bh=jBiZ01pex1Im3tkQ9vn6tyF27fv4w7THik48ltgXgoQ=;
	h=Date:To:From:Subject:From;
	b=WCMsXdrinNF/B+rgEgFHUqBErC5JuJz0BXR0oLLqvblSMja9UvQglL2MiVjsOjSV2
	 1lOWSlt8z+jhwHhvv+dd4jvc3uLJhFUJo5zdomcn3bZUaZDrCNNxMLdkiLajluCsw1
	 WKZhmXG/UfrNoG2l/D523Ay6FTIJvMShYNKZ1y+Q=
Date: Tue, 20 May 2025 22:50:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhangtianyang@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_allocc-avoid-infinite-retries-caused-by-cpuset-race.patch removed from -mm tree
Message-Id: <20250521055002.7D1D3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc.c: avoid infinite retries caused by cpuset race
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-avoid-infinite-retries-caused-by-cpuset-race.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: mm/page_alloc.c: avoid infinite retries caused by cpuset race
Date: Wed, 16 Apr 2025 16:24:05 +0800

__alloc_pages_slowpath has no change detection for ac->nodemask in the
part of retry path, while cpuset can modify it in parallel.  For some
processes that set mempolicy as MPOL_BIND, this results ac->nodemask
changes, and then the should_reclaim_retry will judge based on the latest
nodemask and jump to retry, while the get_page_from_freelist only
traverses the zonelist from ac->preferred_zoneref, which selected by a
expired nodemask and may cause infinite retries in some cases

cpu 64:
__alloc_pages_slowpath {
        /* ..... */
retry:
        /* ac->nodemask = 0x1, ac->preferred->zone->nid = 1 */
        if (alloc_flags & ALLOC_KSWAPD)
                wake_all_kswapds(order, gfp_mask, ac);
        /* cpu 1:
        cpuset_write_resmask
            update_nodemask
                update_nodemasks_hier
                    update_tasks_nodemask
                        mpol_rebind_task
                         mpol_rebind_policy
                          mpol_rebind_nodemask
		// mempolicy->nodes has been modified,
		// which ac->nodemask point to

        */
        /* ac->nodemask = 0x3, ac->preferred->zone->nid = 1 */
        if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
                                 did_some_progress > 0, &no_progress_loops))
                goto retry;
}

Simultaneously starting multiple cpuset01 from LTP can quickly reproduce
this issue on a multi node server when the maximum memory pressure is
reached and the swap is enabled

Link: https://lkml.kernel.org/r/20250416082405.20988-1-zhangtianyang@loongson.cn
Fixes: c33d6c06f60f ("mm, page_alloc: avoid looking up the first zone in a zonelist twice")
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/page_alloc.c~mm-page_allocc-avoid-infinite-retries-caused-by-cpuset-race
+++ a/mm/page_alloc.c
@@ -4562,6 +4562,14 @@ restart:
 	}
 
 retry:
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * infinite retries.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
+
 	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
 	if (alloc_flags & ALLOC_KSWAPD)
 		wake_all_kswapds(order, gfp_mask, ac);
_

Patches currently in -mm which might be from zhangtianyang@loongson.cn are


