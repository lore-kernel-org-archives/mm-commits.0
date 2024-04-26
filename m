Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FF37C085
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103943; cv=none; b=osax3UYbvRbSiEevQAoRuJQ6nsDk56DwxQfqBsY/eMw77i4htPs7HPNXSP9HSZkgT97wsm/EeHpk8gNoAhGU77SHW7zCu5GI/PY5KEXY2IbZOPXiBL4zr3lMU17fJX26cwbRusE60McLO+sB9EukliceyqVSNUzHFFihLnXA708=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103943; c=relaxed/simple;
	bh=041XldCUf1eihhIp57+NDHH5cgRETDESD58WrOSQ1Nk=;
	h=Date:To:From:Subject:Message-Id; b=Ldbk4dAn6BovAjy7B8utntUU0AijrvrhqnOHta2J4I4uALzMnXnXOP5gNr+FwDHmf9nHEPLJd1FOACsq0DAiiRicxr7gPSP/PVzlNKSJsLs+AyJJPWheq4oGnIjsAnfI1hehAwRt8KufUvc0iLiiuid5Q8M5dWUOz706TvhQr0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pb0IijUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pb0IijUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E346EC113CD;
	Fri, 26 Apr 2024 03:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103943;
	bh=041XldCUf1eihhIp57+NDHH5cgRETDESD58WrOSQ1Nk=;
	h=Date:To:From:Subject:From;
	b=Pb0IijUHsuwFg31qSjwDXnqdhFx6e8y5GMn4IrLiItDcee+CIS8OtuN5LP1gtdtm/
	 1u/GqlRTvVDxp6mqk53QBUzbOXucchFKwuJLhiYfD1LIz2oJMrz9XpVAV98H4rRVSy
	 Z5Ydc8zLq3ZNpwTy6l0DGQMUm1yWHZFKobjuVNP8=
Date: Thu, 25 Apr 2024 20:59:02 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-improve-dumping-of-mapcount-and-page_type.patch removed from -mm tree
Message-Id: <20240426035902.E346EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: improve dumping of mapcount and page_type
has been removed from the -mm tree.  Its filename was
     mm-improve-dumping-of-mapcount-and-page_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: improve dumping of mapcount and page_type
Date: Thu, 21 Mar 2024 14:24:46 +0000

For pages that have a page_type, set the mapcount to 0, which will reduce
the confusion in people reading page dumps ("Why does this page have a
mapcount of -128?").  Now that hugetlbfs is a page_type, read the
entire_mapcount for any large folio; this is fine for all folios as no
user reuses the entire_mapcount field.

For pages which do not have a page type, do not print it to reduce
clutter.

Link: https://lkml.kernel.org/r/20240321142448.1645400-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/mm/debug.c~mm-improve-dumping-of-mapcount-and-page_type
+++ a/mm/debug.c
@@ -55,18 +55,14 @@ static void __dump_folio(struct folio *f
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
-	int mapcount = 0;
+	int mapcount = atomic_read(&page->_mapcount) + 1;
 	char *type = "";
 
-	/*
-	 * page->_mapcount space in struct page is used by slab pages to
-	 * encode own info, and we must avoid calling page_folio() again.
-	 */
-	if (!folio_test_slab(folio)) {
-		mapcount = atomic_read(&page->_mapcount) + 1;
-		if (folio_test_large(folio))
-			mapcount += folio_entire_mapcount(folio);
-	}
+	/* Open-code page_mapcount() to avoid looking up a stale folio */
+	if (mapcount < 0)
+		mapcount = 0;
+	if (folio_test_large(folio))
+		mapcount += folio_entire_mapcount(folio);
 
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
@@ -99,7 +95,8 @@ static void __dump_folio(struct folio *f
 	 */
 	pr_warn("%sflags: %pGp%s\n", type, &folio->flags,
 		is_migrate_cma_folio(folio, pfn) ? " CMA" : "");
-	pr_warn("page_type: %pGt\n", &folio->page.page_type);
+	if (page_has_type(&folio->page))
+		pr_warn("page_type: %pGt\n", &folio->page.page_type);
 
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

