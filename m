Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FE23C10BA
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896808; cv=none; b=hYH3hdLmtWI6nJWXFZl2w31jmIxtWZcbTcmujUL73m/BuCclgNhjkQV24OW0YDi00KSfY96zCDx32DqO97kM3YJJsYufGOG6GTkZBIK+6tkpqv1QRy3pCYMO9GFtLpQToS5W/dYG2oFHnnvB+O/nWAeyyn/FhLpjJd49TzgJrII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896808; c=relaxed/simple;
	bh=uR4DcrgpMO3dDAezbw6sdiwo9Fhoh6+iKiSFJPRorWY=;
	h=Date:To:From:Subject:Message-Id; b=LYkI+txc9FDaWSTeEij6jOdnXfg8AbLKY7QN+a5dv9/C6YEBa/OeODZk4xNQLZaFSvPWLaagN3F+hfE+IcVfVYknB4xjGNBlCl4KuLEZsAr+Sd081ntnQjClaPBAMYp3nc3t2YC1KJfTTEgz1lbWbP8W5ljp2epbboNpKIwhJII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LeYOzsks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LeYOzsks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0631F00A3D;
	Wed,  5 Aug 2026 02:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896807;
	bh=3TyC9BTo0mnCAR5nEhP23IT/MArYZe0zc9f3p9h/KBA=;
	h=Date:To:From:Subject;
	b=LeYOzsksEwwnB2OTvDdoUcExsMzGKjDefMIjnUElEuAoxbYbGjOkpGudg0PlIShn8
	 gCzScfedcKjpLVkQO7Rk+o9YzimAbp5fIctleiKt5k/TcUgnTQTCg6TPSs6gwXXo/r
	 5kRtnjB0b3NCT/I+gJkP/idy+NR2UpFSwXxgqsMQ=
Date: Tue, 04 Aug 2026 19:26:46 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-convert-page-folio-for-hwpoison-checks.patch removed from -mm tree
Message-Id: <20260805022646.EF0631F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: convert page -> folio for hwpoison checks
has been removed from the -mm tree.  Its filename was
     mm-rmap-convert-page-folio-for-hwpoison-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: convert page -> folio for hwpoison checks
Date: Thu, 30 Jul 2026 09:45:52 +0000

Patch series "mm/rmap: Refactor try_to_unmap_one", v4.

In preparation for batching anonymous large folio unmapping to optimize
it, refactor try_to_unmap_one.  This series refactors hugetlb,
anon-lazyfree and anon-swapbacked logic into their own functions,
significantly reducing the length of the huge try_to_unmap_one.


This patch (of 5):

try_to_unmap() receives hugetlb folios only from the hwpoison path. 
hugetlb_update_hwpoison() sets the hugetlb folio's head-page hwpoison bit,
and page_vma_mapped_walk() reports the hugetlb mapping at the head PFN, so
the previous PageHWPoison(subpage) check happened to work for hugetlb.

For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
folios before calling try_to_unmap().  Hence it is always the case that if
try_to_unmap_one() handles an hwpoisoned folio, then the head page is
marked with the poison bit.

Therefore, convert the poisoned subpage checks to folio_test_hwpoison().

No functional change intended, except that, while at it,
convert VM_BUG_* to VM_WARN_*.

Link: https://lore.kernel.org/20260730094559.418003-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260730094559.418003-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-convert-page-folio-for-hwpoison-checks
+++ a/mm/rmap.c
@@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct foli
 			bool anon = folio_test_anon(folio);
 
 			/*
-			 * The try_to_unmap() is only passed a hugetlb page
-			 * in the case where the hugetlb page is poisoned.
+			 * The try_to_unmap() is only passed a hugetlb folio
+			 * in the case where the hugetlb folio contains a
+			 * poisoned page.
 			 */
-			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
+			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -2204,7 +2205,8 @@ static bool try_to_unmap_one(struct foli
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
+		/* unmap_poisoned_folio() only refs order-0 or hugetlb folios */
+		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

