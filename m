Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D528322A
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724806386; cv=none; b=Re+/Dl+7Vs6zA4iuPBxc/nB0Mpz8fo3O3W/6FwMSEDHEEPrpt+O6R7T/mv4BoDvCFq70g8pR0bLLEA/YronuZ7dDTjNmEbbmfz+j665uq5BLzmU+DVzEMYRlc26emy5lTimj2bkZ9mEL+A+VcOYtN2CFBtI1KRLD3CNPq1SmOAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724806386; c=relaxed/simple;
	bh=HqC1w4FyKJTxCIishv2sRnW+YlS2yY9suCzkn7Q+8OU=;
	h=Date:To:From:Subject:Message-Id; b=g1mLfNh4bZcmZRvAjRBIDg/lazVoCvI3LlqsHMtA9wefcy4XpIolkljozex1Gje76+skEurvc1l5xwQhlRNHVypsFrJ7tcXLKNP0gyeq8a5upMkoDbbwmx97vppFkXbUegh0yPgPFD6h8y04y+YajIxUnGSD02vzzBhbhbl+PiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aTVyTmvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aTVyTmvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD214C32786;
	Wed, 28 Aug 2024 00:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724806385;
	bh=HqC1w4FyKJTxCIishv2sRnW+YlS2yY9suCzkn7Q+8OU=;
	h=Date:To:From:Subject:From;
	b=aTVyTmvFuGsJr1s1JXjIpDkiTwmbFXj9KNmkX1DqLzxWWtUtSGXo2ROBuHAC8PBny
	 i1p5SgD9hTFNl64g3HTsKfJ4bR3f6mcoue8m8oRPzwDfYPvG80tGyYNCyXgd9UMMaK
	 tuaHq0gWgcWZtXLPImQBAn/eDOQwyZEWk8avT/Yc=
Date: Tue, 27 Aug 2024 17:53:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch added to mm-unstable branch
Message-Id: <20240828005305.BD214C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate_device: use more folio in migrate_device_finalize()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate_device: use more folio in migrate_device_finalize()
Date: Mon, 26 Aug 2024 14:58:12 +0800

Saves a couple of calls to compound_head() and remove last two callers of
putback_lru_page().

Link: https://lkml.kernel.org/r/20240826065814.1336616-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-use-more-folio-in-migrate_device_finalize
+++ a/mm/migrate_device.c
@@ -815,42 +815,45 @@ void migrate_device_finalize(unsigned lo
 	unsigned long i;
 
 	for (i = 0; i < npages; i++) {
-		struct folio *dst, *src;
+		struct folio *dst = NULL, *src = NULL;
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 
+		if (newpage)
+			dst = page_folio(newpage);
+
 		if (!page) {
-			if (newpage) {
-				unlock_page(newpage);
-				put_page(newpage);
+			if (dst) {
+				folio_unlock(dst);
+				folio_put(dst);
 			}
 			continue;
 		}
 
-		if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE) || !newpage) {
-			if (newpage) {
-				unlock_page(newpage);
-				put_page(newpage);
+		src = page_folio(page);
+
+		if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE) || !dst) {
+			if (dst) {
+				folio_unlock(dst);
+				folio_put(dst);
 			}
-			newpage = page;
+			dst = src;
 		}
 
-		src = page_folio(page);
-		dst = page_folio(newpage);
 		remove_migration_ptes(src, dst, false);
 		folio_unlock(src);
 
-		if (is_zone_device_page(page))
-			put_page(page);
+		if (folio_is_zone_device(src))
+			folio_put(src);
 		else
-			putback_lru_page(page);
+			folio_putback_lru(src);
 
-		if (newpage != page) {
-			unlock_page(newpage);
-			if (is_zone_device_page(newpage))
-				put_page(newpage);
+		if (dst != src) {
+			folio_unlock(dst);
+			if (folio_is_zone_device(dst))
+				folio_put(dst);
 			else
-				putback_lru_page(newpage);
+				folio_putback_lru(dst);
 		}
 	}
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

