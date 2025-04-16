Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA7019F40A
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 01:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744766730; cv=none; b=pg9swL3A42qSSrj2ORCfv6gXmkBE5ny1JWvOe2XwnmMaN+s2GYImP3ZiAlRF4CI7KC4kG5s2Eh0g95cJl2w97qGGY55LjcGGZh49jAWMrDaZWqRiw3jWZPZ6vRyuzEExII4+TF3ckXA3k50Bvbmy+qt/eZo7Tb8M1aSM7JcKD9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744766730; c=relaxed/simple;
	bh=3OnpIxJaoovPrmWbyWgoEyDgkfLU1EyZoBkCzLYUwIk=;
	h=Date:To:From:Subject:Message-Id; b=jlMLtEHhiulG7mYiteUSGf5j8979VpP5n7h49QG80AKpztgdIyqVMtf5xcKiILBewdfxAu7suIP5TAtI5XR3WJ194yMN3/Q7RYWNKlh5pFi8zeVZqES42QN6mRjMqInw+7Duz5emmb4DfNsYy+kki+hvqlufIDKKyu/wcwBvD/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D7wiS5X+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D7wiS5X+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7747EC4CEE7;
	Wed, 16 Apr 2025 01:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744766729;
	bh=3OnpIxJaoovPrmWbyWgoEyDgkfLU1EyZoBkCzLYUwIk=;
	h=Date:To:From:Subject:From;
	b=D7wiS5X+/cDt83r2gKesE8ZClu4R1ATXwd0NfLUiJIx4dJRzufOOdR3kmcIwm6q7H
	 Q9cRTZiXjGyzVAdHWm3BZmIq9+W2sBQfqUw+h9CY9f96LxRiZfBP9l0l53YxGbx+Ap
	 7Edu9eTh+NRx/WdLWv23UXaUOa+HtsP5j9g7w0cI=
Date: Tue, 15 Apr 2025 18:25:28 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,muchun.song@linux.dev,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-avoid-passing-a-null-nodemask-when-there-is-mbind-policy.patch added to mm-unstable branch
Message-Id: <20250416012529.7747EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, hugetlb: avoid passing a null nodemask when there is mbind policy
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-avoid-passing-a-null-nodemask-when-there-is-mbind-policy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-avoid-passing-a-null-nodemask-when-there-is-mbind-policy.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm, hugetlb: avoid passing a null nodemask when there is mbind policy
Date: Tue, 15 Apr 2025 14:15:03 +0200

Before trying to allocate a page, gather_surplus_pages() sets up a
nodemask for the nodes we can allocate from, but instead of passing the
nodemask down the road to the page allocator, it iterates over the nodes
within that nodemask right there, meaning that the page allocator will
receive a preferred_nid and a null nodemask.

This is a problem when using a memory policy, because it might be that the
page allocator ends up using a node as a fallback which is not represented
in the policy.

Avoid that by passing the nodemask directly to the page allocator, so it
can filter out fallback nodes that are not part of the nodemask.

Link: https://lkml.kernel.org/r/20250415121503.376811-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-passing-a-null-nodemask-when-there-is-mbind-policy
+++ a/mm/hugetlb.c
@@ -2419,7 +2419,6 @@ static int gather_surplus_pages(struct h
 	long i;
 	long needed, allocated;
 	bool alloc_ok = true;
-	int node;
 	nodemask_t *mbind_nodemask, alloc_nodemask;
 
 	mbind_nodemask = policy_mbind_nodemask(htlb_alloc_mask(h));
@@ -2443,21 +2442,12 @@ retry:
 	for (i = 0; i < needed; i++) {
 		folio = NULL;
 
-		/* Prioritize current node */
-		if (node_isset(numa_mem_id(), alloc_nodemask))
-			folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
-					numa_mem_id(), NULL);
-
-		if (!folio) {
-			for_each_node_mask(node, alloc_nodemask) {
-				if (node == numa_mem_id())
-					continue;
-				folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
-						node, NULL);
-				if (folio)
-					break;
-			}
-		}
+		/*
+		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
+		 * down the road to pick the current node if that is the case.
+		 */
+		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+						    NUMA_NO_NODE, &alloc_nodemask);
 		if (!folio) {
 			alloc_ok = false;
 			break;
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-hugetlb-avoid-passing-a-null-nodemask-when-there-is-mbind-policy.patch
mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch

