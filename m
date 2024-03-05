Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D35F14288
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 20:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709671656; cv=none; b=n5/+lu/CV/RHYbxthMuw/Gf+D4kvRn3dr518bLMvqVEDfrkkCkjLy54+8+aKEm0tu1JsogW47oZcbpFdUYUyqXfELrO2X5pI0iN800CGvlmmjS1dW+stdQvy9+YDRzj9RF8dcZD080vyl/QKj9VxszkEc8NEn4tPS2qSYBwGT/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709671656; c=relaxed/simple;
	bh=F2i9OScWrsTTPnm5I4OUlmDo22AxJII7ykZ0TtJGJ7k=;
	h=Date:To:From:Subject:Message-Id; b=ScmCEWdo1CSE2l03pixBcUNPorJmrr22NLpYVoKRCkBhrvDFqn4MSvuUGBiJJZLmwZIrbEbfCwUUpWGblbqTtjwnD46WOfGWL56ObLSjRYz8PJ6bSskT0Q5D6dlbdKQxrvk3/pWhB6eRayxlmiLGQbCrtmdZpSB7jUVs0vY5LhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=usnVMV2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="usnVMV2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8AAC433C7;
	Tue,  5 Mar 2024 20:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709671655;
	bh=F2i9OScWrsTTPnm5I4OUlmDo22AxJII7ykZ0TtJGJ7k=;
	h=Date:To:From:Subject:From;
	b=usnVMV2yieVrBvl33uQlHtqyj/TCKIdZxdMyYpvcsfGyBfLa7GttFrqWoRwY3JN0X
	 lEF4eBjm2SiG5AqXzsJ6Kpl8g3x+tUZh0L8bconwSoVLGyEMh3PviarkLIYH/9Zg72
	 W6L+f3te5wNsCtBdbuo8Swn/IqJ7yfhDkg/hp8gw=
Date: Tue, 05 Mar 2024 12:47:35 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,broonie@kernel.org,ardb@kernel.org,aishwarya.tcv@arm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-__dump_folio-fix-3.patch removed from -mm tree
Message-Id: <20240305204735.DA8AAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-__dump_folio-fix-3
has been removed from the -mm tree.  Its filename was
     mm-add-__dump_folio-fix-3.patch

This patch was dropped because it was folded into mm-add-__dump_folio.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-add-__dump_folio-fix-3
Date: Mon, 4 Mar 2024 19:02:43 +0000

Further testing revealed some more problems.  We were getting confused
between various different pointers leading to spurious messages about
the page not matching the folio and passing the wrong pointer to
__dump_folio().  Here's a fix-3 patch which I tested like so:

+static int __init page_dump(void)
+{
+       struct page *page;
+
+       printk("testing page dump\n");
+
+       page = alloc_page(GFP_KERNEL);
+       dump_page(page, "single");
+       put_page(page);
+       page = alloc_pages(GFP_KERNEL | __GFP_COMP, 2);
+       dump_page(page, "head");
+       dump_page(page + 1, "tail 1");
+       dump_page(page + 2, "tail 2");
+       dump_page(page + 3, "tail 3");
+       put_page(page);
+
+       return 0;
+}
+
+module_init(page_dump);

(needed some extra debug to check the values of the pointers being
passed to __dump_folio() which we wouldn't want to include)

Link: https://lkml.kernel.org/r/ZeYa00ixxC4k1ot-@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/mm/debug.c~mm-add-__dump_folio-fix-3
+++ a/mm/debug.c
@@ -121,23 +121,31 @@ static void __dump_page(const struct pag
 again:
 	memcpy(&precise, page, sizeof(*page));
 	foliop = page_folio(&precise);
-	idx = folio_page_idx(foliop, page);
-	if (idx != 0) {
-		if (idx < MAX_FOLIO_NR_PAGES) {
-			memcpy(&folio, foliop, 2 * sizeof(struct page));
-			nr_pages = folio_nr_pages(&folio);
-		}
+	if (foliop == (struct folio *)&precise) {
+		idx = 0;
+		if (!folio_test_large(foliop))
+			goto dump;
+		foliop = (struct folio *)page;
+	} else {
+		idx = folio_page_idx(foliop, page);
+	}
+
+	if (idx < MAX_FOLIO_NR_PAGES) {
+		memcpy(&folio, foliop, 2 * sizeof(struct page));
+		nr_pages = folio_nr_pages(&folio);
+		foliop = &folio;
+	}
 
-		if (idx > nr_pages) {
-			if (loops-- > 0)
-				goto again;
-			printk("page does not match folio\n");
-			precise.compound_head &= ~1UL;
-			foliop = (struct folio *)&precise;
-			idx = 0;
-		}
+	if (idx > nr_pages) {
+		if (loops-- > 0)
+			goto again;
+		printk("page does not match folio\n");
+		precise.compound_head &= ~1UL;
+		foliop = (struct folio *)&precise;
+		idx = 0;
 	}
 
+dump:
 	__dump_folio(foliop, &precise, pfn, idx);
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

