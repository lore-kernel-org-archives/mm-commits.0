Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F33853E24
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 20:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718742742; cv=none; b=gha6PzjrhA5wRX9JWJNxOlkPDKaL1jmHRBRM708gPUtqM1iY+EHI+VZQLXYRkGMMeR+TjzBw6G7fwknaO57USWh7tw8MXyiviXQEMQFE0AUEEaHS1wnE1ACgmzkRtHr314Lon8wxBmrRKse6ir2dYZAznS0ptVB7TKbhEebol/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718742742; c=relaxed/simple;
	bh=2yVsMBwJgc29lUjHJZkJ1LcfvLQUnm389Dr9VIJilwo=;
	h=Date:To:From:Subject:Message-Id; b=AV3rvr5eyCSwQy1v66QbYt3RUgQnRZ7x21jcCdS191XnUe6h9/upU0LbEhtRLOpYF6H4/LZUio1lYnwjWgnDBzhUoiJk/jUFcfkk+NdzmahQEDt6/7D9Euk/wCA/Ao5z1QfssV5ud2fz0G8yUGoJ6zYvz6/SfDs1MLjLTvXbUVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ur9ddA/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ur9ddA/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A924CC3277B;
	Tue, 18 Jun 2024 20:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718742741;
	bh=2yVsMBwJgc29lUjHJZkJ1LcfvLQUnm389Dr9VIJilwo=;
	h=Date:To:From:Subject:From;
	b=Ur9ddA/ziE5hhkZyJ6ElgqKwZP13vluFmGvb5F2IcAF71BenZRWxmhGTY+XodPV0V
	 h1rYbjate+3WPkMLnZZclyuF+hLkMISSFEGESVkkYe+ENUVMwbzTzAhCJZJMXn0t1b
	 12KY9WIvcJ552HJk8h8P3KrpYrMEVBtrHSIpDTWM=
Date: Tue, 18 Jun 2024 13:32:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,da.gomez@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch added to mm-unstable branch
Message-Id: <20240618203221.A924CC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: return number of pages beeing freed in shmem_free_swap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch

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
From: Daniel Gomez <da.gomez@samsung.com>
Subject: mm: shmem: return number of pages beeing freed in shmem_free_swap
Date: Tue, 18 Jun 2024 14:54:16 +0800

Both shmem_free_swap callers expect the number of pages being freed.  In
the large folios context, this needs to support larger values other than 0
(used as 1 page being freed) and -ENOENT (used as 0 pages being freed). 
In preparation for large folios adoption, make shmem_free_swap routine
return the number of pages being freed.  So, returning 0 in this context,
means 0 pages being freed.

While we are at it, changing to use free_swap_and_cache_nr() to free large
order swap entry by Baolin Wang.

Link: https://lkml.kernel.org/r/6e567bfbb6bac0bfbdd63e60718bd1aaf8eade6c.1718690645.git.baolin.wang@linux.alibaba.com
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap
+++ a/mm/shmem.c
@@ -836,18 +836,22 @@ static void shmem_delete_from_page_cache
 }
 
 /*
- * Remove swap entry from page cache, free the swap and its page cache.
+ * Remove swap entry from page cache, free the swap and its page cache. Returns
+ * the number of pages being freed. 0 means entry not found in XArray (0 pages
+ * being freed).
  */
-static int shmem_free_swap(struct address_space *mapping,
-			   pgoff_t index, void *radswap)
+static long shmem_free_swap(struct address_space *mapping,
+			    pgoff_t index, void *radswap)
 {
+	int order = xa_get_order(&mapping->i_pages, index);
 	void *old;
 
 	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
 	if (old != radswap)
-		return -ENOENT;
-	free_swap_and_cache(radix_to_swp_entry(radswap));
-	return 0;
+		return 0;
+	free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
+
+	return 1 << order;
 }
 
 /*
@@ -999,7 +1003,7 @@ static void shmem_undo_range(struct inod
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += !shmem_free_swap(mapping,
+				nr_swaps_freed += shmem_free_swap(mapping,
 							indices[i], folio);
 				continue;
 			}
@@ -1066,14 +1070,17 @@ whole_folios:
 			folio = fbatch.folios[i];
 
 			if (xa_is_value(folio)) {
+				long swaps_freed;
+
 				if (unfalloc)
 					continue;
-				if (shmem_free_swap(mapping, indices[i], folio)) {
+				swaps_freed = shmem_free_swap(mapping, indices[i], folio);
+				if (!swaps_freed) {
 					/* Swap was replaced by page: retry */
 					index = indices[i];
 					break;
 				}
-				nr_swaps_freed++;
+				nr_swaps_freed += swaps_freed;
 				continue;
 			}
 
_

Patches currently in -mm which might be from da.gomez@samsung.com are

mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch

