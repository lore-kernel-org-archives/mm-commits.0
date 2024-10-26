Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A711AF9CF
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729985488; cv=none; b=iKVni/zWgjSUJc/gFBFm9stHJHKDZ3yMcQTKBsbgBGQoocDU4yQtbdaEKpCfWfWAiLWE1c2k76gRFzp/dQh1yThOB3qXC8PfEvxEuuEeUVaIO7n9cs2ZiSJQa1V11H9PRT75NNP4aeDncpSJlPW/YPHBfQ9CxA+DQH/30tZ6z/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729985488; c=relaxed/simple;
	bh=plkNQuR57h+veSZboGf/T1GAinzVC2ZnEiIM29p89uw=;
	h=Date:To:From:Subject:Message-Id; b=iOB+FdkHGiRP9gXq050Wh+3hCXliWUyqsM427S6x8qhrbuNHwjJj8+ib7LZGVEoCjcw/yBU+xsDaucXZZ0dFBp28f+HppjGS4OxQNOeMt5gpWiB4UzA+J3iywGDxW8MkT2VRoeFs3au9iyYfOB/zppa/BluvM8i/xIruMnUGWSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AypKsg7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AypKsg7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0956EC4CEC6;
	Sat, 26 Oct 2024 23:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729985487;
	bh=plkNQuR57h+veSZboGf/T1GAinzVC2ZnEiIM29p89uw=;
	h=Date:To:From:Subject:From;
	b=AypKsg7sXAjhPjaYupQcTvyIXTv94eIwx1gDxtTpwjjmnemYEn9vyRq0qVVC5DeIt
	 JPR8OTmev/pr2d+dpbvqmAjPNOpgIgn8csQndz+Xa+y4Y6aCdlFAYMTWGokBJr/JDU
	 OqxrfHDZTWQGPLO4q1aLobPfYf8uqt6WbQUM1iLM=
Date: Sat, 26 Oct 2024 16:31:26 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-aligned-address-in-copy_user_gigantic_page.patch added to mm-unstable branch
Message-Id: <20241026233127.0956EC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use aligned address in copy_user_gigantic_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-aligned-address-in-copy_user_gigantic_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-aligned-address-in-copy_user_gigantic_page.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use aligned address in copy_user_gigantic_page()
Date: Sat, 26 Oct 2024 13:43:07 +0800

When copying gigantic page, it copies page from the first page to the last
page, if directly passing addr_hint which maybe not the address of the
first page of folio, then some archs could flush the wrong cache if it
does use the addr_hint as a hint.  For non-gigantic page, it calculates
the base address inside, even passed the wrong addr_hint, it only has
performance impact as the process_huge_page() wants to process target page
last to keep its cache lines hot), no functional impact.

Let's pass the real accessed address to copy_user_large_folio() and use
the aligned address in copy_user_gigantic_page() to fix it.

Link: https://lkml.kernel.org/r/20241026054307.3896926-2-wangkefeng.wang@huawei.com
Fixes: 530dd9926dc1 ("mm: memory: improve copy_user_large_folio()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 mm/memory.c  |    1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-use-aligned-address-in-copy_user_gigantic_page
+++ a/mm/hugetlb.c
@@ -5338,7 +5338,7 @@ again:
 					break;
 				}
 				ret = copy_user_large_folio(new_folio, pte_folio,
-						ALIGN_DOWN(addr, sz), dst_vma);
+							    addr, dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
 					folio_put(new_folio);
@@ -6641,8 +6641,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			*foliop = NULL;
 			goto out;
 		}
-		ret = copy_user_large_folio(folio, *foliop,
-					    ALIGN_DOWN(dst_addr, size), dst_vma);
+		ret = copy_user_large_folio(folio, *foliop, dst_addr, dst_vma);
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
--- a/mm/memory.c~mm-use-aligned-address-in-copy_user_gigantic_page
+++ a/mm/memory.c
@@ -6849,6 +6849,7 @@ static int copy_user_gigantic_page(struc
 	struct page *dst_page;
 	struct page *src_page;
 
+	addr = ALIGN_DOWN(addr, folio_size(dst));
 	for (i = 0; i < nr_pages; i++) {
 		dst_page = folio_page(dst, i);
 		src_page = folio_page(src, i);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-unused-hugepage-for-vma_alloc_folio.patch
tmpfs-dont-enable-large-folios-if-not-supported.patch
mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch
mm-shmem-remove-__shmem_huge_global_enabled.patch
mm-use-aligned-address-in-clear_gigantic_page.patch
mm-use-aligned-address-in-copy_user_gigantic_page.patch

