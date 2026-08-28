Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13793B52EA
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787890919; cv=none; b=X0NjH16xu5Up+fu73sQ52t2LN2a4TN2nBYikB6u1HRTdHisy0J8vWTcWJoEKmO5V8Jdc2XN52YHBQSS8h9DWTQs35bqRF5oTeVk1qiLokTpbtwTZOrSyNTZEnGWesBFhZFe0Qlt/8GwfTvCGMhQSl98QjsBXcvr18kvK6oNU3l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787890919; c=relaxed/simple;
	bh=Gs7yPCBix8Kchc7syYknwj7QQoSuW5yhyduS5ZopUaE=;
	h=Date:To:From:Subject:Message-Id; b=rdG7fBiYiuXvhFXcPI6Jfie4D76zsRYbY/Vbcaqj8XjOcOxO35178GkX1mL/tTwWRmmCFlkNxOmv5MzlexWovy0/uapWIOVn1g3xLwMygOb707NX0u0/hgrgqlO+GSTUj2FfQ2k8Ox05bHmziWWMtHsWFq5vCA02HOxPgsBWnaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o/rDEpM3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o/rDEpM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C081F000E9;
	Fri, 28 Aug 2026 04:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787890917;
	bh=uVHMLp6/Cym//bW8QRXpYr1rwTJcuPYvuRqTSY50EMA=;
	h=Date:To:From:Subject;
	b=o/rDEpM3njarKZzSjlCNJ9e+x6PBvUDHJbwlYKUHBAv1rIO/9SeQUh+nD5ISTNtWv
	 WewgLsMGLmyy2mBpCM/NKcVSyamP7rtqf1T3YRBVzTmL92j5dHUyAl1PJ5qbmdhkiF
	 Y2uV6Dbdw+guhtTabKZQ82qBCdr/cQufdjZs+YJ4=
Date: Thu, 27 Aug 2026 21:21:57 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-localize-huge_bootmem_zones_valid.patch added to mm-new branch
Message-Id: <20260828042157.95C081F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-localize-huge_bootmem_zones_valid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-localize-huge_bootmem_zones_valid.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
Date: Tue, 25 Aug 2026 16:46:08 +0800

HUGE_BOOTMEM_ZONES_VALID is only used by the huge_bootmem_page flag
handling in mm/hugetlb.c.  Keep the definition next to that private data
structure instead of exposing it through the public hugetlb header.

No functional change is intended.

Link: https://lore.kernel.org/20260825084608.47437-18-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 --
 mm/hugetlb.c            |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-localize-huge_bootmem_zones_valid
+++ a/include/linux/hugetlb.h
@@ -675,8 +675,6 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
--- a/mm/hugetlb.c~mm-hugetlb-localize-huge_bootmem_zones_valid
+++ a/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch

