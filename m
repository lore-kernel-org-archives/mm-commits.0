Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F8414294
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R+KnZS+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C8DC433C8;
	Fri, 29 Dec 2023 20:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880114;
	bh=xIthTktfqmJBTjlgSqRUnX36nSY4XQmo7Rkokv0zT14=;
	h=Date:To:From:Subject:From;
	b=R+KnZS+LGllvyz1SYYZbMLodxIA7OJBcMzQX4Ye+22+xtdbnomLWAX++D0P8vXp8D
	 ahwZjAvDnZNpZwBrVWb+d+gon/YnQo/LP4QCJ0boRMsbzcgHFksdtrdDJrDAfz3dt3
	 hlAo8/QlqXG7iAaQgiFYlRBz1YpVOJoV8dbvx7kU=
Date: Fri, 29 Dec 2023 12:01:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-page_remove_rmap-folio_remove_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200154.46C8DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: page_remove_rmap() -> folio_remove_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-rmap-page_remove_rmap-folio_remove_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: page_remove_rmap() -> folio_remove_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:54 +0100

Let's convert try_to_unmap_one() and try_to_migrate_one().

Link: https://lkml.kernel.org/r/20231220224504.646757-31-david@redhat.com
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

 mm/rmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~mm-rmap-page_remove_rmap-folio_remove_rmap_pte
+++ a/mm/rmap.c
@@ -1647,7 +1647,7 @@ static bool try_to_unmap_one(struct foli
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
-	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
+	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
 	 * try_to_unmap() may return before page_mapped() has become false,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
@@ -1928,7 +1928,7 @@ discard:
 		if (unlikely(folio_test_hugetlb(folio)))
 			hugetlb_remove_rmap(folio);
 		else
-			page_remove_rmap(subpage, vma, false);
+			folio_remove_rmap_pte(folio, subpage, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put(folio);
@@ -1996,7 +1996,7 @@ static bool try_to_migrate_one(struct fo
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
-	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
+	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
 	 * try_to_migrate() may return before page_mapped() has become false,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
@@ -2289,7 +2289,7 @@ static bool try_to_migrate_one(struct fo
 		if (unlikely(folio_test_hugetlb(folio)))
 			hugetlb_remove_rmap(folio);
 		else
-			page_remove_rmap(subpage, vma, false);
+			folio_remove_rmap_pte(folio, subpage, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put(folio);
@@ -2428,7 +2428,7 @@ static bool page_make_device_exclusive_o
 		 * There is a reference on the page for the swap entry which has
 		 * been removed, so shouldn't take another.
 		 */
-		page_remove_rmap(subpage, vma, false);
+		folio_remove_rmap_pte(folio, subpage, vma);
 	}
 
 	mmu_notifier_invalidate_range_end(&range);
_

Patches currently in -mm which might be from david@redhat.com are


