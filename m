Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEE77641D
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423501; cv=none; b=pcTCyFjlGGkSFkL1UEqov6D7gOOOkwr3sMsZYiWmyo/xDl0TmmJVaGh7g8uTSD/XSOtQbh7HsKQGyiiEFMyyCLOTsI7TtOacbOO93WdsY4TdbvQvj4xFdEE0lanYU8Q9NBhXROkrp1OpHU9qNMt9dgiWXRbMvurN3tHMCWvkaHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423501; c=relaxed/simple;
	bh=lpnJuIGkzglp6i0EZXGAiuY9i5npROAFJrOhHUEr6rw=;
	h=Date:To:From:Subject:Message-Id; b=ObKmJDipZblcbPJ2U3tqxo7T+SkuxiiGhhEE2EOfj3Dv+6hOcvCYj5nwIXHMhLYnvEpqKOqFYxoKEKAySeOlBwohUiMgzdFuy6XwjWvvm4GyQ4w6Jitjg2z2Z7R8/jtlemAjycD6Hr+aGJN2B1buzi3Np8kORHsWvE2TtlgZ8pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mod3j3Xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mod3j3Xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1197C4CEC2;
	Wed,  4 Sep 2024 04:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423500;
	bh=lpnJuIGkzglp6i0EZXGAiuY9i5npROAFJrOhHUEr6rw=;
	h=Date:To:From:Subject:From;
	b=mod3j3XeGKK+Mxx8tOrQPlxRmDbqArl40aZH/A+1xNJx4D6iUd+g5YbmUsnEnsnR+
	 M7esK/haVPDeAmnpmPC8q13Wz/EwfnTZiNNRFKBrsgNY5I4Oa9s+ByRPH/C/Z6hM8z
	 BIIYmSLv8fPROI+GDyyqvzQ/aHcIaqVwFkzY8rpo=
Date: Tue, 03 Sep 2024 21:18:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch removed from -mm tree
Message-Id: <20240904041820.D1197C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: use the number of pages in the folio to check the reference count
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: khugepaged: use the number of pages in the folio to check the reference count
Date: Tue, 20 Aug 2024 17:49:14 +0800

Use the number of pages in the folio to check the reference count as
preparation for supporting shmem mTHP collapse.

Link: https://lkml.kernel.org/r/9ea49262308de28957596cc6e8edc2d3a4f54659.1724140601.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count
+++ a/mm/khugepaged.c
@@ -1988,9 +1988,9 @@ static int collapse_file(struct mm_struc
 		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
 
 		/*
-		 * We control three references to the folio:
+		 * We control 2 + nr_pages references to the folio:
 		 *  - we hold a pin on it;
-		 *  - one reference from page cache;
+		 *  - nr_pages reference from page cache;
 		 *  - one from lru_isolate_folio;
 		 * If those are the only references, then any new usage
 		 * of the folio will have to fetch it from the page
@@ -1998,7 +1998,7 @@ static int collapse_file(struct mm_struc
 		 * truncate, so any new usage will be blocked until we
 		 * unlock folio after collapse/during rollback.
 		 */
-		if (folio_ref_count(folio) != 3) {
+		if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
 			result = SCAN_PAGE_COUNT;
 			xas_unlock_irq(&xas);
 			folio_putback_lru(folio);
@@ -2181,7 +2181,7 @@ immap_locked:
 		folio_clear_active(folio);
 		folio_clear_unevictable(folio);
 		folio_unlock(folio);
-		folio_put_refs(folio, 3);
+		folio_put_refs(folio, 2 + folio_nr_pages(folio));
 	}
 
 	goto out;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


