Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198905227
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 00:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724201297; cv=none; b=P7PQXOg/Gh71KmldIUkMYc+6xd4Hpmc1iW7AsguTDejaQEHnk5q4m2cJ/u67LxhiXAqKVfBENzuv0dW/I7VOJDRcoFp9o+TOBG+eXyNoz8A6HJ5fANZaiUQAgpLU59rAOiPvmMdTVidNujqqmPMTBP37PAYuxbfkH87bosW5RiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724201297; c=relaxed/simple;
	bh=HcbLQ8Wr1NUxtTQgVoZi06fxJol8NBaP3laG0oUnk9E=;
	h=Date:To:From:Subject:Message-Id; b=O4xsnQOewOTI8z0k9eITqDxsQH9MmwrIsUREej+HauhgiRNo2iPxA84C22jSoQ1e94vO/G4K6VuVdfx/5RXRBFM+2rv+ohdicr0Ec+e3pUEz3PYTe75FSwPFxv68BaWspvaHNMMsXQelGOdj/vo8XPjyAnnWv4xKyqio44kiHNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eKKQbybA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eKKQbybA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBB3C4AF09;
	Wed, 21 Aug 2024 00:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724201296;
	bh=HcbLQ8Wr1NUxtTQgVoZi06fxJol8NBaP3laG0oUnk9E=;
	h=Date:To:From:Subject:From;
	b=eKKQbybAHtfyD1jzhWH2rYE64pJXkbTSxJ4mq2Bhn7Tzm5kmsI/9xW/BnUOaFYSPZ
	 y2yz1PZyy+6qEqirCyxgCTjEsHk1Bx8QuoFyTRvLZ5JNMMFPNLcb6KI9AdX2DqGRwF
	 L8ALIORY6S/MrIwU/rnv3ZKkHyW4nnHS0UCNuD2M=
Date: Tue, 20 Aug 2024 17:48:15 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-workingset-make-anon-shadow-nodes-memcg-aware.patch added to mm-unstable branch
Message-Id: <20240821004816.5BBB3C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap, workingset: make anon shadow nodes memcg aware
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-workingset-make-anon-shadow-nodes-memcg-aware.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-workingset-make-anon-shadow-nodes-memcg-aware.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/swap, workingset: make anon shadow nodes memcg aware
Date: Tue, 20 Aug 2024 17:23:59 +0800

Currently, the workingset (shadow) nodes of the swap cache are not
accounted to their corresponding memory cgroup, instead, they are all
accounted to the root cgroup.  This leads to inaccurate accounting and
ineffective reclaiming.  One cgroup could swap out a large amount of
memory, take up a large amount of memory with shadow nodes without being
accounted.

This issue is similar to commit 7b785645e8f1 ("mm: fix page cache
convergence regression"), where page cache shadow nodes were incorrectly
accounted.  That was due to the accidental dropping of the accounting flag
during the XArray conversion in commit a28334862993 ("page cache: Finish
XArray conversion").

However, this fix has a different cause.  Swap cache shadow nodes were
never accounted even before the XArray conversion, since they did not
exist until commit 3852f6768ede ("mm/swapcache: support to handle the
shadow entries"), which was years after the XArray conversion.

It's worth noting that one anon shadow Xarray node may contain different
entries from different cgroup, and it gets accounted at reclaim time, so
it's arguable which cgroup it should be accounted to (as Shakeal Butt
pointed out [1]).  File pages may suffer similar issue but less common. 
Things like proactive memory reclaim could make thing more complex.

So this commit still can't provide a 100% accurate accounting of anon
shadows, but it covers the cases when one memory cgroup uses significant
amount of swap, and in most cases memory pressure in one cgroup only
suppose to reclaim this cgroup and children.  Besides, this fix is clean
and easy enough.

Link: https://lore.kernel.org/all/7gzevefivueqtebzvikzbucnrnpurmh3scmfuiuo2tnrs37xso@haj7gzepjur2/ [1]
Link: https://lkml.kernel.org/r/20240820092359.97782-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap-workingset-make-anon-shadow-nodes-memcg-aware
+++ a/mm/swap_state.c
@@ -97,6 +97,7 @@ int add_to_swap_cache(struct folio *foli
 	void *old;
 
 	xas_set_update(&xas, workingset_update_node);
+	xas_set_lru(&xas, &shadow_nodes);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
@@ -718,7 +719,7 @@ int init_swap_address_space(unsigned int
 		return -ENOMEM;
 	for (i = 0; i < nr; i++) {
 		space = spaces + i;
-		xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
+		xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
 		atomic_set(&space->i_mmap_writable, 0);
 		space->a_ops = &swap_aops;
 		/* swap cache doesn't use writeback related tags */
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-clean-up-initialization-helper.patch
mm-swap-skip-slot-cache-on-freeing-for-mthp.patch
mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch
mm-swap-add-a-fragment-cluster-list.patch
mm-swap-relaim-the-cached-parts-that-got-scanned.patch
mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch
mm-swap-workingset-make-anon-shadow-nodes-memcg-aware.patch

