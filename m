Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDF1511208
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 19:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788465538; cv=none; b=sZ9VLWM/zoDnM1+F5uCi6YTjjH3fZqL08pFhggude8jWrwttLmTIuB/Plvzw00/7bZcIcajOj/BaKxQc+QUAoq4BnqUQ9FUo+nkKmd6EVmGm8A3N/aLGS7c4YlOAC1h7nFPn0ynfdes4qD2hoJbUSJHeeAlpQH0f+1wClRlD9Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788465538; c=relaxed/simple;
	bh=WwnTv3o/i+nzTRTqFxLIgNJqm8/nZmZSoTroNy9QjwA=;
	h=Date:To:From:Subject:Message-Id; b=X6nUGrL7oKnToth9AITpEiqjvXM8j4nbO5A4CKXioOlayKSbwxKhzN8RsMVBg6nAIT9YEQUtevy3XT8yjqIGSbiVkBEO9R8Xup/f8TOc1TLwsfHCQnzVK1wl0S+qfbkFOHEg9dA1i0QAaTKzIV2BzX76XCrWsJTjg3b55yknUkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1OF9szLZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1OF9szLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC031F00A3D;
	Thu,  3 Sep 2026 19:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788465526;
	bh=e3YQj/lcQMAiw1kdNfzrzDI1mvgSOYRDDJKKSY5mKIE=;
	h=Date:To:From:Subject;
	b=1OF9szLZ7+yd9Nn8cj7YkGFX00lJx+U0nuJFU3fFG+t0Wh8JYwWeVoNKmtTsCSyt2
	 Xomx7VR6SD5qX4vvLr7xIQ1/buCVTB6M3iFzzMWFWajMeC11Rxma+zTNrKyCZUD8eK
	 vzYb6WRtthRetr8NvEC0UcyOKUxPLJj4dI1GyTZc=
Date: Thu, 03 Sep 2026 12:58:45 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,iweiny@kernel.org,david@kernel.org,dave.jiang@intel.com,alison.schofield@intel.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nvdimm-pmem-remove-test_and_clear_pmem_poison.patch added to mm-new branch
Message-Id: <20260903195846.4CC031F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nvdimm/pmem: remove test_and_clear_pmem_poison()
has been added to the -mm mm-new branch.  Its filename is
     nvdimm-pmem-remove-test_and_clear_pmem_poison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nvdimm-pmem-remove-test_and_clear_pmem_poison.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: nvdimm/pmem: remove test_and_clear_pmem_poison()
Date: Thu, 3 Sep 2026 13:35:35 +0800

TestClearPageHWPoison() is now defined regardless of whether
CONFIG_MEMORY_FAILURE is enabled, returning false when memory failure
handling is unavailable.

The test_and_clear_pmem_poison() wrapper duplicates this configuration
handling and has no other pmem-specific behavior.

Call TestClearPageHWPoison() directly and remove the redundant wrapper. 
This also removes the need to include page-flags.h from pmem.h.

No functional change is intended.

Link: https://lore.kernel.org/20260903053535.17611-3-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/pmem.c |    2 +-
 drivers/nvdimm/pmem.h |   12 ------------
 2 files changed, 1 insertion(+), 13 deletions(-)

--- a/drivers/nvdimm/pmem.c~nvdimm-pmem-remove-test_and_clear_pmem_poison
+++ a/drivers/nvdimm/pmem.c
@@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct p
 		 * here since we're in the driver I/O path and
 		 * outstanding I/O requests pin the dev_pagemap.
 		 */
-		if (test_and_clear_pmem_poison(page))
+		if (TestClearPageHWPoison(page))
 			clear_mce_nospec(pfn);
 	}
 }
--- a/drivers/nvdimm/pmem.h~nvdimm-pmem-remove-test_and_clear_pmem_poison
+++ a/drivers/nvdimm/pmem.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __NVDIMM_PMEM_H__
 #define __NVDIMM_PMEM_H__
-#include <linux/page-flags.h>
 #include <linux/badblocks.h>
 #include <linux/memremap.h>
 #include <linux/types.h>
@@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_de
 		long nr_pages, enum dax_access_mode mode, void **kaddr,
 		unsigned long *pfn);
 
-#ifdef CONFIG_MEMORY_FAILURE
-static inline bool test_and_clear_pmem_poison(struct page *page)
-{
-	return TestClearPageHWPoison(page);
-}
-#else
-static inline bool test_and_clear_pmem_poison(struct page *page)
-{
-	return false;
-}
-#endif
 #endif /* __NVDIMM_PMEM_H__ */
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch
mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch
nvdimm-pmem-remove-test_and_clear_pmem_poison.patch

