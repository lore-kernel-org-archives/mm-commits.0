Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56CE4F7979
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622478; cv=none; b=V0kCnq6YI6Vqzi7CvdGV0VNeGBfOkHnqudW8aBXWD5dOmkeyu6sBZK8Pu/+3z03j5En/LjCVY446vAZeJnZEp3+trf79wE3HfHpWUTpebPhaNXgnZM7KBhVwlkWhnA5N13OTwP+t2dsZLmjEM1b5dt7DrPkDxr6Nr3e7KKwitsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622478; c=relaxed/simple;
	bh=hme6gf24SbxGq/+zrVXDhYbuuuHNRRtM+nXMIzCip8Q=;
	h=Date:To:From:Subject:Message-Id; b=QpPNtLRDzTrQ/L2erpGRT/dKWF+dHh6TUVD/K5YvPxksZGE2qTMvEj1qSVL6hO8oZCswuQilyQfWPZzRXwcttW7dXpcCgWBeeh+AG87OBu2wsfu9Ebo9XczVaQIj/YOLaPUPreRDndbqU9RUt/HCs8r4zYNFGoThfRuANwIGWO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oabsGXAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oabsGXAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662961F000E9;
	Thu,  9 Jul 2026 18:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783622476;
	bh=3Bum7vb4lmoPHfiBexOEA8Q3AEZg84noyIt6FiuZzXk=;
	h=Date:To:From:Subject;
	b=oabsGXAfmfJcWitWqWorAPQzcCvvQMAMh8daxIuG7M+sEGCnkSLuoNhaPeVHmwDfm
	 AFMi0EIqSbYuCw/yIVBXlRLWPkUfqMMA+mjj+RoIwPyQp+vL4f+BptiE6CJ1mT2944
	 MLne7pzUFB2tnD4n57PfxJDbgqTBT4OL4h4JL2D0=
Date: Thu, 09 Jul 2026 11:41:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-km-clear-page-private-before-free-them.patch added to mm-unstable branch
Message-Id: <20260709184116.662961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu-km: clear page->private before free them
has been added to the -mm mm-unstable branch.  Its filename is
     mm-percpu-km-clear-page-private-before-free-them.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-km-clear-page-private-before-free-them.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/percpu-km: clear page->private before free them
Date: Thu, 09 Jul 2026 14:06:01 -0400

Patch series "Keep tail page private zero at free and folio split", v3.

This patchset makes sure tail_page->private is zero before compound or
high-order pages are returned to the allocator.  It also checks tail pages
that become new folio heads during large folio split, before their private
fields are used by new folios.

Note on ZONE_DEVICE and DAX page/folio
===
ZONE_DEVICE and DAX use prep_compound_tail() to reinitialize folios, so
tail_page->private was reset before this patchset.  There was a concern
that after this patchset stale ->private can appear after ZONE_DEVICE/DAX
folio initialization.  My reasoning is that no code sets ZONE_DEVICE/DAX
page->private, so their page->private stays zero all the time. 
ZONE_DEVICE_PRIVATE page migration only supports anonymous memory without
swapcache, so after the migration ->private remains zero.

But let me know if my reasoning is wrong.  It can be fixed by adding
->private zeroing code in ZONE_DEVICE/DAX folio initialization code.

Motivation
===

page->private is zeroed at page free time since commit ac1ea219590c0
("mm/page_alloc: clear page->private in free_pages_prepare()"), since we
concluded that it might be too much to ask every page user to free a page
with ->private zeroed.  The holder of the last page reference might not
know whether ->private needs to be cleared.

For compound and high-order pages, tail_page->private can also leak to
later users if it is left uncleared.  The page allocation path does not
zero every tail_page->private field, so they can be seen by new users and
cause unexpected issues[1].

Check tail_page->private at page free time, and check tail pages that
become new folio heads during large folio split.  With those checks in
place, prep_compound_tail() no longer needs to clear tail_page->private
when preparing compound page metadata.

Overview
===

1. Patch 1 clears all pages ->private before percpu-km frees them.
2. Patch 2 removes setting page->private in compaction code when a free
   page is taken out of the buddy allocator. cc->freepages is indexed by
   page order, so storing the free page order in page->private is
   redundant. In alloc_contig_frozen_range_noprof(),
   isolate_freepages_range() is used to grab free pages from buddy
   allocator and it leaves the aforementioned page->private set until
   either split_free_frozen_pages() or prep_new_page() is called. That
   stale value without resetting triggers the tail_page->private nonzero
   check once set_page_private(0) is removed from prep_compound_tail().

3. Patch 3 adds back the page->private check for tail pages promoted to new
   folio heads in __split_folio_to_order().
4. Patch 4 adds a tail_page->private check in the page free path.
5. Patch 5 removes tail_page->private zeroing from prep_compound_tail().


This patch (of 5):

page->private is cleared in free page path.  In a subsequent commit,
tail_page->private will be checked and ensured to be zero.  Clearing
percpu-km allocated pages' ->private to prevent triggering warnings later,
namely undo what we did in pcpu_create_chunk().

Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com
Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-1-7e4fe155f5b9@nvidia.com
Link: https://lore.kernel.org/all/20260206174017.128673-1-mikhail.v.gavrilov@gmail.com/ [1]
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-km.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/percpu-km.c~mm-percpu-km-clear-page-private-before-free-them
+++ a/mm/percpu-km.c
@@ -94,8 +94,15 @@ static void pcpu_destroy_chunk(struct pc
 	pcpu_stats_chunk_dealloc();
 	trace_percpu_destroy_chunk(chunk->base_addr);
 
-	if (chunk->data)
+	if (chunk->data) {
+		struct page *pages = (struct page *)chunk->data;
+		int i;
+
+		/* clear chunk info from each page before free them */
+		for (i = 0; i < nr_pages; i++)
+			pcpu_set_page_chunk(pages + i, NULL);
 		__free_pages(chunk->data, order_base_2(nr_pages));
+	}
 	pcpu_free_chunk(chunk);
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

