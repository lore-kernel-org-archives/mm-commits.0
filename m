Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC5C14D280
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567198; cv=none; b=sVHu/c/9SO1Pq2m7LnjwoCnFQQeSdAlgpweu/s7CfYEmFqR9wy5kGPeasZ6OTji9ZcsM/WBpCoVZzbmXn4OIL+bvgq+s6/crmYeFY3h4zEQja7zNx8v0qXmYuyBBaQho4y/1NgI2/OT1QTEb+QCfBQ5ll27w7SnqRN+dMkScn3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567198; c=relaxed/simple;
	bh=GEqem8+0OLBeoKlzFOw14VZiDDkhDHm4qQ9ZMiGo8uY=;
	h=Date:To:From:Subject:Message-Id; b=LbeoLfPyLdGh99qtP2HCdsrElx6lmXhGmOk3vosv1irdAYw3wTwzbILjmKCkB/7TTS/bQlt7tscX6vj+P63II9dcdLLxY4g5oGd3RZbbrbeK2D3KX6S9o2pcjg9i0y548U54Vq6bhN3DNgA8BROyh6fHHZecmN1UxELVAvd9IOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=chucnPcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="chucnPcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B58C433C7;
	Wed, 27 Mar 2024 19:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711567197;
	bh=GEqem8+0OLBeoKlzFOw14VZiDDkhDHm4qQ9ZMiGo8uY=;
	h=Date:To:From:Subject:From;
	b=chucnPcQGt/uh0WMmHDulq5ZESZ5DxAOLkY/iVkJc1xWIYJFSO2/D6iAFs44nTqVR
	 TJRjbcHLRBexqSD2tQuqT0DJPOlGWhV2qvpLmtUzn3tRf6V5b+FqRCygoBOoXCZdLT
	 QUQFMo9PQPL76NsGPC5sDJ0FDzh0AR5leT+0YlBo=
Date: Wed, 27 Mar 2024 12:19:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-__set_page_dirty.patch added to mm-unstable branch
Message-Id: <20240327191957.C1B58C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: remove __set_page_dirty()
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-remove-__set_page_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-remove-__set_page_dirty.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: remove __set_page_dirty()
Date: Wed, 27 Mar 2024 18:54:29 +0000

All callers have been converted to use folios; remove this wrapper.

Link: https://lkml.kernel.org/r/20240327185447.1076689-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-__set_page_dirty
+++ a/include/linux/pagemap.h
@@ -1147,11 +1147,6 @@ void folio_end_writeback(struct folio *f
 void wait_for_stable_page(struct page *page);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
-static inline void __set_page_dirty(struct page *page,
-		struct address_space *mapping, int warn)
-{
-	__folio_mark_dirty(page_folio(page), mapping, warn);
-}
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
 static inline void folio_cancel_dirty(struct folio *folio)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch

