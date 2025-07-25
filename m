Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB8C21ABD7
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409726; cv=none; b=Z18sACUahwaCQjRGQaVs0xTWlIumOHMIEpr3pCgnqOHDt/24Pc856NHuXkgZawVjZ+yqKHZtv44p7Cy5eftRedNTFdz2UlpLXKF2eeon0tGMmTUuQdcmm/NpQxT5En3PBkxCRPL74csF2+tUKMiLl9NmTXYWZtWVblE+C82rrY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409726; c=relaxed/simple;
	bh=dTmHIOXk13HJAeH88pKqKqNCf8lJdpCVD5SmaVL2wS0=;
	h=Date:To:From:Subject:Message-Id; b=N1cEUSqM+0RpY+50w9+IhDc88UCOaBDgc10fpX+CxM7oEYsxqvOJDbTCdI3B5XRF4ATIQpPoM0CcUrwADe/aG62IDbjmzsyihptbiwjw/mSRHqjLhAsQ8ymn+FlLz72sxdoNjb3SY1d3dQgU1EOkAShX1a6yK9RtyY6YUnnyw4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i2plX68L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i2plX68L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AF9C4CEED;
	Fri, 25 Jul 2025 02:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409726;
	bh=dTmHIOXk13HJAeH88pKqKqNCf8lJdpCVD5SmaVL2wS0=;
	h=Date:To:From:Subject:From;
	b=i2plX68LmtRHl1h/4qv1/BW7NzHs8K/TY7pzyPubSw6pw96TzyPlABG7e7fgQl0UC
	 EtTQiouB4B6EoWujc10JHj0lvN0/QoFq5Bs/VrFchCGLIYhSS1G/92f9KPTWrVzGtJ
	 PEdW2JUwuRUu5KIwvorzjvv78nGW8+NiAWM7KzTQ=
Date: Thu, 24 Jul 2025 19:15:25 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,antonio@mandelbit.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch removed from -mm tree
Message-Id: <20250725021526.58AF9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: get frozen folio refcount with folio_expected_ref_count()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: get frozen folio refcount with folio_expected_ref_count()
Date: Fri, 18 Jul 2025 14:37:19 -0400

Instead of open coding the refcount calculation, use
folio_expected_ref_count() to calculate frozen folio refcount.  Because:

1. __folio_split() does not split a folio with PG_private, so no elevated
   refcount from PG_private;
2. a frozen folio in __folio_split() is fully unmapped, so folio_mapcount()
   in folio_expected_ref_count() is always 0;
3. (mapping || swap_cache) ? folio_nr_pages(folio) is taken care of by
   folio_expected_ref_count() too.

Link: https://lkml.kernel.org/r/20250718023000.4044406-6-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250718183720.4054515-6-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count
+++ a/mm/huge_memory.c
@@ -3731,6 +3731,7 @@ static int __folio_split(struct folio *f
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct address_space *swap_cache = NULL;
 		struct lruvec *lruvec;
+		int expected_refs;
 
 		if (folio_order(folio) > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
@@ -3794,11 +3795,8 @@ static int __folio_split(struct folio *f
 		     new_folio = next) {
 			next = folio_next(new_folio);
 
-			folio_ref_unfreeze(
-				new_folio,
-				1 + ((mapping || swap_cache) ?
-					     folio_nr_pages(new_folio) :
-					     0));
+			expected_refs = folio_expected_ref_count(new_folio) + 1;
+			folio_ref_unfreeze(new_folio, expected_refs);
 
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -3828,8 +3826,8 @@ static int __folio_split(struct folio *f
 		 * Otherwise, a parallel folio_try_get() can grab @folio
 		 * and its caller can see stale page cache entries.
 		 */
-		folio_ref_unfreeze(folio, 1 +
-			((mapping || swap_cache) ? folio_nr_pages(folio) : 0));
+		expected_refs = folio_expected_ref_count(folio) + 1;
+		folio_ref_unfreeze(folio, expected_refs);
 
 		unlock_page_lruvec(lruvec);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info.patch

