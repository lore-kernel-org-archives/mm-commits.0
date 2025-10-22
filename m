Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C892F90DE
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761169505; cv=none; b=XuZs6amPn7SiC6+dQ5Pu78oufr2yWuxMEFmW6lAZfLO2KUEf+mSFWAbLwd+348EjD/pwE623WOQIuk8nzxDy/QMTRHuZbBtKi0lOpNcFrp5mYtL8wJgy1l16pAOw/0kucnG2AMeaxw0t1am5E0FLPobYwRksjuIHjvPzB1K7XLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761169505; c=relaxed/simple;
	bh=iVffukcxtgiTDTOg1HhBDYuLd8ra6lp+VgD4MOIqDAI=;
	h=Date:To:From:Subject:Message-Id; b=TDl+N5zSy8wahAhj5zQKrYNc0G1N2jP2oQdvvzftMfZoLuQUdgfI267CeMS2cDQefsj75u9tGGyfipU26xp6pT/vjcWHIqKxLyLNXc9U9A5Ai4PUCI4oMPVDFRVfuVXuMIZIpFxoxqjMG1KyVhEapnSJ6UPT0j0s7IAAGToydmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kmPokCan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kmPokCan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA77C4CEFD;
	Wed, 22 Oct 2025 21:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761169504;
	bh=iVffukcxtgiTDTOg1HhBDYuLd8ra6lp+VgD4MOIqDAI=;
	h=Date:To:From:Subject:From;
	b=kmPokCanLIGefUPrq/t9r+Job1NW+KGOzn+rm+ieF4hv4n7CYDrjDDJ2MUkLAHKHj
	 8KuiiMyv4ENiNkbvreWxKcwmgW/v4uuE2f97Mo4rUszYgMQjcN+U2B6ae0dgM3M3Iu
	 EJxq0CfUM50dPhwfAhftxWQ/PfhqpNeu7JpptrlA=
Date: Wed, 22 Oct 2025 14:45:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-update-folio-stat-after-successful-split.patch added to mm-new branch
Message-Id: <20251022214504.4DA77C4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: update folio stat after successful split
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-update-folio-stat-after-successful-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-update-folio-stat-after-successful-split.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: update folio stat after successful split
Date: Tue, 21 Oct 2025 21:21:40 +0000

The current implementation complicates this process:

  * It iterates over the resulting new folios.
  * It uses a flag (@stop_split) to conditionally skip updating the stat
    for the folio at @split_at during the loop.
  * It then attempts to update the skipped stat on a subsequent failure
    path.

This logic is unnecessarily hard to follow.

This commit refactors the code to update the folio statistics only after a
successful split.  This makes the logic much cleaner and sets the stage
for further simplification of the stat-handling code.

Link: https://lkml.kernel.org/r/20251021212142.25766-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   44 +++++++++++---------------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-update-folio-stat-after-successful-split
+++ a/mm/huge_memory.c
@@ -3609,13 +3609,8 @@ static int __split_unmapped_folio(struct
 	const bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
-	bool stop_split = false;
 	struct folio *next;
 	int split_order;
-	int ret = 0;
-
-	if (is_anon)
-		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	folio_clear_has_hwpoisoned(folio);
 
@@ -3624,7 +3619,7 @@ static int __split_unmapped_folio(struct
 	 * folio is split to new_order directly.
 	 */
 	for (split_order = start_order;
-	     split_order >= new_order && !stop_split;
+	     split_order >= new_order;
 	     split_order--) {
 		struct folio *end_folio = folio_next(folio);
 		int old_order = folio_order(folio);
@@ -3647,49 +3642,32 @@ static int __split_unmapped_folio(struct
 			else {
 				xas_set_order(xas, folio->index, split_order);
 				xas_try_split(xas, folio, old_order);
-				if (xas_error(xas)) {
-					ret = xas_error(xas);
-					stop_split = true;
-				}
+				if (xas_error(xas))
+					return xas_error(xas);
 			}
 		}
 
-		if (!stop_split) {
-			folio_split_memcg_refs(folio, old_order, split_order);
-			split_page_owner(&folio->page, old_order, split_order);
-			pgalloc_tag_split(folio, old_order, split_order);
-
-			__split_folio_to_order(folio, old_order, split_order);
-		}
+		folio_split_memcg_refs(folio, old_order, split_order);
+		split_page_owner(&folio->page, old_order, split_order);
+		pgalloc_tag_split(folio, old_order, split_order);
+		__split_folio_to_order(folio, old_order, split_order);
 
+		if (is_anon)
+			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
 		/*
 		 * Iterate through after-split folios and update folio stats.
-		 * But in buddy allocator like split, the folio
-		 * containing the specified page is skipped until its order
-		 * is new_order, since the folio will be worked on in next
-		 * iteration.
 		 */
 		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
 			next = folio_next(new_folio);
-			/*
-			 * for buddy allocator like split, new_folio containing
-			 * @split_at page could be split again, thus do not
-			 * change stats yet. Wait until new_folio's order is
-			 * @new_order or stop_split is set to true by the above
-			 * xas_split() failure.
-			 */
-			if (new_folio == page_folio(split_at)) {
+			if (new_folio == page_folio(split_at))
 				folio = new_folio;
-				if (split_order != new_order && !stop_split)
-					continue;
-			}
 			if (is_anon)
 				mod_mthp_stat(folio_order(new_folio),
 					      MTHP_STAT_NR_ANON, 1);
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-avoid-reinvoking-folio_test_anon.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch

