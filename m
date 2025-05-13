Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1C8183CB0
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118564; cv=none; b=n/venRTCWlB+dEiPksika7GVm6z0DjndTqPVD/2S/h1GxGgBwu4nwAaVC68UftbyU82zXJToDhwC4XpEp3RHMffsszecsCF98taNV4ZzzSRc7bOAtplkkhALKMsJs2a29eR490VR7J0wlhZn9O3olq/eTW0ZLf041DW9Kc6fm3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118564; c=relaxed/simple;
	bh=a97UBh808Kl3o7gGbtSWU67pe1vcSQimIaRICaoW0dI=;
	h=Date:To:From:Subject:Message-Id; b=VvKU/36IE/Wl8L+30OYxVyxNVHHX6bsJ7mjgZSQPzWD6YosGICd8CYvSphyvj/7JJ8ua++T+H92x5MrL1vqc5dxkh1uwXncV+X4dn0hoLYfd6aR7u3q7GikbFz0ZjbNa5KJJoSERH+0ZEWOmShpn3255NyR/CA/G/RO67PacRjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zVQAis6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zVQAis6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81670C4CEE4;
	Tue, 13 May 2025 06:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118563;
	bh=a97UBh808Kl3o7gGbtSWU67pe1vcSQimIaRICaoW0dI=;
	h=Date:To:From:Subject:From;
	b=zVQAis6DR9oYhUalTDfGEhZzLWuWTx+JEWiiAzwbRsi7X8r/3ma2Jim8EiRa+qvB9
	 H2jBhu/3afQ+RD+nyjyztzyOBAM13P8coLLcTIpSJdKnTzjCNGW4asaewr50H/An+L
	 0mJKpIfNw5Vl0zApqfhQvMPCBFEbb2Rq5UQXlpew=
Date: Mon, 12 May 2025 23:42:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,fan.ni@samsung.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch removed from -mm tree
Message-Id: <20250513064243.81670C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb.c: __unmap_hugepage_range(): comment cleanup
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch

This patch was dropped because it was folded into mm-kmemleak-mark-variables-as-__read_mostly.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb.c: __unmap_hugepage_range(): comment cleanup
Date: Mon May  5 02:54:25 PM PDT 2025

Wrap to 80 cols, fix a typo, use regular layout, parenthesize function
identifiers, fix grammar and add braces.

Cc: David Hildenbrand <david@redhat.com>
Cc: Fan Ni <fan.ni@samsung.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-__unmap_hugepage_range-comment-cleanup
+++ a/mm/hugetlb.c
@@ -5969,16 +5969,19 @@ void __unmap_hugepage_range(struct mmu_g
 		if (adjust_reservation) {
 			int rc = vma_needs_reservation(h, vma, address);
 
-			if (rc < 0)
-				/* Pressumably allocate_file_region_entries failed
-				 * to allocate a file_region struct. Clear
-				 * hugetlb_restore_reserve so that global reserve
-				 * count will not be incremented by free_huge_folio.
-				 * Act as if we consumed the reservation.
+			if (rc < 0) {
+				/*
+				 * Presumably allocate_file_region_entries()
+				 * failed to allocate a file_region struct.
+				 * Clear hugetlb_restore_reserve so that the
+				 * global reserve count will not be incremented
+				 * by free_huge_folio().  Act as if we consumed
+				 * the reservation.
 				 */
 				folio_clear_hugetlb_restore_reserve(folio);
-			else if (rc)
+			} else if (rc) {
 				vma_add_reservation(h, vma, address);
+			}
 		}
 
 		tlb_remove_page_size(tlb, folio_page(folio, 0),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

