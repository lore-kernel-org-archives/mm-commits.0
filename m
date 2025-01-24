Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ABB5588E
	for <mm-commits@vger.kernel.org>; Fri, 24 Jan 2025 06:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737698762; cv=none; b=SFhjNxSe980R4J42rBi52zaLt3/psC9Icsfm485lBPyoX+PehN+267309sr09G6qRcks1NBTwDsyG/mX7pXiVgFwqyd38RHT8Ual5yfDknaUFJyLFgsqgNFoP/wghX8SsX50H5icWCpaA8kjQvw8FLMZiWcLsNHnN322+B2roxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737698762; c=relaxed/simple;
	bh=6tl4LnjQAOlFABxxORktDWfW7s24ZDKqF9BZnlhA1E8=;
	h=Date:To:From:Subject:Message-Id; b=U7bE/+n9BUKCvInfEmC78ywNyjj9MaITONYbTBcVib3GGbDquQjWtudvOfYoJnURvX0M3uA+vQlMBWUN6WIQDpE1e18GaEzh7uQZbU5obnrp2lUogly2n7GA3RodAnerdokXvl09PcpxXX78EOoXnuYF2/ccRm7vbkSbMRwbp74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X5cjLd7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X5cjLd7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EECC4CED2;
	Fri, 24 Jan 2025 06:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737698761;
	bh=6tl4LnjQAOlFABxxORktDWfW7s24ZDKqF9BZnlhA1E8=;
	h=Date:To:From:Subject:From;
	b=X5cjLd7YwIF6KDY7BthnmPKaryKGM5xipPzMwKg6/ePk8E9nD48pJUiKWA8Zwlvej
	 lT6JEtsR7cOucE6lajq1HUYlmZ5wgL3HbKyW/2seD/bxc8/PiUb67Lfh+MBO/5IzQP
	 cdxuDQ3NI0sCJpSWHSFuqEdu0qM7I75VRMSaO7mM=
Date: Thu, 23 Jan 2025 22:06:01 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,osalvador@suse.de,muchun.song@linux.dev,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,david@redhat.com,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20250124060601.D5EECC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock.patch

