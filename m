Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4931136349
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268912; cv=none; b=WGWFrvXTgZ1zy5lb5JeQEFhdSGcl4y1532G2gfs4wfJ9UB21/wGgi61r8hfQKsUyZ5OHcDP/9BqV/wUJGcYjbyIjor1xFRzFKYZWW9QCl5NLrY6NUWeUJi3oNNwXXlcUqHJhSKYP1GDLxt8rfJa0lkdWD4gqkY9BOX5wuFs9018=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268912; c=relaxed/simple;
	bh=lI2pWmJ4sJ1FcAvHXniVvH26NEVWLO0Hwum1rvT9sLk=;
	h=Date:To:From:Subject:Message-Id; b=BvyBoAT9onMEX4H7S4Us9SHxauksnF4ytDXPGVSpv19FZJK1AusdkN1gXHCTLXCN6BbQVQXGqM4CZDuMiZPeYnY8woQDXAQ965Cirj92PXLaxZ/EwbdFVcoMVmYn3jd/5YP2sQYSQMmLraZHJdGqYJkEWKBztNchgZPXHSw+ZbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NzYabP7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NzYabP7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434D3C4CEF5;
	Sat, 20 Dec 2025 22:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268911;
	bh=lI2pWmJ4sJ1FcAvHXniVvH26NEVWLO0Hwum1rvT9sLk=;
	h=Date:To:From:Subject:From;
	b=NzYabP7CWZCEKulxsjBFUfumiuBHGAZu//cqscwyEpEPTOWI8oCdm1i/HVWy7Cnv1
	 2/Rdblom2D8iaElT0c+PYiHY7L2v1pkphA30AwfVTBX8sMacrJFk3FoUybx9AxybjM
	 aOD+8DlfztLkWN8Z+v094rUlGzliH1zWgECPCV0k=
Date: Sat, 20 Dec 2025 14:15:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,rppt@kernel.org,rientjes@google.com,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch added to mm-new branch
Message-Id: <20251220221511.434D3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations
+++ a/mm/page_alloc.c
@@ -4792,6 +4792,20 @@ restart:
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

mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch

