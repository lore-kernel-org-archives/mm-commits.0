Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763A63EEAE2
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 22:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377148; cv=none; b=QNmYetoVuUNeBwBnFwLzWQ4Q7ckT3deUyf79Jb/8qPCpv1fJ8oB1wSkynTeEgK7Pn5syR/CkU3GTYPxLSXw/NAj5m1Xix1MdGw2Vo3b/wePmeOcuWIkhoVnj0HoWj+GcA0KMsPLFfqm8tMtmqWMJOpJEF1ztCE6dcz7AsHDLqXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377148; c=relaxed/simple;
	bh=QyvRTbwlqhMhTBnlK0ws1l7cUc2dN+AqzNIWRD2zvKk=;
	h=Date:To:From:Subject:Message-Id; b=qfD7xfAmBAhfvKm3A3LmG9BYM5x3yXC837wc/UOe7azZ8AwUmckYrAmHl9HKlZ+0pzxyO6yIbskwH+SiF0nusVRBGB+HlqX1i3zDy99Hw9rerLCRqYf/9pyAnH27gsTqPFLzmRD2m8lhaGWGYGruOapr25bkFstACL0nBmW9Tc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HadwITFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HadwITFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0371F000E9;
	Mon,  6 Jul 2026 22:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783377147;
	bh=JB9VPag0mORnq1I4m6WL+A+pbWHvwklisevpyp8mHmw=;
	h=Date:To:From:Subject;
	b=HadwITFmFcnN56w3cuZR2xctVQrCQM8nWhnNBkQOp4DNs0kduwtCTepYXs0UmjQtE
	 djA1FINs1yuLKfB3/iRi+oDN2nyjOmihhKPMp3R3JipXVjRwMJySEW6VppOqbglEy5
	 0l7idgyisUnRa1fUY3/aIqdl3oqG7ej/+ZeVhzzE=
Date: Mon, 06 Jul 2026 15:32:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,dennis@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-km-clear-page-private-before-free-them.patch added to mm-new branch
Message-Id: <20260706223226.DF0371F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu-km: clear page->private before free them
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-km-clear-page-private-before-free-them.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-km-clear-page-private-before-free-them.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Fri, 03 Jul 2026 09:47:46 -0400

Patch series "Keep tail page private zero at free and folio split", v2.

This patchset makes sure tail_page->private is zero before compound or
high-order pages are returned to the allocator.  It also checks tail pages
that become new folio heads during large folio split, before their private
fields are used by new folios.

Note on ZONE_DEVICE and DAX page/folio
===
ZONE_DEVICE and DAX use prep_compound_tail() to reinitialize folios, so
tail_page->private was reset before this patchset. There was a concern that
after this patchset stale ->private can appear after ZONE_DEVICE/DAX folio
initialization. My reasoning is that no code sets ZONE_DEVICE/DAX
page->private, so their page->private stays zero all the time.
ZONE_DEVICE_PRIVATE page migration only supports anonymous memory without
swapcache, so after the migration ->private remains zero.

Motivation
===

page->private is zeroed at page free time since commit ac1ea219590c0
("mm/page_alloc: clear page->private in free_pages_prepare()"), since we
concluded that it might be too much to ask every page user to free a page
with ->private zeroed. The holder of the last page reference might not know
whether ->private needs to be cleared.

For compound and high-order pages, tail_page->private can also leak to
later users if it is left uncleared. The page allocation path does not zero
every tail_page->private field, so they can be seen by new users and cause
unexpected issues[1].

Check tail_page->private at page free time, and check tail pages that
become new folio heads during large folio split. With those checks in
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
percpu-km allocated pages' ->private to prevent triggering warnings later.

Link: https://lore.kernel.org/20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com
Link: https://lore.kernel.org/20260703-keep-subpage-private-zero-at-free-v2-1-2970fe777dd6@nvidia.com
Link: https://lore.kernel.org/all/20260206174017.128673-1-mikhail.v.gavrilov@gmail.com/ [1]
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Vlastimil Babka <vbabka@kernel.org>
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

mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

