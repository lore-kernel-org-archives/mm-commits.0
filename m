Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EB67D406
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274064; cv=none; b=krcpWuZs7AkOqV5U0hD+0fW/cPx7YE1QC/5AasM6z+JMAo7vmhLA05Tfm/KobjbHbo6ngBWsvhmWtlZLQrXtevo9DeIYzQxE+P+jzyGD/Dm3N6Srv5qXa8Tc3jLf3Qo6B2a1g1OCQkTGXAW3M7ydqT/OguMiWzaJIlYJRnn0eKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274064; c=relaxed/simple;
	bh=wbJdeLtxgVsS3tMQTv/q6cH/dx9ZYbdm2Mi6RWBsdec=;
	h=Date:To:From:Subject:Message-Id; b=L6syDAwSJRACHgFr8zZrswe/CAhI/qlNc9lzHYF/T6fdp+XlfDpzKHhvfG5Ki+41MiTOv3UBoascCwMQBeIF5ZWdnDb8CTL+zKmMvtlk378a0UwySlCDsTuBen7DYtvuEXN/VGeVGkCf/8qsB1Vnf5kWPyuud956vNk/F6d+K6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rbLdGwMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rbLdGwMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECB2C433C7;
	Tue, 12 Mar 2024 20:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274064;
	bh=wbJdeLtxgVsS3tMQTv/q6cH/dx9ZYbdm2Mi6RWBsdec=;
	h=Date:To:From:Subject:From;
	b=rbLdGwMMDm5hd9jhIuVjEN7k7tVxSZJ9mMZQJ7nkhNSiLaCDxF/MaXG8LEuxuvoej
	 crC59l2dWUyrI+Y3LnqQp1VlRJSAIYp9OldKgruq6m8uqCSvgGn7QHeAU/W2Nrqt4T
	 1mzEmNfWP1C2yoznqEggDB9B/1IvXV3pksXVx0Z0=
Date: Tue, 12 Mar 2024 13:07:43 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch removed from -mm tree
Message-Id: <20240312200744.3ECB2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove folio from deferred split list before uncharging it
has been removed from the -mm tree.  Its filename was
     mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove folio from deferred split list before uncharging it
Date: Mon, 11 Mar 2024 19:18:34 +0000

When freeing a large folio, we must remove it from the deferred split list
before we uncharge it as each memcg has its own deferred split list (with
associated lock) and removing a folio from the deferred split list while
holding the wrong lock will corrupt that list and cause various related
problems.

Link: https://lore.kernel.org/linux-mm/367a14f7-340e-4b29-90ae-bc3fcefdd5f4@arm.com/
Link: https://lkml.kernel.org/r/20240311191835.312162-1-willy@infradead.org
Fixes: f77171d241e3 (mm: allow non-hugetlb large folios to be batch processed)
Fixes: 29f3843026cf (mm: free folios directly in move_folios_to_lru())
Fixes: bc2ff4cbc329 (mm: free folios in a batch in shrink_folio_list())
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Debugged-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c   |    3 +++
 mm/vmscan.c |    6 ++++++
 2 files changed, 9 insertions(+)

--- a/mm/swap.c~mm-remove-folio-from-deferred-split-list-before-uncharging-it
+++ a/mm/swap.c
@@ -1012,6 +1012,9 @@ void folios_put_refs(struct folio_batch
 			free_huge_folio(folio);
 			continue;
 		}
+		if (folio_test_large(folio) &&
+		    folio_test_large_rmappable(folio))
+			folio_undo_large_rmappable(folio);
 
 		__page_cache_release(folio, &lruvec, &flags);
 
--- a/mm/vmscan.c~mm-remove-folio-from-deferred-split-list-before-uncharging-it
+++ a/mm/vmscan.c
@@ -1413,6 +1413,9 @@ free_it:
 		 */
 		nr_reclaimed += nr_pages;
 
+		if (folio_test_large(folio) &&
+		    folio_test_large_rmappable(folio))
+			folio_undo_large_rmappable(folio);
 		if (folio_batch_add(&free_folios, folio) == 0) {
 			mem_cgroup_uncharge_folios(&free_folios);
 			try_to_unmap_flush();
@@ -1819,6 +1822,9 @@ static unsigned int move_folios_to_lru(s
 		if (unlikely(folio_put_testzero(folio))) {
 			__folio_clear_lru_flags(folio);
 
+			if (folio_test_large(folio) &&
+			    folio_test_large_rmappable(folio))
+				folio_undo_large_rmappable(folio);
 			if (folio_batch_add(&free_folios, folio) == 0) {
 				spin_unlock_irq(&lruvec->lru_lock);
 				mem_cgroup_uncharge_folios(&free_folios);
_

Patches currently in -mm which might be from willy@infradead.org are


