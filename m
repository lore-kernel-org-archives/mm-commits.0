Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F20A1804A
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 02:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725242907; cv=none; b=ZIAEmb35asITZxf4SpfIBQ9C7kw9whhMs7lwPPPoVM0Rlyc8zDTOajV/jyPLVN+a9Og+8q8/d/+wvV96EGB4a3/o01CxLz80wpnvlhtzSrar8FR1Rd2ZZo5GFk8HZKXcqfn2kVMrP6srkEbQq5RmAG8cm2yWE5hp9qrQHke8Cmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725242907; c=relaxed/simple;
	bh=dHXh+nejGMEQ+bqhO1PJm5hcXsqRaqcxOTpGR7IL2DI=;
	h=Date:To:From:Subject:Message-Id; b=PN1vY3Se+jexr5lNqeIRsVfiNKLyttM9Qwm4+MORL0Fiwo6RPGZT4sEFQq+quWzHQSvmuegxg/H0rxnrB7qTyVT9ETTyJbLM2fuOUDMO2m+QNvBgv9IQvjSixscr+PviBJK/a9O1WKx6BHWOitATDS64sd/2In1svkc2r1y6yQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P56h1Utp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P56h1Utp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4956C4CEC3;
	Mon,  2 Sep 2024 02:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725242905;
	bh=dHXh+nejGMEQ+bqhO1PJm5hcXsqRaqcxOTpGR7IL2DI=;
	h=Date:To:From:Subject:From;
	b=P56h1UtpUHBiE2wJFUsySuKN0cOIqR11PSccREx7kK/YQp7CaSbZic5yi6GuOVPDV
	 z4gkel2hpitgm48//kbN+xmUWV8VCRDKrvDGqe7FJqBihmgIIT+0S2HjXtqyeGhVIK
	 ntJB5x79tW72imuK71Tip2OVk51+zqbUkL/B07QQ=
Date: Sun, 01 Sep 2024 19:08:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-use-xa_get_order-to-get-the-swap-entry-order-fix.patch added to mm-unstable branch
Message-Id: <20240902020825.C4956C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Re: mm: filemap: use xa_get_order() to get the swap entry order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-use-xa_get_order-to-get-the-swap-entry-order-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-use-xa_get_order-to-get-the-swap-entry-order-fix.patch

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

mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order-fix.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch
mm-shmem-support-large-folio-swap-out-fix.patch
mm-restart-if-multiple-traversals-raced-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

