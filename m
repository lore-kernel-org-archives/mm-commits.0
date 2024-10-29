Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8712A747F
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 01:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730163656; cv=none; b=ct5TMZ1sgRn68dwtwi0xiG/q2RP7FzQHLWT82k2Uep/OHJb7T71RLsIei3xiRvnD+g6TzUKRNRTg/7yXiIzHZseIFT65G8ax8BabWLdq06E2LxUq2mG6oWWjKCLl7LfvrLdnKXisrguHtvGGA4JTGMqJYBVt6NiKZBKyuH2o8A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730163656; c=relaxed/simple;
	bh=o3XYijhQJcUzbNB4gYBeCr9S4Q/TIANyY3NCK66MdDQ=;
	h=Date:To:From:Subject:Message-Id; b=lWuB0OvapMsTPphWFPZjL2Q7O45TbNqpdDbTWNvepSW4B2fxBuz1fb01pBQnnY5kglJIEMUBw5b1M20uP6f9Lu26nSVyQJu3Pfnj4INtsVsl8fX1ovNad4XTb7LXUx74qo7ajiqljny12B+G4G7JRozek7fcd6J/aK6hOXFVvko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RJJoFy1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RJJoFy1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE14C4CEC3;
	Tue, 29 Oct 2024 01:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730163656;
	bh=o3XYijhQJcUzbNB4gYBeCr9S4Q/TIANyY3NCK66MdDQ=;
	h=Date:To:From:Subject:From;
	b=RJJoFy1WBj/ucEWHpTDGWUI2XC5fRRf4k83U+0YCwPCIrG44im2kIzfS3Onwdy9VT
	 Y/eEVAnlQPpKZoK11C9efmYDV+eLPe/+c0yrDaI8MKh49/FM4ArghM1Q63kmWbxZqE
	 wRtr6DeOfEIwIR5Qq12juHfHDe6Pt3kTYKh98bLQ=
Date: Mon, 28 Oct 2024 18:00:55 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-aligned-address-in-clear_gigantic_page.patch added to mm-unstable branch
Message-Id: <20241029010056.1EE14C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use aligned address in clear_gigantic_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-aligned-address-in-clear_gigantic_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-aligned-address-in-clear_gigantic_page.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use aligned address in clear_gigantic_page()
Date: Mon, 28 Oct 2024 22:56:55 +0800

In current kernel, hugetlb_no_page() calls folio_zero_user() with the
fault address.  Where the fault address may be not aligned with the huge
page size.  Then, folio_zero_user() may call clear_gigantic_page() with
the address, while clear_gigantic_page() requires the address to be huge
page size aligned.  So, this may cause memory corruption or information
leak, addtional, use more obvious naming 'addr_hint' instead of 'addr' for
clear_gigantic_page().

Link: https://lkml.kernel.org/r/20241028145656.932941-1-wangkefeng.wang@huawei.com
Fixes: 78fefd04c123 ("mm: memory: convert clear_huge_page() to folio_zero_user()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/memory.c          |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-use-aligned-address-in-clear_gigantic_page
+++ a/fs/hugetlbfs/inode.c
@@ -819,7 +819,7 @@ static long hugetlbfs_fallocate(struct f
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, ALIGN_DOWN(addr, hpage_size));
+		folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
--- a/mm/memory.c~mm-use-aligned-address-in-clear_gigantic_page
+++ a/mm/memory.c
@@ -6804,9 +6804,10 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr,
+static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
 				unsigned int nr_pages)
 {
+	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 	int i;
 
 	might_sleep();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-unused-hugepage-for-vma_alloc_folio.patch
tmpfs-dont-enable-large-folios-if-not-supported.patch
mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch
mm-shmem-remove-__shmem_huge_global_enabled.patch
mm-use-aligned-address-in-clear_gigantic_page.patch
mm-use-aligned-address-in-copy_user_gigantic_page.patch

