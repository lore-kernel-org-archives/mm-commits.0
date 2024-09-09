Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D35818A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925218; cv=none; b=MQx6tXepu+C82zs/niixpVUjxpXh6FU3AvZKlP1fZE0EK6Sc7NXds691q+wv0rCw04aiAQd/3GTBnBnae7naA0CTVFZldfLutAE+5l+AbYr0QTORcaBem8f58tHClW/VrX+DdXgwokNgGePMQHttyA5xR2HUXCQOfke8AIHdQVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925218; c=relaxed/simple;
	bh=C8CVmlQKPuNU6lyXXXkB4R4N3yt3xnCAQ9RChotnsiY=;
	h=Date:To:From:Subject:Message-Id; b=u8QHIw+5JK7BRw/waJFTaV28+p75gBOony+3ZoYI9GDNfu8YTPHe2RK5uGinRIqEerlQxM20dpILw0/0Kc78wjxgEDglAFAzzm1//h2EQ4E3Cv+ZJ1WPexCJ5jVfcw0YYmCGlU+vOO1YIiXPSavmm02q2yY6yQeEr2IuGfxGHCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TA1AhTX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TA1AhTX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BB6C4CEC5;
	Mon,  9 Sep 2024 23:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925218;
	bh=C8CVmlQKPuNU6lyXXXkB4R4N3yt3xnCAQ9RChotnsiY=;
	h=Date:To:From:Subject:From;
	b=TA1AhTX3ZewHlUp7XFsdqCeNlGPHXBlFYZ8EPwJ8KFxZO30E5rFm+l+F5T40jYhsF
	 eC9OYDZgVbl6p3zLOopkb+OKE6XsXdYmjOQ+Mlb/LHsELHGsNRddvCkgONl44Os8y1
	 wghulTXH5BD9wyA4H2e9hDJctuYci4YUITtOn6sU=
Date: Mon, 09 Sep 2024 16:40:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch removed from -mm tree
Message-Id: <20240909234018.15BB6C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate_device: use more folio in migrate_device_finalize()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-support-poison-recovery-from-do_cow_fault.patch
mm-support-poison-recovery-from-copy_present_page.patch

