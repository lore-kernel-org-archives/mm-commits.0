Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1185D14263
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724806384; cv=none; b=NKxfnarGHLVkbxgDy+dN1e6qOzL9lmVNRgN8f6Q5zO2nvCq6hxlwez336mZMoFMOx9vpV2spJOXTe8n3bj2nf/t5hhf45N9WaEnyb5DNblGcsPM66xTcUKKop6OUzOYSNUSdb/ZfVZcvC06l1WYJuV1ONq9I8QxeBy2DIS/FDNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724806384; c=relaxed/simple;
	bh=Es8eidbGwgF5nOadmRf/PfNXjTgoJfcmT/oQ0TQCc4k=;
	h=Date:To:From:Subject:Message-Id; b=T/+cQSwGcSXLmMQxPPa/MoTLGLHSzNFFBC6GfllNow/pp0IQSqJ74uqkpNRgtw4p+6I31MTXRKrWwcpFe3asZYlcvZDHlozOso2FP1YIxxlWG+GevBSI6oP/UJSela1Nij6aVXSFabjA9OLJ3qgSLEDLYyfi6F4QU8BkXaReS20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2jD/ou/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2jD/ou/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E6EC4AF0C;
	Wed, 28 Aug 2024 00:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724806383;
	bh=Es8eidbGwgF5nOadmRf/PfNXjTgoJfcmT/oQ0TQCc4k=;
	h=Date:To:From:Subject:From;
	b=2jD/ou/IoG7/vHYZULzKYV14MsxvJz8bNimyYqi0hjIfAG/+JwfX8LtpT1NDU9HuX
	 stAw9xPlHIavEp0sU4Mshbmu0qsHj7gjjKm3f1dVa3URyB6yUxnPY1pJbMBPoeQ2uu
	 amiUDBItGFIWTMvM6CabCjkVcYz2HTBDUs/T5CCc=
Date: Tue, 27 Aug 2024 17:53:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch added to mm-unstable branch
Message-Id: <20240828005303.D1E6EC4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate_device: use more folio in migrate_device_unmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch

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
Subject: mm: migrate_device: use more folio in migrate_device_unmap()
Date: Mon, 26 Aug 2024 14:58:11 +0800

The page for migrate_device_unmap() already has a reference, so it is safe
to convert the page to folio to save a few calls to compound_head(), which
removes the last isolate_lru_page() call.

Link: https://lkml.kernel.org/r/20240826065814.1336616-4-wangkefeng.wang@huawei.com
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

 mm/migrate_device.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-use-more-folio-in-migrate_device_unmap
+++ a/mm/migrate_device.c
@@ -379,33 +379,33 @@ static unsigned long migrate_device_unma
 			continue;
 		}
 
-		/* ZONE_DEVICE pages are not on LRU */
-		if (!is_zone_device_page(page)) {
-			if (!PageLRU(page) && allow_drain) {
+		folio =	page_folio(page);
+		/* ZONE_DEVICE folios are not on LRU */
+		if (!folio_is_zone_device(folio)) {
+			if (!folio_test_lru(folio) && allow_drain) {
 				/* Drain CPU's lru cache */
 				lru_add_drain_all();
 				allow_drain = false;
 			}
 
-			if (!isolate_lru_page(page)) {
+			if (!folio_isolate_lru(folio)) {
 				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				restore++;
 				continue;
 			}
 
 			/* Drop the reference we took in collect */
-			put_page(page);
+			folio_put(folio);
 		}
 
-		folio = page_folio(page);
 		if (folio_mapped(folio))
 			try_to_migrate(folio, 0);
 
-		if (page_mapped(page) ||
+		if (folio_mapped(folio) ||
 		    !migrate_vma_check_page(page, fault_page)) {
-			if (!is_zone_device_page(page)) {
-				get_page(page);
-				putback_lru_page(page);
+			if (!folio_is_zone_device(folio)) {
+				folio_get(folio);
+				folio_putback_lru(folio);
 			}
 
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
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

