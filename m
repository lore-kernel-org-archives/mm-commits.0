Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD231367
	for <mm-commits@vger.kernel.org>; Wed, 12 Feb 2025 00:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739319236; cv=none; b=ESJEhqGo5nmwjpgYuzR5x6LR8eL7ZCbDo9nhQda55PsBNRRPRlvVeUMVhG6U3wvoEkE4Tam+V5EjN/SnGGSdnw20J4xWnEtf7zrLHEMGS8WnkT5dgsDNpVRoJkm/XDJ49Aepmwpc6cFCpcP6wuAhLfoGl5//04LOX4PQpku2vbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739319236; c=relaxed/simple;
	bh=ITjGJGu/gQt/34XvhsHsI+tZKBiYvzC+svwlIouM/2E=;
	h=Date:To:From:Subject:Message-Id; b=oSJo9gdmVQYM7QSE12AD0VlNad3No+ytghEqoYVwoDgYXU1IX1a4rm0UDuc/WKP8a3MO3tMPgkG252hUqF3jTb2QEsI41XmOXr6w8+s6zKtekqCmmV9TyF9wlk/ottT/HxNWooC9QAz/VpXKtNUDDsMQr3nxZTB/Fb0ozrWOZ7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2GQkkaRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2GQkkaRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B61C4CEDD;
	Wed, 12 Feb 2025 00:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739319236;
	bh=ITjGJGu/gQt/34XvhsHsI+tZKBiYvzC+svwlIouM/2E=;
	h=Date:To:From:Subject:From;
	b=2GQkkaReLg1zH85uK+8QZ+psI4xK2WMo0nLi8g6iSk1B/AGa1JuucdfzILfCRjcVK
	 cspXyW02S8tGS0t+ADDIrlDMRQqUwcNSDpptw+y3YfOAS4t0JNBXN6NBcxWm4n+12A
	 P3pp+SE9bx+k73AmFpzJ3Yx0eAurfFbEBoi2UL+k=
Date: Tue, 11 Feb 2025 16:13:55 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,aneesh.kumar@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-clean-up-the-stale-code-comment.patch added to mm-unstable branch
Message-Id: <20250212001356.19B61C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_gather: clean up the stale code comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_gather-clean-up-the-stale-code-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-clean-up-the-stale-code-comment.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/mmu_gather: clean up the stale code comment
Date: Tue, 11 Feb 2025 11:43:48 +0800

In commit d7f861b9c43a ("mm/mmu_gather: add __tlb_remove_folio_pages()"),
helper function __tlb_remove_folio_pages_size() was added.  And based on
the helper, wrapper functions __tlb_remove_folio_pages() and
__tlb_remove_page_size() are created and used by upper level functions.

So let's update the code comment to reflect the current code about
tlb_remove_page()/tlb_remove_page_size(), etc.

Link: https://lkml.kernel.org/r/20250211034348.39531-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/include/asm-generic/tlb.h~mm-mmu_gather-clean-up-the-stale-code-comment
+++ a/include/asm-generic/tlb.h
@@ -72,22 +72,21 @@
  *
  *    See also MMU_GATHER_TABLE_FREE and MMU_GATHER_RCU_TABLE_FREE.
  *
- *  - tlb_remove_page() / __tlb_remove_page()
- *  - tlb_remove_page_size() / __tlb_remove_page_size()
- *  - __tlb_remove_folio_pages()
- *
- *    __tlb_remove_page_size() is the basic primitive that queues a page for
- *    freeing. __tlb_remove_page() assumes PAGE_SIZE. Both will return a
- *    boolean indicating if the queue is (now) full and a call to
- *    tlb_flush_mmu() is required.
+ *  - tlb_remove_page() / tlb_remove_page_size()
+ *  - __tlb_remove_folio_pages() / __tlb_remove_page_size()
+ *  - __tlb_remove_folio_pages_size()
+ *
+ *    __tlb_remove_folio_pages_size() is the basic primitive that queues pages
+ *    for freeing. It will return a boolean indicating if the queue is (now)
+ *    full and a call to tlb_flush_mmu() is required.
  *
  *    tlb_remove_page() and tlb_remove_page_size() imply the call to
  *    tlb_flush_mmu() when required and has no return value.
  *
- *    __tlb_remove_folio_pages() is similar to __tlb_remove_page(), however,
- *    instead of removing a single page, remove the given number of consecutive
- *    pages that are all part of the same (large) folio: just like calling
- *    __tlb_remove_page() on each page individually.
+ *    __tlb_remove_folio_pages() is similar to __tlb_remove_page_size(),
+ *    however, instead of removing a single page, assume PAGE_SIZE and remove
+ *    the given number of consecutive pages that are all part of the
+ *    same (large) folio.
  *
  *  - tlb_change_page_size()
  *
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch
mm-mmu_gather-remove-unused-__tlb_remove_page.patch
mm-mmu_gather-clean-up-the-stale-code-comment.patch

