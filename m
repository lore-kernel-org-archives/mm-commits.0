Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793408208;
	b=cg/3i2cOA4gJPn2uGJHfUsg6NHyKkcHcKdCZDUluWRiVd2a902aXdHAEvtY6nLqapF3i
	 hAW3spuTa8efCDnVCmqL9XhaCZ9yWLAN4fA+trC8Var2p3mC+OFR0I8OfCNbBi48ImLue
	 YPOBrhkjzaQ5at9DRwq0KiOiNkNw9s3HeSUSOoEkPFYgiHJMp4rjmqhwSG9fgYr9Ni/R4
	 1mWvnXbwI044Q49cpEE8e+78eh3wPv5OwoCjoN/lQTqE/MMEskKfbHR9c5zTGtnY7c7EF
	 rZFRwjTTBdghd2jg7/i1wxuivbKB3h/Iiihbr0ylBZWwoemE36qxYClRp2qpF5YZfvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793408208;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NGNpSqdVFcqijpq8vghpRHt6n6KqyjJmatyCS27rYf8=;
	b=ttg5V3bNNBh88ZP72RfvQaN/hbK2cNOJ7abHh/UajJeXuHCt4eHL+bNADSNdADGoDpE4
	 m96y+jI5B279U6FyUxPb8ZZk9AR8Qt1lUtyHjIGznRIHLqyEZB3igT0M+vGqDtqhJnz7X
	 1ZocXEokPisjT5+IemrFe+9fxeQZl99bmDEsCzWVL/J6L5lLJTP5ZMHALMyOiCfSe2Ohm
	 5hUiIYLQ97NVCFrIJUDgwXJ8Iw703nu7cLuQIqfA6+TxSrNHPv3j600RIPi6A7yC240Nh
	 MMAfP41BiYyoi3qTfAPu1pkFQta5c20wSXWRGeR5yg31p+6Y9EIXIDqPK16XffAgpoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MfRPu7jr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C70606A31A;
	Sat, 31 Oct 2026 00:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MfRPu7jr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391301F000C1;
	Sat, 31 Oct 2026 00:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793408207;
	bh=NGNpSqdVFcqijpq8vghpRHt6n6KqyjJmatyCS27rYf8=;
	h=Date:To:From:Subject;
	b=MfRPu7jrmKMtGWufc/sVnaNv2a7NXChNRDcRJjO4aO8/I0HRWKCd6UVdCvyiroMf5
	 0SxOsbT8IwP4xUYhmmblC/ESoR5obaE407MoL56x/wt8xhXrIGteIltugsosuqK/Ep
	 0+Aheeweat/1bNKTo+4g1/tgDxFdU8yKQQgtQR9g=
Date: Fri, 30 Oct 2026 17:56:46 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,vbabka@kernel.org,
	usama.arif@linux.dev,surenb@google.com,stable@vger.kernel.org,
	ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,
	hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,
	brendan.jackman@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order.patch added to mm-hotfixes-unstable branch
Message-Id: <20261031005647.391301F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/huge_memory: prevent losing PG_waiters in __split_folio_to_order()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/huge_memory: prevent losing PG_waiters in __split_folio_to_order()
Date: Thu, 29 Oct 2026 22:08:44 -0400

__split_folio_to_order() calls prep_compound_page() on each new head page
to create a compound page after clear_compound_head(). 
prep_compound_page() uses non atomic __SetPageHead().  It is mostly OK,
since the folio is locked and frozen and no one else is supposed to modify
the folio's flags.

However, code calling migration_entry_wait() can reach the folio by PFN,
then access its flags.  It is because softleaf_entry_wait_on_locked() used
by migration_entry_wait() sets PG_waiters concurrently without taking a
reference and the frozen refcount during split cannot block it. 
Meanwhile, __SetPageHead() does a plain read and write, so PG_waiters
atomically set by softleaf_entry_wait_on_locked() will be lost if the set
happens after __SetPageHead()'s read and before its write.

One example code interleaving:

CPU0: __split_folio_to_order(new_order>0)  CPU1: do_swap_page()

1. clear_compound_head(new_head)
   new_head->compound_info = 0
   (page_folio(new_head) == new_head now)

                                           2. migration_entry_wait()
                                             softleaf_to_folio(entry)
                                             page_folio() -> new_head
                                             (not the old head any more)

