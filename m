Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC8714288
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 20:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709671654; cv=none; b=nue06iGXM53oAK/4maSwsAcK8ZvvROZYTm1n+nBIGZcOZb+4iUMpK5N8N0Ii3YBJwaNU8J15srVbcXzA2IYEzOVtXGRgt7Xgv9GJ85PhxV0RRkGxzBhSm8YN/zcjw46DJeI6uBxkAMWxfKcHk2Ses3HYXU3VAKLbOetKEgtjkRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709671654; c=relaxed/simple;
	bh=BESQcmmVW+nWE4jEPMN87yUjLJ5kT1KAAPyIirsW7bk=;
	h=Date:To:From:Subject:Message-Id; b=HdizYYTq7qzqLMJzR8KEOL0+/bELzUhTmt8Enj+7CqHKdXrBN6Jl8tO+v6s71IkK95M4rzKmBEvA7Y1pn7V10M3UAG/tGU3az12RPUZuj8MvLUVf3mmv6I7A06NX2CbLqUSiQdqs4e1CTQ2a5oOKI/trCu5KPUcYnp57X5sY/Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wJbYik80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wJbYik80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E35C433F1;
	Tue,  5 Mar 2024 20:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709671653;
	bh=BESQcmmVW+nWE4jEPMN87yUjLJ5kT1KAAPyIirsW7bk=;
	h=Date:To:From:Subject:From;
	b=wJbYik80VHa4T/ztJAYv4z5O5Idl5ZmT0A2vIv2G+4qOdHUmQGT/WdrRPIX8xkv3+
	 hYciWUMGjmpCSrZ84y+jtGTAm1wXzAR5j8tWTTPNK+t1uuHSp37Vkc7m4cqCLpQPue
	 0ucBh51cQeY5c+QAqq33CT+1y9T199Aa6VvYS7+s=
Date: Tue, 05 Mar 2024 12:47:33 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-__dump_folio-fix.patch removed from -mm tree
Message-Id: <20240305204733.95E35C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-__dump_folio-fix
has been removed from the -mm tree.  Its filename was
     mm-add-__dump_folio-fix.patch

This patch was dropped because it was folded into mm-add-__dump_folio.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-add-__dump_folio-fix
Date: Thu, 29 Feb 2024 04:37:31 +0000

fix build issue

Link: https://lkml.kernel.org/r/ZeAKCyTn_xS3O9cE@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +++++++
 mm/debug.c         |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-add-__dump_folio-fix
+++ a/include/linux/mm.h
@@ -2066,6 +2066,13 @@ static inline long folio_nr_pages(struct
 #endif
 }
 
+/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
+#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
+#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
+#else
+#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
+#endif
+
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
--- a/mm/debug.c~mm-add-__dump_folio-fix
+++ a/mm/debug.c
@@ -125,7 +125,7 @@ again:
 	foliop = page_folio(&precise);
 	idx = folio_page_idx(foliop, page);
 	if (idx != 0) {
-		if (idx < (1UL << PUD_ORDER)) {
+		if (idx < MAX_FOLIO_NR_PAGES) {
 			memcpy(&folio, foliop, 2 * sizeof(struct page));
 			nr_pages = folio_nr_pages(&folio);
 		}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

