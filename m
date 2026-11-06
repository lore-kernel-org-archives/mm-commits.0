Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793995565;
	b=ouCL0FzARNn4LWrXP9fGcLLWVb6Wa3u7IYQAJqNKHL1RJmXhWqxMC+lKLE3kQbY5FY9H
	 mS/ja56wbsW7UETkxPFQlxUUq2WO+TRsqYprczWtTWKGK3BHqGvLVZX5Gyx6uiIxLbdb3
	 N75pl+97BFdULZe9Lue1bbz1G54IG1RpPyV8/m9XYWBhJOAgoRnX70GtYR7LqLXlchmsQ
	 KTqFRmfegIFxOjtuyfov/4ecBK/Q4a8wxLJox6sBRZ0oQR1xtPXMwO6mDUNmWzvvMPWGd
	 s00zfTMqQFQbWg7ziN1GrqfjaOhbdTCQ9tMSMiHuVOaBBnspZzm7saqWpak7+qT/HWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793995565;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hpCUfloWogEwq5QmDUmP+vM69BIi5ayktNcjrQ0ddFI=;
	b=vO1ReGL26NoFK3jZLBM85AmHN/IXBWzlnk5fG67+rP+VIKOs6POLfn00gioRZPaCpNWS
	 B8Ajsik7EchhkNwxnHNEEVwI/1xj0eFtkOBQD21rwi2fvCI5JQf2mehqjUUZpdqdKCVaP
	 jnnln/D5fRAjN9UEijkha4ALE20qXdAgUc20W8Dfc0U3aRkfbH3oynM7SyrqHK7PUbmyk
	 RHwnVyC8U4EwFI+kDz9S0gBdyGS79g0pX8AEzY7x+Abv8yDi5pOLluz666PMFXWtcCOhY
	 75X7LeIwmgwKoZL9t5Al1roIxk89UJnZKAI+M3KI5GsWXQLP3AF2yq4mYnkMB/yYNHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=re8jX0W9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93D9606A326;
	Fri,  6 Nov 2026 20:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=re8jX0W9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806121F008A1;
	Fri,  6 Nov 2026 20:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793995564;
	bh=hpCUfloWogEwq5QmDUmP+vM69BIi5ayktNcjrQ0ddFI=;
	h=Date:To:From:Subject;
	b=re8jX0W9MxORIyy1L0pTzTZ9K49z39EOePl3NWtGb9sr3M7Vt7Tl37CGlVmEieCGk
	 1lkHD3BgkOuJ9AHUPqH0nCicjz6/lEC2v4NWuJTzCmz8P89lWPCSkKZuwts92hAoYq
	 HUpBmebPOzfQXd6z0vHX4DmFIeoe3vykEsk8OJ/k=
Date: Fri, 06 Nov 2026 12:06:04 -0800
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,vbabka@kernel.org,
	usama.arif@linux.dev,surenb@google.com,stable@vger.kernel.org,
	ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,
	hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,
	brendan.jackman@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order.patch removed from -mm tree
Message-Id: <20261106200604.806121F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/huge_memory: prevent losing PG_waiters in __split_folio_to_order()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-prevent-losing-pg_waiters-in-__split_folio_to_order.patch

This patch was dropped because an updated version will be issued

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
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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
@@ -3779,7 +3779,15 @@ static void __split_folio_to_order(struc
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


