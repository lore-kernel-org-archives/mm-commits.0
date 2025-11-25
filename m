Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC18329399
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 17:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090934; cv=none; b=n+HlNp40jBrPR7T0yG22vVKaVd7BdF59l5JDq/7FvHwwITctaBF5SYlMQcJO82mZRWcrYpbF0c0SS2wBvkCapW4P/DgdEUAc6t+kL3Fnv4B9G4Fet/EDQuOvQFzG9T3+EFUsn8xqhxFsqlHQkAoZ1SlHbgiTRAlsJy3+O61hLNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090934; c=relaxed/simple;
	bh=Rr6zT22FudKQYeYV7RuIHCfXvGxWigLjF13lUF1p8Lk=;
	h=Date:To:From:Subject:Message-Id; b=JN4d2KThcQ8u5UPwugD5q3FGjWFX0qNVJriBY/B6BhYn2qvRjG5sedy+Ea+BeFnrNqk/AhhITh4Ur7mvWWWBNdtCtnoZY0XpmOVrpdnqYjQI7xGlCKhnQKJgMmSU8PUcyjaBR1Y4xEBCk54G3URJK9bHPtMMH0hQdN2MYaSeXaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aa1/RFzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aa1/RFzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6505CC16AAE;
	Tue, 25 Nov 2025 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764090934;
	bh=Rr6zT22FudKQYeYV7RuIHCfXvGxWigLjF13lUF1p8Lk=;
	h=Date:To:From:Subject:From;
	b=aa1/RFzz4AXJYS6PwzMlmh/NJs839cDwKzNWDN+ABwg93G7dKxJycm/Juv9jaJB4k
	 /2Zgh0xDJ/JGYQGjqUQ0xlB1CMQ9Ri8gGLA7yvXr5jANHxq+2Ph6K+q5XavU4R2jVE
	 fIsqnwkxqicBk5AWSa1Q3Xjjxwy1v0PGAq86gHuo=
Date: Tue, 25 Nov 2025 09:15:33 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-restoring-of-contiguous-ranges-of-order-0-pages.patch added to mm-nonmm-unstable branch
Message-Id: <20251125171534.6505CC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix restoring of contiguous ranges of order-0 pages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-fix-restoring-of-contiguous-ranges-of-order-0-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-restoring-of-contiguous-ranges-of-order-0-pages.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: fix restoring of contiguous ranges of order-0 pages
Date: Tue, 25 Nov 2025 13:09:17 +0200

When contiguous ranges of order-0 pages are restored, kho_restore_page()
calls prep_compound_page() with the first page in the range and order as
parameters and then kho_restore_pages() calls split_page() to make sure
all pages in the range are order-0.

However, since split_page() is not intended to split compound pages and
with VM_DEBUG enabled it will trigger a VM_BUG_ON_PAGE().

Update kho_restore_page() so that it will use prep_compound_page() when it
restores a folio and make sure it properly sets page count for both large
folios and ranges of order-0 pages.

Link: https://lkml.kernel.org/r/20251125110917.843744-3-rppt@kernel.org
Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-restoring-of-contiguous-ranges-of-order-0-pages
+++ a/kernel/liveupdate/kexec_handover.c
@@ -219,11 +219,11 @@ static int __kho_preserve_order(struct k
 	return 0;
 }
 
-static struct page *kho_restore_page(phys_addr_t phys)
+static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
+	unsigned int nr_pages, ref_cnt;
 	union kho_page_info info;
-	unsigned int nr_pages;
 
 	if (!page)
 		return NULL;
@@ -243,11 +243,16 @@ static struct page *kho_restore_page(phy
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
 
-	/* For higher order folios, tail pages get a page count of zero. */
+	/*
+	 * For higher order folios, tail pages get a page count of zero.
+	 * For physically contiguous order-0 pages every pages gets a page
+	 * count of 1
+	 */
+	ref_cnt = is_folio ? 0 : 1;
 	for (unsigned int i = 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
+		set_page_count(page + i, ref_cnt);
 
-	if (info.order > 0)
+	if (is_folio && info.order)
 		prep_compound_page(page, info.order);
 
 	adjust_managed_page_count(page, nr_pages);
@@ -262,7 +267,7 @@ static struct page *kho_restore_page(phy
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = kho_restore_page(phys);
+	struct page *page = kho_restore_page(phys, true);
 
 	return page ? page_folio(page) : NULL;
 }
@@ -287,11 +292,10 @@ struct page *kho_restore_pages(phys_addr
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		struct page *page = kho_restore_page(PFN_PHYS(pfn));
+		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
 
 		if (!page)
 			return NULL;
-		split_page(page, order);
 		pfn += 1 << order;
 	}
 
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch
kho-drop-notifiers.patch
kho-kho_restore_vmalloc-fix-initialization-of-pages-array.patch
kho-fix-restoring-of-contiguous-ranges-of-order-0-pages.patch

