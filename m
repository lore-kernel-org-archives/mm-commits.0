Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F9D13AEB
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U2uBG289"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9171C433C8;
	Fri, 29 Dec 2023 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880096;
	bh=Jq2Qo2Xw64LIo3BkSpw9PSOeCAaRrU5/IWot/x1AwI4=;
	h=Date:To:From:Subject:From;
	b=U2uBG289KWKrGEEgrTOxuL/vRnvGEI8EcQsweUXPL4NItW1rYqjY0N90swV1JO85f
	 ajNYNZs0pjt3cU9zSqzipgW8OCKxQXetHrFSb46MIWDiVV0/6r2Ov3Z2PmJxDrUt3J
	 RuGwsH/oQuP3qI6RPFgbDSR/f4dNXnkwZPzqCkXo=
Date: Fri, 29 Dec 2023 12:01:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-page_add_file_rmap.patch removed from -mm tree
Message-Id: <20231229200135.E9171C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: remove page_add_file_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-page_add_file_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: remove page_add_file_rmap()
Date: Wed, 20 Dec 2023 23:44:36 +0100

All users are gone, let's remove it.

Link: https://lkml.kernel.org/r/20231220224504.646757-13-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 --
 mm/rmap.c            |   21 ---------------------
 2 files changed, 23 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-remove-page_add_file_rmap
+++ a/include/linux/rmap.h
@@ -237,8 +237,6 @@ void page_add_anon_rmap(struct page *, s
 		unsigned long address, rmap_t flags);
 void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
-void page_add_file_rmap(struct page *, struct vm_area_struct *,
-		bool compound);
 void folio_add_file_rmap_ptes(struct folio *, struct page *, int nr_pages,
 		struct vm_area_struct *);
 #define folio_add_file_rmap_pte(folio, page, vma) \
--- a/mm/rmap.c~mm-rmap-remove-page_add_file_rmap
+++ a/mm/rmap.c
@@ -1468,27 +1468,6 @@ void folio_add_file_rmap_pmd(struct foli
 }
 
 /**
- * page_add_file_rmap - add pte mapping to a file page
- * @page:	the page to add the mapping to
- * @vma:	the vm area in which the mapping is added
- * @compound:	charge the page as compound or small page
- *
- * The caller needs to hold the pte lock.
- */
-void page_add_file_rmap(struct page *page, struct vm_area_struct *vma,
-		bool compound)
-{
-	struct folio *folio = page_folio(page);
-
-	VM_WARN_ON_ONCE_PAGE(compound && !PageTransHuge(page), page);
-
-	if (likely(!compound))
-		folio_add_file_rmap_pte(folio, page, vma);
-	else
-		folio_add_file_rmap_pmd(folio, page, vma);
-}
-
-/**
  * page_remove_rmap - take down pte mapping from a page
  * @page:	page to remove mapping from
  * @vma:	the vm area from which the mapping is removed
_

Patches currently in -mm which might be from david@redhat.com are


