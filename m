Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEBF1401C
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807776; cv=none; b=RcXbnQegYJCU0XARYVG6zpR+CPCQE8rewAib9rk/X9yjrBzaAFJsS5o8NJUx0ibBOd4/LhkAZQADodrgjViD5B+cXc+DfzYY2adugTZkWKEn96AnOElhyAK1ktzMXjGfJGFzBVGpD857wqXP8NAGOOqcq1EbesGeXpd7/GOh0Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807776; c=relaxed/simple;
	bh=MFg7DLVzedlvzELf9YIiHGIonLRJuwfG2VgGDoWaOqE=;
	h=Date:To:From:Subject:Message-Id; b=gUT06RmffrZOrNyKtiDgE0t9IjFQmH7jzPQMPaRILq5PcarP2snplUdIsTF+CbddvmCGGt6/XvzX6EJdkCUosK5NdkuDvERJeLesgFSTK4nEOe2mFcLUMrUE3lXRC2IWVNJhmUBP0qojDZwUNv/aY02b3LNJpU46+DULuDXWSwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H6rnnCLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H6rnnCLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B59C4FE01;
	Wed, 28 Aug 2024 01:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724807775;
	bh=MFg7DLVzedlvzELf9YIiHGIonLRJuwfG2VgGDoWaOqE=;
	h=Date:To:From:Subject:From;
	b=H6rnnCLMaa3FP2BuYgqVfQsGgqq4GVnoCge+1/7isqh+HTq3U8KQVgC77wm0AQCCr
	 YCgKfDlUzyi5DQFnmNZEAfuOb8fgq9OEOtark93ksNczReTsjdIYoIlgKEHMG2AynK
	 rtSOw08284HpOYSWGqUPITGpRDcyIASA018+QwFs=
Date: Tue, 27 Aug 2024 18:16:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-isolate_movable_page.patch added to mm-unstable branch
Message-Id: <20240828011615.51B59C4FE01@smtp.kernel.org>
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
Date: Mon, 26 Aug 2024 12:01:32 +0800

There are no more callers of isolate_movable_page(), remove it.

Link: https://lkml.kernel.org/r/20240826040132.1202297-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
@@ -128,14 +128,6 @@ out:
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
mm-migrate-add-folio_isolate_movable.patch
mm-compaction-convert-to-folio_isolate_movable.patch
mm-migrate-convert-to-folio_isolate_movable.patch
mm-migrate-remove-isolate_movable_page.patch

