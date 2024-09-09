Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457EC18A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925216; cv=none; b=mZ0XiMKHaJx1m+dAAnTq3lcWe+l98jBmgS3GgUj0rvCHzJwOVe8Jczi/vzGf1P+l7ZkbC21TQzR4JbXDjgTM174npLTBCLN+Pu5KULi/1qx4Yx5SSoTx7kw38x0JJeDsgzjb0G+3EYGjJcrIzioM9DN/1J20cm2pgu/p5rqijkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925216; c=relaxed/simple;
	bh=VMDe6TH+wAAqOGzWZgavg3DP/DHTpkJSqqyxYu4EpAU=;
	h=Date:To:From:Subject:Message-Id; b=ep0huqria1kFJJ6H/lJtUba3ohXczJ6co9a48k6F+dDlHOu8J+4Fgu9+OnjlbjhwmHYB8ssNOnc1Vr+qoW6ev2SzuVIAmwCwp4HS50rfPk9ObIt9qVLq40zS/lvQbW+YRW+7Nj1XgfSeeIB7CcS+F4SIQ7QBpkdSODWpE06Sy5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e37v1EGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e37v1EGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE2BC4CEC5;
	Mon,  9 Sep 2024 23:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925215;
	bh=VMDe6TH+wAAqOGzWZgavg3DP/DHTpkJSqqyxYu4EpAU=;
	h=Date:To:From:Subject:From;
	b=e37v1EGvNjFXmGHB0YHgNMa0E8aaG2Q+A9aGJscAvKHpXiKUp7wAOIE626Q++OVuT
	 HZsczPuQxJvPh09dK0NQqjhdt2I1oNpsk+X9spHlw+tBFYUk4CXQfTXh3ltqm1juAv
	 ssUHd0o/Cdcv/rhUfglg4riyNnzXZqAx5W16x/xA=
Date: Mon, 09 Sep 2024 16:40:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-use-a-folio-in-migrate_device_range.patch removed from -mm tree
Message-Id: <20240909234015.BDE2BC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate_device: use a folio in migrate_device_range()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-use-a-folio-in-migrate_device_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-support-poison-recovery-from-do_cow_fault.patch
mm-support-poison-recovery-from-copy_present_page.patch

