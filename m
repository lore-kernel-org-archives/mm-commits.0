Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EF24DC528
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783621439; cv=none; b=ItlZNREK3aFlTsw++Hr3B8rIhjx5WY2UM2+q4kSPk55onD34P+KS4A9ZmlF315qVHcirU7VoMBERUU91n9LOMmQ4T59CaUxFcXqTt/51wJo/cw9e4DXxwpz2QT2FwMmrPwA27SYusePTi7NgFB1zibIBqlzG2BJt3K+zP0Vh2eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783621439; c=relaxed/simple;
	bh=ugdDaYacXqsJgF6oXIonzpF4+jEcez7DVBOBJdz6jrA=;
	h=Date:To:From:Subject:Message-Id; b=WkQAslPcvcwQSsOMMXR0+qEntgvPACjyOOSnMtj4XMzRz+IDhrzZYz1B2wI5T5W1x8kVZVtX2lxvgOsvB8r6GNqyUY49Y9kiziqjfa9duHf7q07NtAVJuX23AisjqAGhjnHzxkgsdaYexzWQ+w0xmAJRtvAuQlACh1hA3wiRFAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZfzZ7cS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZfzZ7cS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C807B1F00A3E;
	Thu,  9 Jul 2026 18:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783621437;
	bh=hUHyo6a0vD9GCCjvC6IQ2xwt3Ej4HmNnsO29698+Jy8=;
	h=Date:To:From:Subject;
	b=qZfzZ7cS+OC7k6vFhQZJxWkTsFr3y/mUitKuY2LWJLzOoVtskaHRQUZ8u36EQO/oa
	 ytUc7RhbwOy5Wj9mZ7m6ice4tYD57LKNF+rl1Pa8RSV0OCy4O6TK0UW/clDDUv7sAf
	 Y9I4S46IRYZWwVyh6nytYvbI0xgAMQm10UNSAJiY=
Date: Thu, 09 Jul 2026 11:23:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-percpu-km-clear-page-private-before-free-them.patch removed from -mm tree
Message-Id: <20260709182357.C807B1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/percpu-km: clear page->private before free them
has been removed from the -mm tree.  Its filename was
     mm-percpu-km-clear-page-private-before-free-them.patch

This patch was dropped because an updated version will be issued

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

mm-page_owner-add-numa-node-filter-fix.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

