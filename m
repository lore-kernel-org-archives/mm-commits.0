Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E202D3EEB
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787890879; cv=none; b=WgxHejlfnYICsXcpHLlfeGJpsk9IUCWyrxATkc3dLS/kzaQs4mjAnOi2IYqbI2fmYtZRwgbPRhEknkaa3QLVNMDP/787NnCwsjiNxOKA8/O4igStVZaOUg52YOb5McGiA6dbfHXVP9bNePO1rkNatR04MeIUwZDON65h9FH7EpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787890879; c=relaxed/simple;
	bh=XUlVdbucDrG9LxuHOqIFsXUbV92dDupcj86qA393O1Q=;
	h=Date:To:From:Subject:Message-Id; b=CLbZAB4HURHM1Vtm06Rp2d7jYrDJ8F0PGlrKfdESUN+G7NGIAOMXX9LDQTLdvs4WkoxrLq4E3HlmtAXSYsD8aaDWBC3zOiyP3QeKtsk9i4d+IP/ek32kk6RB25myi6xR5GKGohPdBoDP7Atc/ZIhjX4X/x/F7J5xSrZmu3PpyUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iDYZhRqW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iDYZhRqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289471F000E9;
	Fri, 28 Aug 2026 04:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787890878;
	bh=Zg9r8cH8XVnQvRFWO6gfp5qITSFbnlgsc6vCb+gct3g=;
	h=Date:To:From:Subject;
	b=iDYZhRqWtC58gp63nl2TCSBDWjVmvp/bLkyq9CDZ8/Yp8osJqUujd7RQvoEYWC8Ba
	 czsjz1jxfu60h8bZpTq4c4tH5EpBm49wx01UXda09jQA9tHNTLu/8ALCvLAkC4YAGn
	 B7arLMtrmoj5cFfAAraMf4sqJh4+P/hokQ7mylZ8=
Date: Thu, 27 Aug 2026 21:21:17 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch added to mm-new branch
Message-Id: <20260828042118.289471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch

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
Subject: mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
Date: Tue, 25 Aug 2026 16:45:55 +0800

The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
left uninitialized, because memmap_init_range() would later overwrite it. 
That forced users such as HugeTLB to defer the initialization to their own
setup paths.

Now that memmap_init_range() skips shared tail vmemmap pages, initialize
them immediately in vmemmap_get_tail() with init_compound_tail() instead.

This moves the initialization to the point where the shared tail page is
allocated and avoids relying on deferred handling in individual users. 
The remaining deferred initialization in HugeTLB will be removed once it
switches to the section-based vmemmap optimization mechanism.

Link: https://lore.kernel.org/20260825084608.47437-5-songmuchun@bytedance.com
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

 mm/sparse-vmemmap.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation
+++ a/mm/sparse-vmemmap.c
@@ -338,19 +338,11 @@ static __meminit struct page *vmemmap_ge
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_bootmem_struct_page_init() will take care of initialization
-	 * after memmap_init().
-	 */
-
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
 
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
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

