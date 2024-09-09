Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B4818A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925221; cv=none; b=ABtNgc7IDTk1OEMVSXqYLrWfp+pdKw58QoyBq1jhePdA/8K1iJlOwGLuwi5ngv9ciGZbfyYzyfasF7yw/6e7GRM2R4h1wxDE6elvud/8KMO/uPZjM5KC3T9lPPwdvUTQBhtuFdNwZP6JY7lhhcCjtRRqLhd7z/fUu4WFooHOIEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925221; c=relaxed/simple;
	bh=20e8RDNVwH4jyar16XnyV/SowrqCwsACVy1KIigNVW0=;
	h=Date:To:From:Subject:Message-Id; b=qr3WVruptez5yJ4Ds3IJEIJtfr1g6hPf/juKILdJO7QD1AxR9sqyYWm7xjXTa1dlyWX8Itm7KkbimOoNQAPuTj7MhyMaxWXzn7u5JU/gM003dvv8mKzrRL3JBYIDlRDxtESQQEA8QuNCbNBKWzI6JIzMz0h/mO12+/d/DczKPYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OGSkmT5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OGSkmT5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D63C4CEC5;
	Mon,  9 Sep 2024 23:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925221;
	bh=20e8RDNVwH4jyar16XnyV/SowrqCwsACVy1KIigNVW0=;
	h=Date:To:From:Subject:From;
	b=OGSkmT5NY2jrUSDoxe+wwsZi+KQ98qthoRotVJYe9UjnibAvZqOyEOtWPsH+E2AA8
	 xHQU+F3Scf0kjYmoDv5lWwTHBACgMQg/hzktxV3n0v4fXuc20FF0ilM9A4+xQXbQ/P
	 UA/t2G85BaiBP7bDi4Dg34xE8xaAQj5btUFnl2SM=
Date: Mon, 09 Sep 2024 16:40:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-putback_lru_page.patch removed from -mm tree
Message-Id: <20240909234021.56D63C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove putback_lru_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-putback_lru_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove putback_lru_page()
Date: Mon, 26 Aug 2024 14:58:14 +0800

There are no more callers of putback_lru_page(), remove it.

Link: https://lkml.kernel.org/r/20240826065814.1336616-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/folio-compat.c |    5 -----
 mm/internal.h     |    1 -
 2 files changed, 6 deletions(-)

--- a/mm/folio-compat.c~mm-remove-putback_lru_page
+++ a/mm/folio-compat.c
@@ -92,8 +92,3 @@ struct page *grab_cache_page_write_begin
 			mapping_gfp_mask(mapping));
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
-
-void putback_lru_page(struct page *page)
-{
-	folio_putback_lru(page_folio(page));
-}
--- a/mm/internal.h~mm-remove-putback_lru_page
+++ a/mm/internal.h
@@ -417,7 +417,6 @@ extern unsigned long highest_memmap_pfn;
  * in mm/vmscan.c:
  */
 bool folio_isolate_lru(struct folio *folio);
-void putback_lru_page(struct page *page);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-support-poison-recovery-from-do_cow_fault.patch
mm-support-poison-recovery-from-copy_present_page.patch

