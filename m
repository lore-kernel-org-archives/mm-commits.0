Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF2A31619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486669; cv=none; b=uWgJKwJoaq+wg75Fi9OrQRvbBTgtr+y3QPmSJGc2b+5JZL/R4fMz/3PlLoXhXDMdqJKM8WTKAYKZeqip1UU8pUF/vwO+BfG0DxIrK+WiZUvhTR0P0x30A0nS/s3xjXHI0l3HLExJjlvYN9r6lP+gJe0dXzrjoQzOiPYwd6t69TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486669; c=relaxed/simple;
	bh=31CbkEN/8RkCvw3FIm/CZfv0jgHdnFvsI2L2T40nOk8=;
	h=Date:To:From:Subject:Message-Id; b=D4XuX7IyEjTt+ThWDyv6Re1CGC/qZotqiHxS5k0aQ0mb64miFgQzszqMKa+HNiuiOgkSQNYI98TUZY8DpNKBJgzhFhDI/OAV0qQKjQfwlphnU6wH8aXwBJjzrA4DRp+92aQfWVdIPJP7toDzeQzx+pSpRwtqy20wxW5+UA9Yfuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JJLQTUyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JJLQTUyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9507CC116C6;
	Tue, 27 Jan 2026 04:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486669;
	bh=31CbkEN/8RkCvw3FIm/CZfv0jgHdnFvsI2L2T40nOk8=;
	h=Date:To:From:Subject:From;
	b=JJLQTUyZtzb7goEY8SVmejAP5o27lbMe24zbpJoHCrfQ7NQkWaUCqbUme1wlltTxv
	 JpPOoSurhv8bGpRZJtylABzg1jHb59D0j+Sc0Aj5JteUUkBLcBRRfqYl5H/elhX4ai
	 jPEgFUKpVrd8QY/8Uu1Yao2y4ijmx3NFvyV/DoB4=
Date: Mon, 26 Jan 2026 20:04:29 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,rppt@kernel.org,rientjes@google.com,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-ignore-the-exact-initial-compaction-result.patch removed from -mm tree
Message-Id: <20260127040429.9507CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: ignore the exact initial compaction result
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-ignore-the-exact-initial-compaction-result.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: ignore the exact initial compaction result
Date: Tue, 06 Jan 2026 12:52:36 +0100

Patch series "tweaks for __alloc_pages_slowpath()", v3.


This patch (of 3):

For allocations that are of costly order and __GFP_NORETRY (and can
perform compaction) we attempt direct compaction first.  If that fails, we
continue with a single round of direct reclaim+compaction (as for other
__GFP_NORETRY allocations, except the compaction is of lower priority),
with two exceptions that fail immediately:

- __GFP_THISNODE is specified, to prevent zone_reclaim_mode-like
  behavior for e.g. THP page faults

- compaction failed because it was deferred (i.e. has been failing
  recently so further attempts are not done for a while) or skipped,
  which means there are insufficient free base pages to defragment to
  begin with

Upon closer inspection, the second condition has a somewhat flawed
reasoning.  If there are not enough base pages and reclaim could create
them, we instead fail.  When there are enough base pages and compaction
has already ran and failed, we proceed and hope that reclaim and the
subsequent compaction attempt will succeed.  But it's unclear why they
should and whether it will be as inexpensive as intended.

It might make therefore more sense to just fail unconditionally after the
initial compaction attempt.  However that would change the semantics of
__GFP_NORETRY to attempt reclaim at least once.

Alternatively we can remove the compaction result checks and proceed with
the single reclaim and (lower priority) compaction attempt, leaving only
the __GFP_THISNODE exception for failing immediately.

Link: https://lkml.kernel.org/r/20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz
Link: https://lkml.kernel.org/r/20260106-thp-thisnode-tweak-v3-1-f5d67c21a193@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-ignore-the-exact-initial-compaction-result
+++ a/mm/page_alloc.c
@@ -4798,43 +4798,21 @@ restart:
 		 */
 		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
 			/*
-			 * If allocating entire pageblock(s) and compaction
-			 * failed because all zones are below low watermarks
-			 * or is prohibited because it recently failed at this
-			 * order, fail immediately unless the allocator has
-			 * requested compaction and reclaim retry.
-			 *
-			 * Reclaim is
-			 *  - potentially very expensive because zones are far
-			 *    below their low watermarks or this is part of very
-			 *    bursty high order allocations,
-			 *  - not guaranteed to help because isolate_freepages()
-			 *    may not iterate over freed pages as part of its
-			 *    linear scan, and
-			 *  - unlikely to make entire pageblocks free on its
-			 *    own.
-			 */
-			if (compact_result == COMPACT_SKIPPED ||
-			    compact_result == COMPACT_DEFERRED)
-				goto nopage;
-
-			/*
 			 * THP page faults may attempt local node only first,
 			 * but are then allowed to only compact, not reclaim,
 			 * see alloc_pages_mpol().
 			 *
-			 * Compaction can fail for other reasons than those
-			 * checked above and we don't want such THP allocations
-			 * to put reclaim pressure on a single node in a
-			 * situation where other nodes might have plenty of
-			 * available memory.
+			 * Compaction has failed above and we don't want such
+			 * THP allocations to put reclaim pressure on a single
+			 * node in a situation where other nodes might have
+			 * plenty of available memory.
 			 */
 			if (gfp_mask & __GFP_THISNODE)
 				goto nopage;
 
 			/*
-			 * Looks like reclaim/compaction is worth trying, but
-			 * sync compaction could be very expensive, so keep
+			 * Proceed with single round of reclaim/compaction, but
+			 * since sync compaction could be very expensive, keep
 			 * using async compaction.
 			 */
 			compact_priority = INIT_COMPACT_PRIORITY;
_

Patches currently in -mm which might be from vbabka@suse.cz are


