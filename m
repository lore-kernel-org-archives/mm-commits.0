Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8E74A06
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 01:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758071148; cv=none; b=MEDFxMLyGJlDzeXr6oZMJ2WplNfgkqgwpBV47rlywcSiWXdajtZ4Pj9PkARyYKiEmCHElzdgbRdW+Lerg3RDnHX8OmpsCLDyM7NcTp6SjGwPOAwQ59Lj5032KkcPetYT37u5lG92e0kj4bvyYGanSQiA+BG4SBZ3Hk5JfYsBKtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758071148; c=relaxed/simple;
	bh=GDUx6Ywh/r/oTGs+M3nlD/RgQjA2cTPwee2Gdz1/df0=;
	h=Date:To:From:Subject:Message-Id; b=d6fR2MfzzUVWLyzxGY0Wzl1zSVYlOU6xaF9QomM1hDSLJZF1Q5K+bEkX+WUFZYnmTTjEdbRpFzr8vIYN9lJuUX5USFXAw8dt0IKBfEYslLBC8UleR1svU+1hGQaBLaBoINOn0RIhHfIhmmBlTPoeY0gMpQI0B+zFq9HAAgd2blg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BZ1/ey88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BZ1/ey88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D30FC4CEEB;
	Wed, 17 Sep 2025 01:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758071147;
	bh=GDUx6Ywh/r/oTGs+M3nlD/RgQjA2cTPwee2Gdz1/df0=;
	h=Date:To:From:Subject:From;
	b=BZ1/ey88ywJ1rQMJvX20u5UJKRvq4B/nG4Wd/zaK/iL+vnGtZ9eM38nm6zQrnuoAt
	 ZRsoDy09FhWCSTF27ZMS6kczvOmH/4bT454ms3o2IB80UkN+rkax5hUFjeul9ZS/ab
	 lklz7Z127RLDCWlKzXnN5ROOsZ4GpnnSrAB106+0=
Date: Tue, 16 Sep 2025 18:05:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-check-page-poison-flag-after-locking-it.patch added to mm-unstable branch
Message-Id: <20250917010547.8D30FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: check page poison flag after locking it
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-check-page-poison-flag-after-locking-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-check-page-poison-flag-after-locking-it.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: check page poison flag after locking it
Date: Wed, 17 Sep 2025 00:00:49 +0800

Instead of checking the poison flag only in the fast swap cache lookup
path, always check the poison flags after locking a swap cache folio.

There are two reasons to do so.

The folio is unstable and could be removed from the swap cache anytime, so
it's totally possible that the folio is no longer the backing folio of a
swap entry, and could be an irrelevant poisoned folio.  We might
mistakenly kill a faulting process.

And it's totally possible or even common for the slow swap in path
(swapin_readahead) to bring in a cached folio.  The cache folio could be
poisoned, too.  Only checking the poison flag in the fast path will miss
such folios.

The race window is tiny, so it's very unlikely to happen, though.  While
at it, also add a unlikely prefix.

Link: https://lkml.kernel.org/r/20250916160100.31545-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-swap-check-page-poison-flag-after-locking-it
+++ a/mm/memory.c
@@ -4661,10 +4661,8 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out;
 
 	folio = swap_cache_get_folio(entry);
-	if (folio) {
+	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
-		page = folio_file_page(folio, swp_offset(entry));
-	}
 	swapcache = folio;
 
 	if (!folio) {
@@ -4735,20 +4733,13 @@ vm_fault_t do_swap_page(struct vm_fault
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
-		page = folio_file_page(folio, swp_offset(entry));
-	} else if (PageHWPoison(page)) {
-		/*
-		 * hwpoisoned dirty swapcache pages are kept for killing
-		 * owner processes (which may be unknown at hwpoison time)
-		 */
-		ret = VM_FAULT_HWPOISON;
-		goto out_release;
 	}
 
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;
 
+	page = folio_file_page(folio, swp_offset(entry));
 	if (swapcache) {
 		/*
 		 * Make sure folio_free_swap() or swapoff did not release the
@@ -4761,6 +4752,15 @@ vm_fault_t do_swap_page(struct vm_fault
 			     page_swap_entry(page).val != entry.val))
 			goto out_page;
 
+		if (unlikely(PageHWPoison(page))) {
+			/*
+			 * hwpoisoned dirty swapcache pages are kept for killing
+			 * owner processes (which may be unknown at hwpoison time)
+			 */
+			ret = VM_FAULT_HWPOISON;
+			goto out_page;
+		}
+
 		/*
 		 * KSM sometimes has to copy on read faults, for example, if
 		 * folio->index of non-ksm folios would be nonlinear inside the
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-use-unified-helper-for-swap-cache-look-up.patch
mm-swap-fix-swap-cache-index-error-when-retrying-reclaim.patch
mm-swap-check-page-poison-flag-after-locking-it.patch
mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch
mm-swap-rename-and-move-some-swap-cluster-definition-and-helpers.patch
mm-swap-tidy-up-swap-device-and-cluster-info-helpers.patch
mm-swap-cleanup-swap-cache-api-and-add-kerneldoc.patch
mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch
mm-swap-wrap-swap-cache-replacement-with-a-helper.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api.patch
mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch
mm-swap-remove-contention-workaround-for-swap-cache.patch
mm-swap-implement-dynamic-allocation-of-swap-table.patch
mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

