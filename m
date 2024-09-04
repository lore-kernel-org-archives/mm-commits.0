Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F21474076
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423466; cv=none; b=HHhOUYN2qs2kvZYNk+2doAsO0f8x57fCwjlmDvjjx0hmk/TcgM4d0q1ClxN/pPuwnxdFMxMrmfWWDGVYLAXSZ8PvT1qJb1mz5+ANaGN3Myx2Pb+ptVy/jsJVmTGnf1b2vz8hlCNvyTauerNjLP4JTYZmJYofAE+TyQX8MrrtDig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423466; c=relaxed/simple;
	bh=jz+WxR3zNkz8QY2OSu4XDu4OTBKPKU5LmI8OCR5Cp5w=;
	h=Date:To:From:Subject:Message-Id; b=enT4vAXyZLj5Mq5eFTUTNWrr2pGxltxA4N3cEuvkNTWWoa0W2An/KUayD0pwbGmKvqIi1/kcSNwMms1AEOmZcp0NCe9RmXQEo5ThY0riXTVfBYjsRy5j8FWj7v1qryCJXcDKlq/+0oekXtoMUtzVORQxAIk5FYVL9BVGUwyN890=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JgrLQxk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JgrLQxk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DB5C4CEC2;
	Wed,  4 Sep 2024 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423466;
	bh=jz+WxR3zNkz8QY2OSu4XDu4OTBKPKU5LmI8OCR5Cp5w=;
	h=Date:To:From:Subject:From;
	b=JgrLQxk6dwrJ4Hq+FYMhPf4OzK/izqWzUUeQkeebe0elTDYLXai72YVfp19imUyJl
	 TEC35+SaFKFvx1SqcW13yotd34LBvsuv71D5rYs96tQQ8hIbBpodDuHUjQit6hm5OQ
	 4jsO8ZzLZPBSjFIzMI/yD3lk6wYNYBJuKSq85IYg=
Date: Tue, 03 Sep 2024 21:17:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch removed from -mm tree
Message-Id: <20240904041746.73DB5C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: filemap: use xa_get_order() to get the swap entry order
has been removed from the -mm tree.  Its filename was
     mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: filemap: use xa_get_order() to get the swap entry order
Date: Mon, 12 Aug 2024 15:42:05 +0800

In the following patches, shmem will support the swap out of large folios,
which means the shmem mappings may contain large order swap entries, so
using xa_get_order() to get the folio order of the shmem swap entry to
update the '*start' correctly.

[hughd@google.com: use xa_get_order() to get the swap entry order]
  Link: https://lkml.kernel.org/r/c336e6e4-da7f-b714-c0f1-12df715f2611@google.com
Link: https://lkml.kernel.org/r/6876d55145c1cc80e79df7884aa3a62e397b101d.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/mm/filemap.c~mm-filemap-use-xa_get_order-to-get-the-swap-entry-order
+++ a/mm/filemap.c
@@ -2046,17 +2046,20 @@ unsigned find_get_entries(struct address
 		if (!folio_batch_add(fbatch, folio))
 			break;
 	}
-	rcu_read_unlock();
 
 	if (folio_batch_count(fbatch)) {
-		unsigned long nr = 1;
+		unsigned long nr;
 		int idx = folio_batch_count(fbatch) - 1;
 
 		folio = fbatch->folios[idx];
 		if (!xa_is_value(folio))
 			nr = folio_nr_pages(folio);
-		*start = indices[idx] + nr;
+		else
+			nr = 1 << xa_get_order(&mapping->i_pages, indices[idx]);
+		*start = round_down(indices[idx] + nr, nr);
 	}
+	rcu_read_unlock();
+
 	return folio_batch_count(fbatch);
 }
 
@@ -2088,10 +2091,17 @@ unsigned find_lock_entries(struct addres
 
 	rcu_read_lock();
 	while ((folio = find_get_entry(&xas, end, XA_PRESENT))) {
+		unsigned long base;
+		unsigned long nr;
+
 		if (!xa_is_value(folio)) {
-			if (folio->index < *start)
+			nr = folio_nr_pages(folio);
+			base = folio->index;
+			/* Omit large folio which begins before the start */
+			if (base < *start)
 				goto put;
-			if (folio_next_index(folio) - 1 > end)
+			/* Omit large folio which extends beyond the end */
+			if (base + nr - 1 > end)
 				goto put;
 			if (!folio_trylock(folio))
 				goto put;
@@ -2100,7 +2110,19 @@ unsigned find_lock_entries(struct addres
 				goto unlock;
 			VM_BUG_ON_FOLIO(!folio_contains(folio, xas.xa_index),
 					folio);
+		} else {
+			nr = 1 << xa_get_order(&mapping->i_pages, xas.xa_index);
+			base = xas.xa_index & ~(nr - 1);
+			/* Omit order>0 value which begins before the start */
+			if (base < *start)
+				continue;
+			/* Omit order>0 value which extends beyond the end */
+			if (base + nr - 1 > end)
+				break;
 		}
+
+		/* Update start now so that last update is correct on return */
+		*start = base + nr;
 		indices[fbatch->nr] = xas.xa_index;
 		if (!folio_batch_add(fbatch, folio))
 			break;
@@ -2112,15 +2134,6 @@ put:
 	}
 	rcu_read_unlock();
 
-	if (folio_batch_count(fbatch)) {
-		unsigned long nr = 1;
-		int idx = folio_batch_count(fbatch) - 1;
-
-		folio = fbatch->folios[idx];
-		if (!xa_is_value(folio))
-			nr = folio_nr_pages(folio);
-		*start = indices[idx] + nr;
-	}
 	return folio_batch_count(fbatch);
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


