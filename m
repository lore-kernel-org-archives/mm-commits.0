Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338CB142E6F
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 06:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270761; cv=none; b=RZIQzFbGSqtqUfhyefu2TTJ5s09DGJ4jh15rWlGJLFl5Pq0v1D2U6qmUvxEyS2o6THRs+CV6jzmRXK8JOmGqrkxU8jAZPjK7UwRPsUupQgryWOqU7DLacxJ17scN9NHYXmzihWk+XavGEqPSGxOQYtIlQX0i7RGhIMC+l1GIK/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270761; c=relaxed/simple;
	bh=g4yFGvZMSCh3qiE5QiEM0bI0mM7qm2ObmfqT12Rnrn4=;
	h=Date:To:From:Subject:Message-Id; b=tWdUj/gtuZ8VHfbZkokLmSV864ogOVHcFHHULoYcUEsS5EEA0Y99KDR1RIb8omx3ESxLR4fJzzeF14PlbN/Aieiyqcz1orgkNugFmJkwguMZzzX/i6+9RLiuPszzc5/bnYMh1qw6sVFST8uaohq4Pwmy2Zk2IntEY/JBWdf4geg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DuU2+B6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DuU2+B6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DF1C32781;
	Sat, 10 Aug 2024 06:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723270760;
	bh=g4yFGvZMSCh3qiE5QiEM0bI0mM7qm2ObmfqT12Rnrn4=;
	h=Date:To:From:Subject:From;
	b=DuU2+B6cGsk4DKwE5xo2GsCZNG8E7FuoYbk66elVkhW9MlLjttXTgTkEernpcpg5y
	 0zHGgoj2cgBN+wvcV8rQ8WBzVr9vg5EAamYkHJWlBvooqjoZPlntSidBLF8Zki50L7
	 KCdodDr++ooaScI1esb3uvVsICssY7Z1rx5Y2ziQ=
Date: Fri, 09 Aug 2024 23:19:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-pageunaccepted-page-type.patch added to mm-unstable branch
Message-Id: <20240810061920.C2DF1C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce PageUnaccepted() page type
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-pageunaccepted-page-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-pageunaccepted-page-type.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: introduce PageUnaccepted() page type
Date: Fri, 9 Aug 2024 14:48:50 +0300

The new page type allows physical memory scanners to detect unaccepted
memory and handle it accordingly.

The page type is serialized with zone lock.

Link: https://lkml.kernel.org/r/20240809114854.3745464-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 ++++++++
 mm/page_alloc.c            |    2 ++
 2 files changed, 10 insertions(+)

--- a/include/linux/page-flags.h~mm-introduce-pageunaccepted-page-type
+++ a/include/linux/page-flags.h
@@ -939,6 +939,7 @@ enum pagetype {
 	PG_hugetlb	= 0x04000000,
 	PG_slab		= 0x02000000,
 	PG_zsmalloc	= 0x01000000,
+	PG_unaccepted	= 0x00800000,
 
 	PAGE_TYPE_BASE	= 0x80000000,
 
@@ -1072,6 +1073,13 @@ FOLIO_TEST_FLAG_FALSE(hugetlb)
 
 PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
 
+/*
+ * Mark pages that has to be accepted before touched for the first time.
+ *
+ * Serialized with zone lock.
+ */
+PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
+
 /**
  * PageHuge - Determine if the page belongs to hugetlbfs
  * @page: The page to test.
--- a/mm/page_alloc.c~mm-introduce-pageunaccepted-page-type
+++ a/mm/page_alloc.c
@@ -6972,6 +6972,7 @@ static bool try_to_accept_memory_one(str
 
 	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
+	__ClearPageUnaccepted(page);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	accept_page(page, MAX_PAGE_ORDER);
@@ -7030,6 +7031,7 @@ static bool __free_unaccepted(struct pag
 	list_add_tail(&page->lru, &zone->unaccepted_pages);
 	account_freepages(zone, MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, MAX_ORDER_NR_PAGES);
+	__SetPageUnaccepted(page);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	if (first)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch
mm-reduce-deferred-struct-page-init-ifdeffery.patch
mm-accept-memory-in-__alloc_pages_bulk.patch
mm-introduce-pageunaccepted-page-type.patch
mm-rework-accept-memory-helpers.patch
mm-add-a-helper-to-accept-page.patch
mm-page_isolation-handle-unaccepted-memory-isolation.patch
mm-accept-to-promo-watermark.patch

