Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8275213AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744920; cv=none; b=PNAW3z+sT4PkzF70f6zniEK3bg8UBcc1Y5MGh2hK2INB0886S+ofw1tH9ATwyt60qQjF16g09gHY2Oq3aAPvHhnQ0falR1dHl6lvCvdRil9HmZHkLVirTg48EBdixFQD7BfHc/5DlP6LGSclwJ/ci0lp2j9Q3w0x4q/wFh8Lztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744920; c=relaxed/simple;
	bh=kczCrCQy+ECrYiJfOkBFm3Rx2IXZ+mqOG3a1pUKWceM=;
	h=Date:To:From:Subject:Message-Id; b=uvQ74J5dRTPhXhtKlNDrdDiVZFi9PNwopYikJUI6NesUl72ViiEp6YEG3b1TJjZdRwFN3smNsvJ8tl/MmGK+zgfIKOXyZAu/sGpUQK3X0QqE2rqv8Chu7qJCtV+liLh3L6h52+1ZssGgGPzVBLEGjqfUHq/MEzoAyBtYPce8N9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0PJEAt4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0PJEAt4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A781C4CEF7;
	Sun, 29 Mar 2026 00:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744920;
	bh=kczCrCQy+ECrYiJfOkBFm3Rx2IXZ+mqOG3a1pUKWceM=;
	h=Date:To:From:Subject:From;
	b=0PJEAt4HwSSM6tp/7ORiofLpIdCrp7JK34KsrqRw39Iqo4CfVkId3QjdxlLaX3qdn
	 faL9cbPM2MewFxbJHa1gSFBVuqFn3Q3TUMTTBUbBSeQhBhRxrkaatb0M/oC57c7ACc
	 LKkQicMDprkMLsDk69ECDdjZuZJTfSlfnJpfL0Zk=
Date: Sat, 28 Mar 2026 17:41:59 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-fix-possible-race-in-scan_movable_pages.patch removed from -mm tree
Message-Id: <20260329004200.5A781C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: fix possible race in scan_movable_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-possible-race-in-scan_movable_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory_hotplug: fix possible race in scan_movable_pages()
Date: Fri, 20 Mar 2026 23:13:33 +0100

Patch series "mm: memory hot(un)plug and SPARSEMEM cleanups", v2.

Some cleanups around memory hot(un)plug and SPARSEMEM.  In essence, we can
limit CONFIG_MEMORY_HOTPLUG to CONFIG_SPARSEMEM_VMEMMAP, remove some dead
code, and move all the hotplug bits over to mm/sparse-vmemmap.c.

Some further/related cleanups around other unnecessary code (memory hole
handling and complicated usemap allocation).

I have some further sparse.c cleanups lying around, and I'm planning on
getting rid of bootmem_info.c entirely.


This patch (of 15):

If a hugetlb folio gets freed while we are in scan_movable_pages(),
folio_nr_pages() could return 0, resulting in or'ing "0 - 1 = -1" to the
PFN, resulting in PFN = -1.  We're not holding any locks or references
that would prevent that.

for_each_valid_pfn() would then search for the next valid PFN, and could
return a PFN that is outside of the range of the original requested range.
do_migrate_page() would then try to migrate quite a big range, which is
certainly undesirable.

To fix it, simply test for valid folio_nr_pages() values.  While at it, as
PageHuge() really just does a page_folio() internally, we can just use
folio_test_hugetlb() on the folio directly.

scan_movable_pages() is expected to be fast, and we try to avoid taking
locks or grabbing references.  We cannot use folio_try_get() as that does
not work for free hugetlb folios.  We could grab the hugetlb_lock, but
that just adds complexity.

The race is unlikely to trigger in practice, so we won't be CCing stable.

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org
Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-1-096addc8800d@kernel.org
Fixes: 16540dae959d ("mm/hugetlb: mm/memory_hotplug: use a folio in scan_movable_pages()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-possible-race-in-scan_movable_pages
+++ a/mm/memory_hotplug.c
@@ -1746,6 +1746,7 @@ static int scan_movable_pages(unsigned l
 	unsigned long pfn;
 
 	for_each_valid_pfn(pfn, start, end) {
+		unsigned long nr_pages;
 		struct page *page;
 		struct folio *folio;
 
@@ -1762,9 +1763,9 @@ static int scan_movable_pages(unsigned l
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
 
-		if (!PageHuge(page))
-			continue;
 		folio = page_folio(page);
+		if (!folio_test_hugetlb(folio))
+			continue;
 		/*
 		 * This test is racy as we hold no reference or lock.  The
 		 * hugetlb page could have been free'ed and head is no longer
@@ -1774,7 +1775,11 @@ static int scan_movable_pages(unsigned l
 		 */
 		if (folio_test_hugetlb_migratable(folio))
 			goto found;
-		pfn |= folio_nr_pages(folio) - 1;
+		nr_pages = folio_nr_pages(folio);
+		if (unlikely(nr_pages < 1 || nr_pages > MAX_FOLIO_NR_PAGES ||
+			     !is_power_of_2(nr_pages)))
+			continue;
+		pfn |= nr_pages - 1;
 	}
 	return -ENOENT;
 found:
_

Patches currently in -mm which might be from david@kernel.org are


