Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF9E84A2F
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724799787; cv=none; b=p5AFX4GExNbSIpOXyYMO8ZSHPsL204fbtn+WhzA/pwK3GHmCq1mIJePPmzuqOBsZG/+godqbqLPOzh67VuGpg1QfHENv7h1umAF63lcgxW0oIlX5dp4egb1ICu4YfkGK7nbTlAwYycCOI5Sjgbi5j/PzWqNcFN78h6juRs1CeyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724799787; c=relaxed/simple;
	bh=lZnEoBl7XHCbABoyavmlRupuwAdzYn35c8+BsY01CHU=;
	h=Date:To:From:Subject:Message-Id; b=P4hKKjxTM72p8hL1B/SmWVE12crswtXyOr+P2S8/daZFftRr/Qv0a3Qpj4cgR6+k+3fIB6LkQ3f9pqCrbpuvTAbxz1OrMKAT8YhjT5sEt8Nfmk6kESxmLaZUDpgOFR3cwkZlRpUTrup8N8aBuCnz62tVVX2tC1RWE9cCpBCk3XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=STJULSuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="STJULSuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F075C4AF14;
	Tue, 27 Aug 2024 23:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724799787;
	bh=lZnEoBl7XHCbABoyavmlRupuwAdzYn35c8+BsY01CHU=;
	h=Date:To:From:Subject:From;
	b=STJULSuv1QJv+59ev/XBuWhhatJZbpW/ChGgiWqlbVtRFW1SFa7ukIPK9eZpQsMko
	 NIzH/dUSMhjrxfcuRqVZv8kOXjxpy5wq6g192symkO5d3N1/KrTTyFATNJnthwT+6L
	 p0zYCEn8jYySHStuoL5CjJLbwELvVl5IYviL9SfI=
Date: Tue, 27 Aug 2024 16:03:06 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch added to mm-unstable branch
Message-Id: <20240827230307.4F075C4AF14@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory_hotplug: remove head variable in do_migrate_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch

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
Subject: mm: memory_hotplug: remove head variable in do_migrate_range()
Date: Tue, 27 Aug 2024 19:47:24 +0800

Patch series "mm: memory_hotplug: improve do_migrate_range()", v3.

Unify hwpoisoned page handling and isolation of HugeTLB/LRU/non-LRU
movable page, also convert to use folios in do_migrate_range().


This patch (of 5):

Directly use a folio for HugeTLB and THP when calculate the next pfn, then
remove unused head variable.

Link: https://lkml.kernel.org/r/20240827114728.3212578-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240827114728.3212578-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-head-variable-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1773,7 +1773,7 @@ found:
 static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
-	struct page *page, *head;
+	struct page *page;
 	LIST_HEAD(source);
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
@@ -1786,14 +1786,20 @@ static void do_migrate_range(unsigned lo
 			continue;
 		page = pfn_to_page(pfn);
 		folio = page_folio(page);
-		head = &folio->page;
 
-		if (PageHuge(page)) {
-			pfn = page_to_pfn(head) + compound_nr(head) - 1;
-			isolate_hugetlb(folio, &source);
-			continue;
-		} else if (PageTransHuge(page))
-			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
+		/*
+		 * No reference or lock is held on the folio, so it might
+		 * be modified concurrently (e.g. split).  As such,
+		 * folio_nr_pages() may read garbage.  This is fine as the outer
+		 * loop will revisit the split folio later.
+		 */
+		if (folio_test_large(folio)) {
+			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
+			if (folio_test_hugetlb(folio)) {
+				isolate_hugetlb(folio, &source);
+				continue;
+			}
+		}
 
 		/*
 		 * HWPoison pages have elevated reference counts so the migration would
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

