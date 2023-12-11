Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC394D582
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g7QEmZZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FB8C433C8;
	Mon, 11 Dec 2023 17:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702315422;
	bh=ZO5YdQQpbAZs1B5req6L0CpAr18VKmyWTW2evntAIw4=;
	h=Date:To:From:Subject:From;
	b=g7QEmZZEaJQCrNYHTmhAouaq2W5Ya7xfx659bJ2pe1/jyWVG1PTNHsfloyjh2fmHa
	 3MhrJoUUEZYMdAvJfC3FJShDcvvKTtqY5lhtYAGgQaCrSbBdDgDQqDikq8GeraXBG7
	 vGZn2o6c9YLHnwUkx/INwnfB0sw3irCqDfSJoZBA=
Date: Mon, 11 Dec 2023 09:23:41 -0800
To: mm-commits@vger.kernel.org,rcampbell@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-stale-example-from-comment.patch added to mm-unstable branch
Message-Id: <20231211172342.66FB8C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove stale example from comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-stale-example-from-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-stale-example-from-comment.patch

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
Subject: mm: remove stale example from comment
Date: Mon, 11 Dec 2023 16:22:10 +0000

folio_add_new_anon_rmap() no longer works this way, so just remove the
entire example.

Link: https://lkml.kernel.org/r/20231211162214.2146080-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/mm/memremap.c~mm-remove-stale-example-from-comment
+++ a/mm/memremap.c
@@ -473,21 +473,11 @@ void free_zone_device_page(struct page *
 		__ClearPageAnonExclusive(page);
 
 	/*
-	 * When a device managed page is freed, the page->mapping field
+	 * When a device managed page is freed, the folio->mapping field
 	 * may still contain a (stale) mapping value. For example, the
-	 * lower bits of page->mapping may still identify the page as an
-	 * anonymous page. Ultimately, this entire field is just stale
-	 * and wrong, and it will cause errors if not cleared.  One
-	 * example is:
-	 *
-	 *  migrate_vma_pages()
-	 *    migrate_vma_insert_page()
-	 *      page_add_new_anon_rmap()
-	 *        __page_set_anon_rmap()
-	 *          ...checks page->mapping, via PageAnon(page) call,
-	 *            and incorrectly concludes that the page is an
-	 *            anonymous page. Therefore, it incorrectly,
-	 *            silently fails to set up the new anon rmap.
+	 * lower bits of folio->mapping may still identify the folio as an
+	 * anonymous folio. Ultimately, this entire field is just stale
+	 * and wrong, and it will cause errors if not cleared.
 	 *
 	 * For other types of ZONE_DEVICE pages, migration is either
 	 * handled differently or not done at all, so there is no need
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

