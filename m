Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304C31993B7
	for <mm-commits@vger.kernel.org>; Fri,  5 Sep 2025 00:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757032833; cv=none; b=mKh56Cfkh3DbFKteMxGXVo+afsUrf+VkN43khAQzIffVhExw2ZsXdA+bEz1N1QLeZ3Vxbqx6iASH9fW3v59yt7pd6NHt346pd20zZRwxOlIxLcU2mkI0F5c8e7Q+gikf5tb6QxbnZAmHOlfsAjaQ9Gp23D+TVW30DqFeRT4jKnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757032833; c=relaxed/simple;
	bh=kPE7TrQHf2EnnNDTy7f6UsauO5j4HDjGjsnpN/gYJtQ=;
	h=Date:To:From:Subject:Message-Id; b=kkwNwL2zhtbaoB+5xkRQLjVRAEatZBoAqZYlC4rudpi2hrADjnHfG0hKKXiAwBp4yKuGWbplZAkh55l436Braj4RD/pWQuvLDoYltOOzHBEUyzkKWymMqcNW+yDXsg04pAsaroGPeJKU6wFS3rwjkb0xeAYfT+bvr7WH9dgqfXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bk5jV8Xq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bk5jV8Xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD8FC4CEF0;
	Fri,  5 Sep 2025 00:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757032832;
	bh=kPE7TrQHf2EnnNDTy7f6UsauO5j4HDjGjsnpN/gYJtQ=;
	h=Date:To:From:Subject:From;
	b=Bk5jV8XqF1cEuaXPoQhW42cfcftBlwGK2bZVCjEt9dYa7zojeO5XqG98dUzl8XsRy
	 RvZjSUD3QiLX1abI/4FnQcOO2GntNoD1N3Lf8DqrJWtvd/etSJYmvYuRdZtswPXsjH
	 JMTELRtpcxt80wN1v5cBQSDmrHfjQH9cdIVxkRCY=
Date: Thu, 04 Sep 2025 17:40:32 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,dan.j.williams@intel.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-remove-unused-get_dev_pagemap-parameter.patch added to mm-new branch
Message-Id: <20250905004032.CBD8FC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memremap: remove unused get_dev_pagemap() parameter
has been added to the -mm mm-new branch.  Its filename is
     mm-memremap-remove-unused-get_dev_pagemap-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-remove-unused-get_dev_pagemap-parameter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/memremap: remove unused get_dev_pagemap() parameter
Date: Thu, 4 Sep 2025 08:59:26 +1000

GUP no longer uses get_dev_pagemap().  As it was the only user of the
get_dev_pagemap() pgmap caching feature it can be removed.

Link: https://lkml.kernel.org/r/20250903225926.34702-2-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    6 ++----
 mm/memory-failure.c      |    2 +-
 mm/memory_hotplug.c      |    2 +-
 mm/memremap.c            |   22 ++++------------------
 4 files changed, 8 insertions(+), 24 deletions(-)

--- a/include/linux/memremap.h~mm-memremap-remove-unused-get_dev_pagemap-parameter
+++ a/include/linux/memremap.h
@@ -211,8 +211,7 @@ void *memremap_pages(struct dev_pagemap
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
-struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap);
+struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
@@ -234,8 +233,7 @@ static inline void devm_memunmap_pages(s
 {
 }
 
-static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap)
+static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
 {
 	return NULL;
 }
--- a/mm/memory-failure.c~mm-memremap-remove-unused-get_dev_pagemap-parameter
+++ a/mm/memory-failure.c
@@ -2194,7 +2194,7 @@ int memory_failure(unsigned long pfn, in
 			goto unlock_mutex;
 
 		if (pfn_valid(pfn)) {
-			pgmap = get_dev_pagemap(pfn, NULL);
+			pgmap = get_dev_pagemap(pfn);
 			put_ref_page(pfn, flags);
 			if (pgmap) {
 				res = memory_failure_dev_pagemap(pfn, flags,
--- a/mm/memory_hotplug.c~mm-memremap-remove-unused-get_dev_pagemap-parameter
+++ a/mm/memory_hotplug.c
@@ -375,7 +375,7 @@ struct page *pfn_to_online_page(unsigned
 	 * the section may be 'offline' but 'valid'. Only
 	 * get_dev_pagemap() can determine sub-section online status.
 	 */
-	pgmap = get_dev_pagemap(pfn, NULL);
+	pgmap = get_dev_pagemap(pfn);
 	put_dev_pagemap(pgmap);
 
 	/* The presence of a pgmap indicates ZONE_DEVICE offline pfn */
--- a/mm/memremap.c~mm-memremap-remove-unused-get_dev_pagemap-parameter
+++ a/mm/memremap.c
@@ -153,14 +153,14 @@ static int pagemap_range(struct dev_page
 				"altmap not supported for multiple ranges\n"))
 		return -EINVAL;
 
-	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->start), NULL);
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->start));
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
 		return -ENOMEM;
 	}
 
-	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->end), NULL);
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->end));
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
@@ -397,26 +397,12 @@ EXPORT_SYMBOL_GPL(devm_memunmap_pages);
 /**
  * get_dev_pagemap() - take a new live reference on the dev_pagemap for @pfn
  * @pfn: page frame number to lookup page_map
- * @pgmap: optional known pgmap that already has a reference
- *
- * If @pgmap is non-NULL and covers @pfn it will be returned as-is.  If @pgmap
- * is non-NULL but does not cover @pfn the reference to it will be released.
  */
-struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap)
+struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
 {
+	struct dev_pagemap *pgmap;
 	resource_size_t phys = PFN_PHYS(pfn);
 
-	/*
-	 * In the cached case we're already holding a live reference.
-	 */
-	if (pgmap) {
-		if (phys >= pgmap->range.start && phys <= pgmap->range.end)
-			return pgmap;
-		put_dev_pagemap(pgmap);
-	}
-
-	/* fall back to slow path lookup */
 	rcu_read_lock();
 	pgmap = xa_load(&pgmap_array, PHYS_PFN(phys));
 	if (pgmap && !percpu_ref_tryget_live_rcu(&pgmap->ref))
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-gup-remove-dead-pgmap-refcounting-code.patch
mm-memremap-remove-unused-get_dev_pagemap-parameter.patch

