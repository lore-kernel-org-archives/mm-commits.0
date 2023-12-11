Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B214D582
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J/hBB8Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB2EC433C9;
	Mon, 11 Dec 2023 17:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702315420;
	bh=k+g8koCP6CF2uohLQFZGE8BfJAsux7ZtK00L0k7LmIE=;
	h=Date:To:From:Subject:From;
	b=J/hBB8FwNCYQ8tooPPT+eNm3ZE0mH1OnFBqq82yIaPytuJ2Jiw7TYTWEJozOvMCSM
	 mDTiuEFPgYgZSKaUCIcBnbOCNcpfF97RISVgzNQUPSlV+gJqynPhc6r3bIN1Z53gor
	 8gQBVStwe179PRx1NNv7ZnP9ptSkWGgalnN63+40=
Date: Mon, 11 Dec 2023 09:23:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-some-calls-to-page_add_new_anon_rmap.patch added to mm-unstable branch
Message-Id: <20231211172340.2CB2EC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove some calls to page_add_new_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-some-calls-to-page_add_new_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-some-calls-to-page_add_new_anon_rmap.patch

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
Subject: mm: remove some calls to page_add_new_anon_rmap()
Date: Mon, 11 Dec 2023 16:22:09 +0000

We already have the folio in these functions, we just need to use it. 
folio_add_new_anon_rmap() didn't exist at the time they were converted to
folios.

Link: https://lkml.kernel.org/r/20231211162214.2146080-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    2 +-
 mm/memory.c             |    2 +-
 mm/userfaultfd.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/events/uprobes.c~mm-remove-some-calls-to-page_add_new_anon_rmap
+++ a/kernel/events/uprobes.c
@@ -181,7 +181,7 @@ static int __replace_page(struct vm_area
 
 	if (new_page) {
 		folio_get(new_folio);
-		page_add_new_anon_rmap(new_page, vma, addr);
+		folio_add_new_anon_rmap(new_folio, vma, addr);
 		folio_add_lru_vma(new_folio, vma);
 	} else
 		/* no new page, just dec_mm_counter for old_page */
--- a/mm/memory.c~mm-remove-some-calls-to-page_add_new_anon_rmap
+++ a/mm/memory.c
@@ -4068,7 +4068,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	/* ksm created a completely new copy */
 	if (unlikely(folio != swapcache && swapcache)) {
-		page_add_new_anon_rmap(page, vma, vmf->address);
+		folio_add_new_anon_rmap(folio, vma, vmf->address);
 		folio_add_lru_vma(folio, vma);
 	} else {
 		page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
--- a/mm/userfaultfd.c~mm-remove-some-calls-to-page_add_new_anon_rmap
+++ a/mm/userfaultfd.c
@@ -116,7 +116,7 @@ int mfill_atomic_install_pte(pmd_t *dst_
 			folio_add_lru(folio);
 		page_add_file_rmap(page, dst_vma, false);
 	} else {
-		page_add_new_anon_rmap(page, dst_vma, dst_addr);
+		folio_add_new_anon_rmap(folio, dst_vma, dst_addr);
 		folio_add_lru_vma(folio, dst_vma);
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-simplify-the-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

