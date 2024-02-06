Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5E81C68F
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 22:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707258391; cv=none; b=kGkNcUs2wdXFdtMIb+pOO+g455jYScuqVy92QU/YesLm8eXiF2HUn4qMxmXCYtD9LeS/fzrd6REMGw4j9yQrlpPqc4M+3S7/moem2c9o8GdtZ6yuJcRThf9c+p0oMi1LQx7SOdMEYKeX+odzs3Po1XxxhqbCUU/iGbAeEzvRfRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707258391; c=relaxed/simple;
	bh=2ExGU/cGK7QFTu2bxshhIPu0F9dEWRoUeSXKwz2VAnA=;
	h=Date:To:From:Subject:Message-Id; b=DnSSw9UjrDs7dNz4zm3tvlKqQ9ot3VL3uonrD8mlin4rvweVNYxCyM/BjeIGmKCjqAn4PnWDN3Me1aLs9SNYFkdp7QFBceGISG9rdHgBLHRL0mrFeXSCkScnaOyNZ3rL1yUP0U9GaLXqA64KRE8tgMfTclm8tAjZAx/haIy7T6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WIaQ+uDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WIaQ+uDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEDEC433C7;
	Tue,  6 Feb 2024 22:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707258390;
	bh=2ExGU/cGK7QFTu2bxshhIPu0F9dEWRoUeSXKwz2VAnA=;
	h=Date:To:From:Subject:From;
	b=WIaQ+uDjkGXKxPqyP2K4U+mRMFrJ7j8pPmjkgB7zCu7PxBZJpVqdr5AafqgWfHe+w
	 +aFFsK3gwaWLdBU4DcVW0jJT1PL4c/iI7HiIDI9I8r2QDqnPg9jbEXnizSc8qWouHb
	 mS3lUElGxc/yFc7ns4nzCV8ux06C9/RiyivMa314=
Date: Tue, 06 Feb 2024 14:26:29 -0800
To: mm-commits@vger.kernel.org,sumit.semwal@linaro.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-cma-drop-cma_get_name.patch removed from -mm tree
Message-Id: <20240206222630.0CEDEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: drop cma_get_name()
has been removed from the -mm tree.  Its filename was
     mm-cma-drop-cma_get_name.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/cma: drop cma_get_name()
Date: Tue, 6 Feb 2024 09:45:18 +0530

cma_get_name() just returns cma->name without any additional
transformation unlike other helpers such as cma_get_base() and
cma_get_size().  This helper is not worth the additional indirection, and
can be dropped after replacing directly with cma->name in the sole caller
__add_cma_heap().

Link: https://lkml.kernel.org/r/20240206041518.438801-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/heaps/cma_heap.c |    2 +-
 include/linux/cma.h              |    1 -
 mm/cma.c                         |    5 -----
 3 files changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/dma-buf/heaps/cma_heap.c~mm-cma-drop-cma_get_name
+++ a/drivers/dma-buf/heaps/cma_heap.c
@@ -376,7 +376,7 @@ static int __add_cma_heap(struct cma *cm
 		return -ENOMEM;
 	cma_heap->cma = cma;
 
-	exp_info.name = cma_get_name(cma);
+	exp_info.name = cma->name;
 	exp_info.ops = &cma_heap_ops;
 	exp_info.priv = cma_heap;
 
--- a/include/linux/cma.h~mm-cma-drop-cma_get_name
+++ a/include/linux/cma.h
@@ -25,7 +25,6 @@ struct cma;
 extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(const struct cma *cma);
 extern unsigned long cma_get_size(const struct cma *cma);
-extern const char *cma_get_name(const struct cma *cma);
 
 extern int __init cma_declare_contiguous_nid(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
--- a/mm/cma.c~mm-cma-drop-cma_get_name
+++ a/mm/cma.c
@@ -45,11 +45,6 @@ unsigned long cma_get_size(const struct
 	return cma->count << PAGE_SHIFT;
 }
 
-const char *cma_get_name(const struct cma *cma)
-{
-	return cma->name;
-}
-
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch

