Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD13C13A26F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854760; cv=none; b=B1yC0crcM4hLnc8nToBrCJN1Gkr2yWW+Iklx5mXcjyQxsWOlogbWGTnb5UT2gO0ZNWgOt81N0btIXkh8yOlG96cM0A05gqLL8IJLTplVJBK6rLbOguwwxf3iEOe8Att7OLi38JYwgcSbmej2b8BAdUFAhfctf/cr/TLmeAGinm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854760; c=relaxed/simple;
	bh=ebeICnQ6n2ibKA7A6QbS79V/e93xOZ7Nh1I4yQhrA0g=;
	h=Date:To:From:Subject:Message-Id; b=m4FFG0N8VmoFkGmGZzpO4bGJIiyDdilBcpPn7n/kE8rRTHr859qxK+IgjViaE1092VCwk1ongkApYRcSWQyrTst7nMUmfDKmT8IBmTcE4n9jyrco4y2GiGl2mkpR7hSxS5JaiDav48sd4lw5ftFhLHFHzaAhjFCGAk6bG6szVT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cP3KnTjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cP3KnTjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC2CC4CECF;
	Wed,  6 Nov 2024 00:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854760;
	bh=ebeICnQ6n2ibKA7A6QbS79V/e93xOZ7Nh1I4yQhrA0g=;
	h=Date:To:From:Subject:From;
	b=cP3KnTjl2Quzt4FFuHhhwIUDFxDYDJ0SqglKNbOszKeEa5XxcIbVMBjtNuF2+jarP
	 I6EWuXjIiYk5iIw9r4bfzXO0RufEo9AN0Jp24YfB5t5WIizqUmUFyYkO1Y6BdHdjI2
	 ITHEMe9W9cztqNDbxDDiM91deLq92eCjTjXSBpIA=
Date: Tue, 05 Nov 2024 16:59:20 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-pageanonnotksm.patch removed from -mm tree
Message-Id: <20241106005920.8EC2CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add PageAnonNotKsm()
has been removed from the -mm tree.  Its filename was
     mm-add-pageanonnotksm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add PageAnonNotKsm()
Date: Wed, 2 Oct 2024 16:25:30 +0100

Check that this anonymous page is really anonymous, not anonymous-or-KSM. 
This optimises the debug check, but its real purpose is to remove the last
two users of PageKsm().

[willy@infradead.org: fix assertions]
  Link: https://lkml.kernel.org/r/ZwApWPER7caIA_N3@casper.infradead.org
Link: https://lkml.kernel.org/r/20241002152533.1350629-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-add-pageanonnotksm
+++ a/include/linux/page-flags.h
@@ -689,6 +689,13 @@ static __always_inline bool folio_test_a
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_ANON) != 0;
 }
 
+static __always_inline bool PageAnonNotKsm(const struct page *page)
+{
+	unsigned long flags = (unsigned long)page_folio(page)->mapping;
+
+	return (flags & PAGE_MAPPING_FLAGS) == PAGE_MAPPING_ANON;
+}
+
 static __always_inline bool PageAnon(const struct page *page)
 {
 	return folio_test_anon(page_folio(page));
@@ -1137,14 +1144,14 @@ static __always_inline int PageAnonExclu
 
 static __always_inline void SetPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(!PageAnon(page) || PageKsm(page), page);
+	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
 
 static __always_inline void ClearPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(!PageAnon(page) || PageKsm(page), page);
+	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch
nilfs2-remove-nilfs_writepage.patch
nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch
nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch
nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

