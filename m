Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672129;
	b=YzgVFfLBvwGisUtQwP2W6lmvdl3fECXu0pt00P5UUST49t6565Y97L6NvzSPqEfXIwUf
	 vzsA2H0QsLqCGnVK7WSuf2tu8XIbfGUooHRv1PDbz/j1arY3gzIsRL9GUV68+COd7VYdv
	 IS5YxETXIE4jAOUClCTrAQRt6ywi9DuYtsvmD+tM9vXDdQJ8GuYrOhrJHpsuke/ohe1PU
	 0+hDoickt95LrH2nW8ReP2UmWw9M7KlGxd/yqv/oJWtVCkxfHNKHhz3qDkDyNgwXsEWW5
	 EpqSXSIJOaEmjvhYke7fTPL9DDvEs+blVbAZMLaPIDym8+GPATyuB0mU3MuFrrN4y9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672129;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xDF0TVp8VFUYEPS3jTGswj9W7jJMr8sB1y+HpdrAs8Q=;
	b=IV0NgRPsUHmFjTEASvZhHeZPzbFoWOpXotlzMKH59nH8xYCtrCYph8ELKFCoRjzpp/l3
	 nGg6ZTHjcFrjF+OCqBugA7ylv20z0eFp24nkl6jSeupTgxaLW7Mwsqqm88Ywz6jCzUzdn
	 qfWPmOtngn0Q2XOscy8QLSlnbkIETbG+/VH9HRXm0lTpTv8eL9MFfpNjznX8FXMR1TztE
	 nSVfveGsGsoSDk/Bjzf2IONZ9CPvBCAPyuu+lnVpqFhgSc6ZD0ejzIijgsTTx72IrgpOW
	 co4MHHTntItth8fO6vCEfXQuMFHHE3hrdqMfUHPMeh07hdtWSbMKVRfbETOVTTX2F2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F4Li128h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346E9606A331;
	Tue,  3 Nov 2026 02:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F4Li128h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6E71F00919;
	Tue,  3 Nov 2026 02:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672129;
	bh=xDF0TVp8VFUYEPS3jTGswj9W7jJMr8sB1y+HpdrAs8Q=;
	h=Date:To:From:Subject;
	b=F4Li128hhU5GnXl4WoxhVuPg8reR9OUcB2j6/1zNb8uqXM7yOKwjN4K6pK8fzP8YM
	 t9JygIWjz7M1EYhyYJEkHIekeyxdKUbVagc897ndAG7H9vyP04v4aAdfdPmOPFC4Lq
	 eVr6+LBt9LEBrqeXPPNDKcTAvs76VOCANbVe94yU=
Date: Mon, 02 Nov 2026 18:15:28 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,
	hannes@cmpxchg.org,brendan.jackman@linux.dev,zenghui.yu@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch removed from -mm tree
Message-Id: <20261103021528.DE6E71F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page_alloc: mark pages freed by __free_pages_core() as not tagged
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: mm/page_alloc: mark pages freed by __free_pages_core() as not tagged
Date: Thu, 22 Oct 2026 20:27:52 +0800

Onlining hotplugged memory (e.g., a dev_dax device bound to kmem) with
CONFIG_MEM_ALLOC_PROFILING_DEBUG triggers:

  alloc_tag was not set
  WARNING: ./include/linux/alloc_tag.h:166 at __pgalloc_tag_sub+0x1fc/0x254
  Call trace:
   __pgalloc_tag_sub+0x1fc/0x254 (P)
   __free_pages_ok+0x14c/0x6ac
   __free_pages_core+0xa8/0x188
   generic_online_page+0x14/0x20
   online_pages+0x220/0x3b0
   memory_subsys_online+0xfc/0x198
   device_online+0x58/0xe0
   state_store+0xf0/0xf8

Pages entering the buddy through __free_pages_core() have never been
allocated, so their allocation tag references are NULL.  The free path,
__free_pages_prepare() -> pgalloc_tag_sub(), expects a valid tag or a
CODETAG_EMPTY mark and warns otherwise.  Paths feeding never-allocated
pages into the buddy are therefore expected to mark them with
clear_page_tag_ref() first, like init_cma_reserved_pageblock() and
free_reserved_pages() do; of __free_pages_core()'s callers only
memblock_free_pages() clears the tag ref itself, and the hotplug
onlining path was missed.

Since all __free_pages_core() callers free never-allocated pages, mark the
head page as not tagged in __free_pages_core() itself instead of relying on
each caller, and drop the now-redundant clearing from
memblock_free_pages().

Link: https://lore.kernel.org/20261022122752.74774-1-zenghui.yu@linux.dev
Fixes: dcfe378c81f7 ("lib: introduce support for page allocation tagging")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 mm/mm_init.c    |    2 --
 mm/page_alloc.c |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged
+++ a/mm/mm_init.c
@@ -2478,8 +2478,6 @@ void __init memblock_free_pages(unsigned
 		return;
 	}
 
-	/* pages were reserved and not allocated */
-	clear_page_tag_ref(page);
 	__free_pages_core(page, order, MEMINIT_EARLY);
 }
 
--- a/mm/page_alloc.c~mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged
+++ a/mm/page_alloc.c
@@ -1616,6 +1616,9 @@ void __meminit __free_pages_core(struct
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
+	/* pages were never allocated */
+	clear_page_tag_ref(page);
+
 	if (page_contains_unaccepted(page, order)) {
 		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
 			return;
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-skip-collapse_compound_extreme-on-thp-allocation-failure.patch
mm-page_alloc-remove-unneeded-forward-declaration-of-__free_pages_ok.patch

