Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423A277F02
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cd0dbb62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CA7C433C8;
	Tue, 12 Dec 2023 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702397893;
	bh=2Xl4HQRgmYa4nc/NA/4baBpwivdm9Yz3RrwSZyUnjvQ=;
	h=Date:To:From:Subject:From;
	b=Cd0dbb62cktI3IEreDY6Whdi6Ux5pLonOWNMeWajhA9IL0yTBhTGLYX6acQ1O0Xw+
	 UKrYqilUEe0ZPokN4biL0/WQXF8CVE/okAt4asGPEz7unxiz0ZstUO5RtdlW2XFY/R
	 Szzy0dRlqvjGiddMQ6vC/jRc6mpbCmSLzliG8UeQ=
Date: Tue, 12 Dec 2023 08:18:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-simplify-the-assertions-in-unuse_pte.patch removed from -mm tree
Message-Id: <20231212161813.B1CA7C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: simplify the assertions in unuse_pte()
has been removed from the -mm tree.  Its filename was
     mm-simplify-the-assertions-in-unuse_pte.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: simplify the assertions in unuse_pte()
Date: Mon, 11 Dec 2023 16:22:07 +0000

We should only see anon folios in this function (and there are many
assumptions of that already), so we can simplify these two assertions.

Link: https://lkml.kernel.org/r/20231211162214.2146080-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-simplify-the-assertions-in-unuse_pte
+++ a/mm/swapfile.c
@@ -1789,8 +1789,8 @@ static int unuse_pte(struct vm_area_stru
 	arch_swap_restore(entry, page_folio(page));
 
 	/* See do_swap_page() */
-	BUG_ON(!PageAnon(page) && PageMappedToDisk(page));
-	BUG_ON(PageAnon(page) && PageAnonExclusive(page));
+	VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
+	VM_BUG_ON_PAGE(PageAnonExclusive(page), page);
 
 	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
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
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

