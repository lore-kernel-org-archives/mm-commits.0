Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D9C13AF1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w902pBGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB47C433C7;
	Fri, 29 Dec 2023 20:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880115;
	bh=4Wcdq2jgK/UVYerzoiShf6uZqytbXdsXjjY4CYAIUoQ=;
	h=Date:To:From:Subject:From;
	b=w902pBGXoE7ts3oiSy8foFfvUPlY6bOyDxfqUs4/dciCDcxLbNCHstbTwOmEerSVQ
	 xG9SglHbt33ieddoxsmqygwofcg1o/UZ8fakl/1jBKarAVCO3Xho4xA3tYZolev2Qy
	 0e5xj1zM5RCVp6B6sPiHSbQJh0viIjNoyM7ydG5c=
Date: Fri, 29 Dec 2023 12:01:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-stop-referring-to-page_remove_rmap.patch removed from -mm tree
Message-Id: <20231229200155.5EB47C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: stop referring to page_remove_rmap()
has been removed from the -mm tree.  Its filename was
     documentation-stop-referring-to-page_remove_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: Documentation: stop referring to page_remove_rmap()
Date: Wed, 20 Dec 2023 23:44:55 +0100

Refer to folio_remove_rmap_*() instaed.

Link: https://lkml.kernel.org/r/20231220224504.646757-32-david@redhat.com
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

 Documentation/mm/transhuge.rst       |    2 +-
 Documentation/mm/unevictable-lru.rst |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/transhuge.rst~documentation-stop-referring-to-page_remove_rmap
+++ a/Documentation/mm/transhuge.rst
@@ -156,7 +156,7 @@ Partial unmap and deferred_split_folio()
 
 Unmapping part of THP (with munmap() or other way) is not going to free
 memory immediately. Instead, we detect that a subpage of THP is not in use
-in page_remove_rmap() and queue the THP for splitting if memory pressure
+in folio_remove_rmap_*() and queue the THP for splitting if memory pressure
 comes. Splitting will free up unused subpages.
 
 Splitting the page right away is not an option due to locking context in
--- a/Documentation/mm/unevictable-lru.rst~documentation-stop-referring-to-page_remove_rmap
+++ a/Documentation/mm/unevictable-lru.rst
@@ -486,7 +486,7 @@ munlock the pages if we're removing the
 Before the unevictable/mlock changes, mlocking did not mark the pages in any
 way, so unmapping them required no processing.
 
-For each PTE (or PMD) being unmapped from a VMA, page_remove_rmap() calls
+For each PTE (or PMD) being unmapped from a VMA, folio_remove_rmap_*() calls
 munlock_vma_folio(), which calls munlock_folio() when the VMA is VM_LOCKED
 (unless it was a PTE mapping of a part of a transparent huge page).
 
@@ -511,7 +511,7 @@ userspace; truncation even unmaps and de
 which had been Copied-On-Write from the file pages now being truncated.
 
 Mlocked pages can be munlocked and deleted in this way: like with munmap(),
-for each PTE (or PMD) being unmapped from a VMA, page_remove_rmap() calls
+for each PTE (or PMD) being unmapped from a VMA, folio_remove_rmap_*() calls
 munlock_vma_folio(), which calls munlock_folio() when the VMA is VM_LOCKED
 (unless it was a PTE mapping of a part of a transparent huge page).
 
_

Patches currently in -mm which might be from david@redhat.com are


