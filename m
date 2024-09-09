Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D488F18A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925214; cv=none; b=WMoJoueSZZmNoAGGRp4l/HQuHcIp9A4TcMYDsS89A6cchDF49dCyjwyYYrDeaK/2xzehWkwWd6N0h031h/AfdDUFBVrlV7NqT6Es0xQvQK2fTe5ktOZyxxIioFU93HaGzE+BjltO0muh37avN70jtZEwmahLdqcPxJVF6PoY6U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925214; c=relaxed/simple;
	bh=1t6FkqwsGpFxfX9tnm316NgK6gS0yEJyUv+thv7fBa8=;
	h=Date:To:From:Subject:Message-Id; b=rRCE2g6iXn0lmjJJJ0yHNp7uhvHILJDO8H5Fyu59KeTSRZWRGcVPxNdthCdt0dbZJBxKgMwLb18nvpc5KyO9zbZ5OGmV9qY9Y/Jm4Nayb+s8AwINxhWkSKetQQ7Jwl1+cRPsZKNUjLIpSybfuNvnX9JYVb2vLmVCoi1+XcfRWQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tKwYKGC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tKwYKGC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A735EC4CEC5;
	Mon,  9 Sep 2024 23:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925214;
	bh=1t6FkqwsGpFxfX9tnm316NgK6gS0yEJyUv+thv7fBa8=;
	h=Date:To:From:Subject:From;
	b=tKwYKGC29Kf4O53n6aGZISyeNG3o4vn7u8ScW8DHOfE0Np5rSfZF1KgSQT3rvr4z8
	 B/y6zhR3xxZ/VBkJfrm7Lh8jBMPq2ibligWcWKwU4SKkbrHxd4qXIQ2V7S6r4AMh+X
	 h8ByQTtXVTuJCcpAf+XfJ01/COxvIjdiRbxXD43w=
Date: Mon, 09 Sep 2024 16:40:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-convert-to-migrate_device_coherent_folio.patch removed from -mm tree
Message-Id: <20240909234014.A735EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate_device: convert to migrate_device_coherent_folio()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-convert-to-migrate_device_coherent_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate_device: convert to migrate_device_coherent_folio()
Date: Mon, 26 Aug 2024 14:58:09 +0800

Patch series "mm: finish isolate/putback_lru_page()".

Convert to use more folios in migrate_device.c, then we could remove
isolate_lru_page() and putback_lru_page().  


This patch (of 6):

Save a few calls to compound_head() and use folio throughout.

Link: https://lkml.kernel.org/r/20240826065814.1336616-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240826065814.1336616-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c            |    2 +-
 mm/internal.h       |    2 +-
 mm/migrate_device.c |   30 +++++++++++++++---------------
 3 files changed, 17 insertions(+), 17 deletions(-)

--- a/mm/gup.c~mm-migrate_device-convert-to-migrate_device_coherent_folio
+++ a/mm/gup.c
@@ -2335,7 +2335,7 @@ static int migrate_longterm_unpinnable_f
 			folio_get(folio);
 			gup_put_folio(folio, 1, FOLL_PIN);
 
-			if (migrate_device_coherent_page(&folio->page)) {
+			if (migrate_device_coherent_folio(folio)) {
 				ret = -EBUSY;
 				goto err;
 			}
--- a/mm/internal.h~mm-migrate_device-convert-to-migrate_device_coherent_folio
+++ a/mm/internal.h
@@ -1208,7 +1208,7 @@ int numa_migrate_check(struct folio *fol
 		      int *last_cpupid);
 
 void free_zone_device_folio(struct folio *folio);
-int migrate_device_coherent_page(struct page *page);
+int migrate_device_coherent_folio(struct folio *folio);
 
 /*
  * mm/gup.c
--- a/mm/migrate_device.c~mm-migrate_device-convert-to-migrate_device_coherent_folio
+++ a/mm/migrate_device.c
@@ -708,7 +708,7 @@ static void __migrate_device_pages(unsig
 
 			/*
 			 * The only time there is no vma is when called from
-			 * migrate_device_coherent_page(). However this isn't
+			 * migrate_device_coherent_folio(). However this isn't
 			 * called if the page could not be unmapped.
 			 */
 			VM_BUG_ON(!migrate);
@@ -921,38 +921,38 @@ int migrate_device_range(unsigned long *
 EXPORT_SYMBOL(migrate_device_range);
 
 /*
- * Migrate a device coherent page back to normal memory. The caller should have
- * a reference on page which will be copied to the new page if migration is
+ * Migrate a device coherent folio back to normal memory. The caller should have
+ * a reference on folio which will be copied to the new folio if migration is
  * successful or dropped on failure.
  */
-int migrate_device_coherent_page(struct page *page)
+int migrate_device_coherent_folio(struct folio *folio)
 {
 	unsigned long src_pfn, dst_pfn = 0;
-	struct page *dpage;
+	struct folio *dfolio;
 
-	WARN_ON_ONCE(PageCompound(page));
+	WARN_ON_ONCE(folio_test_large(folio));
 
-	lock_page(page);
-	src_pfn = migrate_pfn(page_to_pfn(page)) | MIGRATE_PFN_MIGRATE;
+	folio_lock(folio);
+	src_pfn = migrate_pfn(folio_pfn(folio)) | MIGRATE_PFN_MIGRATE;
 
 	/*
 	 * We don't have a VMA and don't need to walk the page tables to find
-	 * the source page. So call migrate_vma_unmap() directly to unmap the
-	 * page as migrate_vma_setup() will fail if args.vma == NULL.
+	 * the source folio. So call migrate_vma_unmap() directly to unmap the
+	 * folio as migrate_vma_setup() will fail if args.vma == NULL.
 	 */
 	migrate_device_unmap(&src_pfn, 1, NULL);
 	if (!(src_pfn & MIGRATE_PFN_MIGRATE))
 		return -EBUSY;
 
-	dpage = alloc_page(GFP_USER | __GFP_NOWARN);
-	if (dpage) {
-		lock_page(dpage);
-		dst_pfn = migrate_pfn(page_to_pfn(dpage));
+	dfolio = folio_alloc(GFP_USER | __GFP_NOWARN, 0);
+	if (dfolio) {
+		folio_lock(dfolio);
+		dst_pfn = migrate_pfn(folio_pfn(dfolio));
 	}
 
 	migrate_device_pages(&src_pfn, &dst_pfn, 1);
 	if (src_pfn & MIGRATE_PFN_MIGRATE)
-		copy_highpage(dpage, page);
+		folio_copy(dfolio, folio);
 	migrate_device_finalize(&src_pfn, &dst_pfn, 1);
 
 	if (src_pfn & MIGRATE_PFN_MIGRATE)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-support-poison-recovery-from-do_cow_fault.patch
mm-support-poison-recovery-from-copy_present_page.patch

