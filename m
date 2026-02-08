Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2062F22A7E4;
	Sun,  8 Feb 2026 01:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770515774; cv=none; b=Hikk8U5VL+4nD/P+CIMt8hr1tcZksp5yswhlEgzbus8aauD5ItNtt32VEwGR04ju3zZYy3ClGcgAxjwIdoCfoxFK/CPHp4nysaheQDB4LVD5D93PTh8RuEbYvYnS08c4FK16jvd/E8oaXTd4STRYNYln6Ih3rP95sDpXIRcitHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770515774; c=relaxed/simple;
	bh=qhT1YKDCoWAuQ/fbU+Jzft0KtxWaMjItJpa4qonB32w=;
	h=Date:To:From:Subject:Message-Id; b=lzwU25oCmJoy7KRBc2Ia19Sxl/Ebuh9nDmOtfuR28euqEapTKOMEfgf7Wmv7TfcVc7DND1GRChyxbf01IJBTSrtdejry/iaz7qD5R7u+2e7e+NreQAKfIohf7ktzPk0jEXiP02CisRskMhzfJ8tpMJYbHTASc4TA8dRCyZpGbZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0aJTX17I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0aJTX17I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76245C116D0;
	Sun,  8 Feb 2026 01:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770515773;
	bh=qhT1YKDCoWAuQ/fbU+Jzft0KtxWaMjItJpa4qonB32w=;
	h=Date:To:From:Subject:From;
	b=0aJTX17Ii1LkYvrnwraMEyOiEFw4D2Tzij8J68TZ6use8Gqsq6q+yYbIKO2ab4SI6
	 AoutnVbhAlZng8b0+SoHd2z8Mvtbcrunzm6gSvMRVkiaPjs0iUGzkdEBXKwXXd2wqO
	 UTPYqL/Ta4GYHWkgBFMP8fB2B5PGm1Tt7Cyaakb8=
Date: Sat, 07 Feb 2026 17:56:12 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,ryncsn@gmail.com,mhocko@suse.com,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,mikhail.v.gavrilov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-clear-page-private-in-split_page-for-tail-pages.patch removed from -mm tree
Message-Id: <20260208015613.76245C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: clear page->private in split_page() for tail pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-clear-page-private-in-split_page-for-tail-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: mm/page_alloc: clear page->private in split_page() for tail pages
Date: Fri, 6 Feb 2026 22:40:17 +0500

When vmalloc allocates high-order pages and splits them via split_page(),
tail pages may retain stale page->private values from previous use by the
buddy allocator.

This causes a use-after-free in the swap subsystem. The swap code uses
vmalloc_to_page() to get struct page pointers for swap_map, then uses
page->private to track swap count continuations. In add_swap_count_
continuation(), the condition "if (!page_private(head))" assumes fresh
pages have page->private == 0, but tail pages from split_page() may have
non-zero stale values.

When page->private accidentally contains a value like SWP_CONTINUED (32),
swap_count_continued() incorrectly assumes the continuation list is valid
and iterates over uninitialized page->lru, which may contain LIST_POISON
values from a previous list_del(), causing a crash:

  KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

Fix this by clearing page->private for tail pages in split_page(). Note
that we don't touch page->lru to avoid breaking split_free_page() which
may have the head page on a list.

Link: https://lkml.kernel.org/r/20260206174017.128673-1-mikhail.v.gavrilov@gmail.com
Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-clear-page-private-in-split_page-for-tail-pages
+++ a/mm/page_alloc.c
@@ -3129,9 +3129,14 @@ void split_page(struct page *page, unsig
 
 	VM_WARN_ON_PAGE(!page_count(page), page);
 
-	for (i = 1; i < (1 << order); i++)
+	for (i = 1; i < (1 << order); i++) {
 		set_page_refcounted(page + i);
-
+		/*
+		 * Tail pages may have stale page->private from buddy
+		 * allocator or previous use. Clear it.
+		 */
+		set_page_private(page + i, 0);
+	}
 	__split_page(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
_

Patches currently in -mm which might be from mikhail.v.gavrilov@gmail.com are


