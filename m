Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2163A2BAEB
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724132327; cv=none; b=Er/O+JWPzrCnuMFr6z/XOL2hbJbYSeGC1tn4ncLIlsliKXfI/G1kXT0y/lX+xjE38tv2Y/wrYEXtzDSInYWlJc8Vnrd+xWLBCVptZlR3piSDGOM93X9XP4s2ODhfXvUMrlE1LoYJlynIaoMT/6CHO5H5+sDHq29rKkABTk2Wy64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724132327; c=relaxed/simple;
	bh=ZWTfnNLb/kNNpwyd5oPULnUtQvYo6NvdX8ihfdYL8yY=;
	h=Date:To:From:Subject:Message-Id; b=ZMVG2hY2QmM0YEQZwJqHYesGTwh2WDCaTJdNq85XnEMXJms0p/v3rQW3D6BTlj4yxY1e2E5wv0g0cmnwjtEDMpuVLdhJ0VbVCCfulLk2/SotyPIKlRl4P14zXZBg6uqgQKSpxAYNNOYesB8YPYCcoJfmLETyt+JO2kZl3uwqQKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kAg9pmGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kAg9pmGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820BDC4AF09;
	Tue, 20 Aug 2024 05:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724132326;
	bh=ZWTfnNLb/kNNpwyd5oPULnUtQvYo6NvdX8ihfdYL8yY=;
	h=Date:To:From:Subject:From;
	b=kAg9pmGGiYPVfvbtevvNdoltF0qUu5Z/MI8LumWCqQLbaaSNcZFgNIuGaUWq68Hcq
	 uhGlvl2b9FjMej+ihmMPdPrGFOm//ZS7KyUZ+o6lN/VtScMZ7RMzmoMeL8hOe7wRNK
	 rtODjYVYgkOLbGfridcTKKd1uAxlNcG8/rwHIhP0=
Date: Mon, 19 Aug 2024 22:38:46 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@Huawei.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch added to mm-unstable branch
Message-Id: <20240820053846.820BDC4AF09@smtp.kernel.org>
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
Date: Sat, 17 Aug 2024 16:49:37 +0800

Patch series "mm: memory_hotplug: improve do_migrate_range()", v2.

Unify hwpoisoned page handling and isolation of HugeTLB/LRU/non-LRU
movable page, also convert to use folios in do_migrate_range().


This patch (of 5):

Directly use a folio for HugeTLB and THP when calculate the next pfn, then
remove unused head variable.

Link: https://lkml.kernel.org/r/20240817084941.2375713-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240817084941.2375713-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
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
+		 * The folio hold no reference or lock, it might be changed
+		 * concurrently(eg, split), folio_nr_pages() may read garbage,
+		 * but out loop could handle that as it revisits the split
+		 * folio later.
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
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_posioned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

