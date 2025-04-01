Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0861DF73A
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545712; cv=none; b=toI4nwgyq1HJn0MkdvNmfwCBAmAU+KucB1F1GqDosgL6GmPg4d/P88Az9ozxKmqcNiHK2vKsKfVAIxHzRbCRBR4JnmEB0PsCJwPaXhDON3k33UuFfG2dp33bN7isr4Q6vrwBv5h9Duz9z0UuKwne3MzNCYwkuQSu2gvpdGVQS+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545712; c=relaxed/simple;
	bh=5ltdjc3kpp466BbysT5bmTa3L0zVo+Y06qg8ka0aWGk=;
	h=Date:To:From:Subject:Message-Id; b=MpQILwvo4VO9lWYjaB2c8FA/i6cpkcxdtqvIPXHWGr+k5LjP8iqMEaIZW9ObZDiEH4ChLEJHSXlSVQv8sKkmR4kvNzhEFDDt7wbke29SbOPxon/ZUkht5JkmmOc/Hy6RNARnagxhCmRDFAG7qmOtqMtsTgD/SyuB4ptTYrTgND8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oTUpmrX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oTUpmrX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B65C4CEE4;
	Tue,  1 Apr 2025 22:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545711;
	bh=5ltdjc3kpp466BbysT5bmTa3L0zVo+Y06qg8ka0aWGk=;
	h=Date:To:From:Subject:From;
	b=oTUpmrX8zj/sw6CDgaPSdOkiXAXtWaBhl3TTpP31lWhLVKTFHjlMsRYchlf45Phen
	 v29Yg+8EIOorr0IW9jpARDUw8k+lyUu03T/jZuIUNC7b74LSFtNhGlBflTJrLuL6HU
	 m78/BKCIk9PC3YEGAmTAuFEEzTfL+lNpsMP3QSjI=
Date: Tue, 01 Apr 2025 15:15:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,osalvador@suse.de,muchun.song@linux.dev,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,david@redhat.com,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock.patch removed from -mm tree
Message-Id: <20250401221511.90B65C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock
Date: Wed, 22 Jan 2025 14:11:51 +0800

I found a NULL pointer dereference as followed:

 BUG: kernel NULL pointer dereference, address: 0000000000000028
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] SMP PTI
 CPU: 5 UID: 0 PID: 5964 Comm: sh Kdump: loaded Not tainted 6.13.0-dirty #20
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.
 RIP: 0010:has_unmovable_pages+0x184/0x360
 ...
 Call Trace:
  <TASK>
  set_migratetype_isolate+0xd1/0x180
  start_isolate_page_range+0xd2/0x170
  alloc_contig_range_noprof+0x101/0x660
  alloc_contig_pages_noprof+0x238/0x290
  alloc_gigantic_folio.isra.0+0xb6/0x1f0
  only_alloc_fresh_hugetlb_folio.isra.0+0xf/0x60
  alloc_pool_huge_folio+0x80/0xf0
  set_max_huge_pages+0x211/0x490
  __nr_hugepages_store_common+0x5f/0xe0
  nr_hugepages_store+0x77/0x80
  kernfs_fop_write_iter+0x118/0x200
  vfs_write+0x23c/0x3f0
  ksys_write+0x62/0xe0
  do_syscall_64+0x5b/0x170
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

As has_unmovable_pages() call folio_hstate() without hugetlb_lock, there
is a race to free the HugeTLB page between PageHuge() and folio_hstate(). 
There is no need to add hugetlb_lock here as the HugeTLB page can be freed
in lot of places.  So it's enough to unfold folio_hstate() and add a check
to avoid NULL pointer dereference for hugepage_migration_supported().

Link: https://lkml.kernel.org/r/20250122061151.578768-1-liushixin2@huawei.com
Fixes: 464c7ffbcb16 ("mm/hugetlb: filter out hugetlb pages if HUGEPAGE migration is not supported.")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/page_isolation.c~mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock
+++ a/mm/page_isolation.c
@@ -83,7 +83,14 @@ static struct page *has_unmovable_pages(
 			unsigned int skip_pages;
 
 			if (PageHuge(page)) {
-				if (!hugepage_migration_supported(folio_hstate(folio)))
+				struct hstate *h;
+
+				/*
+				 * The huge page may be freed so can not
+				 * use folio_hstate() directly.
+				 */
+				h = size_to_hstate(folio_size(folio));
+				if (h && !hugepage_migration_supported(h))
 					return page;
 			} else if (!folio_test_lru(folio) && !__folio_test_movable(folio)) {
 				return page;
_

Patches currently in -mm which might be from liushixin2@huawei.com are


