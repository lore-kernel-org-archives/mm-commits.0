Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA76154C08
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 23:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723763667; cv=none; b=ME1+GL1gUfs83h7rIx1pdBPfThMcDN8ZQRIMnGqf+3k/cobgeCnE0cDwMeGJGClEUCY0e/ZbH+cD7SH0sC5he2iIM9wQ8jmGG4g+Z2KngH0OlYXf59OkygB5Ac6+wpuQc3yWr0neDCxSMRwC10GIPNzYdcuYa7RyMa6hGHch8M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723763667; c=relaxed/simple;
	bh=vsVbTSXML5dNgfAXklYx0alb9b+p8VLgFNXFkjlUbJI=;
	h=Date:To:From:Subject:Message-Id; b=t6J4ZKWI5t8lJ8InzUsx86IgA6Wo9fkI39eGflcUsBguHxRqcMZoAsMvyb3wGlJ3QhW8xOcb0EtD7VqS5nYlvgAVdEL+/LadFFRF/+oA09qt2BJlor75P31Cnjhenj7m1hqTSUkhkVA3r/BQVJqVdpKnzgsKK6qhTd4TPMSy4MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PgxDcLBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PgxDcLBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A1CC32786;
	Thu, 15 Aug 2024 23:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723763666;
	bh=vsVbTSXML5dNgfAXklYx0alb9b+p8VLgFNXFkjlUbJI=;
	h=Date:To:From:Subject:From;
	b=PgxDcLBxHV7KY4LmMqJW9hsRRgDMfrwRGfyKowj6bdWmA8ustiT0KpMANV27HjqgM
	 XiTOo0ox4RAqxV1E7x1l/hvB1BypRHFlvKi82tzEOTCfrQ2Chb9+iKSiFgRFrefBTe
	 Wis5CvSfcGnH3sGLWsfpXyqB8lT/ABsHvym/NEv0=
Date: Thu, 15 Aug 2024 16:14:25 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,yuzhao@google.com,willy@infradead.org,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,link@vivo.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch added to mm-unstable branch
Message-Id: <20240815231426.97A1CC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-introduce-a-pageflag-for-partially-mapped-folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm-introduce-a-pageflag-for-partially-mapped-folios-fix
Date: Thu, 15 Aug 2024 16:25:09 +0100

don't clear partially mapped bit in hugeTLB folios and fix deferred split THP stats

Link: https://lkml.kernel.org/r/4acdf2b7-ed65-4087-9806-8f4a187b4eb5@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Huan Yang <link@vivo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuang Zhai <zhais@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    1 +
 mm/huge_memory.c           |   14 ++++++++------
 mm/hugetlb.c               |    1 -
 mm/rmap.c                  |    2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

--- a/include/linux/page-flags.h~mm-introduce-a-pageflag-for-partially-mapped-folios-fix
+++ a/include/linux/page-flags.h
@@ -863,6 +863,7 @@ static inline void ClearPageCompound(str
 }
 FOLIO_FLAG(large_rmappable, FOLIO_SECOND_PAGE)
 FOLIO_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
+FOLIO_TEST_SET_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
 #else
 FOLIO_FLAG_FALSE(large_rmappable)
 FOLIO_FLAG_FALSE(partially_mapped)
--- a/mm/huge_memory.c~mm-introduce-a-pageflag-for-partially-mapped-folios-fix
+++ a/mm/huge_memory.c
@@ -3452,6 +3452,7 @@ void __folio_undo_large_rmappable(struct
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 }
 
+/* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
@@ -3481,16 +3482,17 @@ void deferred_split_folio(struct folio *
 		return;
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	if (partially_mapped)
-		folio_set_partially_mapped(folio);
-	else
-		folio_clear_partially_mapped(folio);
-	if (list_empty(&folio->_deferred_list)) {
-		if (partially_mapped) {
+	if (partially_mapped) {
+		if (!folio_test_set_partially_mapped(folio)) {
 			if (folio_test_pmd_mappable(folio))
 				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
 		}
+	} else {
+		/* partially mapped folios cannot become non-partially mapped */
+		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
+	}
+	if (list_empty(&folio->_deferred_list)) {
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
--- a/mm/hugetlb.c~mm-introduce-a-pageflag-for-partially-mapped-folios-fix
+++ a/mm/hugetlb.c
@@ -1758,7 +1758,6 @@ static void __update_and_free_hugetlb_fo
 		free_gigantic_folio(folio, huge_page_order(h));
 	} else {
 		INIT_LIST_HEAD(&folio->_deferred_list);
-		folio_clear_partially_mapped(folio);
 		folio_put(folio);
 	}
 }
--- a/mm/rmap.c~mm-introduce-a-pageflag-for-partially-mapped-folios-fix
+++ a/mm/rmap.c
@@ -1578,7 +1578,7 @@ static __always_inline void __folio_remo
 	 * Check partially_mapped first to ensure it is a large folio.
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
-	    list_empty(&folio->_deferred_list))
+	    !folio_test_partially_mapped(folio))
 		deferred_split_folio(folio, true);
 
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-free-zapped-tail-pages-when-splitting-isolated-thp-fix.patch
mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch
mm-split-underutilized-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch

