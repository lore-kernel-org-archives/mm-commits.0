Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1AD2E8B81;
	Thu, 12 Feb 2026 23:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939872; cv=none; b=rEhB7PuAGOcirbonP1RleXy7jMb/4eVWMgeg4EIr5hyXmfHdL3xM3rqPM6nlRmNEYVlMV7YqsD8n6xsjKdNDz8Cf/JZBfqtV2FMvveMP9RFmxRPObDalZnx6m27uBN7hl5Rwuxa1gar0boVuEw61NN+9kFN7PHCcGF4SZnmNU2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939872; c=relaxed/simple;
	bh=qW0RZrgvKKG6wUB5z+KzsiFjuiRYucR3Xh8F8iKeirg=;
	h=Date:To:From:Subject:Message-Id; b=R3yLr6u4j2jOg8afYxp+c8CANiYG5Er2YGGiw27UAO4S7eYRJxSIxBFjt14ABcBjrB2oMV5q9Ak2ApSmtQDAM5/GusIvbPvDlv0NpmfuXo0IICsj/In8zAsaeVfLbr/0XGBY3BKp1GAy9mIP1ZTeoA+SAi/U4HJYlJe4YZbKNKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1rOC/5+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1rOC/5+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEF8C4CEF7;
	Thu, 12 Feb 2026 23:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939872;
	bh=qW0RZrgvKKG6wUB5z+KzsiFjuiRYucR3Xh8F8iKeirg=;
	h=Date:To:From:Subject:From;
	b=1rOC/5+zp2FmNokLDaotcsK2nJcfOrUNo2MM4i2QATVM0z2uosnxu5Ezs28Gzyl6S
	 41s86XpmkTqg1ff6Bx1pKmvdWS7vLCisj8CJDlEU4K/7gcB1e0CcvVU+rnjvsJ+v79
	 FRxiVXhJgpHUeoCctnC4dWeherjsSO4Fo85zcwVg=
Date: Thu, 12 Feb 2026 15:44:31 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,ryncsn@gmail.com,npiggin@gmail.com,mhocko@suse.com,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,mikhail.v.gavrilov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-clear-page-private-in-free_pages_prepare.patch removed from -mm tree
Message-Id: <20260212234432.0EEF8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: clear page->private in free_pages_prepare()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-clear-page-private-in-free_pages_prepare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
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


