Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688BC14263
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724806396; cv=none; b=Bg5KniU8Wle7C0dCni3ALkifPa2/9UhGte89FV+/cYLE8mrjLSRJ737U6bmklEF+JOTtZhh11ZEsomzBq/c/mxEhNa1ubrV14C5wivX0GYXHwn9b9LbRfGXdszTxu+Xkiqqg/b/K+VDTm0ew4zGHJKCPpAka2aa0lYnVgKUVj+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724806396; c=relaxed/simple;
	bh=M2lkI/kwSD0vc1BQu5FTutiTGZLnQccRoTOFvufEJLw=;
	h=Date:To:From:Subject:Message-Id; b=gOcXbnjqfDW7XeYO4iXSRSSeV4R064olCJ3Pc2jlFFzhiuFjG4TBaCMXypWaBrpERSU2BhZcT1L/nwrGIenGwxUrik1NmohWTB10EiITyKGl26es6a0WVa679Ek9YI/EZZdDMRVzdlW1l25Fw0i6AV6mWUjNda7AzDzFteZGjas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LK4eqqCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LK4eqqCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0994C4AF0E;
	Wed, 28 Aug 2024 00:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724806396;
	bh=M2lkI/kwSD0vc1BQu5FTutiTGZLnQccRoTOFvufEJLw=;
	h=Date:To:From:Subject:From;
	b=LK4eqqClJTRPi6xqEw9wQYEHRNc4BBrz0TJS4HG+pvxLg77ucFYahWuEej+qe30bZ
	 JA0Q4RjSqdbJqmTaCZgjeZplCStEFZVamYzDkxmD4ACrlh3zrQAlXldRhi9k1snMuq
	 wTxxFJvk5irVjOZ9R+o2mrsPZusNAENqlMm3mu1w=
Date: Tue, 27 Aug 2024 17:53:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-putback_lru_page.patch added to mm-unstable branch
Message-Id: <20240828005315.E0994C4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove putback_lru_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-putback_lru_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-putback_lru_page.patch

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
Subject: mm: remove putback_lru_page()
Date: Mon, 26 Aug 2024 14:58:14 +0800

There are no more callers of putback_lru_page(), remove it.

Link: https://lkml.kernel.org/r/20240826065814.1336616-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/folio-compat.c |    5 -----
 mm/internal.h     |    1 -
 2 files changed, 6 deletions(-)

--- a/mm/folio-compat.c~mm-remove-putback_lru_page
+++ a/mm/folio-compat.c
@@ -92,8 +92,3 @@ struct page *grab_cache_page_write_begin
 			mapping_gfp_mask(mapping));
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
-
-void putback_lru_page(struct page *page)
-{
-	folio_putback_lru(page_folio(page));
-}
--- a/mm/internal.h~mm-remove-putback_lru_page
+++ a/mm/internal.h
@@ -417,7 +417,6 @@ extern unsigned long highest_memmap_pfn;
  * in mm/vmscan.c:
  */
 bool folio_isolate_lru(struct folio *folio);
-void putback_lru_page(struct page *page);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

