Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DD74502B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247692; cv=none; b=MqpLy8KOwjWd7ybOXE1rx27x6xPM4uQQk8qfcBE9gwjRDNIqC8ODHgmAsVCA56xnYau7XSzuSre7co5i2h0qdWJVlzEDuvz4hJwHHbySGHBm/I9icWI6gE2yWLmlTinxEuKHkOWsICHhUjWobjtyULSCQaR+BprQgaEEUycY3fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247692; c=relaxed/simple;
	bh=Fr4lvYYTpKQytkI1H/UlaS3+OeXLyg7S90+nmfh3l74=;
	h=Date:To:From:Subject:Message-Id; b=t2oRiWKdFHNp2qMxSoGki2DtAOU3lSSJgzU2s+cSN/mlPn33g1IlOHG9ubsEWDrLQkSDkhJpxgGfLN65arulG1VgutCjAxUSIb1KbDRyYoq9Pno+zLzG/vhPTwBomEEeuvBt7K/YcQMDEj9xxIicrytM86CsTAAIBd+JofCkhqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1JmRdj22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1JmRdj22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D35C4CEC2;
	Mon,  2 Sep 2024 03:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247692;
	bh=Fr4lvYYTpKQytkI1H/UlaS3+OeXLyg7S90+nmfh3l74=;
	h=Date:To:From:Subject:From;
	b=1JmRdj226PMC9r8iLTd6fTg9iPYpYuvKjhzLx+KvdNJXo1RnDriCu/PXH+yQSyAU+
	 sBivutYcBDGrIuS45jxXaL865B7hlSDm6rRxrMTHD5mx89scMh0L2LlVt+Jh+z9hSk
	 o/tfntWpHWtkkWyDEXyH0KunXCdGcm4FD7dH+N4w=
Date: Sun, 01 Sep 2024 20:28:11 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch removed from -mm tree
Message-Id: <20240902032812.66D35C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: remove left over comment about follow_huge_foo()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: remove left over comment about follow_huge_foo()
Date: Thu, 25 Jul 2024 10:16:43 +0800

The comment is useless after commit 57a196a58421 ("hugetlb: simplify
hugetlb handling in follow_page_mask") since all follow_huge_foo() are
killed.

Link: https://lkml.kernel.org/r/20240725021643.1358536-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-left-over-comment-about-follow_huge_foo
+++ a/mm/hugetlb.c
@@ -7503,10 +7503,6 @@ __weak unsigned long hugetlb_mask_last_p
 
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
-/*
- * These functions are overwritable if your architecture needs its own
- * behavior.
- */
 bool isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	bool ret = true;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

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

