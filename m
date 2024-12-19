Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64FC1EA90;
	Thu, 19 Dec 2024 03:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577539; cv=none; b=PKjGIGnrl9O4UkzCHS/gZkL8JS1mJDB+g3AnI88MJQ6/ugfUmE/AuO2kT5fw8fmY1bbWJnNlcxlYxn/t2g3CDeKQ2d0eIv6ovGdwdltR9i+AbId6BvottGRVFiItixpV+17CXpR9OpLZs5hghLrGt7SfAa2Ks/+ee3tmTrpH9pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577539; c=relaxed/simple;
	bh=6WOdsX02LGCO8WoeqUNVKZa3iiRV9ZQt3aooAsZdY74=;
	h=Date:To:From:Subject:Message-Id; b=Y6WYLienX2+weEWSA0OwldvCc0TqVxSMBHln/pRNkiaEvyrLUL3K+y3r0EbHAQuYltKAQkEX962wRRJyn1DwgeL1dE9g+C/O24F5GhQLN48TiRNfvJtM0w/1kNQrujaW5Pm9buCbaaU6hx3wtqcEAn/DNuqsXex7WRhR0Q7aroY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sLdjYZD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sLdjYZD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B7BC4CECD;
	Thu, 19 Dec 2024 03:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577538;
	bh=6WOdsX02LGCO8WoeqUNVKZa3iiRV9ZQt3aooAsZdY74=;
	h=Date:To:From:Subject:From;
	b=sLdjYZD9bcSByS1c1fC8DKLnPYLA6TWIIn5C9ycyDAPPB1mC+vkkOTtcFbF8Egb8h
	 N7WLhZ8wZaf/gr5oWuCiqPrh0f6V0H6EZGN8hX4akmvnMTgJJ62W+mtYzZAdfbavuN
	 b8s7yw5argKT8RwiVbg0JywCDCP1d8FezN4ikQyM=
Date: Wed, 18 Dec 2024 19:05:38 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,stable@vger.kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-convert-partially_mapped-set-clear-operations-to-be-atomic.patch removed from -mm tree
Message-Id: <20241219030538.B8B7BC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert partially_mapped set/clear operations to be atomic
has been removed from the -mm tree.  Its filename was
     mm-convert-partially_mapped-set-clear-operations-to-be-atomic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: convert partially_mapped set/clear operations to be atomic
Date: Thu, 12 Dec 2024 18:33:51 +0000

Other page flags in the 2nd page, like PG_hwpoison and PG_anon_exclusive
can get modified concurrently.  Changes to other page flags might be lost
if they are happening at the same time as non-atomic partially_mapped
operations.  Hence, make partially_mapped operations atomic.

Link: https://lkml.kernel.org/r/20241212183351.1345389-1-usamaarif642@gmail.com
Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
Reported-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/all/e53b04ad-1827-43a2-a1ab-864c7efecf6e@redhat.com/
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 ++----------
 mm/huge_memory.c           |    8 ++++----
 2 files changed, 6 insertions(+), 14 deletions(-)

--- a/include/linux/page-flags.h~mm-convert-partially_mapped-set-clear-operations-to-be-atomic
+++ a/include/linux/page-flags.h
@@ -862,18 +862,10 @@ static inline void ClearPageCompound(str
 	ClearPageHead(page);
 }
 FOLIO_FLAG(large_rmappable, FOLIO_SECOND_PAGE)
-FOLIO_TEST_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
-/*
- * PG_partially_mapped is protected by deferred_split split_queue_lock,
- * so its safe to use non-atomic set/clear.
- */
-__FOLIO_SET_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
-__FOLIO_CLEAR_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
+FOLIO_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
 #else
 FOLIO_FLAG_FALSE(large_rmappable)
-FOLIO_TEST_FLAG_FALSE(partially_mapped)
-__FOLIO_SET_FLAG_NOOP(partially_mapped)
-__FOLIO_CLEAR_FLAG_NOOP(partially_mapped)
+FOLIO_FLAG_FALSE(partially_mapped)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
--- a/mm/huge_memory.c~mm-convert-partially_mapped-set-clear-operations-to-be-atomic
+++ a/mm/huge_memory.c
@@ -3577,7 +3577,7 @@ int split_huge_page_to_list_to_order(str
 		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
 			if (folio_test_partially_mapped(folio)) {
-				__folio_clear_partially_mapped(folio);
+				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
@@ -3689,7 +3689,7 @@ bool __folio_unqueue_deferred_split(stru
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
 		if (folio_test_partially_mapped(folio)) {
-			__folio_clear_partially_mapped(folio);
+			folio_clear_partially_mapped(folio);
 			mod_mthp_stat(folio_order(folio),
 				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
@@ -3733,7 +3733,7 @@ void deferred_split_folio(struct folio *
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
-			__folio_set_partially_mapped(folio);
+			folio_set_partially_mapped(folio);
 			if (folio_test_pmd_mappable(folio))
 				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
@@ -3826,7 +3826,7 @@ static unsigned long deferred_split_scan
 		} else {
 			/* We lost race with folio_put() */
 			if (folio_test_partially_mapped(folio)) {
-				__folio_clear_partially_mapped(folio);
+				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
_

Patches currently in -mm which might be from usamaarif642@gmail.com are


