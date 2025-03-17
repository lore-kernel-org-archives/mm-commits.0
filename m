Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A8221578B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188280; cv=none; b=GaFlYuOrTk9G9htUwDFr75Jo9hDqWFy6CuUb25xqjXr01JbrYcloUJYKUdTDjPA5qy17OwUHEn9qm7ZkrHW/fKE2g150W1XmPsNSUtqRi1EkyoEVyO/qGPFgySpdZmm5Z7CIUxpDgRYlua/M+gInQt5DMpKO4mvRF26JvPnjZXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188280; c=relaxed/simple;
	bh=G1IoPsxZg0AguplyoFLK+Qnz93LWT4HqVLmehLS8emg=;
	h=Date:To:From:Subject:Message-Id; b=rBIAq8sXnUjXDHQy4Sm4kV2i+361jAvy24j9BOQzx4HeW6XbJF3ZW31QyC252gJo++NfKW5gizq72YZhyYoWSOF6nQngDYeJSppBNk6c4tIrnqFjolAQhYZ+cRC0eDwvcbNGLDSO8IyDoItG8ytZ8w0StUt9rdQyyajkodS7wJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=joIRyZ6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="joIRyZ6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD38C4CEED;
	Mon, 17 Mar 2025 05:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188279;
	bh=G1IoPsxZg0AguplyoFLK+Qnz93LWT4HqVLmehLS8emg=;
	h=Date:To:From:Subject:From;
	b=joIRyZ6b3FkIrQTrKttg2XIykt49Z90dTqBGFIdutuMoPpJnl6XCdErLNc7N0EEdT
	 gTFIvKnHPPmHnY/N0F1Y1f0JLpSCPIJrTAvGCd+WTyWDLl3WeO+OqgdMAbaHhjaDSl
	 JLNkr1oECB92i+XmNfN6fg0PYX0yzwoQknSYiE3c=
Date: Sun, 16 Mar 2025 22:11:18 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch removed from -mm tree
Message-Id: <20250317051119.6AD38C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: only align start of ZONE_MOVABLE on nodes with memory
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: only align start of ZONE_MOVABLE on nodes with memory
Date: Tue, 11 Feb 2025 08:29:00 +0000

At the beginning of find_zone_movable_pfns_for_nodes(), it has properly
set node_states[N_MEMORY] in early_calculate_totalpages().

Instead of iterating over all possible nodes, we can just do the alignment
on nodes with memory.

Link: https://lkml.kernel.org/r/20250211082900.10877-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory
+++ a/mm/mm_init.c
@@ -545,7 +545,7 @@ restart:
 
 out2:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
-	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long start_pfn, end_pfn;
 
 		zone_movable_pfn[nid] =
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure.patch
lib-rbtree-split-tests.patch
lib-rbtree-add-random-seed.patch
lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch
lib-interval_tree-add-test-case-for-span-iteration.patch
lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch

