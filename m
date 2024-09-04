Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7137F484
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423609; cv=none; b=dtNGEKtWl47awKZ60PHXMGXfl7br5riTyTJAYBX6cAX3hipISU7OHMMi/YUjbuhDD4S2iuc7YWoiXaakjS9ZmTKPuJ2FY9lWzXKHis49Bq/UzrOoj8UjwciV2RymHLfzWGqKE85wX0Z55j3IXf2ZNETr8M9R3E9t4U8SPDJOGdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423609; c=relaxed/simple;
	bh=fqIVaho3XyNX0JEfap2kI9IjMnB5Cg9DWzVYupDWY3o=;
	h=Date:To:From:Subject:Message-Id; b=XOB30cJdINS5iJq2a9Asg5kmRh0H4SwkbaSZ1NombkG9g7fg9nBNH5l0Ile+TKheURdosF6Z9aYwggUhnwaADen3xUV2orBiadfqfU9Tn1FwxsruMlm6BMEPR328nQyEP0Ly6ijzDEyy9K0Hs7NoW1ojF5lxoFXaZdGgxlnOYeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=etHtefk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="etHtefk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E954C4CEC3;
	Wed,  4 Sep 2024 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423609;
	bh=fqIVaho3XyNX0JEfap2kI9IjMnB5Cg9DWzVYupDWY3o=;
	h=Date:To:From:Subject:From;
	b=etHtefk54CSdSNaPJqu/gzUJ60OtQhGhPeuy0dd4VYOT7fIEaogR2mgcZdUE6JiJd
	 ypDN/wSFeQBGcJ8N+dUJBP7wfsJeayNyLJKWdDYznAODlj5DFfhzEzeT7TG3Sa9Gaw
	 H5WFaF/vGePrUISYUJN2V7ITcaQYgFZWxYYqAEzo=
Date: Tue, 03 Sep 2024 21:20:08 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch removed from -mm tree
Message-Id: <20240904042009.2E954C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory_hotplug: remove head variable in do_migrate_range()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory_hotplug: remove head variable in do_migrate_range()
Date: Tue, 27 Aug 2024 19:47:24 +0800

Patch series "mm: memory_hotplug: improve do_migrate_range()", v3.

Unify hwpoisoned page handling and isolation of HugeTLB/LRU/non-LRU
movable page, also convert to use folios in do_migrate_range().


This patch (of 5):

Directly use a folio for HugeTLB and THP when calculate the next pfn, then
remove unused head variable.

Link: https://lkml.kernel.org/r/20240827114728.3212578-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240827114728.3212578-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-head-variable-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1773,7 +1773,7 @@ found:
 static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
-	struct page *page, *head;
+	struct page *page;
 	LIST_HEAD(source);
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
@@ -1786,14 +1786,20 @@ static void do_migrate_range(unsigned lo
 			continue;
 		page = pfn_to_page(pfn);
 		folio = page_folio(page);
-		head = &folio->page;
 
-		if (PageHuge(page)) {
-			pfn = page_to_pfn(head) + compound_nr(head) - 1;
-			isolate_hugetlb(folio, &source);
-			continue;
-		} else if (PageTransHuge(page))
-			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
+		/*
+		 * No reference or lock is held on the folio, so it might
+		 * be modified concurrently (e.g. split).  As such,
+		 * folio_nr_pages() may read garbage.  This is fine as the outer
+		 * loop will revisit the split folio later.
+		 */
+		if (folio_test_large(folio)) {
+			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
+			if (folio_test_hugetlb(folio)) {
+				isolate_hugetlb(folio, &source);
+				continue;
+			}
+		}
 
 		/*
 		 * HWPoison pages have elevated reference counts so the migration would
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

