Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3693EBF34;
	Fri,  6 Feb 2026 17:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770400231; cv=none; b=dVHBjlbnS6+SNHjkJXsSDgtlPhvRKF/XXyd44MFsQDHkWZWgZZI6Y3uuTCV+Nlv5zrXu43YjdDypaBAreKUetvYrcDVLzdxKuHEbowLd6gmDg7dh+rFWxszhH5BN1k0NZKt0OPzX/yMjNDoAVWJdGUdnYchuSA4m1OKRdydG8f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770400231; c=relaxed/simple;
	bh=PiBW61eOR0uLgDNUuNJHwzRcX0ckdpSTq5JYCoUtP08=;
	h=Date:To:From:Subject:Message-Id; b=uv/sw4LoEYPYsPXh3RirqfU4iapOzMSmmr+DOpUgxtCpRMDQY6RL3I+EUkn3uIxIhQ7V1dod2hj5gKBXS44xOeQ95w/EE5JOeErglb4NSNEsAoIen9ueFi3E+bhKqTrhIrsep0+egQfXEWgLgnRLWnMqF9s5r2Ktubd8jRL/haM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DZK6vCxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DZK6vCxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66E0C116C6;
	Fri,  6 Feb 2026 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770400231;
	bh=PiBW61eOR0uLgDNUuNJHwzRcX0ckdpSTq5JYCoUtP08=;
	h=Date:To:From:Subject:From;
	b=DZK6vCxvnmnqcSL4Xno9puqEBnXfSb57qvs8JGuXahMp7pUA47pvoqpnGTx3SAc6c
	 FFRokjqPBNN6E5UEK8JjyEdw5qrKqC6xrj2UbCzRDMdQgoMq3jCV2wenj5851h/3Pt
	 4do0s99qf+mdEgEly962DDpXshE9Z2JTffVWelQU=
Date: Fri, 06 Feb 2026 09:50:30 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,ryncsn@gmail.com,mhocko@suse.com,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,mikhail.v.gavrilov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-clear-page-private-in-split_page-for-tail-pages.patch added to mm-unstable branch
Message-Id: <20260206175030.E66E0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: clear page->private in split_page() for tail pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-clear-page-private-in-split_page-for-tail-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-clear-page-private-in-split_page-for-tail-pages.patch

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

mm-page_alloc-clear-page-private-in-split_page-for-tail-pages.patch

