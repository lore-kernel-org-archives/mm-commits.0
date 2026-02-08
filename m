Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90903019B2;
	Sun,  8 Feb 2026 02:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770516196; cv=none; b=PKnxR6X+K8Sg1nnILyiR0AbQJk0ftEbjRtx+xnVjtAlbdoDCdbybxP1C/nEmZ7uWZjVk//L33QgbENgwCvemSCHvrfUWIsIawzEXikgbMivb3+pzkppfBF+OKdov5EZ85VZzUcfECK6hD5UAlAFI8VrqIhmckMDTGbEX7fzE8CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770516196; c=relaxed/simple;
	bh=XQS4cY56FqK4LswF7/bdtC0K+2DFYFfTGsx9e6itWp4=;
	h=Date:To:From:Subject:Message-Id; b=MlJgYK3kPN0nvbEOmlR0p+dz4jfMhZchRSBpURa82N8b/RqyvuUI1ng61exq/whnI+iDFibQwnoAGMd5X4Pbtl5ZXTQRTKw/IelW7xilhpxr9RNnq44CX631L0T5AJ3z/pCNvgivM1V5LIBUUdhTlHr5w6FbrCPP4mTKdPDGkmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n3vNWNg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n3vNWNg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F444C19421;
	Sun,  8 Feb 2026 02:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770516195;
	bh=XQS4cY56FqK4LswF7/bdtC0K+2DFYFfTGsx9e6itWp4=;
	h=Date:To:From:Subject:From;
	b=n3vNWNg9xq3zg347yOp73c/uKq1xA68lsI9m6pp1mVqsGhCSe6Xn5GivfmfQ5Wuon
	 5iBOOzgJ65D9d0yxS4M7aMyjM9BFGWFlwFf07vR7EBY1JzCkKa8vMFMa4ujGu+3Slb
	 upduwlazESH5dR4EQZsX0PZBndQyNhqIaq15HZwA=
Date: Sat, 07 Feb 2026 18:03:14 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,ryncsn@gmail.com,npiggin@gmail.com,mhocko@suse.com,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,mikhail.v.gavrilov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-clear-page-private-in-free_pages_prepare.patch added to mm-unstable branch
Message-Id: <20260208020315.6F444C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: clear page->private in free_pages_prepare()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-clear-page-private-in-free_pages_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-clear-page-private-in-free_pages_prepare.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: mm/page_alloc: clear page->private in free_pages_prepare()
Date: Sat, 7 Feb 2026 22:36:14 +0500

Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
clear it before freeing pages.  When these pages are later allocated as
high-order pages and split via split_page(), tail pages retain stale
page->private values.

This causes a use-after-free in the swap subsystem.  The swap code uses
page->private to track swap count continuations, assuming freshly
allocated pages have page->private == 0.  When stale values are present,
swap_count_continued() incorrectly assumes the continuation list is valid
and iterates over uninitialized page->lru containing LIST_POISON values,
causing a crash:

  KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

Fix this by clearing page->private in free_pages_prepare(), ensuring all
freed pages have clean state regardless of previous use.

Link: https://lkml.kernel.org/r/20260207173615.146159-1-mikhail.v.gavrilov@gmail.com
Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_alloc-clear-page-private-in-free_pages_prepare
+++ a/mm/page_alloc.c
@@ -1429,6 +1429,7 @@ __always_inline bool free_pages_prepare(
 
 	page_cpupid_reset_last(page);
 	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
_

Patches currently in -mm which might be from mikhail.v.gavrilov@gmail.com are

mm-page_alloc-clear-page-private-in-free_pages_prepare.patch

