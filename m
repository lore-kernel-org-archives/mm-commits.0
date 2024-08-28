Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F91C3D96A
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 04:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818494; cv=none; b=XPoEsWJbUrxipHIgJk7jnSS1z7VJCr0mT6QNvP17fm+ERDF0yvvQQNrmOGR5X/ukEGduTJIOLWjU8w3YPc/WEHaFBWzoGd9w6Djk21L/j42y2BuCLvXMcquKniZy2P3Bci4rbeqv+NkdLRWivlxUmWEbxeXMG7s25YZ/D2a7yhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818494; c=relaxed/simple;
	bh=BALHt/l1MmxV19rBp3u05tg017iMNA3czmzSOVzgDnw=;
	h=Date:To:From:Subject:Message-Id; b=l5su/PMn49N26seGAuckW1hDNQzwH2czjFEwPwaS2+FmQClgnXqSOvdyJKP8rzMHDCPM5yx0S/VFca90Fpj+ZwWbaf4fy4e+ErgcObZDfQutYkUUkZ3HK5Kx2BIOeUJso+6nFJrMr8U41iQlyBjhajxcc9Auogx/29dsJCP16zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WNKug50c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WNKug50c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC28C4DE05;
	Wed, 28 Aug 2024 04:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724818493;
	bh=BALHt/l1MmxV19rBp3u05tg017iMNA3czmzSOVzgDnw=;
	h=Date:To:From:Subject:From;
	b=WNKug50cgGb6+ZgHaJGUdhNtoiNsXEJLbeAi3lDPvh2MPuTqgaY+F+64to2EVVKNJ
	 DOWuUm6w3ojPyDIYkxUoXiP7SYiKVanEqZcDkLP9SPXlNV6V6fh4F3RACjj5EKgKKg
	 /Do6Yg2+qZ49iyhRI8N3QKxTtnM3SB94XKkjdHSo=
Date: Tue, 27 Aug 2024 21:14:52 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-only-one-page_type-per-page-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240828041453.3FC28C4DE05@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-support-only-one-page_type-per-page-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-support-only-one-page_type-per-page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-only-one-page_type-per-page-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: mm-support-only-one-page_type-per-page-fix
Date: Wed, 28 Aug 2024 11:35:28 +0800

fix ubsan warnings

UBSAN: shift-out-of-bounds in ../include/linux/page-flags.h:998:1
left shift of 240 by 24 places cannot be represented in type 'int'
...

Changing significant bit to unsigned to fix it.

Link: https://lkml.kernel.org/r/2d19c48a-c550-4345-bf36-d05cd303c5de@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-support-only-one-page_type-per-page-fix
+++ a/include/linux/page-flags.h
@@ -966,7 +966,7 @@ static __always_inline void __folio_set_
 {									\
 	VM_BUG_ON_FOLIO(data_race(folio->page.page_type) != UINT_MAX,	\
 			folio);						\
-	folio->page.page_type = PGTY_##lname << 24;			\
+	folio->page.page_type = (unsigned int)PGTY_##lname << 24;	\
 }									\
 static __always_inline void __folio_clear_##fname(struct folio *folio)	\
 {									\
@@ -983,7 +983,7 @@ static __always_inline int Page##uname(c
 static __always_inline void __SetPage##uname(struct page *page)		\
 {									\
 	VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);	\
-	page->page_type = PGTY_##lname << 24;				\
+	page->page_type = (unsigned int)PGTY_##lname << 24;		\
 }									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
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
mm-support-only-one-page_type-per-page-fix.patch