3. prep_compound_page(new_head, new_order)
     __SetPageHead(new_head)
       tmp = new_head->flags.f  <-- load; PG_waiters == 0 in tmp

                                           4. folio_set_waiters(new_head)
                                             set_bit(PG_waiters, &flags.f)
                                             enqueue on waitqueue, sleep

5.     new_head->flags.f = tmp | (1UL << PG_head)
       <-- store; overwrites step 4, PG_waiters == 0 again

Later, folio_unlock(new_folio) sees no PG_waiters, skips folio_wake_bit(),
and CPU1 can remain blocked indefinitely.

Fix it by adding the atomic version SetPageHead() and
prep_compound_page_atomic() using it.  __split_folio_to_order() uses
prep_compound_page_atomic() to avoid the issue without adding an atomic
ops to other prep_compound_page() users.

Link: https://lore.kernel.org/20261029-fix-split_folio_to_order-race-v1-1-a483c7451b0d@nvidia.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: David Hildenbrand <david@kernel.org>
Closes: https://lore.kernel.org/all/DMHE8BEEER1H.2BIY52NXATPIA@nvidia.com/
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: <stable@vger.kernel.org>
---

 include/linux/page-flags.h |    1 +
 mm/huge_memory.c           |   10 +++++++++-
 mm/internal.h              |    2 ++
 mm/page_alloc.c            |   20 ++++++++++++++++++--
 4 files changed, 30 insertions(+), 3 deletions(-)

--- a/include/linux/page-flags.h~mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order
+++ a/include/linux/page-flags.h
@@ -854,6 +854,7 @@ static __always_inline int PageHead(cons
 	return test_bit(PG_head, &page->flags.f);
 }
 
+SETPAGEFLAG(Head, head, PF_ANY)
 __SETPAGEFLAG(Head, head, PF_ANY)
 __CLEARPAGEFLAG(Head, head, PF_ANY)
 CLEARPAGEFLAG(Head, head, PF_ANY)
--- a/mm/huge_memory.c~mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order
+++ a/mm/huge_memory.c
@@ -3781,7 +3781,15 @@ static void __split_folio_to_order(struc
 		 */
 		clear_compound_head(new_head);
 		if (new_order) {
-			prep_compound_page(new_head, new_order);
+			/*
+			 * new_head is recognized as a folio after
+			 * clear_compound_head().
+			 * softleaf_entry_wait_on_locked() can set PG_waiters
+			 * on it without taking a reference, so its frozen state
+			 * cannot prevent it. Use the atomic version to avoid
+			 * losing a concurrently set PG_waiters.
+			 */
+			prep_compound_page_atomic(new_head, new_order);
 			folio_set_large_rmappable(new_folio);
 		}
 
--- a/mm/internal.h~mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order
+++ a/mm/internal.h
@@ -806,6 +806,8 @@ static inline void prep_compound_tail(st
 	VM_WARN_ON_ONCE(tail->private);
 }
 
+void prep_compound_page_atomic(struct page *page, unsigned int order);
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
--- a/mm/page_alloc.c~mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order
+++ a/mm/page_alloc.c
@@ -682,18 +682,34 @@ static inline bool pcp_allowed_order(uns
  * This usage means that zero-order pages may not be compound.
  */
 
-void prep_compound_page(struct page *page, unsigned int order)
+static void __prep_compound_head_and_tail(struct page *page, unsigned int order)
 {
 	int i;
 	int nr_pages = 1 << order;
 
-	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++)
 		prep_compound_tail(page + i, page, order);
 
 	prep_compound_head(page, order);
 }
 
+void prep_compound_page(struct page *page, unsigned int order)
+{
+	__SetPageHead(page);
+	__prep_compound_head_and_tail(page, order);
+}
+
+/*
+ * PG_head is set atomically whereas the other metadata is set with plain stores.
+ * It should be used when @page's flags can be modified concurrently,
+ * e.g., in __split_folio_to_order().
+ */
+void prep_compound_page_atomic(struct page *page, unsigned int order)
+{
+	SetPageHead(page);
+	__prep_compound_head_and_tail(page, order);
+}
+
 static inline void set_buddy_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order.patch

