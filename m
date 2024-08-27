Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B1484A2F
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724799792; cv=none; b=udk1mf0yOwhXWWaj8L+QqaplQ5waKIuc9tizkExKZJeug5eI1cDnmXt04XZ8zwZcEPqLd8G50EBTZbjUb3FoBBghdu3r9yrj0wPkEJ0LfdRQ3SQwPIZIFQeEZQPCX/bpc+gam9iNzkejUgNL1ndn96B4xgDR4gZMjtT0N5lAQhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724799792; c=relaxed/simple;
	bh=PUQgVu/MHzbXpgisJUbek2LpkFf3Yh2Xo3DZWl3yJf0=;
	h=Date:To:From:Subject:Message-Id; b=CdxotekWcyA8GZvvO5M2Pz7TZRYb3DtIeHK85MZPz91AwfYjuoLEriZ3KY27dNQUcSYD43dwlloOz6GavZNHyMl4R4MBOTGa5v3zYS8t1Jg3me0XsWW4BI8H1lXWqcCA0Z19ixizHwC9iYFk2mYlWxNaYKOupaX91WJ83Q+kkb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QGhzXya6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QGhzXya6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04F7C4AF16;
	Tue, 27 Aug 2024 23:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724799791;
	bh=PUQgVu/MHzbXpgisJUbek2LpkFf3Yh2Xo3DZWl3yJf0=;
	h=Date:To:From:Subject:From;
	b=QGhzXya65N2e7xxJEHznOTx5jDznmkVpcpsGPhaD7sP3A4veVO44lYv8WZ8qTdraR
	 EN4CqLhUmcBf1ob+EijHwe6X6vXaiXMe+BY9gzgfkmRs+YM+47bp9fazuGxGH87a1y
	 k83BTweMfCg6PP1Ffa/bsVqfDZH0ldusqSq+g+l0=
Date: Tue, 27 Aug 2024 16:03:11 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch added to mm-unstable branch
Message-Id: <20240827230311.C04F7C4AF16@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory_hotplug: check hwpoisoned page firstly in do_migrate_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch

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
Subject: mm: memory_hotplug: check hwpoisoned page firstly in do_migrate_range()
Date: Tue, 27 Aug 2024 19:47:26 +0800

Commit b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to
be offlined") don't handle the hugetlb pages, the endless loop still occur
if offline a hwpoison hugetlb page, luckly, after the commit e591ef7d96d6
("mm, hwpoison,hugetlb,memory_hotplug: hotremove memory section with
hwpoisoned hugepage"), the HPageMigratable of hugetlb page will be
cleared, and the hwpoison hugetlb page will be skipped in
scan_movable_pages(), so the endless loop issue is fixed.

However if the HPageMigratable() check passed(without reference and lock),
the hugetlb page may be hwpoisoned, it won't cause issue since the
hwpoisoned page will be handled correctly in the next movable pages scan
loop, and it will be isolated in do_migrate_range() but fails to migrate. 
In order to avoid the unnecessary isolation and unify all hwpoisoned page
handling, let's unconditionally check hwpoison firstly, and if it is a
hwpoisoned hugetlb page, try to unmap it as the catch all safety net like
normal page does.

Link: https://lkml.kernel.org/r/20240827114728.3212578-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1793,26 +1793,26 @@ static void do_migrate_range(unsigned lo
 		 * folio_nr_pages() may read garbage.  This is fine as the outer
 		 * loop will revisit the split folio later.
 		 */
-		if (folio_test_large(folio)) {
+		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
-			if (folio_test_hugetlb(folio)) {
-				isolate_hugetlb(folio, &source);
-				continue;
-			}
-		}
 
 		/*
 		 * HWPoison pages have elevated reference counts so the migration would
 		 * fail on them. It also doesn't make any sense to migrate them in the
 		 * first place. Still try to unmap such a page in case it is still mapped
-		 * (e.g. current hwpoison implementation doesn't unmap KSM pages but keep
-		 * the unmap as the catch all safety net).
+		 * (keep the unmap as the catch all safety net).
 		 */
-		if (PageHWPoison(page)) {
+		if (folio_test_hwpoison(folio) ||
+		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
 			if (folio_mapped(folio))
-				try_to_unmap(folio, TTU_IGNORE_MLOCK);
+				unmap_poisoned_folio(folio, TTU_IGNORE_MLOCK);
+			continue;
+		}
+
+		if (folio_test_hugetlb(folio)) {
+			isolate_hugetlb(folio, &source);
 			continue;
 		}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

