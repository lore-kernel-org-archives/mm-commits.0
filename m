Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FDE14284
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0hQENJkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E54DC433C8;
	Fri, 29 Dec 2023 20:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880121;
	bh=OFCnNx3AM2fVpcp6FT0nd1X7wKCmsZfNxS1YjlSe3co=;
	h=Date:To:From:Subject:From;
	b=0hQENJkIGxkCLKXYIgqwfYLJg5f/ZtoqEo219DwKgqyF8pwbPbrlohPUCGiLwXjn+
	 4nos85SwFA3rUB6l6uI2XRnBAoRfuMBSqiKc6s7KZx83CO0aLOkIxHuidkagpSr+uW
	 RNtfgxHlCu3O/lGreN3qSjVOQZRUDJRcJIgyleGc=
Date: Fri, 29 Dec 2023 12:02:00 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-page_try_dup_anon_rmap.patch removed from -mm tree
Message-Id: <20231229200201.5E54DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: remove page_try_dup_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-page_try_dup_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: remove page_try_dup_anon_rmap()
Date: Wed, 20 Dec 2023 23:45:01 +0100

All users are gone, remove page_try_dup_anon_rmap() and any remaining
traces.

Link: https://lkml.kernel.org/r/20231220224504.646757-38-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-remove-page_try_dup_anon_rmap
+++ a/include/linux/rmap.h
@@ -253,7 +253,7 @@ void hugetlb_add_anon_rmap(struct folio
 void hugetlb_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
 
-/* See page_try_dup_anon_rmap() */
+/* See folio_try_dup_anon_rmap_*() */
 static inline int hugetlb_try_dup_anon_rmap(struct folio *folio,
 		struct vm_area_struct *vma)
 {
@@ -478,16 +478,6 @@ static inline int folio_try_dup_anon_rma
 #endif
 }
 
-static inline int page_try_dup_anon_rmap(struct page *page, bool compound,
-					 struct vm_area_struct *vma)
-{
-	struct folio *folio = page_folio(page);
-
-	if (likely(!compound))
-		return folio_try_dup_anon_rmap_pte(folio, page, vma);
-	return folio_try_dup_anon_rmap_pmd(folio, page, vma);
-}
-
 /**
  * page_try_share_anon_rmap - try marking an exclusive anonymous page possibly
  *			      shared to prepare for KSM or temporary unmapping
@@ -496,8 +486,8 @@ static inline int page_try_dup_anon_rmap
  * The caller needs to hold the PT lock and has to have the page table entry
  * cleared/invalidated.
  *
- * This is similar to page_try_dup_anon_rmap(), however, not used during fork()
- * to duplicate a mapping, but instead to prepare for KSM or temporarily
+ * This is similar to folio_try_dup_anon_rmap_*(), however, not used during
+ * fork() to duplicate a mapping, but instead to prepare for KSM or temporarily
  * unmapping a page (swap, migration) via folio_remove_rmap_*().
  *
  * Marking the page shared can only fail if the page may be pinned; device
_

Patches currently in -mm which might be from david@redhat.com are


