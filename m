Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A03028E3F;
	Wed, 16 Apr 2025 23:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744845054; cv=none; b=rT7c+ZnfSN37D785yL+p/8T216OjIz82G01rQTW9hqjvwe2qxr4KW7t5e/sPxCFx4NWjJ8Hm69QhnVrN5LIS8SnFsJFcIuqxkb3BBNvfKJRxSC4OOSUwbmgR9x9OBUueAuxutFqFZH5WXllrO9/uOQS25G9WSgiY9M6SFNYIxlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744845054; c=relaxed/simple;
	bh=cWDm7bL+onZiFIl6IPHOaW5+F4xdkLXaV2ZQY9KRSeY=;
	h=Date:To:From:Subject:Message-Id; b=UYdQlf/tLhDje0OUANnRntVeqHdXF+ytWlG55zYJGPhHWQO7KvDBQMtRydNZl3mewvzPiA6DR9vItr+oHnm686dfdiEjaKTWqFLu6z2UO2rPLHh/DQxa0F6BzQPXcX7GTauoKoiJPnZwrFbinJviXjRW+rf4VjEw4ML8w4d58qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mplO/pAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mplO/pAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F99C4CEE2;
	Wed, 16 Apr 2025 23:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744845053;
	bh=cWDm7bL+onZiFIl6IPHOaW5+F4xdkLXaV2ZQY9KRSeY=;
	h=Date:To:From:Subject:From;
	b=mplO/pAVE+sAk9kmCnBMxEj5fm9fY2MApnmEXwWdQYsdQviorpcS2TkfIkM/sc951
	 434wLdlADb7kS2NTNQ6nsIhMCMG7nRVKfYInqeygU+6poevA0waS0+CsSI9aknYtfA
	 8a+PYV/quqYS2swqsQti8R95oygzMEYpO7hycjh8=
Date: Wed, 16 Apr 2025 16:10:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhangtianyang@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-avoid-infinite-retries-caused-by-cpuset-race.patch added to mm-new branch
Message-Id: <20250416231053.B4F99C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc.c: avoid infinite retries caused by cpuset race
has been added to the -mm mm-new branch.  Its filename is
     mm-page_allocc-avoid-infinite-retries-caused-by-cpuset-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_allocc-avoid-infinite-retries-caused-by-cpuset-race.patch

This patch will later appear in the mm-new branch at
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
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
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
@@ -4555,6 +4555,14 @@ restart:
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

mm-page_allocc-avoid-infinite-retries-caused-by-cpuset-race.patch

