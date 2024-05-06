Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14BA2207A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957053; cv=none; b=m+VtdZHlqqzR9Uxz3HugLj/LRvDirK47WC6byjyMgtQ9VHSSCl74SMGl5A/Pj+GCu8naPCFmE/GeTByx7N1hkyouD7uPfU0xRkP1Cw4P02M34EO5cCkjn8cGgrHzW4eUUSbMHG9TB6T5Qp/oh/cW8fLJuy/jPxb8x2CM2X9nI80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957053; c=relaxed/simple;
	bh=SM4JkTENWLHoz9GyUBsth5/qalAw4K23112KOi4B3WA=;
	h=Date:To:From:Subject:Message-Id; b=TB3JYp2E80Ql6gRIqBIxfYdIPnNLOomscUQ5pd2Fu51CgrUkxUOsWcKZcSqKAqznto4zaxNM7YBhnU5D9w31iIaARzUIXjVRXrYySEg5o+eXv0ukZWkk37v30VXBE/KqfQTfTBeuQueBYXd5Gi9vTKnl6o8vQFCw8EVxfAh6t78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NjbdSnxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NjbdSnxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D5BC113CC;
	Mon,  6 May 2024 00:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957053;
	bh=SM4JkTENWLHoz9GyUBsth5/qalAw4K23112KOi4B3WA=;
	h=Date:To:From:Subject:From;
	b=NjbdSnxcG3zwbHSoIdFcfgFy5U5yanHHGYUlAj7roBAGu4xvvvBSZKqdN40mG10xn
	 WbDogYPCgRdJXAQ62kWCRN1I7WNhwdiMrvkSRVM9Tz+a5zVopCOP07sywO59gwGGlX
	 d8oIu+gnaBLWenw5z4KybNz6L14ajtasNOLhxDXw=
Date: Sun, 05 May 2024 17:57:33 -0700
To: mm-commits@vger.kernel.org,alexs@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch removed from -mm tree
Message-Id: <20240506005733.98D5BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: remove page_mapcount() usage in stable_tree_search()
has been removed from the -mm tree.  Its filename was
     mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/ksm: remove page_mapcount() usage in stable_tree_search()
Date: Tue, 16 Apr 2024 19:25:33 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.

If our folio has a stable node, it is a (small) KSM folio -- see
folio_stable_node().  Let's use folio_mapcount() in stable_tree_search()
instead, which results in no functional change.

The mapcount > 1 check is a bit confusing, because that's usually a check
for page sharing.  Looks like the reason is that we are guaranteed to not
exceed ksm_max_page_sharing for the tree KSM folio when merging with that.
Let's update the documentation to make that clearer.

Link: https://lkml.kernel.org/r/20240416172533.663418-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/ksm.c~mm-ksm-remove-page_mapcount-usage-in-stable_tree_search
+++ a/mm/ksm.c
@@ -1909,12 +1909,15 @@ again:
 			if (page_node) {
 				VM_BUG_ON(page_node->head != &migrate_nodes);
 				/*
-				 * Test if the migrated page should be merged
-				 * into a stable node dup. If the mapcount is
-				 * 1 we can migrate it with another KSM page
-				 * without adding it to the chain.
+				 * If the mapcount of our migrated KSM folio is
+				 * at most 1, we can merge it with another
+				 * KSM folio where we know that we have space
+				 * for one more mapping without exceeding the
+				 * ksm_max_page_sharing limit: see
+				 * chain_prune(). This way, we can avoid adding
+				 * this stable node to the chain.
 				 */
-				if (page_mapcount(page) > 1)
+				if (folio_mapcount(folio) > 1)
 					goto chain_append;
 			}
 
_

Patches currently in -mm which might be from david@redhat.com are


