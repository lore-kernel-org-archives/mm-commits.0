Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F47E47A73
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421875; cv=none; b=fb5koG5e2AohIhTKts7AADGk6+sfCxrr7nqAQUIZlTvyelf9xDKk2nXyhz9GkKHrcfTihjfJB0kvtE2+JpiSsK+jHWE1FAkI03qO18weRCVSW7q1s2ezLXutxhqE4eldJAbvBjzJLEswOvGyXTOWbgqSecF5Kp2cdpZX3dYjL5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421875; c=relaxed/simple;
	bh=b4eyvuYc8n8FUtGsBfD/LAqk92puSNkmQaFejKep2zk=;
	h=Date:To:From:Subject:Message-Id; b=rpkYESIpzNsSVbGEnL6HF2o63S1IzfbMnI6aCvE2jgbWkdCN1HnJ+IQzS6s8q5yyDVEgxlmiKU2nLBa3Gr+Yj6vqL9mmpLYC9mxjxU51rfLqs9F3cIPWTtsTEyBpRMUSl7hRrpbpH8PlzYG6k9AfiXk/gL9W2z9slqYWB5ISADE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IwQ03JTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IwQ03JTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918EEC4CEC2;
	Wed,  4 Sep 2024 03:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421874;
	bh=b4eyvuYc8n8FUtGsBfD/LAqk92puSNkmQaFejKep2zk=;
	h=Date:To:From:Subject:From;
	b=IwQ03JTwJJ5EkKJjA206WJdQUz4PzQ1CwBcUVkqnafBFn9bgScrq1zXlE/jZYiK7o
	 IyVQbLFudUolSybhHIQG5eW6hzrB7MEvT3eoaNKUrwWU6n/AIbGgYu10cWUAlHmILc
	 zpfjvjgXiqpKHXng34WnUtOvP8gryNVPMCfc6mlw=
Date: Tue, 03 Sep 2024 20:51:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-filemap-use-xa_get_order-to-get-the-swap-entry-order-fix.patch removed from -mm tree
Message-Id: <20240904035114.918EEC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Re: mm: filemap: use xa_get_order() to get the swap entry order
has been removed from the -mm tree.  Its filename was
     mm-filemap-use-xa_get_order-to-get-the-swap-entry-order-fix.patch

This patch was dropped because it was folded into mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: Re: mm: filemap: use xa_get_order() to get the swap entry order
Date: Thu, 29 Aug 2024 01:07:17 -0700 (PDT)

find_lock_entries(), used in the first pass of shmem_undo_range() and
truncate_inode_pages_range() before partial folios are dealt with, has to
be careful to avoid those partial folios: as its doc helpfully says,
"Folios which are partially outside the range are not returned".  Of
course, the same must be true of any value entries returned, otherwise
truncation and hole-punch risk erasing swapped areas - as has been seen.

Rewrite find_lock_entries() to emphasize that, following the same pattern
for folios and for value entries.

Adjust find_get_entries() slightly, to get order while still holding
rcu_read_lock(), and to round down the updated start: good changes, like
find_lock_entries() now does, but it's unclear if either is ever
important.

Link: https://lkml.kernel.org/r/c336e6e4-da7f-b714-c0f1-12df715f2611@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/filemap.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

--- a/mm/filemap.c~mm-filemap-use-xa_get_order-to-get-the-swap-entry-order-fix
+++ a/mm/filemap.c
@@ -2046,10 +2046,9 @@ unsigned find_get_entries(struct address
 		if (!folio_batch_add(fbatch, folio))
 			break;
 	}
-	rcu_read_unlock();
 
 	if (folio_batch_count(fbatch)) {
-		unsigned long nr = 1;
+		unsigned long nr;
 		int idx = folio_batch_count(fbatch) - 1;
 
 		folio = fbatch->folios[idx];
@@ -2057,8 +2056,10 @@ unsigned find_get_entries(struct address
 			nr = folio_nr_pages(folio);
 		else
 			nr = 1 << xa_get_order(&mapping->i_pages, indices[idx]);
-		*start = indices[idx] + nr;
+		*start = round_down(indices[idx] + nr, nr);
 	}
+	rcu_read_unlock();
+
 	return folio_batch_count(fbatch);
 }
 
@@ -2090,10 +2091,17 @@ unsigned find_lock_entries(struct addres
 
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
@@ -2102,7 +2110,19 @@ unsigned find_lock_entries(struct addres
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
@@ -2114,17 +2134,6 @@ put:
 	}
 	rcu_read_unlock();
 
-	if (folio_batch_count(fbatch)) {
-		unsigned long nr = 1;
-		int idx = folio_batch_count(fbatch) - 1;
-
-		folio = fbatch->folios[idx];
-		if (!xa_is_value(folio))
-			nr = folio_nr_pages(folio);
-		else
-			nr = 1 << xa_get_order(&mapping->i_pages, indices[idx]);
-		*start = indices[idx] + nr;
-	}
 	return folio_batch_count(fbatch);
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch
mm-shmem-support-large-folio-swap-out-fix.patch
mm-restart-if-multiple-traversals-raced-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

