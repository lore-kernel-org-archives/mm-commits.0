Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83CA13958E
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 19:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708458273; cv=none; b=ERqZTM0pK2IIot0UyifUPgXl+WtDCLiW+hwst3/uAvO9CQOxBonQY9PgMIVuTzW4NiGWbl/X/64cn8Alv/AadnLB7ak9uWxW/z7rdSh6WH2qc0mUs+hE4y8OZOs9S0KPrLpBVEJhARdTYhHJY03xTrxovohDgTamN5BGxIYkdvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708458273; c=relaxed/simple;
	bh=CdKExfqPL+NXyN3ujHgftAO5OtDGSTBe+UBtuflLTX8=;
	h=Date:To:From:Subject:Message-Id; b=VAyo/orjHbilSP7ONU3ZnT0lXIIoutKkDsjcl/ny5AU5XthgAhg+/eixY7JRmRxbXOillcmyFDO7ibGI8nPZwO0+00gMy+EWLJPAbivLPM5Y7kmvGMPZXsFRaNOrcWQkbUmDrW/qAMcp8Ny5ncAtxjGCyf2zcVs31y5lFllnVR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RvK6ON7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RvK6ON7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A7DC43390;
	Tue, 20 Feb 2024 19:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708458273;
	bh=CdKExfqPL+NXyN3ujHgftAO5OtDGSTBe+UBtuflLTX8=;
	h=Date:To:From:Subject:From;
	b=RvK6ON7wdSeUDnsOh2j+lbFVQYWbxQUaakY6WItkDj2J6ielpCmd9WiS4R4jSPuLp
	 s/EZ5aPxKSzcowBbr0jnFdkdvzqS7DSe+dnKVNBrCQrBXjFjT0pYfLfX3Hgn/q4K6u
	 xPQZ5sIq2gEQqkH52gVMWm7xMzDcx2wh+9NwoxYA=
Date: Tue, 20 Feb 2024 11:44:32 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,shikemeng@huaweicloud.com,ryan.roberts@arm.com,mgorman@techsingularity.net,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-unused-fpi_flags-in-free_pages_prepare.patch added to mm-unstable branch
Message-Id: <20240220194433.05A7DC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove unused fpi_flags in free_pages_prepare()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-unused-fpi_flags-in-free_pages_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-unused-fpi_flags-in-free_pages_prepare.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: remove unused fpi_flags in free_pages_prepare()
Date: Tue, 20 Feb 2024 13:32:17 -0500

Patch series "Enable >0 order folio memory compaction", v7.

This patchset enables >0 order folio memory compaction, which is one of
the prerequisitions for large folio support[1].

I am aware of that split free pages is necessary for folio migration in
compaction, since if >0 order free pages are never split and no order-0
free page is scanned, compaction will end prematurely due to migration
returns -ENOMEM.  Free page split becomes a must instead of an
optimization.

lkp ncompare results (on a 8-CPU (Intel Xeon E5-2650 v4 @2.20GHz) 16G VM)
for default LRU (-no-mglru) and CONFIG_LRU_GEN are shown at the bottom,
copied from V3[4].  In sum, most of vm-scalability applications do not see
performance change, and the others see ~4% to ~26% performance boost under
default LRU and ~2% to ~6% performance boost under CONFIG_LRU_GEN.

Overview
===

To support >0 order folio compaction, the patchset changes how free pages
used for migration are kept during compaction.  Free pages used to be
split into order-0 pages that are post allocation processed (i.e.,
PageBuddy flag cleared, page order stored in page->private is zeroed, and
page reference is set to 1).  Now all free pages are kept in a
NR_PAGE_ORDER array of page lists based on their order without post
allocation process.  When migrate_pages() asks for a new page, one of the
free pages, based on the requested page order, is then processed and given
out.  And THP <2MB would need this feature.


[1] https://lore.kernel.org/linux-mm/f8d47176-03a8-99bf-a813-b5942830fd73@arm.com/
[2] https://lore.kernel.org/linux-mm/20231113170157.280181-1-zi.yan@sent.com/
[3] https://lore.kernel.org/linux-mm/20240123034636.1095672-1-zi.yan@sent.com/
[4] https://lore.kernel.org/linux-mm/20240202161554.565023-1-zi.yan@sent.com/
[5] https://lore.kernel.org/linux-mm/20240212163510.859822-1-zi.yan@sent.com/
[6] https://lore.kernel.org/linux-mm/20240214220420.1229173-1-zi.yan@sent.com/
[7] https://lore.kernel.org/linux-mm/20240216170432.1268753-1-zi.yan@sent.com/


This patch (of 4):

Commit 0a54864f8dfb ("kasan: remove PG_skip_kasan_poison flag") removes
the use of fpi_flags in should_skip_kasan_poison() and fpi_flags is only
passed to should_skip_kasan_poison() in free_pages_prepare().  Remove the
unused parameter.

Link: https://lkml.kernel.org/r/20240220183220.1451315-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20240220183220.1451315-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unused-fpi_flags-in-free_pages_prepare
+++ a/mm/page_alloc.c
@@ -1061,7 +1061,7 @@ out:
  * on-demand allocation and then freed again before the deferred pages
  * initialization is done, but this is not likely to happen.
  */
-static inline bool should_skip_kasan_poison(struct page *page, fpi_t fpi_flags)
+static inline bool should_skip_kasan_poison(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		return deferred_pages_enabled();
@@ -1081,10 +1081,10 @@ static void kernel_init_pages(struct pag
 }
 
 static __always_inline bool free_pages_prepare(struct page *page,
-			unsigned int order, fpi_t fpi_flags)
+			unsigned int order)
 {
 	int bad = 0;
-	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
+	bool skip_kasan_poison = should_skip_kasan_poison(page);
 	bool init = want_init_on_free();
 	bool compound = PageCompound(page);
 
@@ -1266,7 +1266,7 @@ static void __free_pages_ok(struct page
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (!free_pages_prepare(page, order, fpi_flags))
+	if (!free_pages_prepare(page, order))
 		return;
 
 	/*
@@ -2343,7 +2343,7 @@ static bool free_unref_page_prepare(stru
 {
 	int migratetype;
 
-	if (!free_pages_prepare(page, order, FPI_NONE))
+	if (!free_pages_prepare(page, order))
 		return false;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-remove-unused-fpi_flags-in-free_pages_prepare.patch
mm-compaction-enable-compacting-0-order-folios.patch
mm-compaction-add-support-for-0-order-folio-memory-compaction.patch
mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch

