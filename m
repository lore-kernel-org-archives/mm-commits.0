Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B4814006
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vXxkHppY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD5AC433C8;
	Fri, 29 Dec 2023 20:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880106;
	bh=RFe/V/6jTWISaXS+TeSlN3d3Pl2tlSjnzi74pVRZebc=;
	h=Date:To:From:Subject:From;
	b=vXxkHppYpVX3kxNpYgtHQLhAJ1znqfN1JDytiLgjRqkBOusaZ5YVJxaduAjBI6Ohq
	 5YosdP5wP2qnFCdFxpxDWLVRK5Nx1V/Zg0tgwlYqxvS8BoAjG29TXfNBtnQFifS0/0
	 U82PneJYKxZ1NsZRHha9DlZCKgnYfXzJdJC52zKA=
Date: Fri, 29 Dec 2023 12:01:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-rmap_compound.patch removed from -mm tree
Message-Id: <20231229200145.EAD5AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: remove RMAP_COMPOUND
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-rmap_compound.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: remove RMAP_COMPOUND
Date: Wed, 20 Dec 2023 23:44:46 +0100

No longer used, let's remove it and clarify RMAP_NONE/RMAP_EXCLUSIVE a
bit.

Link: https://lkml.kernel.org/r/20231220224504.646757-23-david@redhat.com
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

 include/linux/rmap.h |   12 +++---------
 mm/rmap.c            |    2 --
 2 files changed, 3 insertions(+), 11 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-remove-rmap_compound
+++ a/include/linux/rmap.h
@@ -177,21 +177,15 @@ struct anon_vma *folio_get_anon_vma(stru
 typedef int __bitwise rmap_t;
 
 /*
- * No special request: if the page is a subpage of a compound page, it is
- * mapped via a PTE. The mapped (sub)page is possibly shared between processes.
+ * No special request: A mapped anonymous (sub)page is possibly shared between
+ * processes.
  */
 #define RMAP_NONE		((__force rmap_t)0)
 
-/* The (sub)page is exclusive to a single process. */
+/* The anonymous (sub)page is exclusive to a single process. */
 #define RMAP_EXCLUSIVE		((__force rmap_t)BIT(0))
 
 /*
- * The compound page is not mapped via PTEs, but instead via a single PMD and
- * should be accounted accordingly.
- */
-#define RMAP_COMPOUND		((__force rmap_t)BIT(1))
-
-/*
  * Internally, we're using an enum to specify the granularity. We make the
  * compiler emit specialized code for each granularity.
  */
--- a/mm/rmap.c~mm-rmap-remove-rmap_compound
+++ a/mm/rmap.c
@@ -2662,8 +2662,6 @@ void rmap_walk_locked(struct folio *foli
  * The following two functions are for anonymous (private mapped) hugepages.
  * Unlike common anonymous pages, anonymous hugepages have no accounting code
  * and no lru code, because we handle hugepages differently from common pages.
- *
- * RMAP_COMPOUND is ignored.
  */
 void hugetlb_add_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		unsigned long address, rmap_t flags)
_

Patches currently in -mm which might be from david@redhat.com are


