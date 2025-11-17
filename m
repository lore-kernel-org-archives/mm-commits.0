Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5847A23183C
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343228; cv=none; b=sz/umb8uu/cdTaE5K8ImZZuwfTSzikRLwFzIrPNksVCmMJ4A0teFnEf7IUmL0lCocT2AgBjWldYqWm0GjI8HUODWOwIxxR6yuCGNFGVty/dxyULIoXM0cH7pxiiE7Go2P2Qq/xag+Wkk/iiqwbOW0GTJijJ5WwioA4S/8RzyRg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343228; c=relaxed/simple;
	bh=r97r5FnAoMdzL9WkX8dJ604Y29c2yFM/EEXE8owgDkE=;
	h=Date:To:From:Subject:Message-Id; b=PDa0Nd0LMyaOri+pMRVES0fOojW2xIXobL2JUUlqYWEMmOqc0xCRbzkYwYdnBomeOLH5j7b4WzeZ4fbNg1+jvyFP20cUG8UxFMRNs5MWq44Sbw02efO3XPvosL5G0tOcKcDiOwnVH2d9BuN3gKDx6NUCKkjN9uF/HVG22rdZgrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mrIwpJCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mrIwpJCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8667C4CEF1;
	Mon, 17 Nov 2025 01:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343227;
	bh=r97r5FnAoMdzL9WkX8dJ604Y29c2yFM/EEXE8owgDkE=;
	h=Date:To:From:Subject:From;
	b=mrIwpJCS2Wh9E6eAN7pjoJrY6RVu+43tfpnvnMmCvHYvA80bOYFryPOeSEUPAYts9
	 AimrLlNrP4zr6Tc22McsLMfwbiOgkdKDPtEIAAvokrMhGxUj47q3vPsYXWk9lqBGa1
	 kQuEf5pDCxrGAJbT+NUUDY1tS7/GWzCt5qDn0yjc=
Date: Sun, 16 Nov 2025 17:33:47 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-update-folio-stat-after-successful-split.patch removed from -mm tree
Message-Id: <20251117013347.D8667C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: update folio stat after successful split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-update-folio-stat-after-successful-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   44 +++++++++++---------------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-update-folio-stat-after-successful-split
+++ a/mm/huge_memory.c
@@ -3404,20 +3404,15 @@ static int __split_unmapped_folio(struct
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
 
 	/*
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
 	 */
 	for (split_order = start_order;
-	     split_order >= new_order && !stop_split;
+	     split_order >= new_order;
 	     split_order--) {
 		struct folio *end_folio = folio_next(folio);
 		int old_order = folio_order(folio);
@@ -3440,49 +3435,32 @@ static int __split_unmapped_folio(struct
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

mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch
mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch
mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch
mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch

