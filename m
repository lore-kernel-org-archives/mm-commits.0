Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342ED1D12ED
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 00:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725064009; cv=none; b=ZTeDL4A20oblW3SSZRVW2ygqMQNivOsXXbk62SpvJIXy1LEc2cV7R6d7FKxacxh4HrNG4CTXaOv5sP3LriGCrHMmcb1gnE9RtxFl9x0fLdRzdYA+MTKISIPVWQ+zxMPYnU1pcSnXvi8mOZMRZbkpf0SCPEs3Q4HZZpVd9uOKBwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725064009; c=relaxed/simple;
	bh=sBNLAeH2lzKFDHRYIH5usNVvBTEXmhWt9yG2yc3PRMQ=;
	h=Date:To:From:Subject:Message-Id; b=l+cQzwVeFoEjGuCKVwhylavcTR9hCHC7W0pL8fJW14yU4DZeFxwlMNNADo/evbOUGPzfXv+BFdjCCD7QlS6yj1dwp7TFIaoQY1og9+4vWDcPjmnjpGqffkKv6D/E3a/zb1eVEQYIB9pJBgSH1ry6XPDHDyv0lOjSFP42gtDDieo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rfUW/0um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfUW/0um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D76DC4CEC2;
	Sat, 31 Aug 2024 00:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725064008;
	bh=sBNLAeH2lzKFDHRYIH5usNVvBTEXmhWt9yG2yc3PRMQ=;
	h=Date:To:From:Subject:From;
	b=rfUW/0umYKoc9hwbO6aFQHNSyzneleOt/lHDJbpD8FdL67MvKYw7w03fk9BNXP6cZ
	 K82f54olJnqIqQDfU4DQYAsPPCjX4dztgmlxk5uFvaZnWj2Nnypb4fooMm6rrMt+TC
	 CGd065kjkaK2nl9K9HodQDD7vSrvZ7fdOlvjq/oE=
Date: Fri, 30 Aug 2024 17:26:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-get-reference-before-non-lru-movable-folio-isolation.patch added to mm-unstable branch
Message-Id: <20240831002648.9D76DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: get reference before non LRU movable folio isolation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-get-reference-before-non-lru-movable-folio-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-get-reference-before-non-lru-movable-folio-isolation.patch

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
Subject: mm: compaction: get reference before non LRU movable folio isolation
Date: Thu, 29 Aug 2024 22:54:52 +0800

Patch series "mm: convert to folio_isolate_movable()", v2.

Convert to the new folio_isolate_movable() to get rid of
isolate_movable_page().


This patch (of 5):

Non-LRU movable folio isolation will fail if it can't grab a reference in
isolate_movable_page(), so folio_get_nontail_page() could be called ahead
to unify the handling of non-LRU movable/LRU folio isolation a bit, this
is also prepare to convert isolate_movable_page() to take a folio.  Since
the reference count of the non-LRU movable folio is increased, a
folio_put() is needed whether the folio is isolated or not.

Link: https://lkml.kernel.org/r/20240829145456.2591719-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240829145456.2591719-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/mm/compaction.c~mm-compaction-get-reference-before-non-lru-movable-folio-isolation
+++ a/mm/compaction.c
@@ -1075,41 +1075,41 @@ isolate_migratepages_block(struct compac
 		}
 
 		/*
+		 * Be careful not to clear lru flag until after we're
+		 * sure the folio is not being freed elsewhere -- the
+		 * folio release code relies on it.
+		 */
+		folio = folio_get_nontail_page(page);
+		if (unlikely(!folio))
+			goto isolate_fail;
+
+		/*
 		 * Check may be lockless but that's ok as we recheck later.
-		 * It's possible to migrate LRU and non-lru movable pages.
-		 * Skip any other type of page
+		 * It's possible to migrate LRU and non-lru movable folioss.
+		 * Skip any other type of folios.
 		 */
-		if (!PageLRU(page)) {
+		if (!folio_test_lru(folio)) {
 			/*
-			 * __PageMovable can return false positive so we need
-			 * to verify it under page_lock.
+			 * __folio_test_movable can return false positive so
+			 * we need to verify it under page_lock.
 			 */
-			if (unlikely(__PageMovable(page)) &&
-					!PageIsolated(page)) {
+			if (unlikely(__folio_test_movable(folio)) &&
+					!folio_test_isolated(folio)) {
 				if (locked) {
 					unlock_page_lruvec_irqrestore(locked, flags);
 					locked = NULL;
 				}
 
-				if (isolate_movable_page(page, mode)) {
-					folio = page_folio(page);
+				if (isolate_movable_page(&folio->page, mode)) {
+					folio_put(folio);
 					goto isolate_success;
 				}
 			}
 
-			goto isolate_fail;
+			goto isolate_fail_put;
 		}
 
 		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
-		 */
-		folio = folio_get_nontail_page(page);
-		if (unlikely(!folio))
-			goto isolate_fail;
-
-		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
 		 * admittedly racy check.
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

