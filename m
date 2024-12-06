Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37F8184540;
	Fri,  6 Dec 2024 03:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457326; cv=none; b=H4oywXvrfKuQWlkCxZWfzYfvW8NI8UBGtMKGaKQm5g44cUuIKdLI4M1Zpe2vLOxmed0ALvmbCQvNYYwzwv1tRDppJP2zMU6g6vwrDLzybqHUgD0c4CkFFhOvB9mkji6kb+WwVnMKD5Yq6aFMN53jicW3hLi9n07Edirg4Svvjgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457326; c=relaxed/simple;
	bh=mzaxPi9aId1L4JPegbhW6Xg5R7eSkr7HrgERes8Na84=;
	h=Date:To:From:Subject:Message-Id; b=M5arJRFWGq9bxdXadws7SizoY2zGF41RAbQwiCfVhJlVHzSDZ/y5NZDzDRSZBvJKvCP5OuhJ7JuKc0KVhkPtt0XpeMC9xTx6mNDRc4rF5Jn57BsTbM8FifTDw2bkLJvvWfQUqRnBz38i68DuOyw3e/56+TB7c2KqztjRvxjQV0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dy5OUrgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dy5OUrgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86139C4CED1;
	Fri,  6 Dec 2024 03:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457326;
	bh=mzaxPi9aId1L4JPegbhW6Xg5R7eSkr7HrgERes8Na84=;
	h=Date:To:From:Subject:From;
	b=dy5OUrggPlMyV0YbM91Lhu27XSsd9aNtj7Avty1ZXmZqZ3OEUXh3rWz6/h8kIQz1N
	 AjQ2n1ezygTO/BuaQObhZW2oiaGnjstowQ11ZNEi+j9JjqY8G8dgHHMGg5ObfBpT9V
	 cWbM4JiS6xR5PcUsdbhBj6jn56Ph0djFv5/NdUpY=
Date: Thu, 05 Dec 2024 19:55:26 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-open-code-page_folio-in-dump_page.patch removed from -mm tree
Message-Id: <20241206035526.86139C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: open-code page_folio() in dump_page()
has been removed from the -mm tree.  Its filename was
     mm-open-code-page_folio-in-dump_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: open-code page_folio() in dump_page()
Date: Mon, 25 Nov 2024 20:17:19 +0000

page_folio() calls page_fixed_fake_head() which will misidentify this page
as being a fake head and load off the end of 'precise'.  We may have a
pointer to a fake head, but that's OK because it contains the right
information for dump_page().

gcc-15 is smart enough to catch this with -Warray-bounds:

In function 'page_fixed_fake_head',
    inlined from '_compound_head' at ../include/linux/page-flags.h:251:24,
    inlined from '__dump_page' at ../mm/debug.c:123:11:
../include/asm-generic/rwonce.h:44:26: warning: array subscript 9 is outside
+array bounds of 'struct page[1]' [-Warray-bounds=]

Link: https://lkml.kernel.org/r/20241125201721.2963278-2-willy@infradead.org
Fixes: fae7d834c43c ("mm: add __dump_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/debug.c~mm-open-code-page_folio-in-dump_page
+++ a/mm/debug.c
@@ -124,19 +124,22 @@ static void __dump_page(const struct pag
 {
 	struct folio *foliop, folio;
 	struct page precise;
+	unsigned long head;
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long idx, nr_pages = 1;
 	int loops = 5;
 
 again:
 	memcpy(&precise, page, sizeof(*page));
-	foliop = page_folio(&precise);
-	if (foliop == (struct folio *)&precise) {
+	head = precise.compound_head;
+	if ((head & 1) == 0) {
+		foliop = (struct folio *)&precise;
 		idx = 0;
 		if (!folio_test_large(foliop))
 			goto dump;
 		foliop = (struct folio *)page;
 	} else {
+		foliop = (struct folio *)(head - 1);
 		idx = folio_page_idx(foliop, page);
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch

