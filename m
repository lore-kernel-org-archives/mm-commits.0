Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792692967;
	b=OOeBF/X0w1HJE0wVktl1t6auSZmpipoQcNjacXtDfdDkgOIDnuM2kQ048kJtN5IlKQMI
	 zS+vpB9ar9OE79J+zfPzonIN7nRQuzmT3mXpbRpuO2YefHhFTL2vPnyZwz7wKO66H0HiX
	 6bcMECD2aiKXXNQOHgthfh2Y11V7/xpAMIhWJ8OpODjC9us6Or0aeFS4c/fcMM4NND51D
	 8QVVk2O6byIXE00MLkvHiUN8kok0dbi6DhQ3QXMNidUMBbPnmWu6AKSCLJb1qojJelcC6
	 t88mH8BvzqBjVFSGgYYZUVGmhZrFTlnhF87JcgxoF5Gj9bJ505++WBrTeG8s4ipW4KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792692967;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8OEw3h1+OIAQfp7oEkz5fkn1ZDsZaUVZJP4+1eALmW4=;
	b=Gg186YnxJB95uWY6LxR/2tS9+5GW1aiTjGEbYoKPhuzk4H4oQEkUeZs0pDmH0WeBjDco
	 pwrqNrwpPpzVYQ/0MHU3j1Fi07CUDvsJRYd+DVDqpBl4eIsGJdEl7TBpwVU8wjLAsvm++
	 mP7Ex6/hHqRqfZvbDyDjzXkXVAUVSMKq/nhP+oblouNS/K3Gy00iEwWq4zrmUtl42xcpW
	 3yH0XIN/yjT49CpLIsXkcFp3/Uc4p0VGQdY5D23umz8tr8pOhg4RIUf17un/Qi2554Mro
	 8t0MjoziKV0JKQuHJ+85z5JiP5KkRB4o2VEQTyg17U8WI7jqSffBuyyYw6kyz1BUEFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nf7rzrhY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFFB606A320
	for <mm-commits@vger.kernel.org>; Thu, 22 Oct 2026 18:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nf7rzrhY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5D41F01825;
	Thu, 22 Oct 2026 18:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792692966;
	bh=8OEw3h1+OIAQfp7oEkz5fkn1ZDsZaUVZJP4+1eALmW4=;
	h=Date:To:From:Subject;
	b=nf7rzrhYqyHUbwORn1hfSI8ZQ55bHM7W7Hu7ub3P7ztmWzAKH5J7ekuZlbmRf9H+v
	 vobCM57k8G5qE1r0XyhuDuk54my0+CBFgkwMV4WoktHtoYaIp9ldrzNn0jcjgwvvRt
	 x2h4qGH2edodZiNoYXdyJUMOhXn/1VmUKDA2x9fs=
Date: Thu, 22 Oct 2026 11:16:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch added to mm-unstable branch
Message-Id: <20261022181606.1A5D41F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_alloc: mark pages freed by __free_pages_core() as not tagged
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch

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
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/mm_init.c    |    2 --
 mm/page_alloc.c |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged
+++ a/mm/mm_init.c
@@ -2486,8 +2486,6 @@ void __init memblock_free_pages(unsigned
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

mm-damon-api-remove-unused-nr_damos_-enumerators.patch
selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems.patch
mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch

