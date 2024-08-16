Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4608C8005B;
	Fri, 16 Aug 2024 05:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785418; cv=none; b=EbTYenIYKOpw/mkoz52PnHETOG178M2BA1xZcayS0JQ5gnwU4TcdTkisSbZQCXmHp0bJddWSGCr8KfvT4Gph+WLnOPlf7VQtIi07ji8OZ0iTv80iI9URZRXTd9SlPWuYhCRSiZGzT+PR1WTBAaDibJJG5dhw/rcggRkf5V3ThIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785418; c=relaxed/simple;
	bh=rl1qikBqr2hmiOML9y/s0RcliLFqJiNfDD166Qmmy3w=;
	h=Date:To:From:Subject:Message-Id; b=H20I9hI07CQdREQfIHDKu+heKEZSFm4IArtqFuKAB3Qke7LvfWZA7cZ86de4Sv0ZFzCrOR54ugeFOB+dZbky2lpmRtwnSqBxoju2VZMR6N1ZbuV92ceyl0H/0BKdcnCobpunHS7NdylrKryBNBEPi1g11Vj7aAg8kVVr2Z2EnFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xl4uy2xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xl4uy2xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180EBC32782;
	Fri, 16 Aug 2024 05:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785418;
	bh=rl1qikBqr2hmiOML9y/s0RcliLFqJiNfDD166Qmmy3w=;
	h=Date:To:From:Subject:From;
	b=xl4uy2xmwrTCUTRb5Xf9GARo/B4fXtUJsAGueOSYIFlMQKo+qutgmsrf/6RyQNbaJ
	 uJcvhu4h3gv5/F66EzpTJ8RW6+wgQDWZCbVNJapvTfGxxJV5/rzMEKP2eIgzvIlCOo
	 irsjsg3Fnc9JxQhQBKrQt6TiYo9U/AHO76dzzzF0=
Date: Thu, 15 Aug 2024 22:16:57 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,willy@infradead.org,urezki@gmail.com,stable@vger.kernel.org,mhocko@suse.com,bhe@redhat.com,baohua@kernel.org,hailong.liu@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-fix-page-mapping-if-vm_area_alloc_pages-with-high-order-fallback-to-order-0.patch removed from -mm tree
Message-Id: <20240816051658.180EBC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-page-mapping-if-vm_area_alloc_pages-with-high-order-fallback-to-order-0.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Michal Hocko <mhocko@suse.com>
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


