Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29012DC797
	for <mm-commits@vger.kernel.org>; Thu,  6 Nov 2025 23:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762472539; cv=none; b=Km50QKMlY7H3FI7NrvShU6QTxWZfAinXngCc5aN6EKWVe/2wWdiC7gSqKdZsLhYjkQkEMxHe+M28vicvkgw2BMNZYTeE8V7kUNznDDZevXdy8tY9vFYW2eADQoKjsy2j/SWXUzwPJD9Ab2JZHl+crOZl6L4zGegDlJMb4/TzCRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762472539; c=relaxed/simple;
	bh=x68CDfEvQG0AMWdcFgff723SEMH21ILVX9XqWG5L8RI=;
	h=Date:To:From:Subject:Message-Id; b=unVEXx4GjurjTnQCnRux4ZYFlf2FdpWmtkLJV60pusgXJG8EG5eoL5CAV2XFf3ccBWZJZGz/bY6nga4iT55cbQ35FBJFw1IEo5PWES9wxmQWOPZJSo2lGorSzNy5zrhk9N2r+qb0JZEzbyky1nbDGygJZQVer8BqL/raNHsWZQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y6cu4zJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y6cu4zJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3C7C116D0;
	Thu,  6 Nov 2025 23:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762472539;
	bh=x68CDfEvQG0AMWdcFgff723SEMH21ILVX9XqWG5L8RI=;
	h=Date:To:From:Subject:From;
	b=y6cu4zJhZMAAJZVXiEhSWeM0P2hV/ah1vqRTOoGl7rWLx98ji98vzK8JK3BJ7GoY5
	 cb93hu5pgySNdkf4V7yf7jGtWVUZdUWbROkld1gy8Y2zhRmLDbL/u9e7l3Y0J7DDFN
	 cqrw0lEowFKK+RwY3Ue4l/7PsKv1kdGpQ9PMgN4A=
Date: Thu, 06 Nov 2025 15:42:18 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch added to mm-new branch
Message-Id: <20251106234219.4C3C7C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: optimise hugetlb_folio_init_tail_vmemmap()
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: optimise hugetlb_folio_init_tail_vmemmap()
Date: Thu, 6 Nov 2025 20:14:48 +0000

Extract the zone number directly from the folio instead of using the
folio's zone number to look up the zone and asking the zone what its
number is.

Also we should use &folio->page instead of casting from folio to page

Link: https://lkml.kernel.org/r/20251106201452.2292631-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-optimise-hugetlb_folio_init_tail_vmemmap
+++ a/mm/hugetlb.c
@@ -3246,7 +3246,7 @@ static void __init hugetlb_folio_init_ta
 					unsigned long start_page_number,
 					unsigned long end_page_number)
 {
-	enum zone_type zone = zone_idx(folio_zone(folio));
+	enum zone_type zone = folio_zonenum(folio);
 	int nid = folio_nid(folio);
 	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
@@ -3279,7 +3279,7 @@ static void __init hugetlb_folio_init_vm
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
-	prep_compound_head((struct page *)folio, huge_page_order(h));
+	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
 static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
_

Patches currently in -mm which might be from willy@infradead.org are

hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch
migrate-optimise-alloc_migration_target.patch
memory_hotplug-optimise-try_offline_memory_block.patch

