Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBCFC2C9
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 00:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376464; cv=none; b=NaBqAq8iYKAzhpwBmqCmNTQ7rjdslI2Q1dwPYAOivC8yIUAKLdrKOooe6t3YD99/vyfCQvl5zwiBTubHkOgrINXTlUDUppJ179pWr+cM4+mTwnicZROc8TkAuYWgxSG8kaSYM/7tpNGeFaY2lVelnBGrz1ixeDx+YdmUlCQ+fAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376464; c=relaxed/simple;
	bh=CNZ3F5kmkkMQubZbuNBLJhAGXp8MK89QV13DQHA+vkM=;
	h=Date:To:From:Subject:Message-Id; b=YRPQcsBR6ALQ+b9LhBbstF20GqJBL94TExGx48vm+I4v+pXJZuLs3zRcURVkigv9bK1r0gBfLyrmqB1ZWVmVz/W8Tfg+vHN6v4bRjFSfkyZ8rMggfZZPj1yVB1sj7d0OMtbnQcMFvq+s+I83oIr2jcy1AR7GdmYzSkhfwO3tdFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2QuwEAuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2QuwEAuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4220C4CEF1;
	Tue,  9 Sep 2025 00:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757376464;
	bh=CNZ3F5kmkkMQubZbuNBLJhAGXp8MK89QV13DQHA+vkM=;
	h=Date:To:From:Subject:From;
	b=2QuwEAuTI/vDhjMQ1B2L0eWeU65JwkvGlVqVsT9qekog0cc/aJrgR3eAi6KYG0iFV
	 4eV3Ws4zuydESAU3/cjDyOEZAzZCCuxvUmhbmiT3iQ6m+Clp8g/6WnMNFDQfw1aiLq
	 QtG2FTHf9E+Kpez/5OKNpoHnEopGYxlCBTZA25Vw=
Date: Mon, 08 Sep 2025 17:07:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,flyinrm@gmail.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch added to mm-new branch
Message-Id: <20250909000743.E4220C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
Date: Mon Sep  8 04:59:47 PM PDT 2025

tweak whitespace

Cc: Chanwon Park <flyinrm@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   42 +++++++++++++++++++++---------------------
 mm/show_mem.c   |    4 ++--
 2 files changed, 23 insertions(+), 23 deletions(-)

--- a/mm/page_alloc.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
+++ a/mm/page_alloc.c
@@ -2860,29 +2860,29 @@ static void free_frozen_page_commit(stru
 		 */
 		return;
 	}
+
 	high = nr_pcp_high(pcp, zone, batch, free_high);
-	if (pcp->count >= high) {
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-				   pcp, pindex);
-		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
-		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
-				      ZONE_MOVABLE, 0)) {
-			struct pglist_data *pgdat = zone->zone_pgdat;
-			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+	if (pcp->count < high)
+		return;
 
-			/*
-			 * Assume that memory pressure on this node is gone
-			 * and may be in a reclaimable state. If a memory
-			 * fallback node exists, direct reclaim may not have
-			 * been triggered, leaving 'hopeless node' stay in
-			 * that state for a while. Let kswapd work again by
-			 * resetting kswapd_failures.
-			 */
-			if (atomic_read(&pgdat->kswapd_failures)
-			    >= MAX_RECLAIM_RETRIES &&
-			    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
-				atomic_set(&pgdat->kswapd_failures, 0);
-		}
+	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
+			   pcp, pindex);
+	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
+	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
+			      ZONE_MOVABLE, 0)) {
+		struct pglist_data *pgdat = zone->zone_pgdat;
+		clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+
+		/*
+		 * Assume that memory pressure on this node is gone and may be
+		 * in a reclaimable state. If a memory fallback node exists,
+		 * direct reclaim may not have been triggered, causing a
+		 * 'hopeless node' to stay in that state for a while.  Let
+		 * kswapd work again by resetting kswapd_failures.
+		 */
+		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
+		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
+			atomic_set(&pgdat->kswapd_failures, 0);
 	}
 }
 
--- a/mm/show_mem.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
+++ a/mm/show_mem.c
@@ -278,8 +278,8 @@ static void show_free_areas(unsigned int
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			str_yes_no(atomic_read(&pgdat->kswapd_failures)
-				   >= MAX_RECLAIM_RETRIES),
+			str_yes_no(atomic_read(&pgdat->kswapd_failures) >=
+				   MAX_RECLAIM_RETRIES),
 			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
docs-mm-add-document-for-swap-table-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

