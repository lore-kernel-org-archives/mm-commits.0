Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D184D582
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ux9qOtSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16598C433C8;
	Mon, 11 Dec 2023 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702315424;
	bh=ZdUbg/mDfKDSW8/W+oR6E2EhgL79yOKSLhzLuDC9hoI=;
	h=Date:To:From:Subject:From;
	b=ux9qOtSKnLz6y3fm7L0ZGoPJJdL/bd8gj+VJhg+jpvKQLgbazhwC4ncKrOpK28uFd
	 flr1Mu8zpd4kW0NwaPkhAzc5jDpD1nD1HnId3QzvnHTYBgHd05Gj/1w0AArQ63dOyP
	 f8/s9YPcJaEUrxa2HYFRcQN/6iske4XAgmUj3/cE=
Date: Mon, 11 Dec 2023 09:23:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch added to mm-unstable branch
Message-Id: <20231211172344.16598C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove references to page_add_new_anon_rmap in comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch

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
Subject: mm: remove references to page_add_new_anon_rmap in comments
Date: Mon, 11 Dec 2023 16:22:11 +0000

Refer to folio_add_new_anon_rmap() instead.

Link: https://lkml.kernel.org/r/20231211162214.2146080-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-remove-references-to-page_add_new_anon_rmap-in-comments
+++ a/mm/rmap.c
@@ -1231,9 +1231,9 @@ static void __page_check_anon_rmap(struc
 	 * We have exclusion against page_add_anon_rmap because the caller
 	 * always holds the page locked.
 	 *
-	 * We have exclusion against page_add_new_anon_rmap because those pages
+	 * We have exclusion against folio_add_new_anon_rmap because those pages
 	 * are initially only visible via the pagetables, and the pte is locked
-	 * over the call to page_add_new_anon_rmap.
+	 * over the call to folio_add_new_anon_rmap.
 	 */
 	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
 			folio);
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

