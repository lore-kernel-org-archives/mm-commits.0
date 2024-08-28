Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8051401C
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807772; cv=none; b=gvtRlZRMKo9pMn5OLjNalShcl1NAlN4lMMDqsgabCspWbUTU3x9k9ORKX3zRTj6RitIDsi5XXnrKdfcbd1Lr59IHf829vQM4P5jxMCvxh5B4eu1YepQGEzwuf8CxbAmwnxkxg+fZ0obbQ/Tf+cydxYwFPS37BkeZxlZu18VXPas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807772; c=relaxed/simple;
	bh=K8fC39VLd4i/sag0bghwqEngy31c6f6pueVx/dkg18Q=;
	h=Date:To:From:Subject:Message-Id; b=W4X43cFZ0cKisMwBFUX3xCR5n8PURYNvRk79yvKceH1pyRgS8e7SQQkJJ6gil+0nZIvFX8JIZ4B+MU30yEZBkYc9eK4UV0FEJeNbwdqOtaQt8sc58Lhwczf7LmXQmianrBLqx2p/iknvjH+4vBlEpsFqRvjR0TOajq8OILwfYMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1PIV3+0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1PIV3+0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E20C4FE0C;
	Wed, 28 Aug 2024 01:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724807771;
	bh=K8fC39VLd4i/sag0bghwqEngy31c6f6pueVx/dkg18Q=;
	h=Date:To:From:Subject:From;
	b=1PIV3+0j83Ti0qOPzxM2qyB2fQJJExGpdAktwLD9z6blR/1s9soVQY+mO0ZGcHxVg
	 JleXsnZFl2kL5qyPJ+P4l/Yo/YIAQXeegJCdnSVigP1jsF7CSCpkDSRzZ0rrLKayxd
	 3DgNOWZjDPGQiRDDZmlKLaIe+azyKiMgi8MJAGnE=
Date: Tue, 27 Aug 2024 18:16:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-convert-to-folio_isolate_movable.patch added to mm-unstable branch
Message-Id: <20240828011611.92E20C4FE0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: convert to folio_isolate_movable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-convert-to-folio_isolate_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-convert-to-folio_isolate_movable.patch

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
Subject: mm: compaction: convert to folio_isolate_movable()
Date: Mon, 26 Aug 2024 12:01:30 +0800

The tail page will always fail to isolate for non-lru-movable and LRU page
in isolate_migratepages_block(), so move PageTail check ahead, then
convert to use folio_isolate_movable() helper and more folios.

Link: https://lkml.kernel.org/r/20240826040132.1202297-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/mm/compaction.c~mm-compaction-convert-to-folio_isolate_movable
+++ a/mm/compaction.c
@@ -1074,39 +1074,41 @@ isolate_migratepages_block(struct compac
 			}
 		}
 
+		if (PageTail(page))
+			goto isolate_fail;
+
+		folio = page_folio(page);
+
 		/*
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
+				if (folio_isolate_movable(folio, mode))
 					goto isolate_success;
-				}
 			}
 
 			goto isolate_fail;
 		}
 
 		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
+		 * Be careful not to clear lru flag until after we're
+		 * sure the folio is not being freed elsewhere -- the
+		 * folio release code relies on it.
 		 */
-		folio = folio_get_nontail_page(page);
-		if (unlikely(!folio))
+		if (unlikely(folio_try_get(folio)))
 			goto isolate_fail;
 
 		/*
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

