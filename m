Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DC678B5C
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 19:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579489; cv=none; b=lQS5s/VWr4CJrMnftjaDg6XWVLR0s1ZrpXDyHUxeygGSC+LzWXdQ/sbQtxQ7Y4WB8gUH8a7fKeXrxladvVbqsQN+OulvNtzPJnq8s7kHGDpMpdHeKP4ZrUKW7Z9MXL04viIAo7CNLmnO4F0+ktoIz7cvNXE4vIFORTog0XfwfIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579489; c=relaxed/simple;
	bh=QolAhQ+376xmNBvyYIDupoDc4bXkPheTlOYfWFd/zhI=;
	h=Date:To:From:Subject:Message-Id; b=EuezhPQ8rVhCJX2CDyP82H8QnZIFKLCbCmE9rbAW32fIzHGXzGCLp3ggDQsk9DxHB6Ep9mudvIPC+jM41IJadlMKDXLIGKEDhy5d5KeI0jXuQgO0bzRgoBdROuCNjeKX4hwzkueJIVXQvoNUwp0v04iZzJXxcpTqfLUDBx5WEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bb24oI8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bb24oI8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF45C433F1;
	Mon,  4 Mar 2024 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709579488;
	bh=QolAhQ+376xmNBvyYIDupoDc4bXkPheTlOYfWFd/zhI=;
	h=Date:To:From:Subject:From;
	b=Bb24oI8aHIaToC73HQihMmPGgnc7ObawpEe2RFWG0d9H2RG4YM8NBrU5dhy9MWmgd
	 IKbLtEGp+CXhurq5u7UWExZcbx/ba+9uiMf38ZAlwTmvV5DlfnqPxhIgeRZ1Ed0EF0
	 iGeV9Ci0G/omTOehY68X0IUAfoTcqjj5Er84r48o=
Date: Mon, 04 Mar 2024 11:11:28 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,broonie@kernel.org,ardb@kernel.org,aishwarya.tcv@arm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-__dump_folio-fix-3.patch added to mm-unstable branch
Message-Id: <20240304191128.CBF45C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-__dump_folio-fix-3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-__dump_folio-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-__dump_folio-fix-3.patch

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

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch
mm-use-folio-more-widely-in-__split_huge_page.patch
mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

