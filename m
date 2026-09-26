Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550E133ADAE
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 06:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403353; cv=none; b=k/uiFlvjkjLh1clHMRW74YqzoH7APGpFoyAH+SBaXMQ99DEuno/0TeTxrxx+fLEHfXlzQ57zoW1H7PS4Tjx/Z8SecoqYKOq0dQF5+RffpfX3en10x26NI9y8Pf0pE75rrJMjezHjTV8XE3nQ5CRhp8V3LMLqle9WJEkjSzwewhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403353; c=relaxed/simple;
	bh=qIUre8copXSHgNCjifrOfAYDsdv05Yg24Ckk5gOQUDc=;
	h=Date:To:From:Subject:Message-Id; b=QZjQoOl7w6TSwLj1zCDOH+d9tDo4QyrbjzPJQytauTLxlVKJI7vqvtLERA8ZId8ZGmNEBiBikSzwxDuqYs5O9k4LCficX5qWkupD3uO5FAdbKNEwb/IRJwZn01MKnP+4wd2IgmUEMtt2afXqn/qLTfgsQHVq81by7DN2FVYEkLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kmkjVnqo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kmkjVnqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBADC1F000FF;
	Sat, 26 Sep 2026 06:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790403352;
	bh=QeRAb51pUd2Wq/X4zT23kQx7DZ1NFtF62pAP3Y0c37o=;
	h=Date:To:From:Subject;
	b=kmkjVnqonGFA9AvIBPJ1hUEL/T9avQ2xers7h93jOx1p1eU508atHPKSfZuncabl+
	 Hb3COCJO9Vnx1KFedpEDkbOkKepg1gXPdaCVMptTnyCbbM3fFM3qRpWQgxv0JmcW+D
	 JISo1eaB2a+Wymtyyrn5M7AQdqSBFKxwd5EKvbgg=
Date: Fri, 25 Sep 2026 23:15:51 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,iweiny@kernel.org,david@kernel.org,dave.jiang@intel.com,alison.schofield@intel.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] nvdimm-pmem-remove-test_and_clear_pmem_poison.patch removed from -mm tree
Message-Id: <20260926061551.DBADC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nvdimm/pmem: remove test_and_clear_pmem_poison()
has been removed from the -mm tree.  Its filename was
     nvdimm-pmem-remove-test_and_clear_pmem_poison.patch

This patch was dropped because it was folded into mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

