Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD4455769;
	Thu,  8 Aug 2024 22:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723155275; cv=none; b=JhJJQ/33VNLMt69GJQ2SPkDtMdoJ5Zuc3Zmf7hrhJ6dLFRLysohNBmiHfQ6FaskVoHAB4fbLHcQVYRhhdbB+sQKmahLcyeWjoYWluP/bGNp3jfbtW/UpJIKaEI2NO5vNIdOm8a7FnP23V3L22dwxX49i5kiWzbTQDvZ2OwaoGM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723155275; c=relaxed/simple;
	bh=JwZUtwKq5xlUkx42ZIEvwgsvGXWiyNLES4OPj1Tdd8A=;
	h=Date:To:From:Subject:Message-Id; b=EZHxgmd7S+bbNPas6fsMmnNB+zAalO2m3fAWcj2+4B3Uo3o2asAE1FGzjY4IXGkVyHIcKE2PIoA2+qH+5H/gQq+shD2r8u/Zw8ObaFJWegVdHuilfjpWV/ZTCwCpKTKzOVMW89S/mnqLBohgiG3k6uRpb2AL6U59iLKcRsXOatM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TDLhEdMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TDLhEdMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9785C32782;
	Thu,  8 Aug 2024 22:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723155275;
	bh=JwZUtwKq5xlUkx42ZIEvwgsvGXWiyNLES4OPj1Tdd8A=;
	h=Date:To:From:Subject:From;
	b=TDLhEdMWRQQfeCrcfkOqH9P2SdHOYuRE+/AUDuCwis9AJEykSod8HRkMf+lj9nkJN
	 zM9CJMO2MmvKtRtwxWuisTCI5YQ6etjXA7iTjPA8MYJkRFwCAN49DEf0hFViPa/yAY
	 vGlWviR4CAow5ndoPO2AlnB0Hxwqb8GYeWF8nV/Y=
Date: Thu, 08 Aug 2024 15:14:34 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,willy@infradead.org,urezki@gmail.com,stable@vger.kernel.org,bhe@redhat.com,baohua@kernel.org,hailong.liu@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-page-mapping-if-vm_area_alloc_pages-with-high-order-fallback-to-order-0.patch added to mm-hotfixes-unstable branch
Message-Id: <20240808221434.E9785C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-fix-page-mapping-if-vm_area_alloc_pages-with-high-order-fallback-to-order-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-page-mapping-if-vm_area_alloc_pages-with-high-order-fallback-to-order-0.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hailong Liu <hailong.liu@oppo.com>
Subject: mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0
Date: Thu, 8 Aug 2024 20:19:56 +0800

The __vmap_pages_range_noflush() assumes its argument pages** contains
pages with the same page shift.  However, since commit e9c3cda4d86e ("mm,
vmalloc: fix high order __GFP_NOFAIL allocations"), if gfp_flags includes
__GFP_NOFAIL with high order in vm_area_alloc_pages() and page allocation
failed for high order, the pages** may contain two different page shifts
(high order and order-0).  This could lead __vmap_pages_range_noflush() to
perform incorrect mappings, potentially resulting in memory corruption.

Users might encounter this as follows (vmap_allow_huge = true, 2M is for
PMD_SIZE):

kvmalloc(2M, __GFP_NOFAIL|GFP_X)
    __vmalloc_node_range_noprof(vm_flags=VM_ALLOW_HUGE_VMAP)
        vm_area_alloc_pages(order=9) ---> order-9 allocation failed and fallback to order-0
            vmap_pages_range()
                vmap_pages_range_noflush()
                    __vmap_pages_range_noflush(page_shift = 21) ----> wrong mapping happens

We can remove the fallback code because if a high-order allocation fails,
__vmalloc_node_range_noprof() will retry with order-0.  Therefore, it is
unnecessary to fallback to order-0 here.  Therefore, fix this by removing
the fallback code.

Link: https://lkml.kernel.org/r/20240808122019.3361-1-hailong.liu@oppo.com
Fixes: e9c3cda4d86e ("mm, vmalloc: fix high order __GFP_NOFAIL allocations")
Signed-off-by: Hailong Liu <hailong.liu@oppo.com>
Reported-by: Tangquan Zheng <zhengtangquan@oppo.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-page-mapping-if-vm_area_alloc_pages-with-high-order-fallback-to-order-0
+++ a/mm/vmalloc.c
@@ -3584,15 +3584,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			page = alloc_pages_noprof(alloc_gfp, order);
 		else
 			page = alloc_pages_node_noprof(nid, alloc_gfp, order);
-		if (unlikely(!page)) {
-			if (!nofail)
-				break;
-
-			/* fall back to the zero order allocations */
-			alloc_gfp |= __GFP_NOFAIL;
-			order = 0;
-			continue;
-		}
+		if (unlikely(!page))
+			break;
 
 		/*
 		 * Higher order allocations must be able to be treated as
_

Patches currently in -mm which might be from hailong.liu@oppo.com are

mm-vmalloc-fix-page-mapping-if-vm_area_alloc_pages-with-high-order-fallback-to-order-0.patch

