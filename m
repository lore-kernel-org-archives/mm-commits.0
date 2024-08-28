Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4DD322A
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724806382; cv=none; b=TuOH4n6QWG8SPNwpB2v9cUgwUwH7nrni8OxU5fIZ4otCenVukLa3D1SCVGiZUV2cG/AN22RPiL9kQybQnZWYGXL4b/4sU43V6+XVAJm7ijY8iERF82Yc9DPz6e8ARoiyZwmv8rk0n4z2EmiAxiaCQbliMkG8KHg98jtF2Z088Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724806382; c=relaxed/simple;
	bh=mothTKYXkBNcMefo8h3ZXniVwEOqt3PAykIy1C2EIgc=;
	h=Date:To:From:Subject:Message-Id; b=hi/lK9Avw8BTGVaQl3KdY/uPh1tLvb2lCoora7RpGKi0fxvwvOEX/EDGxMqU+IVNN8r5DrmEz4tQIvNp2v84BON3nUHHkKgGTeylyC44bdWdQlN7IBpJLSU0G1K/C5MfTvY2xqLPEyfpG9kx1nI6o0XkP9N5qBgpAiqq6O9S+mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ziQjbg+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ziQjbg+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC98AC4AF0C;
	Wed, 28 Aug 2024 00:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724806382;
	bh=mothTKYXkBNcMefo8h3ZXniVwEOqt3PAykIy1C2EIgc=;
	h=Date:To:From:Subject:From;
	b=ziQjbg+Z5F5YjljcovY6lQ7UmrZdYEuyfskcmV95CQF5nRXC2Zh4/ny1IEnY0wvvu
	 9cBtbzt3zoHY5e19WRV9/GRASOXXpLnrz9g7FK4rUuKrxlBsEkgmJAFqdEUuMhEegE
	 hfnbku/mkXGMhnPEgD0vnRdQ7h5kIqQ1CPfuKHWs=
Date: Tue, 27 Aug 2024 17:53:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-use-a-folio-in-migrate_device_range.patch added to mm-unstable branch
Message-Id: <20240828005301.DC98AC4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate_device: use a folio in migrate_device_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-use-a-folio-in-migrate_device_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-use-a-folio-in-migrate_device_range.patch

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
Subject: mm: migrate_device: use a folio in migrate_device_range()
Date: Mon, 26 Aug 2024 14:58:10 +0800

Save two calls to compound_head() and use folio throughout.

Link: https://lkml.kernel.org/r/20240826065814.1336616-3-wangkefeng.wang@huawei.com
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

 mm/migrate_device.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-use-a-folio-in-migrate_device_range
+++ a/mm/migrate_device.c
@@ -898,16 +898,17 @@ int migrate_device_range(unsigned long *
 	unsigned long i, pfn;
 
 	for (pfn = start, i = 0; i < npages; pfn++, i++) {
-		struct page *page = pfn_to_page(pfn);
+		struct folio *folio;
 
-		if (!get_page_unless_zero(page)) {
+		folio = folio_get_nontail_page(pfn_to_page(pfn));
+		if (!folio) {
 			src_pfns[i] = 0;
 			continue;
 		}
 
-		if (!trylock_page(page)) {
+		if (!folio_trylock(folio)) {
 			src_pfns[i] = 0;
-			put_page(page);
+			folio_put(folio);
 			continue;
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

