Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65DC3612F4;
	Wed, 21 Jan 2026 03:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966099; cv=none; b=Jr2Ol8o3NfubpYax7QhuLSfD6ZP74jJpLSbLOkjCc6lJfXB7MtuqEgZQYkA0CH8lbWn8E02vAh20GzXoUNpWztqrZcl37kKdsob0RT6N4sbzdKMWeWxsBZkJKYG3Yd6SW1pSs3ArO/YHF4eyRpZLIy5VwX4AuU1nt8xs7ehbVhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966099; c=relaxed/simple;
	bh=HQzlJD8f+EbcLTjeuVIAja2myNC7jNchRaXD3uxTMb4=;
	h=Date:To:From:Subject:Message-Id; b=gd9exKIEAwP6aDKI5EGA1xYAByuzAMahcDEGvsd0n8teulb/xRLTzvndJ8x3Cm8pa64+XR0NbUJtjjVQlG5/g+Lc+n5Mp0do8BEUTEBnezQ4EMnWo2urUbl5at04Nx9DHg8WkpKrOOM3W0vvcOAN8JYGYnyH30wW7oocaHZqpPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J+FyK7Je; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J+FyK7Je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF82C16AAE;
	Wed, 21 Jan 2026 03:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966099;
	bh=HQzlJD8f+EbcLTjeuVIAja2myNC7jNchRaXD3uxTMb4=;
	h=Date:To:From:Subject:From;
	b=J+FyK7Je2O4TKYaOp53Pmz2NsTQcNLSWkJpMIyejM07J+hTB4IxvwL7sWzZSrGGJt
	 TvDC46VgRTzLR3LxBmpSwZ0Bl/NNV5+jXLU/zxyEyfNdqLYF5dR9hLvOI2zwrxVPBV
	 4euM1QnX5HyE4ohTRmFa/ZB/+0ugh2NCafGz4QD0=
Date: Tue, 20 Jan 2026 19:28:19 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rientjes@google.com,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch removed from -mm tree
Message-Id: <20260121032819.9EF82C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations
Date: Fri, 19 Dec 2025 17:31:57 +0100

Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
local-only and all-node allocations"), THP page fault allocations have
settled on the following scheme (from the commit log):

1. local node only THP allocation with no reclaim, just compaction.
2. for madvised VMA's or when synchronous compaction is enabled always - THP
   allocation from any node with effort determined by global defrag setting
   and VMA madvise
3. fallback to base pages on any node

Recent customer reports however revealed we have a gap in step 1 above. 
What we have seen is excessive reclaim due to THP page faults on a NUMA
node that's close to its high watermark, while other nodes have plenty of
free memory.

The problem with step 1 is that it promises no reclaim after the
compaction attempt, however reclaim is only avoided for certain compaction
outcomes (deferred, or skipped due to insufficient free base pages), and
not e.g.  when compaction is actually performed but fails (we did see
compact_fail vmstat counter increasing).

THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
which is not the intention.

Thus add a check for __GFP_THISNODE that corresponds to this exact
situation and prevents continuing with reclaim/compaction once the initial
compaction attempt isn't successful in allocating the page.

Note that commit cc638f329ef6 has not introduced this over-reclaim
possibility; it appears to exist in some form since commit 2f0799a0ffc0
("mm, thp: restore node-local hugepage allocations").  Followup commits
b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction may
not succeed") and cc638f329ef6 have moved in the right direction, but left
the abovementioned gap.

Link: https://lkml.kernel.org/r/20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz
Fixes: 2f0799a0ffc0 ("mm, thp: restore node-local hugepage allocations")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations
+++ a/mm/page_alloc.c
@@ -4819,6 +4819,20 @@ restart:
 				goto nopage;
 
 			/*
+			 * THP page faults may attempt local node only first,
+			 * but are then allowed to only compact, not reclaim,
+			 * see alloc_pages_mpol().
+			 *
+			 * Compaction can fail for other reasons than those
+			 * checked above and we don't want such THP allocations
+			 * to put reclaim pressure on a single node in a
+			 * situation where other nodes might have plenty of
+			 * available memory.
+			 */
+			if (gfp_mask & __GFP_THISNODE)
+				goto nopage;
+
+			/*
 			 * Looks like reclaim/compaction is worth trying, but
 			 * sync compaction could be very expensive, so keep
 			 * using async compaction.
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-ignore-the-exact-initial-compaction-result.patch
mm-page_alloc-refactor-the-initial-compaction-handling.patch
mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch

