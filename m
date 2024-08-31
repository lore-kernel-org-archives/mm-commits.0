Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8E43C00
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 00:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725064017; cv=none; b=li6fl+ovBq1525ICadbcbYYek3x1dt5RjPuahbcxMUIEbI4tAXMCu2cZQg1nSkzpIcRIqwrhiZNIQM1UBmewsCF8witneyWD3yObTOem47bFkLKJd9/7Qw953FjbvOlF9zohyymPgevkkfqvvABgcQ/JwhE0f56Bj9VlG7MFuCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725064017; c=relaxed/simple;
	bh=mEOXo3LnNgaN8x8Gcu5sKParbMjhfKkqlnyOaC+M70c=;
	h=Date:To:From:Subject:Message-Id; b=MWORMcoMXe7H1CNZ/rfccguP3LrIAsgYhIErD5eKvh0760yr1AVOoXNXJxtTchBU2F3UzrJfmgZ8Yj1x6XiIuI1gQ2fZ8dSStzla6slC9PVinn6KX2PAGGrH3F2o8miI7ZbU6sudDnZqjZNhaCX40L0r87WWXNeYcbIKaS0If04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1pmCZj6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1pmCZj6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9379C4CEC2;
	Sat, 31 Aug 2024 00:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725064016;
	bh=mEOXo3LnNgaN8x8Gcu5sKParbMjhfKkqlnyOaC+M70c=;
	h=Date:To:From:Subject:From;
	b=1pmCZj6Z9+I8jAp4Lx5iVJW0Gv+tePOgkYJKmf9ZfJupnEH1GaeFo0eUE/er6ZzJk
	 ZbNXgkKxGipxUGSre5bPam1zO2aVWlZY0nvzqkZrG0e8VC6ELD44jneFK9IaJRdj1O
	 i4miObZyJ/TlB81tvvLsQM55yoltJV5mvb2KBY+s=
Date: Fri, 30 Aug 2024 17:26:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-isolate_movable_page.patch added to mm-unstable branch
Message-Id: <20240831002656.C9379C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: remove isolate_movable_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-isolate_movable_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-isolate_movable_page.patch

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
Subject: mm: migrate: remove isolate_movable_page()
Date: Thu, 29 Aug 2024 22:54:56 +0800

There are no more callers of isolate_movable_page(), remove it.

Link: https://lkml.kernel.org/r/20240829145456.2591719-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    3 ---
 mm/migrate.c            |    8 --------
 2 files changed, 11 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-remove-isolate_movable_page
+++ a/include/linux/migrate.h
@@ -69,7 +69,6 @@ int migrate_pages(struct list_head *l, n
 		  unsigned long private, enum migrate_mode mode, int reason,
 		  unsigned int *ret_succeeded);
 struct folio *alloc_migration_target(struct folio *src, unsigned long private);
-bool isolate_movable_page(struct page *page, isolate_mode_t mode);
 bool folio_isolate_movable(struct folio *folio, isolate_mode_t mode);
 bool isolate_folio_to_list(struct folio *folio, struct list_head *list);
 
@@ -91,8 +90,6 @@ static inline int migrate_pages(struct l
 static inline struct folio *alloc_migration_target(struct folio *src,
 		unsigned long private)
 	{ return NULL; }
-static inline bool isolate_movable_page(struct page *page, isolate_mode_t mode)
-	{ return false; }
 static inline bool folio_isolate_movable(struct folio *folio,
 					 isolate_mode_t mode)
 	{ return false; }
--- a/mm/migrate.c~mm-migrate-remove-isolate_movable_page
+++ a/mm/migrate.c
@@ -127,14 +127,6 @@ out_putfolio:
 	return false;
 }
 
-bool isolate_movable_page(struct page *page, isolate_mode_t mode)
-{
-	if (PageTail(page))
-		return false;
-
-	return folio_isolate_movable((struct folio *)page, mode);
-}
-
 static void putback_movable_folio(struct folio *folio)
 {
 	const struct movable_operations *mops = folio_movable_ops(folio);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-support-only-one-page_type-per-page-fix.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix.patch
mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch
mm-compaction-get-reference-before-non-lru-movable-folio-isolation.patch
mm-migrate-add-folio_isolate_movable.patch
mm-migrate-convert-to-folio_isolate_movable.patch
mm-compaction-convert-to-folio_isolate_movable.patch
mm-migrate-remove-isolate_movable_page.patch

