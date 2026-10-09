Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9253F39FA
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525388; cv=none; b=mTR3VrIZPu+9YWD9TMorCPlhsXFwW85Lqlz2Z/S5x7410EsQe8uvmkQhWby2K2x7EQiXbLMaQ+rEwJS5wXgKWsT9ByLWrfHXUDY/ViGBmSVcVWPLr5QEmlLWD+08QCPmOvg0gdkZqkq3MDr2UlLCMdstZxsghpg2RZdTxB4BAaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525388; c=relaxed/simple;
	bh=LefgnSVkPhnqBAWZGaCpjaAiEms2gN0BP9uafUdEvUk=;
	h=Date:To:From:Subject:Message-Id; b=OH6RFKESqFTGKnJOAf8WcyQSL6WcA5HzX+RFe0BLUhY3+hZJTtt/puHXmYcwvsCQqD6vv8oJbhUaQhIbujNzuybHXM7fECnGqqItQjo23W+jubhTpjxdHplTU5HgF16OL2neWILvrUkw4n//Zt34PBhp1eqaHBrkqCzXz6Vu+Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKeRROPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKeRROPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814E61F00893;
	Fri,  9 Oct 2026 05:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525386;
	bh=JwY/irIKTYLNbiIK6wlCqVZ3FAKg5FT1LaS3O92+4Gw=;
	h=Date:To:From:Subject;
	b=vKeRROPGvMFcNU8u/ZCPOeX4AzNNtofKwzZ3+WUHnS4doZXsnmDT5TdrVeJrgVSyh
	 juVFFgrshFIVNQsi4wiC6Nl+d0WZICI3AaUZ/kF9Met2CXBsHb1d9AEG+s3lc08KJF
	 Gcw5lfBdHrHnRAd1fRUpnmAEJS0L2Bpwo6ZxRhX8=
Date: Thu, 08 Oct 2026 22:56:26 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,iweiny@kernel.org,david@kernel.org,dave.jiang@intel.com,alison.schofield@intel.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch removed from -mm tree
Message-Id: <20261009055626.814E61F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-flags: define HWPoison test-and-change helpers unconditionally
has been removed from the -mm tree.  Its filename was
     mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/page-flags: define HWPoison test-and-change helpers unconditionally
Date: Thu, 3 Sep 2026 13:35:34 +0800

Page flag helpers for configuration-dependent flags provide false or no-op
variants so that their users can be independent of the configuration.

The HWPoison helpers do not fully follow this pattern.  When
CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
regular, test-and-set, and test-and-clear operations.  When it is
disabled, only PAGEFLAG_FALSE() is instantiated, leaving
TestSetPageHWPoison() and TestClearPageHWPoison() undefined.

Use TESTSCFLAG_FALSE() to provide the missing accessors when memory
failure handling is disabled.  Both accessors return false, which is
consistent with HWPoison state being unavailable, and makes the accessor
interface consistent across configurations.

Also remove now-unneeded test_and_clear_pmem_poison() from nvdimm/pmem.

Link: https://lore.kernel.org/20260903053535.17611-1-kaitao.cheng@linux.dev
Link: https://lore.kernel.org/20260903053535.17611-2-kaitao.cheng@linux.dev
Link: https://lore.kernel.org/20260903053535.17611-3-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ira Weiny <iweiny@kernel.org>
---

 drivers/nvdimm/pmem.c      |    2 +-
 drivers/nvdimm/pmem.h      |   12 ------------
 include/linux/page-flags.h |    1 +
 3 files changed, 2 insertions(+), 13 deletions(-)

--- a/drivers/nvdimm/pmem.c~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
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
--- a/drivers/nvdimm/pmem.h~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
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
--- a/include/linux/page-flags.h~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
+++ a/include/linux/page-flags.h
@@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison, hwpoison)
+TESTSCFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are


