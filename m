Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828B312B8B
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 17:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707241181; cv=none; b=uxQ0MrM75rGK3lRdlVOiqmw7X8CYBVHhmlFC8LBn/KldVT2V+D4voojVSVsVEwt0KKfysk9pQfUWud+0mwy+ZdnpMkLSoqvhaHG1QRc4L619V6tSupg50QHqz+5XEcmFdSyBsyje3S1AqdR1DlaqX4cRqPUWqet+AZU+xxlpiYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707241181; c=relaxed/simple;
	bh=R1bwBH35NRWTwQFEHGS/utfShp+rZcoI0dXaDfjt0p4=;
	h=Date:To:From:Subject:Message-Id; b=HCjw8DisgjoXEVwahgAhoXb5KR7hU7gQxrTRk9SgK8g7TO/eoR0p22MRwf/GlDniz+Hm5TZIPIcSwo1BtSDA5BiWBRJdA884PogF7YKRD/frihbn3hWwR9WR9SVmRW4gypqbY+PkJkuJmgsWKynpDykI9mvmKLMeQ2o8kHxSwUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SihHFYrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SihHFYrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66D1C43601;
	Tue,  6 Feb 2024 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707241180;
	bh=R1bwBH35NRWTwQFEHGS/utfShp+rZcoI0dXaDfjt0p4=;
	h=Date:To:From:Subject:From;
	b=SihHFYrmKfSPFQM9cR3X+BCQ2jhw1cEMXDesIn3HyiMRS71BjCahCkFrVFdP0+nDz
	 rwkf1LqdGp7u0k93zquTN5DuUsrwu5Z9OO9F5gQBFcJI83HYP1eoKLd+WfBFMzCYkr
	 I+6pMR4W64GOXtmgA8HdGChyYsLDFaQ1qT5olMrU=
Date: Tue, 06 Feb 2024 09:39:40 -0800
To: mm-commits@vger.kernel.org,sumit.semwal@linaro.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-drop-cma_get_name.patch added to mm-unstable branch
Message-Id: <20240206173940.B66D1C43601@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: drop cma_get_name()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-drop-cma_get_name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-drop-cma_get_name.patch

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
mm-cma-drop-cma_get_name.patch

