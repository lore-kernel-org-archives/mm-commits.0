Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C8C18A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925217; cv=none; b=cDab65e9d5/emySRtaS6IXxYsnGY3aPQbfR+lceYeFiJNVGqHgkEOwx2DT27kik8bNOTRCtwzCNOQLwEjqV98qiyFcV5sICrtj0iposHr82mSEuJN9Gn+Wj98SK9PYiccM1n3TSKaXNtubBWYx4kDyCBm7qamrd3x4z4srkPGlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925217; c=relaxed/simple;
	bh=ocU820RKDYjQ+f2y9jINbljuyLvRyYYOgrOZ9KethRc=;
	h=Date:To:From:Subject:Message-Id; b=s1dv76ov01YGdXAsZoNoQLvrKhzkfle1zFU/zYYfVFtjY2ERWZNn0J9GYRGryJOTKec6qQrsZWV4yEaOrrBkPKY2jA/gunipMBwQ6QDdXe56sEy8XX+WCrAvB9AmD9Cf9OEWtb0UhXa7F5YUXWVThdJQumtLnPiWfso1b4qpjrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A1dNLluf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A1dNLluf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAD6C4CEC5;
	Mon,  9 Sep 2024 23:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925216;
	bh=ocU820RKDYjQ+f2y9jINbljuyLvRyYYOgrOZ9KethRc=;
	h=Date:To:From:Subject:From;
	b=A1dNLlufwZZEWeNCtly/JLK41g+24Ruw3tcuLXfspeel+658QdyWQFk8tWi+R3Ms+
	 JX4P2W8PNWiCsWPDdXhp02a2KuXMSCL0mut3Ylm0FqAQmiiPqSGj51iZ8XNg5ZOxUt
	 qgFXIUf7y0Uht93qX5w+MSjkyIsT7/Je8M9ILTj8=
Date: Mon, 09 Sep 2024 16:40:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch removed from -mm tree
Message-Id: <20240909234016.DBAD6C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate_device: use more folio in migrate_device_unmap()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-support-poison-recovery-from-do_cow_fault.patch
mm-support-poison-recovery-from-copy_present_page.patch

