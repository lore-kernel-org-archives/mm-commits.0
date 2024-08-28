Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BBE1401C
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807774; cv=none; b=oXf5LBMl1rV9Doat3xl2Xkbf8poe6ha6cVU4acNQFCeUjZouBe0tCrQRJWk17Us2cy9kvTFNRg16m+elGrfNzev/VKdc7VM0CzQfPDm79+kX1MkwGh0st7n1LaV/akDwJTQoyoEvFpOUvVvxqymRE7FYjWnPbM5n01VlnpgG3MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807774; c=relaxed/simple;
	bh=MRKsFZwd4Qp7PJH9W1lfV5giLF9MKtWescRKpO6UUMw=;
	h=Date:To:From:Subject:Message-Id; b=u5zldUBlIUwNZqX9OKMqMVqWBAuH0U7FmFJI5Rda+fwM49eyO+iHkddBUDLVaNNy+WaB7rqmLL1ndQdoEJHkbH1CtVFS7hepayYPzGezRxGMfvyODU15dshJq/ttICnGj75WDAzNQN7qUB89EyF8MRKZp0zYeUxUud6Sg3Xjtzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nVszFDeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nVszFDeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C27C4FE07;
	Wed, 28 Aug 2024 01:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724807773;
	bh=MRKsFZwd4Qp7PJH9W1lfV5giLF9MKtWescRKpO6UUMw=;
	h=Date:To:From:Subject:From;
	b=nVszFDeQYGsMtGcV53nns0kma7fEwPUcHhXOuOOJHTaQkfFYbN8JNXqm2ZA9aeqJA
	 S1lbXkY1QrNBQE7qemGy+RZ5q7d91nGId7UG2tqY/V0WqQ6fPbtDQwu2xgYtVQYMBY
	 Nw3fdLsMC4OU40Jz6H8KsR3Dd54QIWcWCsC/lm1I=
Date: Tue, 27 Aug 2024 18:16:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-to-folio_isolate_movable.patch added to mm-unstable branch
Message-Id: <20240828011613.74C27C4FE07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: convert to folio_isolate_movable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-to-folio_isolate_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-convert-to-folio_isolate_movable.patch

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
Subject: mm: migrate: convert to folio_isolate_movable()
Date: Mon, 26 Aug 2024 12:01:31 +0800

Directly use folio_isolate_movable() helper in isolate_folio_to_list().

Link: https://lkml.kernel.org/r/20240826040132.1202297-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-convert-to-folio_isolate_movable
+++ a/mm/migrate.c
@@ -197,8 +197,8 @@ bool isolate_folio_to_list(struct folio
 	if (lru)
 		isolated = folio_isolate_lru(folio);
 	else
-		isolated = isolate_movable_page(&folio->page,
-						ISOLATE_UNEVICTABLE);
+			isolated = folio_isolate_movable(folio,
+							 ISOLATE_UNEVICTABLE);
 
 	if (!isolated)
 		return false;
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

